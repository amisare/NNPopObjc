//
//  NNTestProtocol.m
//  NNPopObjcTests
//
//  Created by GuHaijun on 2019/12/8.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNTestProtocol.h"
#import <objc/runtime.h>
#import <NNPopObjc/NNPopObjc.h>

@implementation NSString (NNTestMark)

- (NSMutableArray<NSString *> *)marks {
	NSMutableArray<NSString *> *value = objc_getAssociatedObject(self, @selector(marks));
	if (value == nil) {
		value = [NSMutableArray new];
		objc_setAssociatedObject(self, @selector(marks), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return value;
}

- (void)setMarks:(NSMutableArray<NSString *> *)marks {
	NSMutableArray<NSString *> *value = marks;
	if (![marks isKindOfClass:[NSMutableArray class]]) {
		value = [NSMutableArray new];
	}
	objc_setAssociatedObject(self, @selector(marks), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@nn_extension(NNTestProtocol)

+ (NSString *)nameOfClass {
	NSMutableString *value = [NSMutableString new];
	[value appendString:NSStringFromClass(self)];
	[value.marks addObject:@"NNTestProtocol"];
    return value;
}

- (NSString *)nameOfClass {
	NSMutableString *value = [NSMutableString new];
	[value appendString:NSStringFromClass([self class])];
	[value.marks addObject:@"NNTestProtocol"];
    return value;
}

@end

@nn_extension(NNTestSubProtocol)

- (NSString *)stringValue {
	NSMutableString *value = objc_getAssociatedObject(self, @selector(stringValue));
	if (value.length == 0) {
		value = [NSMutableString new];
	}
	[value.marks addObject:@"NNTestSubProtocol"];
	[value.marks addObject:NSStringFromSelector(_cmd)];
	return value;
}

- (void)setStringValue:(NSString *)stringValue {
	NSMutableString *value = [NSMutableString stringWithString:stringValue];
	[value.marks addObject:@"NNTestSubProtocol"];
	[value.marks addObject:NSStringFromSelector(_cmd)];
    objc_setAssociatedObject(self, @selector(stringValue), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
