//
//  NNTestClassCase5+NNTestProtocol.mm
//  NNPopObjcTests
//
//  Created by 顾海军 on 2019/12/17.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNTestClassCase5.h"
#import "NNTestProtocol.h"
#import <objc/runtime.h>
#import <NNPopObjc/NNPopObjc.h>

@nn_extension(NNTestSubProtocol, @nn_where(NNTestClassCase50, self == [NNTestClassCase50 class]))

+ (void)initialize {
	NSMutableString *value = [NSMutableString stringWithString:@"initialize track"];
	NNTestFunctionParse *parse = [NNTestFunctionParse parseWithFunctionInfo:@(__FUNCTION__)];
	value.track.stack->push([NNTestTrackItem itemWithMethodName:parse.methodName
													 methodTypd:parse.methodType
												  implmentClass:parse.implmentClass
													invokeClass:NSStringFromClass(self)]);
	case51Track = value;
}

@end
