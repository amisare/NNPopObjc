//
//  NNPopObjcTests.m
//  NNPopObjcTests
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <NNPopObjc/NNPopObjc.h>
#import "NNTestProtocol.h"
#import "NNTestClassCase0.h"

@interface NNPopObjcTests : XCTestCase

@end

@implementation NNPopObjcTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testCase0 {
    {
        NSString *className = NSStringFromClass([NNTestClassCase00 class]);
        XCTAssertTrue([[NNTestClassCase00 className] isEqualToString:className]);
        NNTestClassCase00 *case00 = [NNTestClassCase00 new];
        XCTAssertTrue([[case00 className] isEqualToString:className]);
    }
    
    {
        NSString *className = NSStringFromClass([NNTestClassCase01 class]);
        XCTAssertTrue([[NNTestClassCase01 className] isEqualToString:className]);
        NNTestClassCase01 *case00 = [NNTestClassCase01 new];
        XCTAssertTrue([[case00 className] isEqualToString:className]);
        
        case00.stringValue = className;
        XCTAssertTrue([case00.stringValue isEqualToString:className]);
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
