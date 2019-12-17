//
//  NNTestClassCase4.mm
//  NNPopObjcTests
//
//  Created by 顾海军 on 2019/12/16.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNTestClassCase4.h"
#import <objc/runtime.h>


@implementation NNTestClassCase40

- (NSString *)stringValue {
	NSMutableString *value = objc_getAssociatedObject(self, @selector(stringValue));
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

@end


@implementation NNTestClassCase41

- (void)setStringValue:(NSString *)stringValue {
	NSMutableString *value = [NSMutableString stringWithString:stringValue];
	NNTestFunctionParse *parse = [NNTestFunctionParse parseWithFunctionInfo:@(__FUNCTION__)];
	value.track.stack->push([NNTestTrackItem itemWithMethodName:parse.methodName
													 methodTypd:parse.methodType
												  implmentClass:parse.implmentClass
													invokeClass:NSStringFromClass([self class])]);
    objc_setAssociatedObject(self, @selector(stringValue), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation NNTestClassCase42

@end
