//
//  NNDemoProtocol.h
//  NNPopObjcDemo
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NNDemoProtocol <NSObject>

@optional
+ (void)sayHelloPop;
- (void)sayHelloPop;

@end

@protocol NNDemoWhoImIProtocol <NNDemoProtocol>

@optional
@property (nonatomic, strong) NSString* whoImI;

@end

@protocol NNDemoNameProtocol <NSObject>

@optional
@property (nonatomic, strong) NSString* name;

@end

NS_ASSUME_NONNULL_END
