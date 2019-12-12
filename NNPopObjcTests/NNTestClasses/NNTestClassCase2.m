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
	[value.marks addObject:@"NNTestClassCase2"];
    return value;
}

- (NSString *)nameOfClass {
	NSMutableString *value = [NSMutableString new];
	[value appendString:NSStringFromClass([self class])];
	[value.marks addObject:@"NNTestClassCase2"];
    return value;
}

- (NSString *)stringValue {
	NSMutableString *value = _stringValue;
	if (value.length == 0) {
		value = [NSMutableString new];
	}
	[value.marks addObject:@"NNTestClassCase2"];
	[value.marks addObject:NSStringFromSelector(_cmd)];
	return value;
}

- (void)setStringValue:(NSString *)stringValue {
	NSMutableString *value = [NSMutableString stringWithString:stringValue];
	[value.marks addObject:@"NNTestClassCase2"];
	[value.marks addObject:NSStringFromSelector(_cmd)];
	_stringValue = value;
}

@end
