//
//  NNPopObjcInjection.m
//  NNPopObjc
//
//  Created by 顾海军 on 2019/10/26.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNPopObjcInjection.h"
#import <objc/runtime.h>
#import <ctype.h>
#import <objc/message.h>
#import <os/lock.h>
#import <pthread.h>
#import <stdio.h>
#import <stdlib.h>
#import <string.h>


static pthread_mutex_t nn_pop_inject_lock = PTHREAD_MUTEX_INITIALIZER;


void __nn_pop_extension_append(nn_pop_extension_node_t **head, nn_pop_extension_node_t **entry) {
    if (*head) {
        nn_pop_extension_node_t *t = *head;
        while (t->next != NULL) {
            t = t->next;
        }
        t->next = *entry;
    }
    else {
        *head = *entry;
    }
}


void __nn_pop_extension_free(nn_pop_extension_node_t **head) {
    while (*head) {
        nn_pop_extension_node_t *t = *head;
        *head = (t)->next;
        free(t);
    }
}


void __nn_pop_extension_foreach(nn_pop_extension_node_t *head, void (^enumerate_block)(nn_pop_extension_node_t *item, BOOL *stop)) {
    nn_pop_extension_node_t *t = head;
    BOOL stop = false;
    while (t) {
        if (enumerate_block && stop == false) {
            enumerate_block(t, &stop);
        }
        t = t->next;
    }
}


void __nn_pop_freeProtocols(nn_pop_protocol_t *protocols, unsigned int protocol_count) {
    
    for (unsigned int i = 0; i < protocol_count; i++) {
        // free default extension
        __nn_pop_extension_free(&(protocols[i].extension.base));
        // free special extension
        __nn_pop_extension_free(&(protocols[i].extension.special));
    }
    
    free(protocols);
}


/// Gets a root clazz that conformed to protocol.
///
/// @param protocol A protocol that root clazz adpoted.
/// @param clazz A clazz that it is sub clazz of root or the root self.
Class __nn_pop_rootProtocolClass(Protocol *protocol, Class clazz) {
    
    Class result = nil;
    
    if (clazz == nil || protocol == nil) {
        return result;
    }
    
    Class currentClazz = clazz;
    while (currentClazz) {
        if (class_conformsToProtocol(currentClazz, protocol)) {
            result = currentClazz;
        }
        currentClazz = class_getSuperclass(currentClazz);
    }
    
    return result;
}


BOOL nn_pop_isExtensionClass(Class clazz, nn_pop_protocol_t *protocols, unsigned int protocol_count) {
    
    __block BOOL result = false;
    
    for (unsigned int i = 0; i < protocol_count; i++) {
        
        nn_pop_protocol_t protocol = protocols[i];
        
        if (clazz == protocol.extension.base->extension_clazz) {
            result = true;
        }
        if (result) {
            break;
        }
        
        __nn_pop_extension_foreach(protocol.extension.special, ^(nn_pop_extension_node_t *item, BOOL *stop) {
            if (clazz == item->extension_clazz) {
                result = true;
                *stop = true;
            }
        });
        if (result) {
            break;
        }
    }
    
    return result;
}


void nn_pop_injectProtocolExtension (Protocol *protocol, Class extentionClass, Class clazz, BOOL checkSupserImplement) {
    
    unsigned imethodCount = 0;
    Method *imethodList = class_copyMethodList(extentionClass, &imethodCount);
    
    unsigned cmethodCount = 0;
    Method *cmethodList = class_copyMethodList(object_getClass(extentionClass), &cmethodCount);
    
    Class metaclazz = object_getClass(clazz);
    
    for (unsigned i = 0; i < imethodCount; i++) {
        Method method = imethodList[i];
        SEL selector = method_getName(method);
        
        if (checkSupserImplement && class_getInstanceMethod(clazz, selector)) {
            continue;
        }
        
        IMP imp = method_getImplementation(method);
        const char *types = method_getTypeEncoding(method);
        class_addMethod(clazz, selector, imp, types);
    }
    
    for (unsigned i = 0; i < cmethodCount; i++) {
        Method method = cmethodList[i];
        SEL selector = method_getName(method);
        
        if (selector == @selector(initialize)) {
            continue;
        }
        
        if (checkSupserImplement && class_getInstanceMethod(metaclazz, selector)) {
            continue;
        }
        
        IMP imp = method_getImplementation(method);
        const char *types = method_getTypeEncoding(method);
        class_addMethod(metaclazz, selector, imp, types);
    }
    
    free(imethodList); imethodList = NULL;
    free(cmethodList); cmethodList = NULL;
    
    (void)[extentionClass class];
}


void nn_pop_injectProtocols (nn_pop_protocol_t *protocols, unsigned int protocol_count) {
    
    qsort_b(protocols, protocol_count, sizeof(nn_pop_protocol_t), ^(const void *a, const void *b){
        
        if (a == b)
            return 0;
        
        const nn_pop_protocol_t *p_a = (nn_pop_protocol_t *)a;
        const nn_pop_protocol_t *p_b = (nn_pop_protocol_t *)b;
        
        int (^protocolInjectionPriority)(const nn_pop_protocol_t *) = ^(const nn_pop_protocol_t *protocol){
            int runningTotal = 0;
            
            for (size_t i = 0;i < protocol_count;++i) {
                
                if (protocol == protocols + i)
                    continue;
                
                if (protocol_conformsToProtocol(protocol->protocol, protocols[i].protocol))
                    runningTotal++;
            }
            
            return runningTotal;
        };
        
        return protocolInjectionPriority(p_b) - protocolInjectionPriority(p_a);
    });
    
    unsigned classCount = objc_getClassList(NULL, 0);
    if (!classCount) {
        fprintf(stderr, "ERROR: No clazzes registered with the runtime\n");
        return;
    }
    
    Class *clazzes = (Class *)malloc(sizeof(Class) * (classCount + 1));
    if (!clazzes) {
        fprintf(stderr, "ERROR: Could not allocate space for %u clazzes\n", classCount);
        return;
    }
    
    classCount = objc_getClassList(clazzes, classCount);
    
    @autoreleasepool {
        
        for (size_t i = 0; i < protocol_count; ++i) {
            nn_pop_protocol_t protocol = protocols[i];
            
            // loop all clazzes
            for (unsigned int i = 0; i < classCount; i++) {
                
                Class clazz = clazzes[i];
                
                if (!class_conformsToProtocol(clazz, protocol.protocol)) {
                    continue;
                }
                
                if (nn_pop_isExtensionClass(clazz, protocols, protocol_count)) {
                    continue;
                }
                __nn_pop_extension_foreach(protocol.extension.special, ^(nn_pop_extension_node_t *item, BOOL *stop) {
                    if (clazz == item->special_clazz) {
                        nn_pop_injectProtocolExtension(protocol.protocol, item->extension_clazz, clazz, false);
                        *stop = true;
                    }
                });
                
                Class rootClass = __nn_pop_rootProtocolClass(protocol.protocol, clazz);
                if (nn_pop_isExtensionClass(rootClass, protocols, protocol_count)) {
                    continue;
                }
                __nn_pop_extension_foreach(protocol.extension.special, ^(nn_pop_extension_node_t *item, BOOL *stop) {
                    if (rootClass == item->special_clazz) {
                        nn_pop_injectProtocolExtension(protocol.protocol, item->extension_clazz, rootClass, false);
                        *stop = true;
                    }
                });
                
                nn_pop_injectProtocolExtension(protocol.protocol, protocol.extension.base->extension_clazz, rootClass, true);
                
            }
        }
    }
    
    free(clazzes);
}


void __nn_pop_loadSection(const mach_header *mhp, const char *sectname, void (^loaded)(nn_pop_protocol_t *protocols, unsigned int protocol_count)) {
    
    if (pthread_mutex_lock(&nn_pop_inject_lock) != 0) {
        fprintf(stderr, "ERROR: Could not synchronize on special protocol data\n");
    }
    
    nn_pop_mach_header *_mhp = (nn_pop_mach_header *)mhp;
    
    unsigned long size = 0;
    uintptr_t *sectionData = (uintptr_t*)getsectiondata(_mhp, nn_pop_stringify(nn_pop_segment_name), sectname, &size);
    if (size == 0) {
        pthread_mutex_unlock(&nn_pop_inject_lock);
        return;
    }
    
    unsigned long sectionItemCount = size / sizeof(nn_pop_extension_section_item);
    nn_pop_extension_section_item *sectionItems = (nn_pop_extension_section_item *)sectionData;
    
    nn_pop_protocol_t *protocols = (nn_pop_protocol_t *)malloc((sectionItemCount + 1) * sizeof(nn_pop_protocol_t));
    if (protocols == NULL) {
        pthread_mutex_unlock(&nn_pop_inject_lock);
        return;
    }
    
    for (unsigned int sectionIndex = 0, protocolIndex = 0; sectionIndex < sectionItemCount; sectionIndex++) {
        
        nn_pop_extension_section_item *_sectionItem = &sectionItems[sectionIndex];
        
        Protocol *protocol = objc_getProtocol(_sectionItem->extension_protocol);
        if (!protocol) {
            continue;
        }
        nn_pop_protocol_t *_protocol = &protocols[protocolIndex++];
        _protocol->protocol = protocol;
        _protocol->extension.base = NULL;
        _protocol->extension.special = NULL;
        
        nn_pop_extension_node_t *_extension = (nn_pop_extension_node_t *)malloc(1 * sizeof(nn_pop_extension_node_t));
        if (!_extension) {
            continue;
        }
        _extension->extension_prefix = _sectionItem->extension_prefix;
        _extension->special_clazz = objc_getClass(_sectionItem->special_clazz);
        _extension->extension_clazz = objc_getClass(_sectionItem->extension_clazz);
        _extension->next = NULL;
        if (_extension->special_clazz == objc_getClass("NSObject")) {
            _protocol->extension.base = _extension;
        }
        else {
            _protocol->extension.special = _extension;
        }
    }
    
    qsort_b(protocols, sectionItemCount, sizeof(nn_pop_protocol_t), ^int(const void *a, const void *b) {
        const nn_pop_protocol_t *_a = (nn_pop_protocol_t *)a;
        const nn_pop_protocol_t *_b = (nn_pop_protocol_t *)b;
        
        const char *p_a = protocol_getName(_a->protocol);
        const char *p_b = protocol_getName(_b->protocol);
        
        int cmp = strcmp(p_a, p_b);
        return cmp;
    });
    
    unsigned int protocolBaseIndex = 0, protocolForwardIndex = 1;
    while (protocolForwardIndex < sectionItemCount) {
        if (protocol_isEqual(protocols[protocolBaseIndex].protocol, protocols[protocolForwardIndex].protocol)) {
            __nn_pop_extension_append(&(protocols[protocolBaseIndex].extension.special), &(protocols[protocolForwardIndex].extension.special));
        }
        else {
            protocols[++protocolBaseIndex] = protocols[protocolForwardIndex];
        }
        protocolForwardIndex++;
    }
    unsigned int protocolCount = protocolBaseIndex + 1;
    protocols = (nn_pop_protocol_t *)realloc(protocols, (protocolCount + 1) * sizeof(nn_pop_protocol_t));
    protocols[protocolCount] = (nn_pop_protocol_t){0};
    
    if (loaded) {
        loaded(protocols, protocolCount);
    }
    
    __nn_pop_freeProtocols(protocols, protocolCount);
    
    pthread_mutex_unlock(&nn_pop_inject_lock);
}


void __nn_pop_dyld_callback(const mach_header *mhp, intptr_t vmaddr_slide) {
    __nn_pop_loadSection(mhp, nn_pop_stringify(nn_pop_section_name), ^(nn_pop_protocol_t *protocols, unsigned int protocol_count) {
        nn_pop_injectProtocols(protocols, protocol_count);
    });
}


__attribute__((constructor)) void __nn_pop_prophet() {
    _dyld_register_func_for_add_image(__nn_pop_dyld_callback);
}

