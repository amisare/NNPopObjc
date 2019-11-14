//
//  NNPopObjcWhere.h
//  Pods
//
//  Created by GuHaijun on 2019/11/2.
//

#ifndef NNPopObjcWhere_h
#define NNPopObjcWhere_h

#import "NNPopObjcDefines.h"

/// IMPLEMENTATION DETAILS FOLLOW!
/// Do not write code that depends on anything below this line.

/**
 * nn_pop_where_block_ result type
 */
typedef enum : NSUInteger {
    nn_pop_where_value_unmatched = 0,
    nn_pop_where_value_matched_default,
    nn_pop_where_value_matched_constrained,
} nn_pop_where_value_def;

/**
 * nn_where implementation
 */
#define nn_pop_where_(...) \
        metamacro_concat(nn_pop_where_, nn_pop_argcount(__VA_ARGS__))(__VA_ARGS__)

/**
 * nn_where static function name, the name is prefixed as 'w' and concated all args with '_'
 */
#define nn_pop_extension_where_name_(...) \
        nn_pop_args_concat(_, w, __VA_ARGS__) \

/**
 * nn_where static function define
 */
#define nn_pop_extension_where_(prefix, protocol, where_keywordify, where_unique_id, where_block, ...) \
        static nn_pop_where_value_def nn_pop_extension_where_name_(prefix, protocol, where_unique_id, __VA_ARGS__)(Class self) { \
            where_keywordify \
            return where_block(self); \
        } \

/**
 * nn_pop_where_ expansions
 */
#define nn_pop_where_0() \
        nn_pop_where_keywordify, \
        , \
        nn_pop_where_block_(true, true) \

#define nn_pop_where_1(expression) \
        nn_pop_where_keywordify, \
        _, \
        nn_pop_where_block_(expression, false) \

#define nn_pop_where_2(unique_id, expression) \
        nn_pop_where_keywordify, \
        unique_id, \
        nn_pop_where_block_(expression, false) \

/**
 * nn_pop_where_block_ expansions
 */
#define nn_pop_where_block_(expression, as_default) \
        ^nn_pop_where_value_def(__unsafe_unretained Class self){ \
            if (self == nil) { \
                return nn_pop_where_value_unmatched; \
            } \
            BOOL is_match = (expression); \
            if (is_match == false) { \
                return nn_pop_where_value_unmatched; \
            } \
            return as_default ? nn_pop_where_value_matched_default : nn_pop_where_value_matched_constrained; \
        } \

/**
 * Inspired by libextobjc: https://github.com/jspahrsummers/libextobjc
 */
#if defined(DEBUG) && !defined(NDEBUG)
#define nn_pop_where_keywordify autoreleasepool {}
#else
#define nn_pop_where_keywordify try {} @catch (...) {}
#endif

#endif /* NNPopObjcWhere_h */
