//
//  NNCodeC.h
//  NNPopObjcDemo
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNCodeProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NNCodeC : NSObject <NNCodeWhoProtocol, NNCodeNameProtocol>

@property (nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
