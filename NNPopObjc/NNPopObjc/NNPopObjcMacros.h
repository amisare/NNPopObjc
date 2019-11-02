//
//  NNPopObjcMacros.h
//  Pods
//
//  Created by GuHaijun on 2019/11/2.
//

#ifndef NNPopObjcMacros_h
#define NNPopObjcMacros_h

#import "metamacros.h"

#define nn_pop_extension_prefix                 __NNPopObjc
#define nn_pop_segment_name                     __DATA
#define nn_pop_section_name                     __nn_pop_objc__

#define nn_pop_section(section_name) __attribute((used, section(metamacro_stringify(nn_pop_segment_name) "," section_name )))

#define nn_pop_vrgs_concat(SEP, ...) \
        metamacro_concat(nn_pop_vrgs_concat_, metamacro_argcount(__VA_ARGS__))(SEP, __VA_ARGS__)


#define nn_pop_vrgs_concat_0(SEP)
#define nn_pop_vrgs_concat_1(SEP, _0) metamacro_concat(_0, )

#define nn_pop_vrgs_concat_2(SEP, _0, _1) \
        metamacro_concat( \
        nn_pop_vrgs_concat_1(SEP, _0), \
        metamacro_concat(SEP, _1) \
        ) \

#define nn_pop_vrgs_concat_3(SEP, _0, _1, _2) \
        metamacro_concat( \
        nn_pop_vrgs_concat_2(SEP, _0, _1), \
        metamacro_concat(SEP, _2) \
        ) \

#define nn_pop_vrgs_concat_4(SEP, _0, _1, _2, _3) \
        metamacro_concat( \
        nn_pop_vrgs_concat_3(SEP, _0, _1, _2), \
        metamacro_concat(SEP, _3) \
        ) \

#define nn_pop_vrgs_concat_5(SEP, _0, _1, _2, _3, _4) \
        metamacro_concat( \
        nn_pop_vrgs_concat_4(SEP, _0, _1, _2, _3), \
        metamacro_concat(SEP, _4) \
        ) \

#define nn_pop_vrgs_concat_6(SEP, _0, _1, _2, _3, _4, _5) \
        metamacro_concat( \
        nn_pop_vrgs_concat_5(SEP, _0, _1, _2, _3, _4), \
        metamacro_concat(SEP, _5) \
        ) \

#define nn_pop_vrgs_concat_7(SEP, _0, _1, _2, _3, _4, _5, _6) \
        metamacro_concat( \
        nn_pop_vrgs_concat_6(SEP, _0, _1, _2, _3, _4, _5), \
        metamacro_concat(SEP, _6) \
        ) \

#define nn_pop_vrgs_concat_8(SEP, _0, _1, _2, _3, _4, _5, _6, _7) \
        metamacro_concat( \
        nn_pop_vrgs_concat_7(SEP, _0, _1, _2, _3, _4, _5, _6), \
        metamacro_concat(SEP, _7) \
        ) \

#define nn_pop_vrgs_concat_9(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8) \
        metamacro_concat( \
        nn_pop_vrgs_concat_8(SEP, _0, _1, _2, _3, _4, _5, _6, _7), \
        metamacro_concat(SEP, _8) \
        ) \

#define nn_pop_vrgs_concat_10(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9) \
        metamacro_concat( \
        nn_pop_vrgs_concat_9(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8), \
        metamacro_concat(SEP, _9) \
        ) \

#define nn_pop_vrgs_concat_11(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10) \
        metamacro_concat( \
        nn_pop_vrgs_concat_10(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9), \
        metamacro_concat(SEP, _10) \
        ) \

#define nn_pop_vrgs_concat_12(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11) \
        metamacro_concat( \
        nn_pop_vrgs_concat_11(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10), \
        metamacro_concat(SEP, _11) \
        ) \

#define nn_pop_vrgs_concat_13(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12) \
        metamacro_concat( \
        nn_pop_vrgs_concat_12(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11), \
        metamacro_concat(SEP, _12) \
        ) \

#define nn_pop_vrgs_concat_14(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13) \
        metamacro_concat( \
        nn_pop_vrgs_concat_13(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12), \
        metamacro_concat(SEP, _13) \
        ) \

#define nn_pop_vrgs_concat_15(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14) \
        metamacro_concat( \
        nn_pop_vrgs_concat_14(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13), \
        metamacro_concat(SEP, _14) \
        ) \

#define nn_pop_vrgs_concat_16(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15) \
        metamacro_concat( \
        nn_pop_vrgs_concat_15(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14), \
        metamacro_concat(SEP, _15) \
        ) \

#define nn_pop_vrgs_concat_17(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16) \
        metamacro_concat( \
        nn_pop_vrgs_concat_16(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15), \
        metamacro_concat(SEP, _16) \
        ) \

#define nn_pop_vrgs_concat_18(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17) \
        metamacro_concat( \
        nn_pop_vrgs_concat_17(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16), \
        metamacro_concat(SEP, _17) \
        ) \

#define nn_pop_vrgs_concat_19(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18) \
        metamacro_concat( \
        nn_pop_vrgs_concat_18(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17), \
        metamacro_concat(SEP, _18) \
        ) \

#define nn_pop_vrgs_concat_20(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19) \
        metamacro_concat( \
        nn_pop_vrgs_concat_19(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18), \
        metamacro_concat(SEP, _19) \
        ) \


#endif /* NNPopObjcMacros_h */
