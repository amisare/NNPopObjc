//
//  NNPopObjcInjection.m
//  NNPopObjc
//
//  Created by 顾海军 on 2019/10/26.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNPopObjcInjection.h"
#import <mach-o/getsect.h>
#import <mach-o/dyld.h>
#import <objc/runtime.h>
#import <ctype.h>
#import <os/lock.h>
#import <pthread.h>
#import <stdio.h>
#import <stdlib.h>
#import <string.h>

#import <iostream>
#import <vector>
#import <set>

#import "NNPopObjcMemory.h"
#import "NNPopObjcProtocol.h"
#import "NNPopObjcLogging.h"


namespace popobjc {

typedef struct
#ifdef __LP64__
mach_header_64
#else
mach_header
#endif
nn_pop_mach_header;

static pthread_mutex_t injectLock = PTHREAD_MUTEX_INITIALIZER;

/// Gets a root clazz that confrom to protocol.
/// @param protocol A protocol that root clazz adpoted.
/// @param clazz A clazz that it is sub clazz of root or the root self.
Class classRootProtocolClass(Class clazz, Protocol *protocol) {
    
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
BOOL classConformsToProtocol(Class clazz, Protocol *protocol)  {
    
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
BOOL classIsExtensionClass(Class clazz, std::vector<ProtocolExtension *> protocolExtensions) {
    
    BOOL result = false;
    
    for (auto protocolExtension : protocolExtensions) {
        
        protocolExtension->extension.foreach([&](ExtensionNode *item, BOOL *stop) {
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
/// @param clazz A class
/// @param extentionClazz Extension implement class
/// @param checkSupserImplement Whether the injection should check super implemention,
/// if a instance mathod has been implemented by super class, then jump over the injection.
void injectImplementions(Class clazz, Class extentionClazz, BOOL checkSupserImplement) {
    
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
/// @param clazz A class
/// @param protocolExtension A nn_pop_protocol_extension_t struct
void injectProtocolExtension(Class clazz, ProtocolExtension *protocolExtension) {
    
    ExtensionList defaultList = ExtensionList();
    ExtensionList constrainedList = ExtensionList();
    
    protocolExtension->extension.foreach([&](ExtensionNode *node, BOOL *stop) {
        
        nn_pop_where_value_def matchValue = node->where_fp(clazz);
        
        if (matchValue == nn_pop_where_value_matched_default) {
            ExtensionNode *matchedNode = new ExtensionNode(node);
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
                ExtensionNode *matchedNode = new ExtensionNode(node);
                matchedNode->next = nil;
                constrainedList.append(matchedNode);
            }
        }
    });
    
    __unused NSString *(^assertExtensionDesc)(ExtensionList list) = ^(ExtensionList list){
        NSMutableArray<NSString *> *extension_names = [NSMutableArray new];
        list.foreach([=](ExtensionNode *item, BOOL *stop) {
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
        injectImplementions(clazz, constrainedList.head()->clazz, false);
    }
    if (defaultList.count() == 1) {
        injectImplementions(clazz, defaultList.head()->clazz, true);
    }
    
    defaultList.clear();
    constrainedList.clear();
    
    return;
}

/// Injects each protocols extension in to the corresponding class
/// @param protocolExtensions nn_pop_protocol_extension_t list
void injectProtocolExtensions(std::vector<ProtocolExtension *> protocolExtensions) {
    
    std::sort(protocolExtensions.begin(), protocolExtensions.end(), [=](const ProtocolExtension *a, const ProtocolExtension *b) {
        
        std::function<int(const ProtocolExtension *)> protocolInjectionPriority = [=](const ProtocolExtension *protocolExtension) {
            
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
        POP_LOG(FATAL) << "No clazzes registered with the runtime";
        return;
    }
    
    Class *clazzes = (Class *)nn_pop_malloc((size_t)(classCount + 1) * sizeof(Class));
    if (!clazzes) {
        POP_LOG(FATAL) << "Could not allocate space for " << classCount << " clazzes";
        return;
    }
    
    classCount = objc_getClassList(clazzes, classCount);
    
    @autoreleasepool {
        
        for (auto protocolExtension : protocolExtensions) {
            
            std::set<const char *> injected;
            
            // loop all clazzes
            for (unsigned int i = 0; i < classCount; i++) {
                
                Class clazz = clazzes[i];
                
                if (classConformsToProtocol(clazz, protocolExtension->protocol) == false) {
                    continue;
                }
                if (classIsExtensionClass(clazz, protocolExtensions) == true) {
                    continue;
                }
                
                Class rootClazz = classRootProtocolClass(clazz, protocolExtension->protocol);
                if (injected.find(class_getName(rootClazz)) == injected.end()) {
                    injectProtocolExtension(rootClazz, protocolExtension);
                    injected.insert(class_getName(rootClazz));
                }
                if (clazz !=  rootClazz) {
                    injectProtocolExtension(clazz, protocolExtension);
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
void loadSection(const nn_pop_mach_header *mhp,
                 const char *sectname,
                 std::function<void (std::vector<ProtocolExtension *> protocolExtensions)> loaded) {
    
    if (pthread_mutex_lock(&injectLock) != 0) {
        POP_LOG(FATAL) << "Lock injection thread failed";
        return;
    }
    
    unsigned long size = 0;
    uintptr_t *sectionData = (uintptr_t*)getsectiondata(mhp, nn_pop_metamacro_stringify(nn_pop_segment_name), sectname, &size);
    if (size == 0) {
        pthread_mutex_unlock(&injectLock);
        return;
    }
    
    @autoreleasepool {
        
        unsigned long sectionItemCount = size / sizeof(ExtensionDescription);
        ExtensionDescription *sectionItems = (ExtensionDescription *)sectionData;
        
        std::vector<ProtocolExtension *> protocolExtensions;
        
        for (unsigned int i = 0; i < sectionItemCount; i++) {
            
            ExtensionDescription *_extensionDescription = &sectionItems[i];
            ProtocolExtension *protocolExtension = new ProtocolExtension(_extensionDescription);
            if (protocolExtension == NULL) {
                continue;
            }
            
            std::vector<ProtocolExtension *>::iterator _p = protocolExtensions.begin();
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
    }
    
    pthread_mutex_unlock(&injectLock);
}

/// Image loaded callback function.
/// @param mhp mhp
/// @param vmaddr_slide vmaddr_slide
void imageLoadedCallback(const struct mach_header *mhp, intptr_t vmaddr_slide) {
    
    nn_pop_mach_header *_mhp = (nn_pop_mach_header *)mhp;
    
    loadSection(_mhp,
                nn_pop_metamacro_stringify(nn_pop_section_name),
                [](std::vector<ProtocolExtension *> protocolExtensions) {
        injectProtocolExtensions(protocolExtensions);
    });
}

/// Initializer function is called by ImageLoaderMachO::doModInitFunctions at dyld project.
/// @note dyld project: https://opensource.apple.com/tarballs/dyld/
/// @note fix: The dynamic library section cannot be loaded when the protocol extensions
/// are implemented in a dynamic library.
__attribute__((constructor)) void initializer() {
    
    _dyld_register_func_for_add_image(imageLoadedCallback);
}

} // namespace popobjc


/// @note fix: __attribute__((constructor)) function is not called in static library mode.
@interface NNPopObjcInjection : NSObject

@end

@implementation NNPopObjcInjection

@end
