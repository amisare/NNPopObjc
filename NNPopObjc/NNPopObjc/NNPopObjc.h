//
//  NNPopObjc.h
//  NNPopObjc
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for NNPopObjc.
FOUNDATION_EXPORT double NNPopObjcVersionNumber;

//! Project version string for NNPopObjc.
FOUNDATION_EXPORT const unsigned char NNPopObjcVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <NNPopObjc/PublicHeader.h>

#define nn_extension(protocol, clazz) \
\
interface __NNPopObjc##_##protocol##_##clazz : clazz <protocol> \
\
@end \
\
@implementation __NNPopObjc##_##protocol##_##clazz \
\
