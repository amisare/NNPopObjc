//
//  NNPopObjcInjection.h
//  NNPopObjc
//
//  Created by 顾海军 on 2019/10/26.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <mach-o/getsect.h>
#include <mach-o/dyld.h>

#import "NNPopObjcProtocol.h"

typedef struct
#ifdef __LP64__
mach_header_64
#else
mach_header
#endif
nn_pop_mach_header;
