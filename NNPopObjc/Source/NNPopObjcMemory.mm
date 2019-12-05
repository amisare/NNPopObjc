//
//  NNPopObjcMemory.m
//  NNPopObjc
//
//  Created by GuHaijun on 2019/11/14.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNPopObjcMemory.h"

namespace popobjc {

void *nn_pop_malloc(size_t size) {
    void *_ptr = malloc(size);
    memset(_ptr, 0, size); // fix: EXC_BAD_ACCESS
    return _ptr;
}

} // namespace popobjc
