//
//  NNTestClassCase5.mm
//  NNPopObjcTests
//
//  Created by 顾海军 on 2019/12/17.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNTestClassCase5.h"

NSString *case50Track;
NSString *case51Track;

@implementation NNTestClassCase50

+ (void)initialize {
	NSMutableString *value = [NSMutableString stringWithString:@"initialize track"];
	NNTestFunctionParse *parse = [NNTestFunctionParse parseWithFunctionInfo:@(__FUNCTION__)];
	value.track.stack->push([NNTestTrackItem itemWithMethodName:parse.methodName
													 methodTypd:parse.methodType
												  implmentClass:parse.implmentClass
													invokeClass:NSStringFromClass(self)]);
	case50Track = value;
}

@end


@implementation NNTestClassCase51

@end
