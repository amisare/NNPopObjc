//
//  NSObject+NNPopObjc.m
//  NNPopObjc
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NSObject+NNPopObjc.h"
#import <objc/runtime.h>
#import "NNPopObjc-Define.h"
#import "NNPopObjc-Swizzle.h"
#import "NNPopObjc-Protocol.h"

NS_INLINE BOOL __nn_pop_forwardInvocation(NSInvocation *anInvocation) {
    
    Class clazz = object_getClass(anInvocation.target);
    
    // Get the protocol that descripts sel and adopted by the class or super class.
    Protocol *protocol = nn_pop_getProtocol(clazz, anInvocation.selector);
    if (protocol == nil) {
        // Not found
        return false;
    }
    
    // According the clazz type, gets all classes or meta classes that adopt the protocol.
    unsigned int protocolClassCount = 0;
    Class *protocolClazzList = nn_pop_copyProtocolClassList(protocol, &protocolClassCount, class_isMetaClass(clazz) ? NN_POP_CopyProtocolClassListTypeMetaClass : NN_POP_CopyProtocolClassListTypeClass);
    
    // Group the classes
    // Classes that implements the procotol
    unsigned int popObjcProtocolClazzListCount = 0;
    Class *popProtocolObjcClazzList = (Class *)malloc((1 + protocolClassCount) * sizeof(Class));
    
    // Root classes that only adopts the procotol
    unsigned int rootProtocolClazzCount = 0;
    Class *rootProtocolClazzList = (Class *)malloc((1 + protocolClassCount) * sizeof(Class));
    
    // Sub classes that only adopts the procotol
    unsigned int subProtocolClazzCount = 0;
    Class *subProtocolClazzList = (Class *)malloc((1 + protocolClassCount) * sizeof(Class));
    
    nn_pop_separateProtocolClassList(protocol, protocolClazzList, protocolClassCount,
                                     &rootProtocolClazzList, &rootProtocolClazzCount,
                                     &subProtocolClazzList, &subProtocolClazzCount,
                                     &popProtocolObjcClazzList, &popObjcProtocolClazzListCount);
    
    // Add the implemented protocol methods to root classes (or corresponding meta classes).
    nn_pop_implementProtocolClassList(rootProtocolClazzList, rootProtocolClazzCount, protocol, anInvocation.selector, YES);
    // Add the implemented protocol methods to sub classes (or corresponding meta classes).
    nn_pop_implementProtocolClassList(subProtocolClazzList, subProtocolClazzCount, protocol, anInvocation.selector, NO);
    
    // Free memory
    free(protocolClazzList);
    free(popProtocolObjcClazzList);
    free(rootProtocolClazzList);
    free(subProtocolClazzList);
    
    // Check method implement
    if (![anInvocation.target respondsToSelector:anInvocation.selector]) {
        return false;
    }
    
    // Invoke method
    [anInvocation invoke];
    
    return true;
}

@implementation NSObject (NNPopObjc)

+(void)load {
    
    // Hood class method
    nn_pop_swizzleSelector(object_getClass(self),
                           @selector(forwardInvocation:),
                           @selector(__nn_pop_class_forwardInvocation:));
    // Hood instance method
    nn_pop_swizzleSelector(self,
                           @selector(forwardInvocation:),
                           @selector(__nn_pop_instance_forwardInvocation:));
}

+ (void)__nn_pop_class_forwardInvocation:(NSInvocation *)anInvocation {
    
    if (__nn_pop_forwardInvocation(anInvocation)) {
        return;
    }
    [self __nn_pop_class_forwardInvocation:anInvocation];
}

- (void)__nn_pop_instance_forwardInvocation:(NSInvocation *)anInvocation {
    
    if (__nn_pop_forwardInvocation(anInvocation)) {
        return;
    }
    [self __nn_pop_instance_forwardInvocation:anInvocation];
}

@end
