//
//  NNTestClassCase0.h
//  NNPopObjcTests
//
//  Created by GuHaijun on 2019/12/8.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNTestProtocol.h"

@interface NNTestClassCase0 : NSObject

@end


@interface NNTestClassCase00 : NNTestClassCase0<NNTestProtocol>

@end


@interface NNTestClassCase01 : NNTestClassCase0<NNTestSubProtocol>

@end
