//
//  NNTestClassCase6+NNTestProtocol.mm
//  NNPopObjcTests
//
//  Created by 顾海军 on 2020/2/21.
//  Copyright © 2020 GuHaiJun. All rights reserved.
//

#import "NNTestClassCase6.h"
#import "NNTestProtocol.h"
#import <NNPopObjc/NNPopObjc.h>

@nn_extension(NNTestProtocol, @nn_where(NNTestClassCase61, self = [NNTestClassCase61 class]))

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
