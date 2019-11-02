//
//  NNPopObjcSection.h
//  Pods
//
//  Created by GuHaijun on 2019/11/2.
//

#ifndef NNPopObjcSection_h
#define NNPopObjcSection_h

#import "NNPopObjcMacros.h"

typedef nn_where_type_e (*extension_where_fp)(Class clazz);

typedef struct {
    const char *extension_protocol;
    const char *extension_prefix;
    const char *extension_clazz;
    extension_where_fp extension_where_fp;
    unsigned int extension_adopt_protocols_count;
    const char *extension_adopt_protocols[20];
} nn_pop_extension_section_item;


#define nn_pop_extension_section_name_(...) \
        nn_pop_vrgs_concat(_, s, __VA_ARGS__) \

#define nn_pop_extension_section_(prefix, protocol, ...) \
        metamacro_if_eq(0, metamacro_argcount(__VA_ARGS__))(nn_pop_extension_section_0(prefix, protocol))\
        (metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__))(nn_pop_extension_section_0(prefix, protocol))\
        (nn_pop_extension_section_N(prefix, protocol, __VA_ARGS__)))\


#define nn_pop_extension_section_0(prefix, protocol) \
        const nn_pop_extension_section_item \
        nn_pop_extension_section_name_(prefix, protocol) \
        nn_pop_section(metamacro_stringify(nn_pop_section_name)) = \
        { \
            metamacro_stringify(protocol), \
            metamacro_stringify(prefix), \
            metamacro_stringify(nn_pop_extension_name_(prefix, protocol)), \
            nn_pop_extension_where_name_(prefix, protocol), \
            0, \
            {}, \
        }; \

#define nn_pop_extension_section_N(prefix, protocol, nn_where_unique_id, nn_where_block, ...) \
        const nn_pop_extension_section_item \
        nn_pop_extension_section_name_(prefix, protocol, nn_where_unique_id, __VA_ARGS__) \
        nn_pop_section(metamacro_stringify(nn_pop_section_name)) = \
        { \
            metamacro_stringify(protocol), \
            metamacro_stringify(prefix), \
            metamacro_stringify(nn_pop_extension_name_(prefix, protocol, nn_where_unique_id, __VA_ARGS__)), \
            nn_pop_extension_where_name_(prefix, protocol, nn_where_unique_id, __VA_ARGS__), \
            metamacro_argcount(__VA_ARGS__), \
            {nn_pop_adopt_protocol_names(__VA_ARGS__)}, \
        }; \

#define nn_pop_adopt_protocol_names(...) \
        metamacro_if_eq(0, metamacro_argcount(__VA_ARGS__))()\
        (nn_pop_adopt_protocol_names_(__VA_ARGS__))\

#define nn_pop_adopt_protocol_names_(...) \
        metamacro_foreach_cxt(nn_pop_adopt_protocol_name_iter,,, __VA_ARGS__) \

#define nn_pop_adopt_protocol_name_iter(INDEX, CONTEXT, VAR) \
        metamacro_stringify(VAR),

#endif /* NNPopObjcSection_h */
