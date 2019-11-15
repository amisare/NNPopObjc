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
#import <set>

#import "NNPopObjcMemory.h"


static pthread_mutex_t nn_pop_injectLock = PTHREAD_MUTEX_INITIALIZER;

/// Gets a root clazz that confrom to protocol.
/// @param protocol A protocol that root clazz adpoted.
/// @param clazz A clazz that it is sub clazz of root or the root self.
Class nn_pop_class_rootProtocolClass(Class clazz, Protocol *protocol) {
    
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

/// Returns a Boolean value that indicates whether a class conforms to a given protocol.
/// It is same as: + (BOOL)conformsToProtocol:(Protocol *)protocol
/// @param clazz The class you want to inspect.
/// @param protocol A protocol.
BOOL nn_pop_class_conformsToProtocol(Class clazz, Protocol *protocol)  {
    
    BOOL result = false;
    
    if (clazz == nil || protocol == nil) {
        return result;
    }
    
    Class currentClazz = clazz;
    while (currentClazz) {
        if (class_conformsToProtocol(currentClazz, protocol)) {
            result = true;
            break;
        }
        currentClazz = class_getSuperclass(currentClazz);
    }
    
    return result;
}

/// Returns a Boolean value that indicates whether clazz is in protocol implements.
/// @param clazz A class
/// @param protocols nn_pop_protocol_extension_t list
/// @param protocol_count nn_pop_protocol_extension_t list count
BOOL nn_pop_isExtensionClass(Class clazz, nn_pop_protocolExtension_t **protocols, unsigned int protocol_count) {
    
    __block BOOL result = false;
    
    for (unsigned int i = 0; i < protocol_count; i++) {
        
        nn_pop_protocolExtension_t protocol = *protocols[i];
        
        nn_pop_extensionListForeach(&(protocol.extension), ^(nn_pop_extensionNode_p item, BOOL *stop) {
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
/// @param extentionClazz Extension implement class
/// @param clazz A class
/// @param checkSupserImplement Whether the injection should check super implemention,
/// if a instance mathod has been implemented by super class, then jump over the injection.
void nn_pop_injectProtocolExtension(Class extentionClazz, Class clazz, BOOL checkSupserImplement) {
    
    unsigned int iMethodCount = 0;
    Method *iMethodList = class_copyMethodList(extentionClazz, &iMethodCount);
    
    unsigned int cMethodCount = 0;
    Method *cMethodList = class_copyMethodList(object_getClass(extentionClazz), &cMethodCount);
    
    Class metaclazz = object_getClass(clazz);
    
    for (unsigned int i = 0; i < iMethodCount; i++) {
        Method method = iMethodList[i];
        SEL selector = method_getName(method);
        
        if (checkSupserImplement && (class_getInstanceMethod(clazz, selector) != nil)) {
            continue;
        }
        
        IMP imp = method_getImplementation(method);
        const char *types = method_getTypeEncoding(method);
        class_addMethod(clazz, selector, imp, types);
    }
    
    for (unsigned int i = 0; i < cMethodCount; i++) {
        Method method = cMethodList[i];
        SEL selector = method_getName(method);
        
        if (selector == @selector(initialize)) {
            continue;
        }
        
        if (checkSupserImplement && (class_getInstanceMethod(metaclazz, selector) != nil)) {
            continue;
        }
        
        IMP imp = method_getImplementation(method);
        const char *types = method_getTypeEncoding(method);
        class_addMethod(metaclazz, selector, imp, types);
    }
    
    free(iMethodList); iMethodList = NULL;
    free(cMethodList); cMethodList = NULL;
    
    (void)[extentionClazz class];
}

/// Injects protocol extension in to clazz
/// @param protocolExtension A nn_pop_protocol_extension_t struct
/// @param clazz A class
void nn_pop_injectProtocol(nn_pop_protocolExtension_t *protocolExtension, Class clazz) {
    
    __block nn_pop_extensionNode_p defaultList = nil;
    __block nn_pop_extensionNode_p constrainedList = nil;
    
    nn_pop_extensionListForeach(&(protocolExtension->extension), ^(nn_pop_extensionNode_p node, BOOL *stop) {
        
        nn_pop_where_value_def matchValue = node->where_fp(clazz);
        
        if (matchValue == nn_pop_where_value_matched_default) {
            nn_pop_extensionNode_p matchedNode = nn_pop_extensionNodeNew();
            nn_pop_extensionNodeCopy(matchedNode, node);
            matchedNode->next = nil;
            nn_pop_extensionListAppend(&(defaultList), &(matchedNode));
        }
        
        if (matchValue == nn_pop_where_value_matched_constrained) {
            BOOL conform = true;
            for (unsigned int i = 0; i < node->confromProtocolCount; i++) {
                Protocol *protocol = node->confromProtocols[i];
                if ([clazz conformsToProtocol:protocol] == false) {
                    conform = false;
                    break;
                }
            }
            if (conform) {
                nn_pop_extensionNode_p matchedNode = nn_pop_extensionNodeNew();
                nn_pop_extensionNodeCopy(matchedNode, node);
                matchedNode->next = nil;
                nn_pop_extensionListAppend(&(constrainedList), &(matchedNode));
            }
        }
    });
    
    __unused NSString *(^assertExtensionDesc)(nn_pop_extensionNode_p *head) = ^(nn_pop_extensionNode_p *head){
        NSMutableArray<NSString *> *extension_names = [NSMutableArray new];
        nn_pop_extensionListForeach(head, ^(nn_pop_extensionNode_p item, BOOL *stop) {
            [extension_names addObject:NSStringFromClass(item->clazz)];
        });
        NSString *extensionDesc = [extension_names componentsJoinedByString:@", "];
        return extensionDesc;
    };
    NSCAssert(!(nn_pop_extensionListCount(&(constrainedList)) > 1),
              @"Matched multiple constraint protocol extensions for class %@. The matched protocol extensions: %@", @(class_getName(clazz)), assertExtensionDesc(&(constrainedList)));
    NSCAssert(!(nn_pop_extensionListCount(&(defaultList)) > 1),
              @"Matched multiple default protocol extensions for class %@. The matched protocol extensions: %@", @(class_getName(clazz)), assertExtensionDesc(&(defaultList)));
    NSCAssert(!((nn_pop_extensionListCount(&(constrainedList)) == 0) && (nn_pop_extensionListCount(&(defaultList)) == 0)),
              @"Unmatched to the protocol extension for class %@", @(class_getName(clazz)));
    
    if (nn_pop_extensionListCount(&(constrainedList)) == 1) {
        nn_pop_injectProtocolExtension(constrainedList->clazz, clazz, false);
    }
    if (nn_pop_extensionListCount(&(defaultList)) == 1) {
        nn_pop_injectProtocolExtension(defaultList->clazz, clazz, true);
    }
    
    nn_pop_extensionListFree(&defaultList);
    nn_pop_extensionListFree(&constrainedList);
    
    return;
}

/// Injects each protocols extension in to the corresponding class
/// @param protocolExtensions nn_pop_protocol_extension_t list
/// @param protocolExtensionCount nn_pop_protocol_extension_t list count
void nn_pop_injectProtocols (nn_pop_protocolExtension_t **protocolExtensions, unsigned int protocolExtensionCount) {
    
    qsort_b(protocolExtensions, protocolExtensionCount, sizeof(nn_pop_protocolExtension_t *), ^(const void *a, const void *b){
        
        if (a == b)
            return 0;
        
        const nn_pop_protocolExtension_t *p_a = *(nn_pop_protocolExtension_t **)a;
        const nn_pop_protocolExtension_t *p_b = *(nn_pop_protocolExtension_t **)b;
        
        int (^protocolInjectionPriority)(const nn_pop_protocolExtension_t *) = ^(const nn_pop_protocolExtension_t *protocol){
            int runningTotal = 0;
            
            for (size_t i = 0; i < protocolExtensionCount; ++i) {
                
                if (protocol == *(protocolExtensions + i))
                    continue;
                
                if (protocol_conformsToProtocol(protocol->protocol, protocolExtensions[i]->protocol))
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
    
    Class *clazzes = (Class *)nn_pop_malloc((size_t)(classCount + 1) * sizeof(Class));
    if (!clazzes) {
        fprintf(stderr, "ERROR: Could not allocate space for %d clazzes\n", classCount);
        return;
    }
    
    classCount = objc_getClassList(clazzes, classCount);
    
    @autoreleasepool {
        
        for (size_t i = 0; i < protocolExtensionCount; ++i) {
            
            nn_pop_protocolExtension_t *protocol = protocolExtensions[i];
            
            std::set<const char *> injected;
            
            // loop all clazzes
            for (unsigned int i = 0; i < classCount; i++) {
                
                Class clazz = clazzes[i];
                
                if (nn_pop_class_conformsToProtocol(clazz, protocol->protocol) == false) {
                    continue;
                }
                if (nn_pop_isExtensionClass(clazz, protocolExtensions, protocolExtensionCount) == true) {
                    continue;
                }
                
                Class rootClazz = nn_pop_class_rootProtocolClass(clazz, protocol->protocol);
                if (injected.find(class_getName(rootClazz)) == injected.end()) {
                    nn_pop_injectProtocol(protocol, rootClazz);
                    injected.insert(class_getName(rootClazz));
                }
                if (clazz !=  rootClazz) {
                    nn_pop_injectProtocol(protocol, clazz);
                    injected.insert(class_getName(clazz));
                }
            }
        }
    }
    
    free(clazzes);
}

/// Loads protocol extensions info from image segment
/// @param mhp A mach header appears at the very beginning of the object file
/// @param sectname A section name in __DATA segment
void nn_pop_loadSection(const nn_pop_mach_header *mhp, const char *sectname, void (^loaded)(nn_pop_protocolExtension_t **protocolExtensions, unsigned int protocolExtensionCount)) {
    
    if (pthread_mutex_lock(&nn_pop_injectLock) != 0) {
        fprintf(stderr, "ERROR: Could not synchronize on special protocol data\n");
    }
    
    unsigned long size = 0;
    uintptr_t *sectionData = (uintptr_t*)getsectiondata(mhp, nn_pop_metamacro_stringify(nn_pop_segment_name), sectname, &size);
    if (size == 0) {
        pthread_mutex_unlock(&nn_pop_injectLock);
        return;
    }
    
    unsigned long sectionItemCount = size / sizeof(nn_pop_extensionDescription_t);
    nn_pop_extensionDescription_t *sectionItems = (nn_pop_extensionDescription_t *)sectionData;
    
    nn_pop_protocolExtension_t **protocolExtensions = nn_pop_protocolExtensionsNew((size_t) (sectionItemCount + 1));
    if (protocolExtensions == NULL) {
        pthread_mutex_unlock(&nn_pop_injectLock);
        return;
    }
    
    for (unsigned int sectionIndex = 0, protocolIndex = 0; sectionIndex < sectionItemCount; sectionIndex++) {
        
        nn_pop_extensionDescription_t *_extensionDescription = &sectionItems[sectionIndex];
        nn_pop_protocolExtension_t *protocolExtension = nn_pop_protocolExtensionNew();
        if (protocolExtension == NULL) {
            continue;
        }
        nn_pop_protocolExtensionInitWithExtensionDescription(protocolExtension, _extensionDescription);
        protocolExtensions[protocolIndex++] = protocolExtension;
    }
    
    qsort_b(protocolExtensions, sectionItemCount, sizeof(nn_pop_protocolExtension_t *), ^int(const void *a, const void *b) {
        const nn_pop_protocolExtension_t *_a = *(nn_pop_protocolExtension_t **)a;
        const nn_pop_protocolExtension_t *_b = *(nn_pop_protocolExtension_t **)b;
        
        const char *_aName = protocol_getName(_a->protocol);
        const char *_bName = protocol_getName(_b->protocol);
        
        int cmp = strcmp(_aName, _bName);
        return cmp;
    });
    
    unsigned int protocolBaseIndex = 0, protocolForwardIndex = 1;
    while (protocolForwardIndex < sectionItemCount) {
        
        nn_pop_protocolExtension_t *protocolBase = protocolExtensions[protocolBaseIndex];
        nn_pop_protocolExtension_t *protocolForward = protocolExtensions[protocolForwardIndex];
        
        if (protocol_isEqual(protocolBase->protocol, protocolForward->protocol)) {
            nn_pop_extensionListAppend(&(protocolBase->extension), &(protocolForward->extension));
            protocolForward->extension = nil;
            nn_pop_protocolExtensionFree(protocolForward);
        }
        else {
            protocolExtensions[++protocolBaseIndex] = protocolForward;
        }
        protocolForwardIndex++;
    }
    
    unsigned int protocolCount = protocolBaseIndex + 1;
    protocolExtensions = (nn_pop_protocolExtension_t **)nn_pop_realloc(protocolExtensions, (protocolCount + 1) * sizeof(nn_pop_protocolExtension_t *));
    memset(protocolExtensions + protocolCount, 0, sizeof(nn_pop_protocolExtension_t *));
    
    if (loaded) {
        loaded(protocolExtensions, protocolCount);
    }
    
    nn_pop_protocolExtensionsFree(protocolExtensions, protocolCount);
    
    pthread_mutex_unlock(&nn_pop_injectLock);
}

/// ProgramVars, it is defined in ImageLoader.h at dyld project.
/// @note dyld project: https://opensource.apple.com/tarballs/dyld/
struct nn_pop_ProgramVars
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
__attribute__((constructor)) void nn_pop_prophet(int argc, const char* argv[], const char* envp[], const char* apple[], const nn_pop_ProgramVars* vars) {
    
    nn_pop_mach_header *mhp = (nn_pop_mach_header *)vars->mh;
    
    nn_pop_loadSection(mhp, nn_pop_metamacro_stringify(nn_pop_section_name), ^(nn_pop_protocolExtension_t **protocolExtensions, unsigned int protocolExtensionCount) {
        nn_pop_injectProtocols(protocolExtensions, protocolExtensionCount);
    });
}

