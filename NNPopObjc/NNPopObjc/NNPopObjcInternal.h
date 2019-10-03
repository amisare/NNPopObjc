//
//  NNPopObjcInternal.h
//  NNPopObjc
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "NNProtocolRelation.h"

#ifdef DEBUG
#define NNPopObjcLog(format, ...)      {NSLog((@"NNPopObjc: [Line %04d] %s " format), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__);}
#else
#define NNPopObjcLog(format, ...)
#endif

NS_INLINE NSMutableArray <NNProtocolRelation *> * nn_protocolRelations(Class class, SEL sel) {
    
    // Result
    NSMutableArray <NNProtocolRelation *> *protocolRelations = [NSMutableArray new];
    
    // Loop class
    Class currentClass = class;
    
    
    while (currentClass) {
        
        // Get protocol list
        unsigned int count = 0;
        __unsafe_unretained Protocol **protocols = class_copyProtocolList(currentClass, &count);
        
        // Check each protocol
        for (unsigned int i = 0; i < count; i++) {
            
            // Get method description
            struct objc_method_description description = (struct objc_method_description){NULL, NULL};
            
            // Required method
            description = protocol_getMethodDescription(protocols[i], sel, YES, class_isMetaClass(currentClass) ^ 1);
            if (description.name != NULL) {
                NNProtocolRelation *protocolRelation =
                [[NNProtocolRelation alloc] initWithProtocol:protocols[i]
                                                       clazz:currentClass
                                           methodDescription:description];
                [protocolRelations addObject:protocolRelation];
                continue;
            }
            
            // Optional method
            description = protocol_getMethodDescription(protocols[i], sel, NO, class_isMetaClass(currentClass) ^ 1);
            if (description.name != NULL) {
                NNProtocolRelation *protocolRelation =
                [[NNProtocolRelation alloc] initWithProtocol:protocols[i]
                                                       clazz:currentClass
                                           methodDescription:description];
                [protocolRelations addObject:protocolRelation];
                continue;
            }
        }
        
        // release
        free(protocols);
        
        // Get superClass and continue
        currentClass = class_getSuperclass(currentClass);
    }
    
    return protocolRelations;
}

NS_INLINE void nn_swizzedMark(id self, SEL _cmd) {
    NNPopObjcLog(@"%@ %s methods have been swizzed", self, sel_getName(_cmd));
}

NS_INLINE void nn_swizzleSelector(Class clazz, SEL originalSelector, SEL swizzledSelector) {
    
    // Prevent multiple swizz
    NSString *swizzedMarkName = [NSString stringWithFormat:@"%@_%@", @"nn_swizzedMark", @(sel_getName(swizzledSelector))];
    SEL swizzedMarkSelector = NSSelectorFromString(swizzedMarkName);
    if ([clazz respondsToSelector:swizzedMarkSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [clazz performSelector:swizzedMarkSelector];
#pragma clang diagnostic pop
        return;
    }
    class_addMethod(clazz, swizzedMarkSelector, (IMP)nn_swizzedMark, "v@:");
    
    // Swizz method
    Method originalMethod = class_getClassMethod(clazz, originalSelector);
    Method swizzedMethod = class_getClassMethod(clazz, swizzledSelector);
    
    IMP originalImplementation = class_replaceMethod(clazz, method_getName(originalMethod), method_getImplementation(swizzedMethod), method_getTypeEncoding(originalMethod));
    
    class_replaceMethod(clazz, method_getName(swizzedMethod), originalImplementation, method_getTypeEncoding(originalMethod));
}

