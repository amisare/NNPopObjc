//
//  NNTestProtocol.h
//  NNPopObjcTests
//
//  Created by 顾海军 on 2019/10/8.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NNTestProtocol <NSObject>

@optional
@property (nonatomic, strong) NSString* whoImI;
- (void)sayHelloPop;
+ (void)sayHelloPop;

@end

