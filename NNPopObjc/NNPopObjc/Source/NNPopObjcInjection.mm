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
#import <vector>
#import <set>

#import "NNPopObjcMemory.h"
#import "NNPopObjcProtocol.h"


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
/// @param protocolExtensions nn_pop_protocol_extension_t list
BOOL nn_pop_isExtensionClass(Class clazz, std::vector<nn_pop_protocolExtension *> protocolExtensions) {
    
    BOOL result = false;
    
    for (auto protocolExtension : protocolExtensions) {
        
        protocolExtension->extension.foreach([&](nn_pop_extensionNode *item, BOOL *stop) {
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
void nn_pop_injectProtocol(nn_pop_protocolExtension *protocolExtension, Class clazz) {
    
    nn_pop_extensionList defaultList = nn_pop_extensionList();
    nn_pop_extensionList constrainedList = nn_pop_extensionList();
    
    protocolExtension->extension.foreach([&](nn_pop_extensionNode *node, BOOL *stop) {
        
        nn_pop_where_value_def matchValue = node->where_fp(clazz);
        
        if (matchValue == nn_pop_where_value_matched_default) {
            nn_pop_extensionNode *matchedNode = node->copy();
            matchedNode->next = nil;
            defaultList.append(matchedNode);
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
                nn_pop_extensionNode *matchedNode = node->copy();
                matchedNode->next = nil;
                constrainedList.append(matchedNode);
            }
        }
    });
    
    __unused NSString *(^assertExtensionDesc)(nn_pop_extensionList list) = ^(nn_pop_extensionList list){
        NSMutableArray<NSString *> *extension_names = [NSMutableArray new];
        list.foreach([=](nn_pop_extensionNode *item, BOOL *stop) {
            [extension_names addObject:NSStringFromClass(item->clazz)];
        });
        NSString *extensionDesc = [extension_names componentsJoinedByString:@", "];
        return extensionDesc;
    };
    NSCAssert(!(constrainedList.count() > 1),
              @"Matched multiple constraint protocol extensions for class %@. The matched protocol extensions: %@", @(class_getName(clazz)), assertExtensionDesc(constrainedList));
    NSCAssert(!(defaultList.count() > 1),
              @"Matched multiple default protocol extensions for class %@. The matched protocol extensions: %@", @(class_getName(clazz)), assertExtensionDesc(defaultList));
    NSCAssert(!((constrainedList.count() == 0) && (defaultList.count() == 0)),
              @"Unmatched to the protocol extension for class %@", @(class_getName(clazz)));
    
    if (constrainedList.count() == 1) {
        nn_pop_injectProtocolExtension(constrainedList.head()->clazz, clazz, false);
    }
    if (defaultList.count() == 1) {
        nn_pop_injectProtocolExtension(defaultList.head()->clazz, clazz, true);
    }
    
    defaultList.clear();
    constrainedList.clear();
    
    return;
}

/// Injects each protocols extension in to the corresponding class
/// @param protocolExtensions nn_pop_protocol_extension_t list
void nn_pop_injectProtocols(std::vector<nn_pop_protocolExtension *> protocolExtensions) {
    
    std::sort(protocolExtensions.begin(), protocolExtensions.end(), [=](const nn_pop_protocolExtension *a, const nn_pop_protocolExtension *b) {
        
        std::function<int(const nn_pop_protocolExtension *)> protocolInjectionPriority = [=](const nn_pop_protocolExtension *protocolExtension) {
            
            int runningTotal = 0;
            
            for (auto _protocolExtension : protocolExtensions) {
                if (protocolExtension == _protocolExtension)
                    continue;
                
                if (protocol_conformsToProtocol(protocolExtension->protocol, _protocolExtension->protocol))
                    runningTotal++;
            }
            return runningTotal;
        };
        
        return protocolInjectionPriority(b) - protocolInjectionPriority(a);
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
        
        for (auto protocolExtension : protocolExtensions) {
            
            std::set<const char *> injected;
            
            // loop all clazzes
            for (unsigned int i = 0; i < classCount; i++) {
                
                Class clazz = clazzes[i];
                
                if (nn_pop_class_conformsToProtocol(clazz, protocolExtension->protocol) == false) {
                    continue;
                }
                if (nn_pop_isExtensionClass(clazz, protocolExtensions) == true) {
                    continue;
                }
                
                Class rootClazz = nn_pop_class_rootProtocolClass(clazz, protocolExtension->protocol);
                if (injected.find(class_getName(rootClazz)) == injected.end()) {
                    nn_pop_injectProtocol(protocolExtension, rootClazz);
                    injected.insert(class_getName(rootClazz));
                }
                if (clazz !=  rootClazz) {
                    nn_pop_injectProtocol(protocolExtension, clazz);
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
void nn_pop_loadSection(const nn_pop_mach_header *mhp,
                        const char *sectname,
                        std::function<void (std::vector<nn_pop_protocolExtension *> protocolExtensions)> loaded) {
    
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
    
    std::vector<nn_pop_protocolExtension *> protocolExtensions;
    
    for (unsigned int i = 0; i < sectionItemCount; i++) {
        
        nn_pop_extensionDescription_t *_extensionDescription = &sectionItems[i];
        nn_pop_protocolExtension *protocolExtension = new nn_pop_protocolExtension(_extensionDescription);
        if (protocolExtension == NULL) {
            continue;
        }
        
        std::vector<nn_pop_protocolExtension *>::iterator _p = protocolExtensions.begin();
        while (_p != protocolExtensions.end()) {
            if (protocol_isEqual((*_p)->protocol, protocolExtension->protocol)) {
                break;
            }
            _p++;
        }
        
        if (_p != protocolExtensions.end()) {
            (*_p)->extension.append(protocolExtension->extension.head());
            protocolExtension->extension.head(NULL);
            delete protocolExtension;
        }
        else {
            protocolExtensions.push_back(protocolExtension);
        }
    }
    
    if (loaded) {
        loaded(protocolExtensions);
    }
    
    for (auto protocolExtension : protocolExtensions) {
        delete protocolExtension;
    }
    
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
__attribute__((constructor)) void nn_pop_prophet(int argc,
                                                 const char* argv[],
                                                 const char* envp[],
                                                 const char* apple[],
                                                 const nn_pop_ProgramVars* vars) {
    
    nn_pop_mach_header *mhp = (nn_pop_mach_header *)vars->mh;
    
    nn_pop_loadSection(mhp,
                       nn_pop_metamacro_stringify(nn_pop_section_name),
                       [](std::vector<nn_pop_protocolExtension *> protocolExtensions) {
        nn_pop_injectProtocols(protocolExtensions);
    });
}

