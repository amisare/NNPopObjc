//
//  NNTestProtocol.m
//  NNPopObjcTests
//
//  Created by 顾海军 on 2019/10/8.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNTestProtocol.h"
#import <NNPopObjc/NNPopObjc.h>
#import "NNTestClassBA.h"

@nn_extension(NNTestProtocol, NSObject)

+ (void)sayHelloPop {
    NSLog(@"+[%@ %s] say hello pop", self, sel_getName(_cmd));
}

- (void)sayHelloPop {
    NSLog(@"-[%@ %s] say hello pop", [self class], sel_getName(_cmd));
}

- (NSString *)whoImI {
    NSString *whoImI = [NSString stringWithFormat:@"-[%@ %s] I am %@", [self class], sel_getName(_cmd), nil];
    return whoImI;
}

- (void)setWhoImI:(NSString *)whoImI {
    NSLog(@"-[%@ %s%@]", [self class], sel_getName(_cmd), whoImI);
}

@end

@nn_extension(NNTestProtocol, NNTestClassBA)

+ (void)sayHelloPop {
    NSLog(@"+[%@ %s] say hello pop", self, sel_getName(_cmd));
}

- (void)sayHelloPop {
    NSLog(@"-[%@ %s] say hello pop", [self class], sel_getName(_cmd));
}

- (NSString *)whoImI {
    NSString *whoImI = [NSString stringWithFormat:@"-[%@ %s] I am %@", [self class], sel_getName(_cmd), self.name];
    return whoImI;
}

- (void)setWhoImI:(NSString *)whoImI {
    self.name = whoImI;
}
@end
