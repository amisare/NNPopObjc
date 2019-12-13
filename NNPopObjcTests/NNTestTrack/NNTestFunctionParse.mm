//
//  NNTestFunctionParse.m
//  NNPopObjcTests
//
//  Created by 顾海军 on 2019/12/13.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNTestFunctionParse.h"

@implementation NNTestFunctionParse

+ (instancetype)parseWithFunctionInfo:(NSString *)functionInfo {
	
	NNTestFunctionParse *parse = [NNTestFunctionParse new];
	NSString *info = functionInfo;
	info = [info stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSArray<NSString *> *components = [info componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[] "]];
	if (components.count == 4) {
		parse.methodType = NNTestMethodTypeUnknown;
		if ([components[0] isEqualToString:@"-"]) {
			parse.methodType = NNTestMethodTypeInstance;
		}
		if ([components[0] isEqualToString:@"+"]) {
			parse.methodType = NNTestMethodTypeClass;
		}
		parse.implmentClass = components[1];
		parse.methodName = components[2];
	}
	return parse;
}

@end
