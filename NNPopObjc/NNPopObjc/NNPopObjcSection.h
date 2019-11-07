//
//  NNPopObjcSection.h
//  Pods
//
//  Created by GuHaijun on 2019/11/2.
//

#ifndef NNPopObjcSection_h
#define NNPopObjcSection_h

#import "NNPopObjcDefines.h"

/// IMPLEMENTATION DETAILS FOLLOW!
/// Do not write code that depends on anything below this line.

typedef nn_pop_where_value_def (*extension_where_fp)(Class clazz);

typedef struct {
    /// Name of protocol be extended
    const char *extension_protocol;
    /// Prefix of extension class name
    const char *extension_prefix;
    /// Name of extension class
    const char *extension_clazz;
    /// Where clause function pointer
    extension_where_fp extension_where_fp;
    /// Protocols count that Class confrom to.
    unsigned int extension_adopt_protocols_count;
    /// Protocols that Class confrom to.
    const char *extension_adopt_protocols[20];
} nn_pop_extension_section_item;

/**
 * __attribute__ of section
 */
#define nn_pop_section(section_name) __attribute__((used, section(metamacro_stringify(nn_pop_segment_name) "," section_name )))

/**
 * nn_pop_extension_section_item name, the name is prefixed as 's' and concated all args with '_'
 */
#define nn_pop_extension_section_name_(...) \
        nn_pop_args_concat(_, s, __VA_ARGS__) \

/**
 * nn_pop_extension_section define
 */
#define nn_pop_extension_section_(prefix, protocol, nn_pop_where_unique_id, nn_pop_where_block, ...) \
        const nn_pop_extension_section_item \
        nn_pop_extension_section_name_(prefix, protocol, nn_pop_where_unique_id, __VA_ARGS__) \
        nn_pop_section(metamacro_stringify(nn_pop_section_name)) = \
        { \
            metamacro_stringify(protocol), \
            metamacro_stringify(prefix), \
            metamacro_stringify(nn_pop_extension_name_(prefix, protocol, nn_pop_where_unique_id, __VA_ARGS__)), \
            nn_pop_extension_where_name_(prefix, protocol, nn_pop_where_unique_id, __VA_ARGS__), \
            nn_pop_argcount(__VA_ARGS__), \
            {nn_pop_adopt_protocol_names(__VA_ARGS__)}, \
        }; \

/**
 *  Convert each macro argument into a string constant, then concat all strings whth ','.
 *
 * @code

    nn_pop_adopt_protocol_names(a, b, c)
    // "a", "b", "c",

 * @endcode
 */
#define nn_pop_adopt_protocol_names(...) \
        metamacro_if_eq(0, nn_pop_argcount(__VA_ARGS__))()\
        (nn_pop_adopt_protocol_names_(__VA_ARGS__))\

#define nn_pop_adopt_protocol_names_(...) \
        metamacro_foreach_cxt(nn_pop_adopt_protocol_name_iter,,, __VA_ARGS__) \

#define nn_pop_adopt_protocol_name_iter(INDEX, CONTEXT, VAR) \
        metamacro_stringify(VAR),

#endif /* NNPopObjcSection_h */
