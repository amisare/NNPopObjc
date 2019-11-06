//
//  NNPopObjcExtension.h
//  Pods
//
//  Created by GuHaijun on 2019/11/2.
//

#ifndef NNPopObjcExtension_h
#define NNPopObjcExtension_h

#import "NNPopObjcDefines.h"


#define nn_pop_extension_name_(...) \
        nn_pop_args_concat(_, __VA_ARGS__) \

/**
 * nn_extension implementation
 */
#define nn_pop_extension_(protocol, ...) \
        nn_pop_extension_param_check(protocol, __VA_ARGS__)

/**
 * Check nn_extension variable parameter list, the list requires a minimum of 3 parameters.
 * If the parameter is less than 3, then use a @nn_where() as the variable parameter list input.
 */
#define nn_pop_extension_param_check(protocol, ...) \
        nn_pop_if_less(nn_pop_argcount(__VA_ARGS__), 3) \
        (nn_pop_extension_param_fill(nn_pop_extension_prefix, protocol, @nn_where())) \
        (nn_pop_extension_param_fill(nn_pop_extension_prefix, protocol, __VA_ARGS__)) \

/**
 * Used to fill nn_extension variable parameter list.
 */
#define nn_pop_extension_param_fill(prefix, protocol, ...) \
        nn_pop_extension_param_expand(prefix, protocol, __VA_ARGS__) \

/**
 * Expand nn_extension
 */
#define nn_pop_extension_param_expand(prefix, protocol, where_keywordify, where_unique_id, where_block, ...) \
        \
        class NSObject; \
        \
        nn_pop_extension_where_(nn_pop_extension_prefix, protocol, where_keywordify, where_unique_id, where_block, __VA_ARGS__)\
        \
        nn_pop_extension_section_(nn_pop_extension_prefix, protocol, where_unique_id, where_block, __VA_ARGS__) \
        \
        @interface nn_pop_extension_name_(prefix, protocol, where_unique_id, __VA_ARGS__) : NSObject < protocol nn_pop_adopt_protocol(__VA_ARGS__)> \
        \
        @end \
        \
        @implementation nn_pop_extension_name_(prefix, protocol, where_unique_id, __VA_ARGS__) \

/**
 * Concat all args with ','
 *
 * @code
 
    nn_pop_adopt_protocol(a, b, c) 
    // ,a ,b ,c
 
 * @endcode
 */
#define nn_pop_adopt_protocol(...) \
        metamacro_if_eq(0, nn_pop_argcount(__VA_ARGS__))()\
        (nn_pop_adopt_protocol_(__VA_ARGS__))\

#define nn_pop_adopt_protocol_(...) \
        metamacro_foreach_cxt(nn_pop_adopt_protocol_iter,,, __VA_ARGS__) \

#define nn_pop_adopt_protocol_iter(INDEX, CONTEXT, VAR) \
        ,VAR \

#endif /* NNPopObjcExtension_h */
