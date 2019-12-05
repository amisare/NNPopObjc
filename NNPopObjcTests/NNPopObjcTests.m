//
//  NNPopObjcTests.m
//  NNPopObjcTests
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import <NNPopObjc/NNPopObjc.h>
#import "NNTestClassA.h"

@interface NNPopObjcTests : XCTestCase

@end

@implementation NNPopObjcTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
