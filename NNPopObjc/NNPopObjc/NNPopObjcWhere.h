//
//  NNPopObjcWhere.h
//  Pods
//
//  Created by GuHaijun on 2019/11/2.
//

#ifndef NNPopObjcWhere_h
#define NNPopObjcWhere_h

#import "NNPopObjcDefines.h"


typedef enum : NSUInteger {
    nn_where_value_unmatched = 0,
    nn_where_value_matched_default,
    nn_where_value_matched_limited,
} nn_where_value_def;


#define nn_where_(...) \
        metamacro_concat(nn_where_, nn_pop_argcount(__VA_ARGS__))(__VA_ARGS__)

#define nn_pop_extension_where_name_(...) \
        nn_pop_args_concat(_, w, __VA_ARGS__) \

#define nn_pop_extension_where_(prefix, protocol, nn_where_unique_id, nn_where_block, ...) \
        static nn_where_value_def nn_pop_extension_where_name_(prefix, protocol, nn_where_unique_id, __VA_ARGS__)(Class self) { \
            return nn_where_block(self); \
        } \


#define nn_where_0() \
        , \
        nn_where_block_default_ \

#define nn_where_1(expression) \
        _, \
        nn_where_block_(expression) \

#define nn_where_2(unique_id, expression) \
        unique_id, \
        nn_where_block_(expression) \

#define nn_where_block_default_ \
        ^nn_where_value_def(__unsafe_unretained Class self){ \
            BOOL result = (self != nil); \
            return (result ? nn_where_value_matched_default : nn_where_value_unmatched); \
        } \

#define nn_where_block_(expression) \
        ^nn_where_value_def(__unsafe_unretained Class self){ \
            if (self == nil) { \
                return nn_where_value_unmatched; \
            } \
            BOOL result = (expression); \
            return (result ? nn_where_value_matched_limited : nn_where_value_unmatched); \
        } \


#endif /* NNPopObjcWhere_h */
