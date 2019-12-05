//
//  NNPopObjcDescription.h
//  Pods
//
//  Created by GuHaijun on 2019/11/2.
//

#ifndef NNPopObjcDescription_h
#define NNPopObjcDescription_h

#import "NNPopObjcDefines.h"
#import "NNPopObjcWhere.h"

/// IMPLEMENTATION DETAILS FOLLOW!
/// Do not write code that depends on anything below this line.

typedef nn_pop_where_value_def (*where_fp)(Class clazz);

typedef struct {
    /// Name of protocol be extended
    const char *protocol;
    /// Prefix of extension implementation class name
    const char *prefix;
    /// Name of extension implemention class
    const char *clazz;
    /// Where clause function pointer
    where_fp where_fp;
    /// Count of protocols that the adopted class should be confrom to.
    unsigned int confrom_protocol_count;
    /// Protocols that the adopted class should be confrom to.
    const char *confrom_protocols[20];
} nn_pop_extension_description_t;

/**
 * __attribute__ of extension description section
 */
#define nn_pop_extension_description_section(section_name) __attribute__((used, section(nn_pop_metamacro_stringify(nn_pop_segment_name) "," section_name )))

/**
 * nn_pop_extension_description_t name, the name is prefixed as 's' and concated all args with '_'
 */
#define nn_pop_extension_description_name_(...) \
        nn_pop_args_concat(_, s, __VA_ARGS__) \

/**
 * nn_pop_extension_description define
 */
#define nn_pop_extension_description_(prefix, protocol, where_unique_id, where_block, ...) \
        const nn_pop_extension_description_t \
        nn_pop_extension_description_name_(prefix, protocol, where_unique_id, __VA_ARGS__) \
        nn_pop_extension_description_section(nn_pop_metamacro_stringify(nn_pop_section_name)) = \
        { \
            nn_pop_metamacro_stringify(protocol), \
            nn_pop_metamacro_stringify(prefix), \
            nn_pop_metamacro_stringify(nn_pop_extension_name_(prefix, protocol, where_unique_id, __VA_ARGS__)), \
            nn_pop_extension_where_name_(prefix, protocol, where_unique_id, __VA_ARGS__), \
            nn_pop_argcount(__VA_ARGS__), \
            {nn_pop_confrom_protocol_names(__VA_ARGS__)}, \
        }; \

/**
 *  Convert each macro argument into a string constant, then concat all strings whth ','.
 *
 * @code

    nn_pop_confrom_protocol_names(a, b, c)
    // "a", "b", "c",

 * @endcode
 */
#define nn_pop_confrom_protocol_names(...) \
        nn_pop_metamacro_if_eq(0, nn_pop_argcount(__VA_ARGS__))()\
        (nn_pop_confrom_protocol_names_(__VA_ARGS__))\

#define nn_pop_confrom_protocol_names_(...) \
        nn_pop_metamacro_foreach_cxt(nn_pop_confrom_protocol_name_iter,,, __VA_ARGS__) \

#define nn_pop_confrom_protocol_name_iter(INDEX, CONTEXT, VAR) \
        nn_pop_metamacro_stringify(VAR),

#endif /* NNPopObjcDescription_h */
