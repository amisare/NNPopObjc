//
//  NNPopObjcTickTock.h
//  NNPopObjc
//
//  Created by GuHaijun on 2020/2/23.
//  Copyright © 2020 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ostream>
#import <iomanip>

using namespace std;

#define TICK popobjc::TickTock::Tick();
#define TOCK popobjc::TickTock::Tock();

namespace popobjc {

namespace TickTock {

class TickTock {
public:
    NSTimeInterval tick;
    NSTimeInterval tock;
    TickTock(NSTimeInterval tick, NSTimeInterval tock) : tick(tick), tock(tock) {};
    friend ostream &operator<<(ostream &output, const TickTock &thiz);
};

inline ostream &operator<< (ostream &output, const TickTock &thiz) {
    NSTimeInterval tick = thiz.tick * 1000;
    NSTimeInterval tock = thiz.tock * 1000;
    output << fixed << setprecision(2);
    output << "total time: " << tock - tick << " milliseconds" << " ";
    output << "tick: " << (long)tick << " ";
    output << "tock: " << (long)tock;
    return output;
}

NSTimeInterval Tick();
TickTock Tock();

}

}
