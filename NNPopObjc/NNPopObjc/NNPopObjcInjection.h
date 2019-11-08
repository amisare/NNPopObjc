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

/// Extension description list node
struct nn_pop_extension_node {
    /// Prefix of extension implementation class name
    const char *prefix;
    /// Extension implemention Class
    Class clazz;
    /// Where clause function pointer
    where_fp where_fp;
    /// Count of protocols that the adopted class should be confrom to.
    unsigned int confrom_protocols_count;
    /// Protocols that the adopted class should be confrom to.
    Protocol *confrom_protocols[20];
    /// Next extension list node.
    nn_pop_extension_node_t *next;
};

/// Protocol extension description
typedef struct {
    /// Protocol be extended
    Protocol *protocol;
    /// Protocol extension descriptions
    nn_pop_extension_node_t *extension;
} nn_pop_protocol_t;
