//
//  NNProtocolRelation.h
//  NNPopObjc
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNProtocolRelation : NSObject

- (instancetype)initWithProtocol:(Protocol *)protocol
                           clazz:(Class)clazz
               methodDescription:(struct objc_method_description)methodDescription;

@property (nonatomic, assign) Protocol *protocol;
@property (nonatomic, strong) Class clazz;
@property (nonatomic, assign) struct objc_method_description methodDescription;

@end

NS_ASSUME_NONNULL_END
