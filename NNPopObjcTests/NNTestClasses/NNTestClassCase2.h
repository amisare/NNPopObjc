//
//  NNTestClassCase2.h
//  NNPopObjcTests
//
//  Created by 顾海军 on 2019/12/12.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNTestProtocol.h"


@interface NNTestClassCase2 : NSObject

@end


@interface NNTestClassCase20 : NNTestClassCase2<NNTestSubProtocol>

@end


@interface NNTestClassCase21 : NNTestClassCase2<NNTestSubProtocol>

@property (nonatomic, strong) NSString *stringValue;

@end
