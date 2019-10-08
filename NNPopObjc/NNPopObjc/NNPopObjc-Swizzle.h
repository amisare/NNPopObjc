//
//  NNPopObjc-Swizzle.h
//  NNPopObjc
//
//  Created by 顾海军 on 2019/10/8.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#ifndef NNPopObjc_Swizzle_h
#define NNPopObjc_Swizzle_h

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "NNPopObjc-Define.h"

NS_INLINE void nn_swizzledMark(id self, SEL _cmd) {
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
    class_addMethod(clazz, swizzedMarkSelector, (IMP)nn_swizzledMark, "v@:");
    
    // Swizz method
    Method originalMethod = class_getClassMethod(clazz, originalSelector);
    Method swizzedMethod = class_getClassMethod(clazz, swizzledSelector);
    
    IMP originalImplementation = class_replaceMethod(clazz, method_getName(originalMethod), method_getImplementation(swizzedMethod), method_getTypeEncoding(originalMethod));
    
    class_replaceMethod(clazz, method_getName(swizzedMethod), originalImplementation, method_getTypeEncoding(originalMethod));
}


#endif /* NNPopObjc_Swizzle_h */
