//
//  NNTestClassCase6.h
//  NNPopObjcTests
//
//  Created by 顾海军 on 2020/2/21.
//  Copyright © 2020 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNTestClassCase0.h"
#import "NNTestProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NNTestClassCase60 : NNTestClassCase0<NNTestProtocol>

@end

@interface NNTestClassCase61 : NNTestClassCase60

@end

@interface NNTestClassCase62 : NNTestClassCase61<NNTestProtocol>

@end

NS_ASSUME_NONNULL_END
