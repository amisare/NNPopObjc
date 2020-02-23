//
//  NNDynamicProtocol.m
//  NNPopObjcDynamicExample
//
//  Created by GuHaijun on 2020/2/23.
//  Copyright © 2020 GuHaiJun. All rights reserved.
//

#import "NNDynamicProtocol.h"

#ifndef NNCodeLog_h
#define NNCodeLog_h

#define DLog(format, ...) printf("%s\n", [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);

#endif /* NNCodeLog_h */

@nn_extension(NNDynamicProtocol)

+ (void)sayHelloPop {
    DLog(@"+[%@ %s] dynamic says hello pop", self, sel_getName(_cmd));
}

- (void)sayHelloPop {
    DLog(@"-[%@ %s] dynamic says hello pop", [self class], sel_getName(_cmd));
}

@end
