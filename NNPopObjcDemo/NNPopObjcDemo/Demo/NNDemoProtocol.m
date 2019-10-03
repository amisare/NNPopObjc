//
//  NNDemoProtocol.m
//  NNPopObjcDemo
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNDemoProtocol.h"
#import "NNDemoObjc.h"
#import "NNDemoSwift.h"
#import "NNDemoLog.h"

@nn_extension(NNDemoProtocol, NSObject)

+ (void)sayHelloPop {
    DLog(@"%@: class say hello pop", self);
}

- (void)sayHelloPop {
    DLog(@"%@: object say hello pop", [self class]);
}

- (NSString *)whoImI {
    DLog(@"%@: %s", [self class], sel_getName(_cmd));
    return [NSString stringWithFormat:@"%@", [self class]];
}

- (void)setWhoImI:(NSString *)whoImI {
    DLog(@"%@: %s:%@", [self class], sel_getName(_cmd), whoImI);
}

@end


@nn_extension(NNDemoProtocol, NNDemoObjc)

+ (void)sayHelloPop {
    DLog(@"objc: class say hello pop");
}

- (void)sayHelloPop {
    DLog(@"objc: object say hello pop");
}

- (NSString *)whoImI {
    DLog(@"%@: %s", [self class], sel_getName(_cmd));
    return [NSString stringWithFormat:@"%@", [self class]];
}

- (void)setWhoImI:(NSString *)whoImI {
    DLog(@"%@: %s:%@", [self class], sel_getName(_cmd), whoImI);
}
@end

@nn_extension(NNDemoProtocol, NNDemoSwift)

+ (void)sayHelloPop {
    DLog(@"swift: class say hello pop");
}

- (void)sayHelloPop {
    DLog(@"swift: object say hello pop");
}

- (NSString *)whoImI {
    DLog(@"%@: %s", [self class], sel_getName(_cmd));
    return [NSString stringWithFormat:@"%@", [self class]];
}

- (void)setWhoImI:(NSString *)whoImI {
    DLog(@"%@: %s:%@", [self class], sel_getName(_cmd), whoImI);
}

@end
