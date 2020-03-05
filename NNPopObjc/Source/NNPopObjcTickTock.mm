//
//  NNPopObjcTickTock.m
//  NNPopObjc
//
//  Created by GuHaijun on 2020/2/23.
//  Copyright © 2020 GuHaiJun. All rights reserved.
//

#import "NNPopObjcTickTock.h"
#import <stack>

using namespace std;

namespace popobjc {

namespace TickTock {

stack<NSTimeInterval> ticks;

NSTimeInterval Tick() {
    NSTimeInterval tick = [[NSDate date] timeIntervalSince1970];
    ticks.push(tick);
    return tick;
}

TickTock Tock() {
    NSTimeInterval tock = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval tick = ({
        NSTimeInterval _tick;
        if (!ticks.empty()) {
            _tick = ticks.top(); ticks.pop();
        }
        else {
            _tick = -1.0;
        }
        _tick;
    });
    return TickTock(tick, tock);
}

}  // namespace TickTock

} // namespace popobjc
