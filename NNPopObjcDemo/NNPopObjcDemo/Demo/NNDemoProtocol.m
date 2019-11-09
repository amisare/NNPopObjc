//
//  NNDemoProtocol.m
//  NNPopObjcDemo
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNDemoProtocol.h"
#import "NNDemoCpp.h"
#import "NNDemoObjc.h"
#import "NNDemoSwift.h"
#import "NNDemoLog.h"


@nn_extension(NNDemoProtocol)

+ (void)sayHelloPop {
    DLog(@"+[%@ %s] code says hello pop", self, sel_getName(_cmd));
}

- (void)sayHelloPop {
    DLog(@"-[%@ %s] code says hello pop", [self class], sel_getName(_cmd));
}

@end


@nn_extension(NNDemoWhoImIProtocol, @nn_where(), NNDemoNameProtocol)

- (NSString *)whoImI {
    NSString *whoImI = [NSString stringWithFormat:@"-[%@ %s] code says I am %@", [self class], sel_getName(_cmd), self.name];
    return whoImI;
}

- (void)setWhoImI:(NSString *)whoImI {
    self.name = whoImI;
}

@end


@nn_extension(NNDemoWhoImIProtocol, @nn_where(provide_a_unique_identifier_for_where, self == [NNDemoObjc class]), NNDemoNameProtocol)

+ (void)sayHelloPop {
    DLog(@"+[%@ %s] objc says hello pop", self, sel_getName(_cmd));
}

- (void)sayHelloPop {
    DLog(@"-[%@ %s] objc says hello pop", [self class], sel_getName(_cmd));
}

- (NSString *)whoImI {
    NSString *whoImI = [NSString stringWithFormat:@"-[%@ %s] objc says I am %@", [self class], sel_getName(_cmd), self.name];
    return whoImI;
}

- (void)setWhoImI:(NSString *)whoImI {
    self.name = whoImI;
}

@end


@nn_extension(NNDemoWhoImIProtocol, @nn_where(NNDemoCpp, self == [NNDemoCpp class]), NNDemoNameProtocol)

- (void)sayHelloPop {
    DLog(@"-[%@ %s] cpp says hello pop", [self class], sel_getName(_cmd));
}

- (NSString *)whoImI {
    NSString *whoImI = [NSString stringWithFormat:@"-[%@ %s] cpp says I am %@", [self class], sel_getName(_cmd), self.name];
    return whoImI;
}

@end


@nn_extension(NNDemoWhoImIProtocol, @nn_where(NNDemoSwift, self == [NNDemoSwift class]), NNDemoNameProtocol)

- (void)sayHelloPop {
    DLog(@"-[%@ %s] swift says hello pop", [self class], sel_getName(_cmd));
}

- (NSString *)whoImI {
    NSString *whoImI = [NSString stringWithFormat:@"-[%@ %s] swift says I am %@", [self class], sel_getName(_cmd), self.name];
    return whoImI;
}

@end
