//
//  NNCodeProtocol.h
//  NNPopObjcExample
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NNCodeProtocol <NSObject>

@optional
+ (void)sayHelloPop;
- (void)sayHelloPop;

@end

@protocol NNCodeWhoProtocol <NNCodeProtocol>

@optional
@property (nonatomic, strong) NSString* who;

@end

@protocol NNCodeNameProtocol <NSObject>

@optional
@property (nonatomic, strong) NSString* name;

@end

NS_ASSUME_NONNULL_END
