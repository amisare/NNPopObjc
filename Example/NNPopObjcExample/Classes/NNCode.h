//
//  NNCode.h
//  NNPopObjcExample
//
//  Created by GuHaijun on 2020/2/22.
//  Copyright © 2020 顾海军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNCodeProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NNCode : NSObject <NNCodeProtocol, NNCodeNameProtocol>

@property (nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
