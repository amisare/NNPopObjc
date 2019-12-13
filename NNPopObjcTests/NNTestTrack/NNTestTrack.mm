//
//  NNTestTrack.m
//  NNPopObjcTests
//
//  Created by 顾海军 on 2019/12/13.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNTestTrack.h"

@implementation NNTestTrack {
	std::shared_ptr<std::stack<NNTestTrackItem *>> _stack;
}

- (instancetype)init {
	self = [super init];
	_stack = std::make_shared<std::stack<NNTestTrackItem *>>();
	return self;
}

- (std::shared_ptr<std::stack<NNTestTrackItem *>>)stack {
	return _stack;
}

@end

@implementation NNTestTrackItem

+ (instancetype)itemWithMethodName:(NSString *)methodName
						methodTypd:(NNTestMethodType)methodType
					 implmentClass:(NSString *)implmentClass
					   invokeClass:(NSString *)invokeClass {
	NNTestTrackItem *item = [NNTestTrackItem new];
	item.methodName = methodName;
	item.methodType = methodType;
	item.implmentClass = implmentClass;
	item.invokeClass = invokeClass;
	return item;
}

@end

