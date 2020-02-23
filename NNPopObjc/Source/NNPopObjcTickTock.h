//
//  NNPopObjcTickTock.h
//  NNPopObjc
//
//  Created by GuHaijun on 2020/2/23.
//  Copyright © 2020 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TICK popobjc::TickTock::Tick();
#define TOCK popobjc::TickTock::Tock();

namespace popobjc {

namespace TickTock {

void Tick();
NSTimeInterval Tock();

}

}
