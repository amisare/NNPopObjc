//
//  NNTestFunctionParse.h
//  NNPopObjcTests
//
//  Created by 顾海军 on 2019/12/13.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NNTestMethodType) {
	NNTestMethodTypeUnknown,
	NNTestMethodTypeInstance,
	NNTestMethodTypeClass,
};

@interface NNTestFunctionParse : NSObject

+ (instancetype)parseWithFunctionInfo:(NSString *)functionInfo;
@property (nonatomic, strong) NSString *implmentClass;
@property (nonatomic, assign) NNTestMethodType methodType;
@property (nonatomic, strong) NSString *methodName;

@end
