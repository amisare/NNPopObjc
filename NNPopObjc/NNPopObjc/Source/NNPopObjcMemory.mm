//
//  NNPopObjcMemory.m
//  NNPopObjc
//
//  Created by GuHaijun on 2019/11/14.
//

#import "NNPopObjcMemory.h"

void *nn_pop_malloc(size_t size) {
    void *_ptr = malloc(size);
    memset(_ptr, 0, size);
    return _ptr;
}


void *nn_pop_realloc(void *ptr, size_t size) {
    void *_ptr = realloc(ptr, size);
    return _ptr;
}
