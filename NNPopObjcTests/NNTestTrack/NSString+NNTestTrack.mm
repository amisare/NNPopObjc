//
//  NSString+NNTestTrack.mm
//  NNPopObjcTests
//
//  Created by 顾海军 on 2019/12/13.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NSString+NNTestTrack.h"
#import <objc/runtime.h>

@implementation NSString (NNTestTrack)

- (NNTestTrack *)track {
	NNTestTrack *value = objc_getAssociatedObject(self, @selector(track));
	if (value == nil) {
		value = [NNTestTrack new];
		self.track = value;
	}
	return value;
}

- (void)setTrack:(NNTestTrack *)track {
	objc_setAssociatedObject(self, @selector(track), track, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
