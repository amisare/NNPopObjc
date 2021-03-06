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
#import "NNTestClassCase3.h"
#import "NNTestClassCase4.h"
#import "NNTestClassCase5.h"
#import "NNTestClassCase6.h"

@interface NSString (XCTAssert)

- (BOOL)xct_isEqualToString:(NSString *)string;

@end

@implementation NSString (XCTAssert)

- (BOOL)xct_isEqualToString:(NSString *)string {
	return [self isEqualToString:string];
}

@end

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
		Class clazz = [NNTestClassCase0 class];
		XCTAssertFalse([clazz respondsToSelector:@selector(nameOfClass)]);
		XCTAssertFalse([[clazz new] respondsToSelector:@selector(nameOfClass)]);
		XCTAssertFalse([[clazz new] respondsToSelector:@selector(stringValue)]);
		XCTAssertFalse([[clazz new] respondsToSelector:@selector(setStringValue:)]);
	}
}

- (void)testCase1 {
	// NNTestClassCase10
	{
		Class clazz = [NNTestClassCase10 class];
		NSString *clazzName = NSStringFromClass(clazz);
		// + nameOfClass
		{
			NSString *v = [clazz nameOfClass];
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestProtocol,,)))];
			});
		}
		// - nameOfClass
		{
			NSString *v = [[clazz new] nameOfClass];
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestProtocol,,)))];
			});
		}
	}
	// NNTestClassCase11
	{
		Class clazz = [NNTestClassCase11 class];
		NSString *clazzName = NSStringFromClass(clazz);
		// + nameOfClass
		{
			NSString *v = [clazz nameOfClass];
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestProtocol,,)))];
			});
		}
		// - nameOfClass
		{
			NSString *v = [[clazz new] nameOfClass];
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestProtocol,,)))];
			});
		}
		{
			id<NNTestSubProtocol> obj = [clazz new];
			obj.stringValue = clazzName;
			NSString *v = obj.stringValue;
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestSubProtocol,,)))];
			});
			XCTAssertTrue({
				[track.stack->top().methodName
				 xct_isEqualToString:
				 @"stringValue"];
			});
			track.stack->pop();
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestSubProtocol,,)))];
			});
			XCTAssertTrue({
				[track.stack->top().methodName
				 xct_isEqualToString:
				 @"setStringValue:"];
			});
		}
	}
}

- (void)testCase2 {
	// NNTestClassCase21
	{
		Class clazz = [NNTestClassCase21 class];
		NSString *clazzName = NSStringFromClass(clazz);
		// + nameOfClass
		{
			NSString *v = [clazz nameOfClass];
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestProtocol,,)))];
			});
		}
		// - nameOfClass
		{
			NSString *v = [[clazz new] nameOfClass];
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestProtocol,,)))];
			});
		}
		{
			id<NNTestSubProtocol> obj = [clazz new];
			obj.stringValue = clazzName;
			NSString *v = obj.stringValue;
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestSubProtocol,,)))];
			});
			XCTAssertTrue({
				[track.stack->top().methodName
				 xct_isEqualToString:
				 @"stringValue"];
			});
			track.stack->pop();
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestSubProtocol,,)))];
			});
			XCTAssertTrue({
				[track.stack->top().methodName
				 xct_isEqualToString:
				 @"setStringValue:"];
			});
		}
	}
}

- (void)testCase3 {
	// NNTestClassCase30
	{
		Class clazz = [NNTestClassCase30 class];
		NSString *clazzName = NSStringFromClass(clazz);
		// + nameOfClass
		{
			NSString *v = [clazz nameOfClass];
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 clazzName];
			});
		}
		// - nameOfClass
		{
			NSString *v = [[clazz new] nameOfClass];
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 clazzName];
			});
		}
		{
			id<NNTestSubProtocol> obj = [clazz new];
			obj.stringValue = clazzName;
			NSString *v = obj.stringValue;
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 clazzName];
			});
			XCTAssertTrue({
				[track.stack->top().methodName
				 xct_isEqualToString:
				 @"stringValue"];
			});
			track.stack->pop();
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 clazzName];
			});
			XCTAssertTrue({
				[track.stack->top().methodName
				 xct_isEqualToString:
				 @"setStringValue:"];
			});
		}
	}
	// NNTestClassCase31
	{
		Class clazz = [NNTestClassCase31 class];
		NSString *clazzName = NSStringFromClass(clazz);
		// + nameOfClass
		{
			NSString *v = [clazz nameOfClass];
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestProtocol,,)))];
			});
		}
		// - nameOfClass
		{
			NSString *v = [[clazz new] nameOfClass];
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 clazzName];
			});
		}
		{
			id<NNTestSubProtocol> obj = [clazz new];
			obj.stringValue = clazzName;
			NSString *v = obj.stringValue;
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 clazzName];
			});
			XCTAssertTrue({
				[track.stack->top().methodName
				 xct_isEqualToString:
				 @"stringValue"];
			});
			track.stack->pop();
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestSubProtocol,,)))];
			});
			XCTAssertTrue({
				[track.stack->top().methodName
				 xct_isEqualToString:
				 @"setStringValue:"];
			});
		}
	}
}

- (void)testCase4 {
	// NNTestClassCase40
	{
		Class clazz = [NNTestClassCase40 class];
		NSString *clazzName = NSStringFromClass(clazz);
		// + nameOfClass
		{
			NSString *v = [clazz nameOfClass];
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestSubProtocol, NNTestClassCase40Protocol,)))];
			});
		}
		// - nameOfClass
		{
			NSString *v = [[clazz new] nameOfClass];
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestProtocol,,)))];
			});
		}
		{
			id<NNTestSubProtocol> obj = [clazz new];
			obj.stringValue = clazzName;
			NSString *v = obj.stringValue;
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 clazzName];
			});
			XCTAssertTrue({
				[track.stack->top().methodName
				 xct_isEqualToString:
				 @"stringValue"];
			});
			track.stack->pop();
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestSubProtocol, NNTestClassCase40Protocol,)))];
			});
			XCTAssertTrue({
				[track.stack->top().methodName
				 xct_isEqualToString:
				 @"setStringValue:"];
			});
		}
	}
	// NNTestClassCase41
	{
		Class clazz = [NNTestClassCase41 class];
		NSString *clazzName = NSStringFromClass(clazz);
		// + nameOfClass
		{
			NSString *v = [clazz nameOfClass];
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestProtocol,,)))];
			});
		}
		// - nameOfClass
		{
			NSString *v = [[clazz new] nameOfClass];
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestSubProtocol,, NNTestClassCase41Protocol)))];
			});
		}
		{
			id<NNTestSubProtocol> obj = [clazz new];
			obj.stringValue = clazzName;
			NSString *v = obj.stringValue;
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestSubProtocol,, NNTestClassCase41Protocol)))];
			});
			XCTAssertTrue({
				[track.stack->top().methodName
				 xct_isEqualToString:
				 @"stringValue"];
			});
			track.stack->pop();
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 clazzName];
			});
			XCTAssertTrue({
				[track.stack->top().methodName
				 xct_isEqualToString:
				 @"setStringValue:"];
			});
		}
	}
	// NNTestClassCase42
	{
		Class clazz = [NNTestClassCase42 class];
		NSString *clazzName = NSStringFromClass(clazz);
		// + nameOfClass
		{
			NSString *v = [clazz nameOfClass];
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestProtocol,,)))];
			});
		}
		// - nameOfClass
		{
			NSString *v = [[clazz new] nameOfClass];
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestProtocol,,)))];
			});
		}
		{
			id<NNTestSubProtocol, NNTestClassCase420Protocol> obj = [clazz new];
			obj.stringValue = clazzName;
			__unused NSString *v = obj.stringValue;
			XCTAssertTrue([clazzName isEqualToString:v]);
			NNTestTrack *track = v.track;
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestSubProtocol,, NNTestClassCase420Protocol, NNTestClassCase421Protocol)))];
			});
			XCTAssertTrue({
				[track.stack->top().methodName
				 xct_isEqualToString:
				 @"stringValue"];
			});
			track.stack->pop();
			XCTAssertTrue({
				[track.stack->top().implmentClass
				 xct_isEqualToString:
				 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestSubProtocol,, NNTestClassCase420Protocol, NNTestClassCase421Protocol)))];
			});
			XCTAssertTrue({
				[track.stack->top().methodName
				 xct_isEqualToString:
				 @"setStringValue:"];
			});
		}
	}
}

- (void)testCase5 {
	// NNTestClassCase50
	{
		__unused id obj = [NNTestClassCase50 new];
		NNTestTrack *track = case50Track.track;
		XCTAssertTrue({
			[track.stack->top().invokeClass
			 xct_isEqualToString:
			 @"NNTestClassCase50"];
		});
		XCTAssertTrue({
			[track.stack->top().implmentClass
			 xct_isEqualToString:
			 @"NNTestClassCase50"];
		});
		XCTAssertTrue({
			track.stack->top().methodType == NNTestMethodTypeClass;
		});
		XCTAssertTrue({
			[track.stack->top().methodName
			 xct_isEqualToString:
			 @"initialize"];
		});
	}
	// NNTestClassCase51
	{
		// initialize method does not need injection
		__unused id obj = [NNTestClassCase51 new];
		NNTestTrack *track = case51Track.track;
		XCTAssertTrue({
			[track.stack->top().invokeClass
			 xct_isEqualToString:
			 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestSubProtocol, NNTestClassCase50,)))];
		});
		XCTAssertTrue({
			[track.stack->top().implmentClass
			 xct_isEqualToString:
			 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestSubProtocol, NNTestClassCase50,)))];
		});
		XCTAssertTrue({
			track.stack->top().methodType == NNTestMethodTypeClass;
		});
		XCTAssertTrue({
			[track.stack->top().methodName
			 xct_isEqualToString:
			 @"initialize"];
		});
	}
}

- (void)testCase6 {
    // NNTestClassCase60
    {
        Class clazz = [NNTestClassCase60 class];
        NSString *clazzName = NSStringFromClass(clazz);
        // + nameOfClass
        {
            NSString *v = [clazz nameOfClass];
            XCTAssertTrue([clazzName isEqualToString:v]);
            NNTestTrack *track = v.track;
            XCTAssertTrue({
                [track.stack->top().implmentClass
                 xct_isEqualToString:
                 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestProtocol,,)))];
            });
        }
        // - nameOfClass
        {
            NSString *v = [[clazz new] nameOfClass];
            XCTAssertTrue([clazzName isEqualToString:v]);
            NNTestTrack *track = v.track;
            XCTAssertTrue({
                [track.stack->top().implmentClass
                 xct_isEqualToString:
                 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestProtocol,,)))];
            });
        }
    }
    // NNTestClassCase61
    {
        Class clazz = [NNTestClassCase61 class];
        NSString *clazzName = NSStringFromClass(clazz);
        // + nameOfClass
        {
            NSString *v = [clazz nameOfClass];
            XCTAssertTrue([clazzName isEqualToString:v]);
            NNTestTrack *track = v.track;
            XCTAssertTrue({
                [track.stack->top().implmentClass
                 xct_isEqualToString:
                 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestProtocol,,)))];
            });
        }
        // - nameOfClass
        {
            NSString *v = [[clazz new] nameOfClass];
            XCTAssertTrue([clazzName isEqualToString:v]);
            NNTestTrack *track = v.track;
            XCTAssertTrue({
                [track.stack->top().implmentClass
                 xct_isEqualToString:
                 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestProtocol,,)))];
            });
        }
    }
    // NNTestClassCase62
    {
        Class clazz = [NNTestClassCase62 class];
        NSString *clazzName = NSStringFromClass(clazz);
        // + nameOfClass
        {
            NSString *v = [clazz nameOfClass];
            XCTAssertTrue([clazzName isEqualToString:v]);
            NNTestTrack *track = v.track;
            XCTAssertTrue({
                [track.stack->top().implmentClass
                 xct_isEqualToString:
                 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestProtocol, NNTestClassCase62,)))];
            });
        }
        // - nameOfClass
        {
            NSString *v = [[clazz new] nameOfClass];
            XCTAssertTrue([clazzName isEqualToString:v]);
            NNTestTrack *track = v.track;
            XCTAssertTrue({
                [track.stack->top().implmentClass
                 xct_isEqualToString:
                 @(nn_pop_metamacro_stringify(nn_pop_extension_name_(nn_pop_extension_prefix, NNTestProtocol, NNTestClassCase62,)))];
            });
        }
    }
}

- (void)testPerformanceExample {
	// This is an example of a performance test case.
	[self measureBlock:^{
		// Put the code you want to measure the time of here.
	}];
}

@end
