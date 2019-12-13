//
//  NNTestClassCase2.m
//  NNPopObjcTests
//
//  Created by 顾海军 on 2019/12/12.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNTestClassCase2.h"

@implementation NNTestClassCase2

@end


@implementation NNTestClassCase20

@end


@implementation NNTestClassCase21 {
	NSMutableString *_stringValue;
}

+ (NSString *)nameOfClass {
	NSMutableString *value = [NSMutableString new];
	[value appendString:NSStringFromClass(self)];
	NNTestFunctionParse *parse = [NNTestFunctionParse parseWithFunctionInfo:@(__FUNCTION__)];
	value.track.stack->push([NNTestTrackItem itemWithMethodName:parse.methodName
													 methodTypd:parse.methodType
												  implmentClass:parse.implmentClass
													invokeClass:NSStringFromClass(self)]);
    return value;
}

- (NSString *)nameOfClass {
	NSMutableString *value = [NSMutableString new];
	[value appendString:NSStringFromClass([self class])];
	NNTestFunctionParse *parse = [NNTestFunctionParse parseWithFunctionInfo:@(__FUNCTION__)];
	value.track.stack->push([NNTestTrackItem itemWithMethodName:parse.methodName
													 methodTypd:parse.methodType
												  implmentClass:parse.implmentClass
													invokeClass:NSStringFromClass([self class])]);
    return value;
}

- (NSString *)stringValue {
	NSMutableString *value = _stringValue;
	if (value.length == 0) {
		value = [NSMutableString new];
	}
	NNTestFunctionParse *parse = [NNTestFunctionParse parseWithFunctionInfo:@(__FUNCTION__)];
	value.track.stack->push([NNTestTrackItem itemWithMethodName:parse.methodName
													 methodTypd:parse.methodType
												  implmentClass:parse.implmentClass
													invokeClass:NSStringFromClass([self class])]);
	return value;
}

- (void)setStringValue:(NSString *)stringValue {
	NSMutableString *value = [NSMutableString stringWithString:stringValue];
	NNTestFunctionParse *parse = [NNTestFunctionParse parseWithFunctionInfo:@(__FUNCTION__)];
	value.track.stack->push([NNTestTrackItem itemWithMethodName:parse.methodName
													 methodTypd:parse.methodType
												  implmentClass:parse.implmentClass
													invokeClass:NSStringFromClass([self class])]);
	_stringValue = value;
}

@end
