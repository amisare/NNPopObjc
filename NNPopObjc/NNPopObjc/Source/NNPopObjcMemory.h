//
//  NNPopObjcMemory.h
//  NNPopObjc
//
//  Created by GuHaijun on 2019/11/14.
//

#ifndef NNPopObjcMemory_h
#define NNPopObjcMemory_h

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */


void *nn_pop_malloc(size_t size);
void *nn_pop_realloc(void *ptr, size_t size);

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* NNPopObjcMemory_h */
