//
//  NNTestClassCase4.h
//  NNPopObjcTests
//
//  Created by 顾海军 on 2019/12/16.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNTestClassCase0.h"
#import "NNTestProtocol.h"


@protocol NNTestClassCase40Protocol <NSObject>

@end

@interface NNTestClassCase40 : NNTestClassCase0<NNTestSubProtocol, NNTestClassCase40Protocol>

@end

@protocol NNTestClassCase41Protocol <NSObject>

@end

@interface NNTestClassCase41 : NNTestClassCase0<NNTestSubProtocol, NNTestClassCase41Protocol>

@end

@protocol NNTestClassCase420Protocol <NSObject>

@optional
@property (nonatomic, strong) NSString *case42;

@end

@protocol NNTestClassCase421Protocol <NSObject>

@end

@interface NNTestClassCase42 : NNTestClassCase0<NNTestSubProtocol, NNTestClassCase420Protocol, NNTestClassCase421Protocol>

@property (nonatomic, strong) NSString *case42;

@end
