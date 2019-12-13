//
//  NNTestTrack.h
//  NNPopObjcTests
//
//  Created by 顾海军 on 2019/12/13.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stack>
#import "NNTestFunctionParse.h"

@class NNTestTrackItem;

@interface NNTestTrack : NSObject

- (std::shared_ptr<std::stack<NNTestTrackItem *>>)stack;

@end


@interface NNTestTrackItem : NSObject

@property (nonatomic, strong) NSString *invokeClass;
@property (nonatomic, strong) NSString *implmentClass;
@property (nonatomic, assign) NNTestMethodType methodType;
@property (nonatomic, strong) NSString *methodName;

+ (instancetype)itemWithMethodName:(NSString *)methodName
						methodTypd:(NNTestMethodType)methodType
					 implmentClass:(NSString *)implmentClass
					   invokeClass:(NSString *)invokeClass;

@end
