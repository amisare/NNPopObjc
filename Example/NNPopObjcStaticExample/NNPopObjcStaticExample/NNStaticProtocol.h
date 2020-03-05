//
//  NNStaticProtocol.h
//  NNPopObjcStaticExample
//
//  Created by GuHaijun on 2020/2/23.
//  Copyright © 2020 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NNPopObjc/NNPopObjc.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NNStaticProtocol <NSObject>

@optional
+ (void)sayHelloPop;
- (void)sayHelloPop;

@end

NS_ASSUME_NONNULL_END
