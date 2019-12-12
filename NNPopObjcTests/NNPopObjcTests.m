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
#import "NNTestClassCase1.h"
#import "NNTestClassCase2.h"

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
	// NNTestClassCase0
	{
        XCTAssertFalse([NNTestClassCase0 respondsToSelector:@selector(nameOfClass)]);
        XCTAssertFalse([[NNTestClassCase0 new] respondsToSelector:@selector(nameOfClass)]);
        XCTAssertFalse([[NNTestClassCase0 new] respondsToSelector:@selector(stringValue)]);
        XCTAssertFalse([[NNTestClassCase0 new] respondsToSelector:@selector(setStringValue:)]);
    }
	// NNTestClassCase00
    {
        NSString *className = NSStringFromClass([NNTestClassCase00 class]);
        XCTAssertTrue([className isEqualToString:[NNTestClassCase00 nameOfClass]]);
        NNTestClassCase00 *obj = [NNTestClassCase00 new];
        XCTAssertTrue([className isEqualToString:[obj nameOfClass]]);
		
        XCTAssertFalse([[NNTestClassCase0 new] respondsToSelector:@selector(stringValue)]);
        XCTAssertFalse([[NNTestClassCase0 new] respondsToSelector:@selector(setStringValue:)]);
    }
	// NNTestClassCase01
    {
        NSString *className = NSStringFromClass([NNTestClassCase01 class]);
        XCTAssertTrue([className isEqualToString:[NNTestClassCase01 nameOfClass]]);
        NNTestClassCase01 *obj = [NNTestClassCase01 new];
        XCTAssertTrue([className isEqualToString:[obj nameOfClass]]);
        
        obj.stringValue = className;
        XCTAssertTrue([className isEqualToString:obj.stringValue]);
    }
}

- (void)testCase1 {
	// NNTestClassCase10
    {
        NSString *className = NSStringFromClass([NNTestClassCase10 class]);
        XCTAssertTrue([className isEqualToString:[NNTestClassCase10 nameOfClass]]);
        NNTestClassCase10 *obj = [NNTestClassCase10 new];
        XCTAssertTrue([className isEqualToString:[obj nameOfClass]]);
        
        obj.stringValue = className;
        XCTAssertTrue([className isEqualToString:obj.stringValue]);
    }
}

- (void)testCase2 {
	// NNTestClassCase20
    {
        NSString *className = NSStringFromClass([NNTestClassCase20 class]);
        XCTAssertTrue([className isEqualToString:[NNTestClassCase20 nameOfClass]]);
        XCTAssertTrue([@"NNTestProtocol" isEqualToString:[[[NNTestClassCase20 nameOfClass] marks] lastObject]]);
        NNTestClassCase20 *obj = [NNTestClassCase20 new];
        XCTAssertTrue([className isEqualToString:[obj nameOfClass]]);
        XCTAssertTrue([@"NNTestProtocol" isEqualToString:[[[obj nameOfClass] marks] lastObject]]);
        
        obj.stringValue = className;
		NSArray<NSString *> *marks = [[obj.stringValue marks] copy];
        XCTAssertTrue([className isEqualToString:obj.stringValue]);
        XCTAssertTrue([@"NNTestSubProtocol" isEqualToString:marks[0]]);
        XCTAssertTrue([@"setStringValue:" isEqualToString:marks[1]]);
        XCTAssertTrue([@"NNTestSubProtocol" isEqualToString:marks[2]]);
        XCTAssertTrue([@"stringValue" isEqualToString:marks[3]]);
    }
	// NNTestClassCase21
	{
        NSString *className = NSStringFromClass([NNTestClassCase21 class]);
        XCTAssertTrue([className isEqualToString:[NNTestClassCase21 nameOfClass]]);
        XCTAssertTrue([@"NNTestClassCase2" isEqualToString:[[[NNTestClassCase21 nameOfClass] marks] lastObject]]);
        NNTestClassCase21 *obj = [NNTestClassCase21 new];
        XCTAssertTrue([className isEqualToString:[obj nameOfClass]]);
        XCTAssertTrue([@"NNTestClassCase2" isEqualToString:[[[obj nameOfClass] marks] lastObject]]);
        
        obj.stringValue = className;
		NSArray<NSString *> *marks = [[obj.stringValue marks] copy];
        XCTAssertTrue([className isEqualToString:obj.stringValue]);
        XCTAssertTrue([@"NNTestClassCase2" isEqualToString:marks[0]]);
        XCTAssertTrue([@"setStringValue:" isEqualToString:marks[1]]);
        XCTAssertTrue([@"NNTestClassCase2" isEqualToString:marks[2]]);
        XCTAssertTrue([@"stringValue" isEqualToString:marks[3]]);
	}
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
