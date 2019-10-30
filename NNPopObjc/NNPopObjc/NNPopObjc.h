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
class NNPopObjc; \
\
nn_pop_extension_section_(nn_pop_extension_prefix, protocol, clazz); \
\
@interface nn_pop_extension_name_(nn_pop_extension_prefix, protocol, clazz) : clazz <protocol> \
\
@end \
\
@implementation nn_pop_extension_name_(nn_pop_extension_prefix, protocol, clazz) \
\


#pragma mark - define

typedef struct {
    const char *extension_prefix;
    const char *extension_protocol;
    const char *special_clazz;
    const char *extension_clazz;
} nn_pop_extension_section_item;


#define nn_pop_extension_prefix                 __NNPopObjc_
#define nn_pop_segment_name                     __DATA
#define nn_pop_section_name                     __nn_pop_objc__

#define nn_pop_stringify(VALUE) \
        nn_pop_stringify_(VALUE)

#define nn_pop_concat(A, B) \
        nn_pop_concat_(A, B)

#define nn_pop_stringify_(VALUE) # VALUE
#define nn_pop_concat_(A, B) A ## B

#define nn_pop_section(section_name) __attribute((used, section(nn_pop_stringify(nn_pop_segment_name) "," section_name )))

#define nn_pop_extension_name_(prefix, protocol, clazz) \
        nn_pop_concat(prefix, \
        nn_pop_concat(protocol, \
        nn_pop_concat(_, clazz \
        ))) \

#define nn_pop_extension_section_(prefix, protocol, clazz) \
        const nn_pop_extension_section_item \
        nn_pop_concat(k, nn_pop_extension_name_(prefix, protocol, clazz)) \
        nn_pop_section(nn_pop_stringify(nn_pop_section_name)) = \
        { \
            nn_pop_stringify(prefix), \
            nn_pop_stringify(protocol), \
            nn_pop_stringify(clazz), \
            nn_pop_stringify(nn_pop_extension_name_(prefix, protocol, clazz)) \
        }; \

@interface NNPopObjc : NSObject

@end
