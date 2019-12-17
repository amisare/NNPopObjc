//
//  NNTestProtocol.mm
//  NNPopObjcTests
//
//  Created by GuHaijun on 2019/12/8.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNTestProtocol.h"
#import <objc/runtime.h>
#import <NNPopObjc/NNPopObjc.h>

@nn_extension(NNTestProtocol)

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

@end


@nn_extension(NNTestSubProtocol)

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
