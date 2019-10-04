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

NS_INLINE BOOL nn_forwardInvocation(NSInvocation *anInvocation) {
    
    Class clazz = object_getClass(anInvocation.target);
    
    Protocol *protocol = nn_findProtocol(clazz, anInvocation.selector);
    if (nil == protocol) {
        return false;
    }
    
    unsigned int protocolClassCount = 0;
    Class *protocolClazzList = nn_copyProtocolClassList(protocol, &protocolClassCount, class_isMetaClass(clazz) ? NN_CopyProtocolClassListTypeMetaClass : NN_CopyProtocolClassListTypeClass);
    
    unsigned int popObjcProtocolClazzListCount = 0;
    Class *popProtocolObjcClazzList = (Class *)malloc((1 + protocolClassCount) * sizeof(Class));
    unsigned int rootProtocolClazzCount = 0;
    Class *rootProtocolClazzList = (Class *)malloc((1 + protocolClassCount) * sizeof(Class));
    unsigned int subProtocolClazzCount = 0;
    Class *subProtocolClazzList = (Class *)malloc((1 + protocolClassCount) * sizeof(Class));
    
    nn_separateProtocolClassList(protocol, protocolClazzList, protocolClassCount,
                                 &rootProtocolClazzList, &rootProtocolClazzCount,
                                 &subProtocolClazzList, &subProtocolClazzCount,
                                 &popProtocolObjcClazzList, &popObjcProtocolClazzListCount);

    nn_completeProtocolClassList(rootProtocolClazzList, rootProtocolClazzCount, protocol,anInvocation.selector, YES);
    nn_completeProtocolClassList(subProtocolClazzList, subProtocolClazzCount, protocol,anInvocation.selector, NO);
    
    free(protocolClazzList);
    free(popProtocolObjcClazzList);
    free(rootProtocolClazzList);
    free(subProtocolClazzList);
    
    if (![anInvocation.target respondsToSelector:anInvocation.selector]) {
        [anInvocation.target doesNotRecognizeSelector:anInvocation.selector];
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
