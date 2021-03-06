//
//  NNTestProtocol.h
//  NNPopObjcTests
//
//  Created by GuHaijun on 2019/12/8.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+NNTestTrack.h"

@protocol NNTestProtocol <NSObject>

@optional
+ (NSString *)nameOfClass;
- (NSString *)nameOfClass;

@end

@protocol NNTestSubProtocol <NNTestProtocol>

@optional
@property (nonatomic, strong) NSString *stringValue;

@end
