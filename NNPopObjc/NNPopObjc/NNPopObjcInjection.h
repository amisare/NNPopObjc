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

#import "NNPopObjc.h"

typedef struct
#ifdef __LP64__
mach_header_64
#else
mach_header
#endif
nn_pop_mach_header;

typedef struct nn_pop_extension_node nn_pop_extension_node_t;

typedef struct nn_pop_extension_node {
    const char *extension_prefix;
    Class special_clazz;
    Class extension_clazz;
    nn_pop_extension_node_t *next;
};

typedef struct {
    nn_pop_extension_node_t *base;
    nn_pop_extension_node_t *special;
} nn_pop_extension_t;

typedef struct {
    Protocol *protocol;
    nn_pop_extension_t extension;
} nn_pop_protocol_t;
