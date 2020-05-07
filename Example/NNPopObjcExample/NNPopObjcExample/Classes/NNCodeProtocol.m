//
//  NNCodeProtocol.m
//  NNPopObjcExample
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNCodeProtocol.h"
#import <objc/runtime.h>
#import "NNCodeObjc.h"
#import "NNCodeCpp.h"
#import "NNPopObjcExample-Swift.h"
#import "NNCodeLog.h"


@nn_extension(NNCodeProtocol)

+ (void)sayHelloPop {
    DLog(@"+[%@ %s] code says hello pop", self, sel_getName(_cmd));
}

- (void)sayHelloPop {
    DLog(@"-[%@ %s] code says hello pop", [self class], sel_getName(_cmd));
}

@end


@nn_extension(NNCodeNameProtocol)

- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, @selector(name), name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)name {
    return objc_getAssociatedObject(self, @selector(name));
}

@end


@nn_extension(NNCodeWhoProtocol, @nn_where(), NNCodeNameProtocol)

- (NSString *)who {
    NSString *who = [NSString stringWithFormat:@"-[%@ %s] code says I am %@", [self class], sel_getName(_cmd), self.name];
    return who;
}

@end


@nn_extension(NNCodeWhoProtocol, @nn_where(NNCodeCpp, self == [NNCodeCpp class]), NNCodeNameProtocol)

+ (void)sayHelloPop {
    DLog(@"+[%@ %s] cpp says hello pop", self, sel_getName(_cmd));
}

- (void)sayHelloPop {
    DLog(@"-[%@ %s] cpp says hello pop", [self class], sel_getName(_cmd));
}

- (NSString *)who {
    NSString *who = [NSString stringWithFormat:@"-[%@ %s] cpp says I am %@", [self class], sel_getName(_cmd), self.name];
    return who;
}

@end


@nn_extension(NNCodeWhoProtocol, @nn_where(a_where_unique_id, self == [NNCodeObjc class]), NNCodeNameProtocol)

+ (void)sayHelloPop {
    DLog(@"+[%@ %s] objc says hello pop", self, sel_getName(_cmd));
}

- (NSString *)who {
    NSString *who = [NSString stringWithFormat:@"-[%@ %s] objc says I am %@", [self class], sel_getName(_cmd), self.name];
    return who;
}

- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, @selector(name), [NSString stringWithFormat:@"[%@]", name], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)name {
    NSString *_name = objc_getAssociatedObject(self, @selector(name));
    return [NSString stringWithFormat:@"%@!", _name];
}

@end


@nn_extension(NNCodeWhoProtocol, @nn_where(NNCodeSwift, self == [NNCodeSwift class]), NNCodeNameProtocol)

- (void)sayHelloPop {
    DLog(@"-[%@ %s] swift says hello pop", [self class], sel_getName(_cmd));
}

- (NSString *)who {
    NSString *who = [NSString stringWithFormat:@"-[%@ %s] swift says I am %@", [self class], sel_getName(_cmd), self.name];
    return who;
}

@end
