//
//  NNPopObjcInjection.h
//  NNPopObjc
//
//  Created by 顾海军 on 2019/10/26.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#ifndef NNPopObjcInjection_h
#define NNPopObjcInjection_h

#import <Foundation/Foundation.h>
#include <mach-o/getsect.h>
#include <mach-o/dyld.h>

namespace popobjc {

typedef struct
#ifdef __LP64__
mach_header_64
#else
mach_header
#endif
nn_pop_mach_header;

} // namespace popobjc

#endif /* NNPopObjcInjection_h */
