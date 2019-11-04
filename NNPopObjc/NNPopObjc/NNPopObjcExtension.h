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

#define nn_pop_extension_(protocol, ...) \
        nn_pop_if_less(nn_pop_argcount(__VA_ARGS__), 2) \
        (nn_pop_extension_fill(nn_pop_extension_prefix, protocol, nn_where())) \
        (nn_pop_extension_fill(nn_pop_extension_prefix, protocol, __VA_ARGS__)) \

#define nn_pop_extension_fill(prefix, protocol, ...) \
        nn_pop_extension_expand(prefix, protocol, __VA_ARGS__) \

#define nn_pop_extension_expand(prefix, protocol, nn_where_unique_id, nn_where_block, ...) \
        \
        class NSObject; \
        \
        nn_pop_extension_where_(nn_pop_extension_prefix, protocol, nn_where_unique_id, nn_where_block, __VA_ARGS__)\
        \
        nn_pop_extension_section_(nn_pop_extension_prefix, protocol, nn_where_unique_id, nn_where_block, __VA_ARGS__) \
        \
        @interface nn_pop_extension_name_(prefix, protocol, nn_where_unique_id, __VA_ARGS__) : NSObject < protocol nn_pop_adopt_protocol(__VA_ARGS__)> \
        \
        @end \
        \
        @implementation nn_pop_extension_name_(prefix, protocol, nn_where_unique_id, __VA_ARGS__) \


#define nn_pop_adopt_protocol(...) \
        metamacro_if_eq(0, nn_pop_argcount(__VA_ARGS__))()\
        (nn_pop_adopt_protocol_(__VA_ARGS__))\

#define nn_pop_adopt_protocol_(...) \
        metamacro_foreach_cxt(nn_pop_adopt_protocol_iter,,, __VA_ARGS__) \

#define nn_pop_adopt_protocol_iter(INDEX, CONTEXT, VAR) \
        ,VAR \

#endif /* NNPopObjcExtension_h */
