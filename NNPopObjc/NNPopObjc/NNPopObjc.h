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

#import "metamacros.h"
#import "NNPopObjcMacros.h"
#import "NNPopObjcWhere.h"
#import "NNPopObjcSection.h"
#import "NNPopObjcExtension.h"

#define nn_where(...)                   nn_where_(__VA_ARGS__)
#define nn_extension(protocol, ...)     nn_pop_extension_(protocol, __VA_ARGS__)
