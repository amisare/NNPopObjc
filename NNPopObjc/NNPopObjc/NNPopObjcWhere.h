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
    nn_pop_where_value_unmatched = 0,
    nn_pop_where_value_matched_default,
    nn_pop_where_value_matched_limited,
} nn_pop_where_value_def;


#define nn_pop_where_(...) \
        nn_pop_where_keywordify, \
        metamacro_concat(nn_pop_where_, nn_pop_argcount(__VA_ARGS__))(__VA_ARGS__)

#define nn_pop_extension_where_name_(...) \
        nn_pop_args_concat(_, w, __VA_ARGS__) \

#define nn_pop_extension_where_(prefix, protocol, where_keywordify, where_unique_id, where_block, ...) \
        static nn_pop_where_value_def nn_pop_extension_where_name_(prefix, protocol, where_unique_id, __VA_ARGS__)(Class self) { \
            where_keywordify \
            return where_block(self); \
        } \


#define nn_pop_where_0() \
        , \
        nn_pop_where_block_default_ \

#define nn_pop_where_1(expression) \
        _, \
        nn_pop_where_block_(expression) \

#define nn_pop_where_2(unique_id, expression) \
        unique_id, \
        nn_pop_where_block_(expression) \


#define nn_pop_where_block_default_ \
        ^nn_pop_where_value_def(__unsafe_unretained Class self){ \
            BOOL result = (self != nil); \
            return (result ? nn_pop_where_value_matched_default : nn_pop_where_value_unmatched); \
        } \

#define nn_pop_where_block_(expression) \
        ^nn_pop_where_value_def(__unsafe_unretained Class self){ \
            if (self == nil) { \
                return nn_pop_where_value_unmatched; \
            } \
            BOOL result = (expression); \
            return (result ? nn_pop_where_value_matched_limited : nn_pop_where_value_unmatched); \
        } \


#if defined(DEBUG) && !defined(NDEBUG)
#define nn_pop_where_keywordify autoreleasepool {}
#else
#define nn_pop_where_keywordify try {} @catch (...) {}
#endif

#endif /* NNPopObjcWhere_h */
