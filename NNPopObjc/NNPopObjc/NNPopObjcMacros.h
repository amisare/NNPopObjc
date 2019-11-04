//
//  NNPopObjcMacros.h
//  Pods
//
//  Created by GuHaijun on 2019/11/2.
//

#ifndef NNPopObjcMacros_h
#define NNPopObjcMacros_h

#import "metamacros.h"


#define nn_pop_at(N, ...) \
        metamacro_concat(nn_pop_at, N)(__VA_ARGS__)

#define nn_pop_inc(VAL) \
        nn_pop_at(VAL, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40)

#define nn_pop_if_equal(A, B) \
        metamacro_concat(nn_pop_if_equal, A)(B)

#define nn_pop_if_greater(A, B) \
        metamacro_concat(nn_pop_if_greater, A)(B)

#define nn_pop_if_greater_or_equal(A, B) \
        metamacro_concat(nn_pop_if_greater_or_equal, A)(B)

#define nn_pop_if_less(A, B) \
        metamacro_concat(nn_pop_if_less, A)(B)

#define nn_pop_if_less_or_equal(A, B) \
        metamacro_concat(nn_pop_if_less_or_equal, A)(B)

#define nn_pop_args_concat(SEP, ...) \
        metamacro_concat(nn_pop_args_concat_, metamacro_argcount(__VA_ARGS__))(SEP, __VA_ARGS__)


// nn_pop_if_equal expansions
#define nn_pop_if_equal20(VALUE) \
    metamacro_concat(nn_pop_if_equal20_, VALUE)

#define nn_pop_if_equal20_0(...) metamacro_expand_
#define nn_pop_if_equal20_1(...) metamacro_expand_
#define nn_pop_if_equal20_2(...) metamacro_expand_
#define nn_pop_if_equal20_3(...) metamacro_expand_
#define nn_pop_if_equal20_4(...) metamacro_expand_
#define nn_pop_if_equal20_5(...) metamacro_expand_
#define nn_pop_if_equal20_6(...) metamacro_expand_
#define nn_pop_if_equal20_7(...) metamacro_expand_
#define nn_pop_if_equal20_8(...) metamacro_expand_
#define nn_pop_if_equal20_9(...) metamacro_expand_
#define nn_pop_if_equal20_10(...) metamacro_expand_
#define nn_pop_if_equal20_11(...) metamacro_expand_
#define nn_pop_if_equal20_12(...) metamacro_expand_
#define nn_pop_if_equal20_13(...) metamacro_expand_
#define nn_pop_if_equal20_14(...) metamacro_expand_
#define nn_pop_if_equal20_15(...) metamacro_expand_
#define nn_pop_if_equal20_16(...) metamacro_expand_
#define nn_pop_if_equal20_17(...) metamacro_expand_
#define nn_pop_if_equal20_18(...) metamacro_expand_
#define nn_pop_if_equal20_19(...) metamacro_expand_
#define nn_pop_if_equal20_20(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_equal20_21(...) metamacro_expand_
#define nn_pop_if_equal20_22(...) metamacro_expand_
#define nn_pop_if_equal20_23(...) metamacro_expand_
#define nn_pop_if_equal20_24(...) metamacro_expand_
#define nn_pop_if_equal20_25(...) metamacro_expand_
#define nn_pop_if_equal20_26(...) metamacro_expand_
#define nn_pop_if_equal20_27(...) metamacro_expand_
#define nn_pop_if_equal20_28(...) metamacro_expand_
#define nn_pop_if_equal20_29(...) metamacro_expand_
#define nn_pop_if_equal20_30(...) metamacro_expand_
#define nn_pop_if_equal20_31(...) metamacro_expand_
#define nn_pop_if_equal20_32(...) metamacro_expand_
#define nn_pop_if_equal20_33(...) metamacro_expand_
#define nn_pop_if_equal20_34(...) metamacro_expand_
#define nn_pop_if_equal20_35(...) metamacro_expand_
#define nn_pop_if_equal20_36(...) metamacro_expand_
#define nn_pop_if_equal20_37(...) metamacro_expand_
#define nn_pop_if_equal20_38(...) metamacro_expand_
#define nn_pop_if_equal20_39(...) metamacro_expand_
#define nn_pop_if_equal20_40(...) metamacro_expand_

#define nn_pop_if_equal0(VALUE) nn_pop_if_equal1(nn_pop_inc(VALUE))
#define nn_pop_if_equal1(VALUE) nn_pop_if_equal2(nn_pop_inc(VALUE))
#define nn_pop_if_equal2(VALUE) nn_pop_if_equal3(nn_pop_inc(VALUE))
#define nn_pop_if_equal3(VALUE) nn_pop_if_equal4(nn_pop_inc(VALUE))
#define nn_pop_if_equal4(VALUE) nn_pop_if_equal5(nn_pop_inc(VALUE))
#define nn_pop_if_equal5(VALUE) nn_pop_if_equal6(nn_pop_inc(VALUE))
#define nn_pop_if_equal6(VALUE) nn_pop_if_equal7(nn_pop_inc(VALUE))
#define nn_pop_if_equal7(VALUE) nn_pop_if_equal8(nn_pop_inc(VALUE))
#define nn_pop_if_equal8(VALUE) nn_pop_if_equal9(nn_pop_inc(VALUE))
#define nn_pop_if_equal9(VALUE) nn_pop_if_equal10(nn_pop_inc(VALUE))
#define nn_pop_if_equal10(VALUE) nn_pop_if_equal11(nn_pop_inc(VALUE))
#define nn_pop_if_equal11(VALUE) nn_pop_if_equal12(nn_pop_inc(VALUE))
#define nn_pop_if_equal12(VALUE) nn_pop_if_equal13(nn_pop_inc(VALUE))
#define nn_pop_if_equal13(VALUE) nn_pop_if_equal14(nn_pop_inc(VALUE))
#define nn_pop_if_equal14(VALUE) nn_pop_if_equal15(nn_pop_inc(VALUE))
#define nn_pop_if_equal15(VALUE) nn_pop_if_equal16(nn_pop_inc(VALUE))
#define nn_pop_if_equal16(VALUE) nn_pop_if_equal17(nn_pop_inc(VALUE))
#define nn_pop_if_equal17(VALUE) nn_pop_if_equal18(nn_pop_inc(VALUE))
#define nn_pop_if_equal18(VALUE) nn_pop_if_equal19(nn_pop_inc(VALUE))
#define nn_pop_if_equal19(VALUE) nn_pop_if_equal20(nn_pop_inc(VALUE))


// nn_pop_if_greater expansions
#define nn_pop_if_greater20(VALUE) \
    metamacro_concat(nn_pop_if_greater20_, VALUE)

#define nn_pop_if_greater20_0(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_1(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_2(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_3(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_4(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_5(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_6(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_7(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_8(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_9(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_10(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_11(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_12(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_13(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_14(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_15(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_16(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_17(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_18(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_19(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater20_20(...) metamacro_expand_
#define nn_pop_if_greater20_21(...) metamacro_expand_
#define nn_pop_if_greater20_22(...) metamacro_expand_
#define nn_pop_if_greater20_23(...) metamacro_expand_
#define nn_pop_if_greater20_24(...) metamacro_expand_
#define nn_pop_if_greater20_25(...) metamacro_expand_
#define nn_pop_if_greater20_26(...) metamacro_expand_
#define nn_pop_if_greater20_27(...) metamacro_expand_
#define nn_pop_if_greater20_28(...) metamacro_expand_
#define nn_pop_if_greater20_29(...) metamacro_expand_
#define nn_pop_if_greater20_30(...) metamacro_expand_
#define nn_pop_if_greater20_31(...) metamacro_expand_
#define nn_pop_if_greater20_32(...) metamacro_expand_
#define nn_pop_if_greater20_33(...) metamacro_expand_
#define nn_pop_if_greater20_34(...) metamacro_expand_
#define nn_pop_if_greater20_35(...) metamacro_expand_
#define nn_pop_if_greater20_36(...) metamacro_expand_
#define nn_pop_if_greater20_37(...) metamacro_expand_
#define nn_pop_if_greater20_38(...) metamacro_expand_
#define nn_pop_if_greater20_39(...) metamacro_expand_
#define nn_pop_if_greater20_40(...) metamacro_expand_

#define nn_pop_if_greater0(VALUE) nn_pop_if_greater1(nn_pop_inc(VALUE))
#define nn_pop_if_greater1(VALUE) nn_pop_if_greater2(nn_pop_inc(VALUE))
#define nn_pop_if_greater2(VALUE) nn_pop_if_greater3(nn_pop_inc(VALUE))
#define nn_pop_if_greater3(VALUE) nn_pop_if_greater4(nn_pop_inc(VALUE))
#define nn_pop_if_greater4(VALUE) nn_pop_if_greater5(nn_pop_inc(VALUE))
#define nn_pop_if_greater5(VALUE) nn_pop_if_greater6(nn_pop_inc(VALUE))
#define nn_pop_if_greater6(VALUE) nn_pop_if_greater7(nn_pop_inc(VALUE))
#define nn_pop_if_greater7(VALUE) nn_pop_if_greater8(nn_pop_inc(VALUE))
#define nn_pop_if_greater8(VALUE) nn_pop_if_greater9(nn_pop_inc(VALUE))
#define nn_pop_if_greater9(VALUE) nn_pop_if_greater10(nn_pop_inc(VALUE))
#define nn_pop_if_greater10(VALUE) nn_pop_if_greater11(nn_pop_inc(VALUE))
#define nn_pop_if_greater11(VALUE) nn_pop_if_greater12(nn_pop_inc(VALUE))
#define nn_pop_if_greater12(VALUE) nn_pop_if_greater13(nn_pop_inc(VALUE))
#define nn_pop_if_greater13(VALUE) nn_pop_if_greater14(nn_pop_inc(VALUE))
#define nn_pop_if_greater14(VALUE) nn_pop_if_greater15(nn_pop_inc(VALUE))
#define nn_pop_if_greater15(VALUE) nn_pop_if_greater16(nn_pop_inc(VALUE))
#define nn_pop_if_greater16(VALUE) nn_pop_if_greater17(nn_pop_inc(VALUE))
#define nn_pop_if_greater17(VALUE) nn_pop_if_greater18(nn_pop_inc(VALUE))
#define nn_pop_if_greater18(VALUE) nn_pop_if_greater19(nn_pop_inc(VALUE))
#define nn_pop_if_greater19(VALUE) nn_pop_if_greater20(nn_pop_inc(VALUE))


// nn_pop_if_greater_or_equal expansions
#define nn_pop_if_greater_or_equal20(VALUE) \
    metamacro_concat(nn_pop_if_greater_or_equal20_, VALUE)

#define nn_pop_if_greater_or_equal20_0(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_1(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_2(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_3(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_4(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_5(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_6(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_7(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_8(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_9(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_10(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_11(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_12(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_13(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_14(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_15(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_16(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_17(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_18(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_19(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_20(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_greater_or_equal20_21(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_22(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_23(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_24(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_25(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_26(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_27(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_28(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_29(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_30(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_31(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_32(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_33(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_34(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_35(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_36(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_37(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_38(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_39(...) metamacro_expand_
#define nn_pop_if_greater_or_equal20_40(...) metamacro_expand_

#define nn_pop_if_greater_or_equal0(VALUE) nn_pop_if_greater_or_equal1(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal1(VALUE) nn_pop_if_greater_or_equal2(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal2(VALUE) nn_pop_if_greater_or_equal3(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal3(VALUE) nn_pop_if_greater_or_equal4(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal4(VALUE) nn_pop_if_greater_or_equal5(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal5(VALUE) nn_pop_if_greater_or_equal6(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal6(VALUE) nn_pop_if_greater_or_equal7(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal7(VALUE) nn_pop_if_greater_or_equal8(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal8(VALUE) nn_pop_if_greater_or_equal9(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal9(VALUE) nn_pop_if_greater_or_equal10(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal10(VALUE) nn_pop_if_greater_or_equal11(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal11(VALUE) nn_pop_if_greater_or_equal12(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal12(VALUE) nn_pop_if_greater_or_equal13(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal13(VALUE) nn_pop_if_greater_or_equal14(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal14(VALUE) nn_pop_if_greater_or_equal15(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal15(VALUE) nn_pop_if_greater_or_equal16(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal16(VALUE) nn_pop_if_greater_or_equal17(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal17(VALUE) nn_pop_if_greater_or_equal18(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal18(VALUE) nn_pop_if_greater_or_equal19(nn_pop_inc(VALUE))
#define nn_pop_if_greater_or_equal19(VALUE) nn_pop_if_greater_or_equal20(nn_pop_inc(VALUE))


// nn_pop_if_less expansions
#define nn_pop_if_less20(VALUE) \
    metamacro_concat(nn_pop_if_less20_, VALUE)

#define nn_pop_if_less20_0(...) metamacro_expand_
#define nn_pop_if_less20_1(...) metamacro_expand_
#define nn_pop_if_less20_2(...) metamacro_expand_
#define nn_pop_if_less20_3(...) metamacro_expand_
#define nn_pop_if_less20_4(...) metamacro_expand_
#define nn_pop_if_less20_5(...) metamacro_expand_
#define nn_pop_if_less20_6(...) metamacro_expand_
#define nn_pop_if_less20_7(...) metamacro_expand_
#define nn_pop_if_less20_8(...) metamacro_expand_
#define nn_pop_if_less20_9(...) metamacro_expand_
#define nn_pop_if_less20_10(...) metamacro_expand_
#define nn_pop_if_less20_11(...) metamacro_expand_
#define nn_pop_if_less20_12(...) metamacro_expand_
#define nn_pop_if_less20_13(...) metamacro_expand_
#define nn_pop_if_less20_14(...) metamacro_expand_
#define nn_pop_if_less20_15(...) metamacro_expand_
#define nn_pop_if_less20_16(...) metamacro_expand_
#define nn_pop_if_less20_17(...) metamacro_expand_
#define nn_pop_if_less20_18(...) metamacro_expand_
#define nn_pop_if_less20_19(...) metamacro_expand_
#define nn_pop_if_less20_20(...) metamacro_expand_
#define nn_pop_if_less20_21(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_22(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_23(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_24(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_25(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_26(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_27(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_28(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_29(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_30(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_31(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_32(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_33(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_34(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_35(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_36(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_37(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_38(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_39(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less20_40(...) __VA_ARGS__ metamacro_consume_

#define nn_pop_if_less0(VALUE) nn_pop_if_less1(nn_pop_inc(VALUE))
#define nn_pop_if_less1(VALUE) nn_pop_if_less2(nn_pop_inc(VALUE))
#define nn_pop_if_less2(VALUE) nn_pop_if_less3(nn_pop_inc(VALUE))
#define nn_pop_if_less3(VALUE) nn_pop_if_less4(nn_pop_inc(VALUE))
#define nn_pop_if_less4(VALUE) nn_pop_if_less5(nn_pop_inc(VALUE))
#define nn_pop_if_less5(VALUE) nn_pop_if_less6(nn_pop_inc(VALUE))
#define nn_pop_if_less6(VALUE) nn_pop_if_less7(nn_pop_inc(VALUE))
#define nn_pop_if_less7(VALUE) nn_pop_if_less8(nn_pop_inc(VALUE))
#define nn_pop_if_less8(VALUE) nn_pop_if_less9(nn_pop_inc(VALUE))
#define nn_pop_if_less9(VALUE) nn_pop_if_less10(nn_pop_inc(VALUE))
#define nn_pop_if_less10(VALUE) nn_pop_if_less11(nn_pop_inc(VALUE))
#define nn_pop_if_less11(VALUE) nn_pop_if_less12(nn_pop_inc(VALUE))
#define nn_pop_if_less12(VALUE) nn_pop_if_less13(nn_pop_inc(VALUE))
#define nn_pop_if_less13(VALUE) nn_pop_if_less14(nn_pop_inc(VALUE))
#define nn_pop_if_less14(VALUE) nn_pop_if_less15(nn_pop_inc(VALUE))
#define nn_pop_if_less15(VALUE) nn_pop_if_less16(nn_pop_inc(VALUE))
#define nn_pop_if_less16(VALUE) nn_pop_if_less17(nn_pop_inc(VALUE))
#define nn_pop_if_less17(VALUE) nn_pop_if_less18(nn_pop_inc(VALUE))
#define nn_pop_if_less18(VALUE) nn_pop_if_less19(nn_pop_inc(VALUE))
#define nn_pop_if_less19(VALUE) nn_pop_if_less20(nn_pop_inc(VALUE))


// nn_pop_if_less_or_equal expansions
#define nn_pop_if_less_or_equal20(VALUE) \
    metamacro_concat(nn_pop_if_less_or_equal20_, VALUE)

#define nn_pop_if_less_or_equal20_0(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_1(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_2(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_3(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_4(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_5(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_6(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_7(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_8(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_9(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_10(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_11(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_12(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_13(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_14(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_15(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_16(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_17(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_18(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_19(...) metamacro_expand_
#define nn_pop_if_less_or_equal20_20(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_21(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_22(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_23(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_24(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_25(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_26(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_27(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_28(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_29(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_30(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_31(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_32(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_33(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_34(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_35(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_36(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_37(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_38(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_39(...) __VA_ARGS__ metamacro_consume_
#define nn_pop_if_less_or_equal20_40(...) __VA_ARGS__ metamacro_consume_

#define nn_pop_if_less_or_equal0(VALUE) nn_pop_if_less_or_equal1(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal1(VALUE) nn_pop_if_less_or_equal2(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal2(VALUE) nn_pop_if_less_or_equal3(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal3(VALUE) nn_pop_if_less_or_equal4(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal4(VALUE) nn_pop_if_less_or_equal5(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal5(VALUE) nn_pop_if_less_or_equal6(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal6(VALUE) nn_pop_if_less_or_equal7(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal7(VALUE) nn_pop_if_less_or_equal8(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal8(VALUE) nn_pop_if_less_or_equal9(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal9(VALUE) nn_pop_if_less_or_equal10(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal10(VALUE) nn_pop_if_less_or_equal11(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal11(VALUE) nn_pop_if_less_or_equal12(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal12(VALUE) nn_pop_if_less_or_equal13(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal13(VALUE) nn_pop_if_less_or_equal14(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal14(VALUE) nn_pop_if_less_or_equal15(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal15(VALUE) nn_pop_if_less_or_equal16(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal16(VALUE) nn_pop_if_less_or_equal17(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal17(VALUE) nn_pop_if_less_or_equal18(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal18(VALUE) nn_pop_if_less_or_equal19(nn_pop_inc(VALUE))
#define nn_pop_if_less_or_equal19(VALUE) nn_pop_if_less_or_equal20(nn_pop_inc(VALUE))


// nn_pop_at expansions
#define nn_pop_at0(...) metamacro_head(__VA_ARGS__)
#define nn_pop_at1(_0, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at2(_0, _1, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at3(_0, _1, _2, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at4(_0, _1, _2, _3, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at5(_0, _1, _2, _3, _4, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at6(_0, _1, _2, _3, _4, _5, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at7(_0, _1, _2, _3, _4, _5, _6, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at8(_0, _1, _2, _3, _4, _5, _6, _7, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at9(_0, _1, _2, _3, _4, _5, _6, _7, _8, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at10(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at11(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at12(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at13(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at14(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at15(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at16(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at17(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at18(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at19(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at20(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at21(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at22(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at23(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at24(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at25(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at26(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at27(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at28(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at29(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at30(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, _29, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at31(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, _29, _30, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at32(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, _29, _30, _31, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at33(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, _29, _30, _31, _32, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at34(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, _29, _30, _31, _32, _33, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at35(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, _29, _30, _31, _32, _33, _34, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at36(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, _29, _30, _31, _32, _33, _34, _35, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at37(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, _29, _30, _31, _32, _33, _34, _35, _36, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at38(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, _29, _30, _31, _32, _33, _34, _35, _36, _37, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at39(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, _29, _30, _31, _32, _33, _34, _35, _36, _37, _38, ...) metamacro_head(__VA_ARGS__)
#define nn_pop_at40(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, _29, _30, _31, _32, _33, _34, _35, _36, _37, _38, _39, ...) metamacro_head(__VA_ARGS__)


// nn_pop_args_concat_ expansions
#define nn_pop_args_concat_0(SEP)
#define nn_pop_args_concat_1(SEP, _0) metamacro_concat(_0, )

#define nn_pop_args_concat_2(SEP, _0, _1) \
        metamacro_concat( \
        nn_pop_args_concat_1(SEP, _0), \
        metamacro_concat(SEP, _1) \
        )
#define nn_pop_args_concat_3(SEP, _0, _1, _2) \
        metamacro_concat( \
        nn_pop_args_concat_2(SEP, _0, _1), \
        metamacro_concat(SEP, _2) \
        )
#define nn_pop_args_concat_4(SEP, _0, _1, _2, _3) \
        metamacro_concat( \
        nn_pop_args_concat_3(SEP, _0, _1, _2), \
        metamacro_concat(SEP, _3) \
        )
#define nn_pop_args_concat_5(SEP, _0, _1, _2, _3, _4) \
        metamacro_concat( \
        nn_pop_args_concat_4(SEP, _0, _1, _2, _3), \
        metamacro_concat(SEP, _4) \
        )
#define nn_pop_args_concat_6(SEP, _0, _1, _2, _3, _4, _5) \
        metamacro_concat( \
        nn_pop_args_concat_5(SEP, _0, _1, _2, _3, _4), \
        metamacro_concat(SEP, _5) \
        )
#define nn_pop_args_concat_7(SEP, _0, _1, _2, _3, _4, _5, _6) \
        metamacro_concat( \
        nn_pop_args_concat_6(SEP, _0, _1, _2, _3, _4, _5), \
        metamacro_concat(SEP, _6) \
        )
#define nn_pop_args_concat_8(SEP, _0, _1, _2, _3, _4, _5, _6, _7) \
        metamacro_concat( \
        nn_pop_args_concat_7(SEP, _0, _1, _2, _3, _4, _5, _6), \
        metamacro_concat(SEP, _7) \
        )
#define nn_pop_args_concat_9(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8) \
        metamacro_concat( \
        nn_pop_args_concat_8(SEP, _0, _1, _2, _3, _4, _5, _6, _7), \
        metamacro_concat(SEP, _8) \
        )
#define nn_pop_args_concat_10(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9) \
        metamacro_concat( \
        nn_pop_args_concat_9(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8), \
        metamacro_concat(SEP, _9) \
        )
#define nn_pop_args_concat_11(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10) \
        metamacro_concat( \
        nn_pop_args_concat_10(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9), \
        metamacro_concat(SEP, _10) \
        )
#define nn_pop_args_concat_12(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11) \
        metamacro_concat( \
        nn_pop_args_concat_11(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10), \
        metamacro_concat(SEP, _11) \
        )
#define nn_pop_args_concat_13(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12) \
        metamacro_concat( \
        nn_pop_args_concat_12(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11), \
        metamacro_concat(SEP, _12) \
        )
#define nn_pop_args_concat_14(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13) \
        metamacro_concat( \
        nn_pop_args_concat_13(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12), \
        metamacro_concat(SEP, _13) \
        )
#define nn_pop_args_concat_15(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14) \
        metamacro_concat( \
        nn_pop_args_concat_14(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13), \
        metamacro_concat(SEP, _14) \
        )
#define nn_pop_args_concat_16(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15) \
        metamacro_concat( \
        nn_pop_args_concat_15(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14), \
        metamacro_concat(SEP, _15) \
        )
#define nn_pop_args_concat_17(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16) \
        metamacro_concat( \
        nn_pop_args_concat_16(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15), \
        metamacro_concat(SEP, _16) \
        )
#define nn_pop_args_concat_18(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17) \
        metamacro_concat( \
        nn_pop_args_concat_17(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16), \
        metamacro_concat(SEP, _17) \
        )
#define nn_pop_args_concat_19(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18) \
        metamacro_concat( \
        nn_pop_args_concat_18(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17), \
        metamacro_concat(SEP, _18) \
        )
#define nn_pop_args_concat_20(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19) \
        metamacro_concat( \
        nn_pop_args_concat_19(SEP, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18), \
        metamacro_concat(SEP, _19) \
        )


#endif /* NNPopObjcMacros_h */
