//
//  NNProtocolRelation.m
//  NNPopObjc
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNProtocolRelation.h"

@implementation NNProtocolRelation

- (instancetype)initWithProtocol:(Protocol *)protocol
                           clazz:(Class)clazz
               methodDescription:(struct objc_method_description)methodDescription {
    self = [super init];
    if (self) {
        self.protocol = protocol;
        self.clazz = clazz;
        self.methodDescription = methodDescription;
    }
    return self;
}

@end
