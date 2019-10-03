//
//  NSObject+NNPopObjc.m
//  NNPopObjc
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NSObject+NNPopObjc.h"
#import <objc/runtime.h>
#import "NNPopObjcInternal.h"
#import "NNProtocolRelation.h"

NS_INLINE BOOL nn_forwardInvocation(NSInvocation *anInvocation) {
    
    Class clazz = object_getClass(anInvocation.target);
    
    // Get identifier
    NNProtocolRelation *protocolRelation = nn_protocolRelation(clazz, anInvocation.selector);
    if (!protocolRelation) {
        return false;
    }
    
    // Get implementationClazz
    // Implementation class name array @[procotolName_clazzName, procotolName_NSObject]
    Class implementationClazz = nil;
    for (NSString *clazzSuffix in @[NSStringFromClass(protocolRelation.clazz),
                                    @"NSObject"]) {
        implementationClazz = NSClassFromString([NSString stringWithFormat:@"%s_%@", protocol_getName(protocolRelation.protocol), clazzSuffix]);
        if (implementationClazz && class_conformsToProtocol(implementationClazz, protocolRelation.protocol)) {
            break;
        }
    }
    if (!implementationClazz) {
        return false;
    }
    
    // Swizz method
    Method method = nil;
    if (class_isMetaClass(clazz)) {
        method = class_getClassMethod(implementationClazz, anInvocation.selector);
    }
    else {
        method = class_getInstanceMethod(implementationClazz, anInvocation.selector);
    }
    BOOL isAddMethod = class_addMethod(clazz,
                                       method_getName(method),
                                       method_getImplementation(method),
                                       method_getTypeEncoding(method));
    if (!method || !isAddMethod) {
        return false;
    }
    
    // Invoke method
    [anInvocation invoke];
    
    return true;
}

@implementation NSObject (NNPopObjc)

+(void)load {
    
    // Hood class method
    nn_swizzleSelector(object_getClass(self),
                       @selector(forwardInvocation:),
                       @selector(nn_class_forwardInvocation:));
    // Hood instance method
    nn_swizzleSelector(self,
                       @selector(forwardInvocation:),
                       @selector(nn_instance_forwardInvocation:));
}

+ (void)nn_class_forwardInvocation:(NSInvocation *)anInvocation {
    
    if (nn_forwardInvocation(anInvocation)) {
        return;
    }
    [self nn_class_forwardInvocation:anInvocation];
}

- (void)nn_instance_forwardInvocation:(NSInvocation *)anInvocation {
    
    if (nn_forwardInvocation(anInvocation)) {
        return;
    }
    [self nn_instance_forwardInvocation:anInvocation];
}

@end
