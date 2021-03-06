//
//  NNTestClassCase4+NNTestProtocol.mm
//  NNPopObjcTests
//
//  Created by 顾海军 on 2019/12/16.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNTestClassCase4.h"
#import "NNTestProtocol.h"
#import <objc/runtime.h>
#import <NNPopObjc/NNPopObjc.h>

@nn_extension(NNTestSubProtocol, @nn_where(NNTestClassCase40Protocol, [self conformsToProtocol:@protocol(NNTestClassCase40Protocol)]))

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


@nn_extension(NNTestSubProtocol, @nn_where(self == [NNTestClassCase41 class]), NNTestClassCase41Protocol)

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

@nn_extension(NNTestSubProtocol, @nn_where(self == [NNTestClassCase42 class]), NNTestClassCase420Protocol, NNTestClassCase421Protocol)

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
	self.case42 = value;
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
	self.case42 = stringValue;
}

@end
