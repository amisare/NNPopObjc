//
//  NNTestProtocol.m
//  NNPopObjcTests
//
//  Created by GuHaijun on 2019/12/8.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNTestProtocol.h"
#import <objc/runtime.h>
#import <NNPopObjc/NNPopObjc.h>

@nn_extension(NNTestProtocol)

+ (NSString *)className {
    return NSStringFromClass(self);
}

- (NSString *)className {
    return NSStringFromClass([self class]);
}

@end

@nn_extension(NNTestSubProtocol)

- (NSString *)stringValue {
    return objc_getAssociatedObject(self, @selector(stringValue));
}

- (void)setStringValue:(NSString *)stringValue {
    objc_setAssociatedObject(self, @selector(stringValue), stringValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
