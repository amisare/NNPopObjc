//
//  NNPopObjcInjection.m
//  NNPopObjc
//
//  Created by GuHaijun on 2019/10/26.
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

#import <vector>
#import <unordered_set>

#import "NNPopObjcMemory.h"
#import "NNPopObjcProtocol.h"
#import "NNPopObjcLogging.h"
#import "NNPopObjcTickTock.h"


namespace popobjc {

typedef struct
#ifdef __LP64__
mach_header_64
#else
mach_header
#endif
nn_pop_mach_header;


/// Returns a Boolean value that indicates whether a class conforms to a given protocol.
/// It is same as: + (BOOL)conformsToProtocol:(Protocol *)protocol
/// @param clazz The class you want to inspect.
/// @param protocol A protocol.
/// @param inheritLevel The class inherit level.
BOOL classConformsToProtocol(Class clazz, Protocol *protocol, unsigned int *inheritLevel)  {

    NSCAssert(clazz != nil, @"Parameter clazz cannot be nil");
    NSCAssert(protocol != nil, @"Parameter protocol cannot be nil");

    BOOL result = false;
    unsigned int level = 0;

    Class currentClazz = clazz;
    while (currentClazz) {
        level += 1;
        if (class_conformsToProtocol(currentClazz, protocol)) {
            result = true;
        }
        currentClazz = class_getSuperclass(currentClazz);
    }
    *inheritLevel = level;
    return result;
}

/// Returns a Boolean value that indicates whether clazz is in protocol implements.
/// @param clazz A class
/// @param extensionClazzes Class name list of protocol extension implementions
BOOL classIsExtensionClass(Class clazz, vector<const char *> &extensionClazzes) {

    NSCAssert(clazz != nil, @"Parameter clazz cannot be nil");

    BOOL result = false;
    
    for (unsigned int i = 0; i < extensionClazzes.size(); i++) {
        if (clazz == objc_getClass(extensionClazzes[i])) {
            result = true;
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

    NSCAssert(clazz != nil, @"Parameter clazz cannot be nil");
    NSCAssert(extentionClazz != nil, @"Parameter extentionClazz cannot be nil");

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
/// @param extensions A nn_pop_protocol_extension_t struct list
void injectProtocolExtension(Class clazz, vector<ExtensionDescription *> &extensions) {

    NSCAssert(clazz != nil, @"Parameter clazz cannot be nil");
    NSCAssert(extensions.size() != 0, @"Parameter protocolExtension cannot be nil");

    vector<ExtensionDescription *> defaultList;
    vector<ExtensionDescription *> constrainedList;
    
    for (unsigned int i = 0; i < extensions.size(); i++) {
        
        ExtensionDescription *extension = extensions[i];
        
        nn_pop_where_value_def matchValue = extension->where_fp(clazz);
        if (matchValue == nn_pop_where_value_matched_default) {
            defaultList.push_back(extension);
        }
        if (matchValue == nn_pop_where_value_matched_constrained) {
            BOOL conform = true;
            for (unsigned int i = 0; i < extension->confrom_protocol_count; i++) {
                Protocol *protocol = objc_getProtocol(extension->confrom_protocols[i]);
                if ([clazz conformsToProtocol:protocol] == false) {
                    conform = false;
                    break;
                }
            }
            if (conform) {
                constrainedList.push_back(extension);
            }
        }
    }
    
    __unused NSString *(^assertExtensionDesc)(vector<ExtensionDescription *> list) = ^(vector<ExtensionDescription *> list){
        NSMutableArray<NSString *> *extension_names = [NSMutableArray new];
        for (unsigned int i = 0; i < list.size(); i++) {
            [extension_names addObject:[NSString stringWithUTF8String:list[i]->clazz]];
        }
        NSString *extensionDesc = [extension_names componentsJoinedByString:@", "];
        return extensionDesc;
    };
    NSCAssert(!(constrainedList.size() > 1),
              @"Matched multiple constraint protocol extensions for class %@. The matched protocol extensions: %@", @(class_getName(clazz)), assertExtensionDesc(constrainedList));
    NSCAssert(!(defaultList.size() > 1),
              @"Matched multiple default protocol extensions for class %@. The matched protocol extensions: %@", @(class_getName(clazz)), assertExtensionDesc(defaultList));
    NSCAssert(!((constrainedList.size() == 0) && (defaultList.size() == 0)),
              @"Unmatched to the protocol extension for class %@", @(class_getName(clazz)));

    if (constrainedList.size() == 1) {
        injectImplementions(clazz, objc_getClass(constrainedList[0]->clazz), false);
    }
    if (defaultList.size() == 1) {
        injectImplementions(clazz, objc_getClass(defaultList[0]->clazz), true);
    }

    defaultList.clear();
    constrainedList.clear();

    return;
}

/// Injects each protocols extension in to the corresponding class
/// @param protocolExtension ProtocolExtension
void injectProtocolExtensions(ProtocolExtension &protocolExtension) {

    POP_DLOG(INFO) << "Inject protocol extensions begin";

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
    
    unordered_map<const char *, vector<pair<const char *, int>>>protocolClazzesMap;
    // Loop all protocols
    int protocolCount = (int)protocolExtension.protocols.size();
    for (int i = protocolCount - 1; i >= 0 ; i--) {
        const char *protocolName = protocolExtension.protocols[i];
        Protocol *protocol = objc_getProtocol(protocolName);
        
        const char *lastConformProtocolName = NULL;
        for (int j = i + 1; j < protocolCount; j++) {
            const char *_lastConformProtocolName = protocolExtension.protocols[j];
            if (protocol_conformsToProtocol(protocol, objc_getProtocol(_lastConformProtocolName))) {
                lastConformProtocolName = _lastConformProtocolName;
            }
        }
        
        if (lastConformProtocolName != NULL) {
            // Loop all clazzes
            int lastConformProtocolClazzCount = (int)protocolClazzesMap[lastConformProtocolName].size();
            for (int i = 0; i < lastConformProtocolClazzCount; i++) {
                const char *clazzName = protocolClazzesMap[lastConformProtocolName][i].first;
                Class clazz = objc_getClass(clazzName);
                unsigned int inheritLevel = 0;
                if (classConformsToProtocol(clazz, protocol, &inheritLevel)) {
                    if (classIsExtensionClass(clazz, protocolExtension.clazzes)) {
                        continue;
                    }
                    protocolClazzesMap[protocolName].push_back(make_pair(clazzName, inheritLevel));
                }
            }
        }
        else { // Loop all clazzes
            for (int i = 0; i < classCount; i++) {
                Class clazz = clazzes[i];
                const char *clazzName = class_getName(clazz);
                unsigned int inheritLevel = 0;
                if (classConformsToProtocol(clazz, protocol, &inheritLevel)) {
                    if (classIsExtensionClass(clazz, protocolExtension.clazzes)) {
                        continue;
                    }
                    protocolClazzesMap[protocolName].push_back(make_pair(clazzName, inheritLevel));
                }
            }
        }
        // A higher inheritLevel has a higher priority
        sort(protocolClazzesMap[protocolName].begin(), protocolClazzesMap[protocolName].end(), [=](pair<const char *, int> &lhs, pair<const char *, int> &rhs) {
            return lhs.second > rhs.second;
        });
    }
    // Inject
    for (int i = 0; i < protocolCount; i++) {
        const char *protocolName = protocolExtension.protocols[i];
        for (auto clazzName : protocolClazzesMap[protocolName]) {
            vector<ExtensionDescription *>extensions = protocolExtension.extensions[protocolName];
            Class clazz = objc_getClass(clazzName.first);
            injectProtocolExtension(clazz, extensions);
        }
    }

    free(clazzes);

    POP_DLOG(INFO) << "Inject protocol extensions end";
}

/// Loads protocol extensions info from image segment
/// @param loaded A section loaded callback
void loadSection(std::function<void (ProtocolExtension &protocolExtensions)> loaded) {
    
    const char *segment = nn_pop_metamacro_stringify(nn_pop_segment_name);
    const char *section = nn_pop_metamacro_stringify(nn_pop_section_name);
    
    ProtocolExtension protocolExtension;

    POP_DLOG(INFO) << "Load protocol extensions begin";
    
    uint32_t c = _dyld_image_count();
    for (uint32_t i = 0; i < c; i++) {
        nn_pop_mach_header *mhp = (nn_pop_mach_header *)_dyld_get_image_header(i);
        unsigned long size = 0;
        uintptr_t *sectionData = (uintptr_t*)getsectiondata(mhp, segment, section, &size);
        if (size == 0) {
            continue;
        }
        unsigned int sectionItemCount = (int)size / sizeof(ExtensionDescription);
        ExtensionDescription *sectionItems = (ExtensionDescription *)sectionData;
        protocolExtension.append(sectionItems, sectionItemCount);
    }
    
    POP_DLOG(INFO) << "Load protocol extensions end";

    if (loaded) {
        loaded(protocolExtension);
    }
}

/// Initializer function is called by ImageLoaderMachO::doModInitFunctions at dyld project.
/// @note dyld project: https://opensource.apple.com/tarballs/dyld/
/// @note mach_header is used to load the section which records the protocol extensions.
/// In a library, vars paramater of __attribute__((constructor)) function can only get
/// mach_header of current library. Here we need to get the mach_header from all libraries
/// through _dyld_get_image_header function.
/// @note Integration using the static library pattern, in the linking process, this function
/// is not referenced, so it will be entirely ignored.
/// To prevent this, you need add '-all_load' or '-force_load (path_to_static_archive_library)'
/// parameter for Xcode > Build Settings > Other Linker Flags.
__attribute__((constructor)) void initializer(int argc,
                                              const char **argv,
                                              const char **envp,
                                              const char **apple,
                                              const void* vars) {
    loadSection([](ProtocolExtension &protocolExtensions) {
        injectProtocolExtensions(protocolExtensions);
    });
}

} // namespace popobjc
