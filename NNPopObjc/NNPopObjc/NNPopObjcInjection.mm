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

/// Returns a Boolean value that indicates whether a class conforms to a given protocol.
/// It is same as: + (BOOL)conformsToProtocol:(Protocol *)protocol
/// @param clazz The class you want to inspect.
/// @param protocol A protocol.
BOOL __nn_pop_class_conformsToProtocol(Class clazz, Protocol *protocol)  {
    
    BOOL result = false;
    
    if (clazz == nil || protocol == nil) {
        return result;
    }
    
    Class currentClazz = clazz;
    while (currentClazz) {
        if (class_conformsToProtocol(currentClazz, protocol)) {
            result = true;
        }
        currentClazz = class_getSuperclass(currentClazz);
    }
    
    return result;
}

/// Returns a Boolean value that indicates whether clazz is in protocol implements.
/// @param clazz A class
/// @param protocols nn_pop_protocol_t list
/// @param protocol_count nn_pop_protocol_t list count
BOOL __nn_pop_isExtensionClass(Class clazz, nn_pop_protocol_t *protocols, unsigned int protocol_count) {
    
    __block BOOL result = false;
    
    for (unsigned int i = 0; i < protocol_count; i++) {
        
        nn_pop_protocol_t protocol = protocols[i];
        
        nn_pop_extension_list_foreach(&(protocol.extension), ^(nn_pop_extension_node_p item, BOOL *stop) {
            if (clazz == item->clazz) {
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

/// Injects extentionClass implements in to clazz
/// @param protocol A protocol that extened
/// @param extentionClass Extension implement class
/// @param clazz A class
/// @param checkSupserImplement Whether the injection should check super implemention,
/// if a instance mathod has been implemented by super class, then jump over the injection.
void __nn_pop_injectProtocolExtension (Protocol *protocol, Class extentionClass, Class clazz, BOOL checkSupserImplement) {
    
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

/// Injects protocol extension in to clazz
/// @param protocol A nn_pop_protocol_t struct
/// @param clazz A class
void __nn_pop_injectProtocol(nn_pop_protocol_t protocol, Class clazz) {
    
    __block nn_pop_extension_node_p default_list = nil;
    __block nn_pop_extension_node_p constrained_list = nil;
    
    nn_pop_extension_list_foreach(&(protocol.extension), ^(nn_pop_extension_node_p node, BOOL *stop) {
        
        nn_pop_where_value_def match_value = node->where_fp(clazz);

        if (match_value == nn_pop_where_value_matched_default) {
            nn_pop_extension_node_p matched_node = nn_pop_extension_node_new();
            nn_pop_extension_node_copy(matched_node, node);
            matched_node->next = nil;
            nn_pop_extension_list_append(&(default_list), &(matched_node));
        }
        
        if (match_value == nn_pop_where_value_matched_constrained) {
            BOOL conform = true;
            for (unsigned int i = 0; i < node->confrom_protocols_count; i++) {
                Protocol *protocol = node->confrom_protocols[i];
                if ([clazz conformsToProtocol:protocol] == false) {
                    conform = false;
                    break;
                }
            }
            if (conform) {
                nn_pop_extension_node_p matched_node = nn_pop_extension_node_new();
                nn_pop_extension_node_copy(matched_node, node);
                matched_node->next = nil;
                nn_pop_extension_list_append(&(constrained_list), &(matched_node));
            }
        }
    });
    
    if (nn_pop_extension_list_count(&(constrained_list)) > 1) {
        NSCAssert(false, ([NSString stringWithFormat:@"Matched multiple extensions for %@", @(class_getName(clazz))]));
    }
    if (nn_pop_extension_list_count(&(constrained_list)) == 1) {
        __nn_pop_injectProtocolExtension(protocol.protocol, constrained_list->clazz, clazz, false);
    }
    
    if (nn_pop_extension_list_count(&(default_list)) > 1) {
        NSCAssert(false, ([NSString stringWithFormat:@"Matched multiple extensions for %@", @(class_getName(clazz))]));
    }
    if (nn_pop_extension_list_count(&(default_list)) == 1) {
        __nn_pop_injectProtocolExtension(protocol.protocol, default_list->clazz, clazz, true);
    }
    
    if ((nn_pop_extension_list_count(&(constrained_list)) == 0) && (nn_pop_extension_list_count(&(default_list)) == 0)) {
        NSCAssert(false, ([NSString stringWithFormat:@"You need at least provide a extension for %@", @(class_getName(clazz))]));
    }

    nn_pop_extension_list_free(&default_list);
    nn_pop_extension_list_free(&constrained_list);
    
    return;
}

/// Injects each protocols extension in to the corresponding class
/// @param protocols nn_pop_protocol_t list
/// @param protocol_count nn_pop_protocol_t list count
void __nn_pop_injectProtocols (nn_pop_protocol_t *protocols, unsigned int protocol_count) {
    
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
    
    int classCount = objc_getClassList(NULL, 0);
    if (!classCount) {
        fprintf(stderr, "ERROR: No clazzes registered with the runtime\n");
        return;
    }
    
    Class *clazzes = (Class *)calloc((size_t)(classCount + 1), sizeof(Class));
    if (!clazzes) {
        fprintf(stderr, "ERROR: Could not allocate space for %d clazzes\n", classCount);
        return;
    }
    
    classCount = objc_getClassList(clazzes, classCount);
    
    @autoreleasepool {
        
        for (size_t i = 0; i < protocol_count; ++i) {
            nn_pop_protocol_t protocol = protocols[i];
            
            // loop all clazzes
            for (unsigned int i = 0; i < classCount; i++) {
                
                Class clazz = clazzes[i];
                
                if (__nn_pop_class_conformsToProtocol(clazz, protocol.protocol) == false) {
                    continue;
                }
                if (__nn_pop_isExtensionClass(clazz, protocols, protocol_count) == true) {
                    continue;
                }
                __nn_pop_injectProtocol(protocol, clazz);
            }
        }
    }
    
    free(clazzes);
}

/// Loads protocol extensions info from image segment
/// @param mhp A mach header appears at the very beginning of the object file
/// @param sectname A section name in __DATA segment
void __nn_pop_loadSection(const nn_pop_mach_header *mhp, const char *sectname, void (^loaded)(nn_pop_protocol_t *protocols, unsigned int protocol_count)) {
    
    if (pthread_mutex_lock(&nn_pop_inject_lock) != 0) {
        fprintf(stderr, "ERROR: Could not synchronize on special protocol data\n");
    }
    
    unsigned long size = 0;
    uintptr_t *sectionData = (uintptr_t*)getsectiondata(mhp, metamacro_stringify(nn_pop_segment_name), sectname, &size);
    if (size == 0) {
        pthread_mutex_unlock(&nn_pop_inject_lock);
        return;
    }
    
    unsigned long sectionItemCount = size / sizeof(nn_pop_extension_description_t);
    nn_pop_extension_description_t *sectionItems = (nn_pop_extension_description_t *)sectionData;
    
    nn_pop_protocol_t *protocols = nn_pop_protocols_new((size_t)(sectionItemCount + 1));
    if (protocols == NULL) {
        pthread_mutex_unlock(&nn_pop_inject_lock);
        return;
    }
    
    for (unsigned int sectionIndex = 0, protocolIndex = 0; sectionIndex < sectionItemCount; sectionIndex++) {
        
        nn_pop_extension_description_t *_sectionItem = &sectionItems[sectionIndex];
        
        nn_pop_protocol_t *_protocol = &protocols[protocolIndex++];
        _protocol->protocol = NULL;
        _protocol->extension = NULL;
        
        Protocol *protocol = objc_getProtocol(_sectionItem->protocol);
        if (!protocol) {
            continue;
        }
        _protocol->protocol = protocol;
        
        nn_pop_extension_node_p _extension = nn_pop_extension_node_new();
        if (!_extension) {
            continue;
        }
        _extension->prefix = _sectionItem->prefix;
        _extension->clazz = objc_getClass(_sectionItem->clazz);
        _extension->where_fp = _sectionItem->where_fp;
        _extension->confrom_protocols_count = _sectionItem->confrom_protocols_count;
        for (unsigned int i = 0; i < _extension->confrom_protocols_count; i++) {
            _extension->confrom_protocols[i] = objc_getProtocol(_sectionItem->confrom_protocols[i]);
        }
        _extension->next = NULL;
        nn_pop_extension_list_append(&(_protocol->extension), &(_extension));
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
            nn_pop_extension_list_append(&(protocols[protocolBaseIndex].extension), &(protocols[protocolForwardIndex].extension));
        }
        else {
            protocols[++protocolBaseIndex] = protocols[protocolForwardIndex];
        }
        protocolForwardIndex++;
    }
    unsigned int protocolCount = protocolBaseIndex + 1;
    protocols = (nn_pop_protocol_t *)realloc(protocols, (protocolCount + 1) * sizeof(nn_pop_protocol_t));
    memset((protocols + protocolCount), 0, sizeof(nn_pop_protocol_t));
    
    if (loaded) {
        loaded(protocols, protocolCount);
    }
    
    nn_pop_protocols_free(protocols, protocolCount);
    
    pthread_mutex_unlock(&nn_pop_inject_lock);
}

/// ProgramVars, it is defined in ImageLoader.h at dyld project.
/// @note dyld project: https://opensource.apple.com/tarballs/dyld/
struct __nn_pop_ProgramVars
{
    const void*        mh;
    int*            NXArgcPtr;
    const char***    NXArgvPtr;
    const char***    environPtr;
    const char**    __prognamePtr;
};

/// Initializer function is called by ImageLoaderMachO::doModInitFunctions at dyld project.
/// @param argc argc
/// @param argv argv
/// @param envp envp
/// @param apple apple
/// @param vars vars
/// @note dyld project: https://opensource.apple.com/tarballs/dyld/
__attribute__((constructor)) void __nn_pop_prophet(int argc, const char* argv[], const char* envp[], const char* apple[], const __nn_pop_ProgramVars* vars) {

    nn_pop_mach_header *mhp = (nn_pop_mach_header *)vars->mh;
    
    __nn_pop_loadSection(mhp, metamacro_stringify(nn_pop_section_name), ^(nn_pop_protocol_t *protocols, unsigned int protocol_count) {
        __nn_pop_injectProtocols(protocols, protocol_count);
    });
}

