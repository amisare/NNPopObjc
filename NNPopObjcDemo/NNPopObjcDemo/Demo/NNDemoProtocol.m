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
    DLog(@"+[%@ %s] code say hello pop", self, sel_getName(_cmd));
}

- (void)sayHelloPop {
    DLog(@"-[%@ %s] code say hello pop", [self class], sel_getName(_cmd));
}

@end

@nn_extension(NNDemoWhoImIProtocol)

- (NSString *)whoImI {
    NSString *whoImI = [NSString stringWithFormat:@"-[%@ %s] I am %@", [self class], sel_getName(_cmd), nil];
    return whoImI;
}

- (void)setWhoImI:(NSString *)whoImI {
    DLog(@"-[%@ %s%@]", [self class], sel_getName(_cmd), whoImI);
}

@end

@nn_extension(NNDemoWhoImIProtocol, nn_where(true))

- (NSString *)whoImI {
    NSString *whoImI = [NSString stringWithFormat:@"-[%@ %s] I am %@", [self class], sel_getName(_cmd), nil];
    return whoImI;
}

- (void)setWhoImI:(NSString *)whoImI {
    DLog(@"-[%@ %s%@]", [self class], sel_getName(_cmd), whoImI);
}

@end

@nn_extension(NNDemoWhoImIProtocol, nn_where(self == [NNDemoCpp class]), NNDemoNameProtocol)

+ (void)sayHelloPop {
    DLog(@"+[%@ %s] cpp say hello pop", self, sel_getName(_cmd));
}

- (void)sayHelloPop {
    DLog(@"-[%@ %s] cpp say hello pop", [self class], sel_getName(_cmd));
}

- (NSString *)whoImI {
    NSString *whoImI = [NSString stringWithFormat:@"-[%@ %s] I am %@", [self class], sel_getName(_cmd), self.name];
    return whoImI;
}

- (void)setWhoImI:(NSString *)whoImI {
    self.name = whoImI;
}

@end

@nn_extension(NNDemoWhoImIProtocol, nn_where(NNDemoObjc, self == [NNDemoObjc class]), NNDemoNameProtocol)

- (NSString *)whoImI {
    NSString *whoImI = [NSString stringWithFormat:@"-[%@ %s] I am %@", [self class], sel_getName(_cmd), self.name];
    return whoImI;
}

- (void)setWhoImI:(NSString *)whoImI {
    self.name = whoImI;
}

@end

@nn_extension(NNDemoWhoImIProtocol, nn_where(NNDemoSwift, self == [NNDemoSwift class]), NNDemoNameProtocol)

+ (void)sayHelloPop {
    DLog(@"+[%@ %s] swift say hello pop", self, sel_getName(_cmd));
}

- (void)sayHelloPop {
    DLog(@"-[%@ %s] swift say hello pop", [self class], sel_getName(_cmd));
}

- (NSString *)whoImI {
    NSString *whoImI = [NSString stringWithFormat:@"-[%@ %s] I am %@", [self class], sel_getName(_cmd), self.name];
    return whoImI;
}

- (void)setWhoImI:(NSString *)whoImI {
    self.name = whoImI;
}

@end
