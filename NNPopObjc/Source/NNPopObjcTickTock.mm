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

stack<NSDate *> startDates;

void Tick() {
    startDates.push([NSDate date]);
}

NSTimeInterval Tock() {
    NSDate *startDate = startDates.top(); startDates.pop();
    if (startDate) {
        return -[startDate timeIntervalSinceNow];
    }
    else {
        return -1;
    }
}

}  // namespace TickTock

} // namespace popobjc
