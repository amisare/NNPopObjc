//
//  NNPopObjc-Protocol.h
//  NNPopObjc
//
//  Created by 顾海军 on 2019/10/8.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#ifndef NNPopObjc_Protocol_h
#define NNPopObjc_Protocol_h

#include <Foundation/Foundation.h>
#include <objc/runtime.h>
#import "NNPopObjc-Define.h"

/// Gets a class that conformed to protocol.
NS_INLINE Protocol * _Nullable
nn_getProtocol(Class _Nullable clazz, SEL _Nullable sel) {
    
    // Result
    Protocol *result = nil;
    
    // Check params
    if (clazz == nil || sel == nil) {
        return result;
    }
    
    // Loop class
    Class currentClazz = clazz;
    
    while (currentClazz) {
        
        // Get protocol list
        unsigned int count = 0;
        __unsafe_unretained Protocol **protocols = class_copyProtocolList(currentClazz, &count);
        
        // Check each protocol
        for (unsigned int i = 0; i < count; i++) {
            
            // Get method description
            struct objc_method_description methodDescription = (struct objc_method_description){NULL, NULL};
            
            // Required method
            methodDescription = protocol_getMethodDescription(protocols[i], sel, YES, class_isMetaClass(currentClazz) ^ 1);
            if (sel_isEqual(methodDescription.name, sel)) {
                result = protocols[i];
                break;
            }
            
            // Optional method
            methodDescription = protocol_getMethodDescription(protocols[i], sel, NO, class_isMetaClass(currentClazz) ^ 1);
            if (sel_isEqual(methodDescription.name, sel)) {
                result = protocols[i];
                break;
            }
        }
        
        // release
        free(protocols);
        
        // Found protocol
        if (result) {
            return result;
        }
        
        // Get superClass and continue
        currentClazz = class_getSuperclass(currentClazz);
    }
    
    return nil;
}

/// Gets a root class that conformed to protocol.
NS_INLINE Class _Nullable
nn_rootProtocolClass(Protocol * _Nullable protocol, Class _Nullable clazz) {
    
    Class result = nil;
    
    if (clazz == nil || protocol == nil) {
        return result;
    }
    
    Class currentClazz = clazz;
    while (currentClazz) {
        if (class_conformsToProtocol(currentClazz, protocol)) {
            result = currentClazz;
        }
        // Get superClass and continue
        currentClazz = class_getSuperclass(currentClazz);
    }
    
    return result;
}

/// Creates and returns a list of pointers to all registered class definitions.
NS_INLINE Class _Nonnull * _Nullable
nn_copyClassList(unsigned int * _Nullable outCount) {
    return objc_copyClassList(outCount);
}

/// Creates and returns a list of pointers to all registered meta class definitions.
NS_INLINE Class _Nonnull * _Nullable
nn_copyMetaClassList(unsigned int * _Nullable outCount) {
    unsigned int clazzCount = 0;
    Class *clazzes = nn_copyClassList(&clazzCount);
    
    Class *result = nil;
    unsigned int metaClazzCount = 0;
    if (clazzCount > 0) {
        result = (Class *)malloc((1 + clazzCount) * sizeof(Class));
        for (NSInteger i = 0; i < clazzCount; i++) {
            Class clazz = clazzes[i];
            Class metaClazz = object_getClass(clazz);
            if (metaClazz) {
                result[metaClazzCount++] = metaClazz;
            }
        }
        result[metaClazzCount] = nil;
    }
    
    if (outCount) *outCount = metaClazzCount;
    return result;
}


typedef enum : NSUInteger {
    NN_CopyProtocolClassListTypeClass,
    NN_CopyProtocolClassListTypeMetaClass,
} NN_CopyProtocolClassListType;


/// Creates and returns a list of pointers to all registered class definitions that conformed to protocol.
NS_INLINE Class _Nonnull * _Nullable
nn_copyProtocolClassList(Protocol * _Nullable protocol,
                         unsigned int * _Nullable outCount,
                         NN_CopyProtocolClassListType clazzType) {
    
    Class *result = nil;
    
    // Check params
    if (protocol == nil) {
        return result;
    }
    
    // Get all classes
    unsigned int clazzCount = 0;
    Class *clazzes = (clazzType == NN_CopyProtocolClassListTypeMetaClass) ? nn_copyMetaClassList(&clazzCount) : nn_copyClassList(&clazzCount);
    
    // Get protocol class count
    unsigned int protocolClazzCount = 0;
    for (unsigned int i = 0; i < clazzCount; i++) {
        Class clazz = clazzes[i];
        if (class_conformsToProtocol(clazz, protocol)) {
            protocolClazzCount++;
        }
    }
    
    // Get protocol classes
    if (protocolClazzCount > 0) {
        result = (Class *)malloc((1 + protocolClazzCount) * sizeof(Class));
        unsigned int c = 0;
        for (NSInteger i = 0; i < clazzCount; i++) {
            Class clazz = clazzes[i];
            if (class_conformsToProtocol(clazz, protocol)) {
                result[c++] = clazz;
            }
        }
        result[c] = nil;
    }
    
    free(clazzes);
    
    if (outCount) *outCount = protocolClazzCount;
    return result;
}

/// Removes each object in another given inRightClazzList from the inLeftClazzList, if present.
NS_INLINE Class _Nonnull * _Nullable
nn_copyClassListMinus(Class _Nonnull * _Nullable inLeftClazzList,
                      unsigned int inLeftClazzCount,
                      Class _Nonnull * _Nullable inRightClazzList,
                      unsigned int inRightClazzCount,
                      unsigned int * _Nullable outCount) {
    
    Class *result = nil;
    if (inLeftClazzList == nil  || inLeftClazzCount == 0) {
        return nil;
    }
    
    if (inRightClazzList == nil || inRightClazzCount == 0) {
        result = (Class *)malloc((1 + inLeftClazzCount) * sizeof(Class));
        memcpy(result, inLeftClazzList, inLeftClazzCount * sizeof(Class));
        result[inLeftClazzCount] = nil;
        
        if (outCount) *outCount = inLeftClazzCount;
        return result;
    }
    
    Class *t = (Class *)malloc((1 + inLeftClazzCount) * sizeof(Class));
    unsigned int c = 0;
    for (unsigned int i = 0; i < inLeftClazzCount; i++) {
        Class clazz = inLeftClazzList[i];
        if (clazz) {
            BOOL isFind = false;
            for (unsigned int j = 0; j < inRightClazzCount; j++) {
                if (clazz == inRightClazzList[j]) {
                    isFind = true;
                    break;
                }
            }
            if (!isFind) {
                t[c++] = clazz;
            }
        }
    }
    t[c] = nil;
    
    result = (Class *)malloc((1 + c) * sizeof(Class));
    memcpy(result, t, (1 + c) * sizeof(Class));
    free(t);
    
    if (outCount) *outCount = c;
    return result;
}

/// Creates and returns a list of pointers to class prefixed with "__NNPopObjc" from inClazzList
NS_INLINE Class _Nonnull * _Nullable
nn_copyPopObjcClassList(Class _Nonnull * _Nullable inClazzList,
                        unsigned int inClazzCount,
                        unsigned int * _Nullable outCount) {
    Class *result = nil;
    
    if (inClazzList == nil || inClazzCount == 0) {
        return result;
    }
    
    Class *t = (Class *)malloc((1 + inClazzCount) * sizeof(Class));
    unsigned int c = 0;
    for (unsigned int i = 0; i < inClazzCount; i++) {
        Class clazz = inClazzList[i];
        if (clazz) {
            if ([NSStringFromClass(clazz) containsString:NNPopObjcPrefix]) {
                t[c++] = clazz;
            }
        }
    }
    t[c] = nil;
    
    result = (Class *)malloc((1 + c) * sizeof(Class));
    memcpy(result, t, (1 + c) * sizeof(Class));
    free(t);
    
    if (outCount) *outCount = c;
    return result;
}

/// Creates and returns a list of pointers to class that conformed to protocol from inClazzList
NS_INLINE Class _Nonnull * _Nullable
nn_copyRootProtocolClassList(Protocol * _Nullable protocol,
                             Class _Nonnull * _Nullable inClazzList,
                             unsigned int inClazzCount,
                             unsigned int * _Nullable outCount) {
    
    Class *result = nil;
    
    if (protocol == nil || inClazzList == nil || inClazzCount == 0) {
        return result;
    }
    
    Class *t = (Class *)malloc((1 + inClazzCount) * sizeof(Class));
    unsigned int c = 0;
    for (unsigned int i = 0; i < inClazzCount; i++) {
        Class rootClazz = nn_rootProtocolClass(protocol, inClazzList[i]);;
        if (rootClazz) {
            unsigned int isFind = false;
            // To prevent the repeat
            for (unsigned int j = 0; j < c; j++) {
                if (rootClazz == t[j]) {
                    isFind = true;
                    break;
                }
            }
            if (!isFind) {
                t[c++] = rootClazz;
            }
        }
    }
    t[c] = nil;
    
    result = (Class *)malloc((1 + c) * sizeof(Class));
    memcpy(result, t, (1 + c) * sizeof(Class));
    free(t);
    
    if (outCount) *outCount = c;
    return result;
}

NS_INLINE void
nn_separateProtocolClassList(Protocol * _Nullable protocol,
                             Class _Nonnull * _Nullable inClazzList,
                             unsigned int inClazzCount,
                             Class _Nonnull *_Nonnull* _Nullable outRootClazzList,
                             unsigned int * _Nullable outRootClazzCount,
                             Class _Nonnull *_Nonnull* _Nullable outSubClazzList,
                             unsigned int * _Nullable outSubClazzCount,
                             Class _Nonnull *_Nonnull* _Nullable outPopObjcClazzList,
                             unsigned int * _Nullable outPopObjcClazzCount) {
    
    unsigned int _outPopObjcClazzCount = 0;
    Class *_outPopObjcClazzList = nil;
    unsigned int _outRootClazzCount = 0;
    Class *_outRootClazzList = nil;
    unsigned int _outSubClazzCount = 0;
    Class *_outSubClazzList = nil;
    
    // Store the classes, Except the PopObjc classes
    unsigned int _exceptPopObjcClazzCount = 0;
    Class *_exceptPopObjcClazzList = nil;
    
    if (!inClazzList || !inClazzCount) {
        if (outRootClazzCount) *outRootClazzCount = 0;
        if (outSubClazzCount) *outSubClazzCount = 0;
        if (outPopObjcClazzCount) *outPopObjcClazzCount = 0;
        return;
    }
    
    // Get NNPopObjc class
    {
        _outPopObjcClazzList = nn_copyPopObjcClassList(inClazzList, inClazzCount, &_outPopObjcClazzCount);
        
        if (outPopObjcClazzList) memcpy(*outPopObjcClazzList, _outPopObjcClazzList, _outPopObjcClazzCount * sizeof(Class));
        if (outPopObjcClazzCount) *outPopObjcClazzCount = _outPopObjcClazzCount;
    }
    
    
    if (!protocol) {
        free(_outPopObjcClazzList);
        if (outRootClazzCount) *outRootClazzCount = 0;
        if (outSubClazzCount) *outSubClazzCount = 0;
        return;
    }
    
    _exceptPopObjcClazzList = nn_copyClassListMinus(inClazzList, inClazzCount, _outPopObjcClazzList, _outPopObjcClazzCount, &_exceptPopObjcClazzCount);
    
    // Get root class
    {
        _outRootClazzList = nn_copyRootProtocolClassList(protocol, _exceptPopObjcClazzList, _exceptPopObjcClazzCount, &_outRootClazzCount);
        if (outRootClazzList) memcpy(*outRootClazzList, _outRootClazzList, _outRootClazzCount * sizeof(Class));
        if (outRootClazzCount) *outRootClazzCount = _outRootClazzCount;
    }
    
    {
        _outSubClazzList = nn_copyClassListMinus(_exceptPopObjcClazzList, _exceptPopObjcClazzCount, _outRootClazzList, _outRootClazzCount, &_outSubClazzCount);
        if (outSubClazzList) memcpy(*outSubClazzList, _outSubClazzList, _outSubClazzCount * sizeof(Class));
        if (outSubClazzCount) *outSubClazzCount = _outSubClazzCount;
    }
    
    free(_exceptPopObjcClazzList);
    free(_outRootClazzList);
    free(_outSubClazzList);
}

NS_INLINE void
nn_implementProtocolClassList(Class _Nonnull * _Nullable inClazzList,
                             unsigned int inClazzCount,
                             Protocol * _Nullable protocol,
                             SEL _Nullable selector,
                             BOOL isRootProtocolClazz) {
    
    if (inClazzList == nil || inClazzCount == 0 || protocol == nil || selector == nil) {
        return;
    }
    
    for (unsigned int i = 0; i < inClazzCount; i++) {
        
        Class clazz = inClazzList[i];
        
        NSArray<NSString *> *clazzSuffixes = isRootProtocolClazz ?
        @[NSStringFromClass(clazz), NNPopObjcRootSuffix] :
        @[NSStringFromClass(clazz)];
        
        // Get implementationClazz
        Class implementationClazz = nil;
        
        for (NSString *clazzSuffix in clazzSuffixes) {
            implementationClazz = NSClassFromString([NSString stringWithFormat:@"%@_%s_%@",
                                                     NNPopObjcPrefix,
                                                     protocol_getName(protocol),
                                                     clazzSuffix]);
            if (implementationClazz && class_conformsToProtocol(implementationClazz, protocol)) {
                break;
            }
        }
        if (!implementationClazz) {
            continue;
        }
        
        // Get method
        Method method = nil;
        if (class_isMetaClass(clazz)) {
            method = class_getClassMethod(implementationClazz, selector);
        }
        else {
            method = class_getInstanceMethod(implementationClazz, selector);
        }
        if (!method) {
            continue;
        }
        
        // Add method
        class_addMethod(clazz,
                        method_getName(method),
                        method_getImplementation(method),
                        method_getTypeEncoding(method));
    }
}

#endif /* NNPopObjc_Protocol_h */
