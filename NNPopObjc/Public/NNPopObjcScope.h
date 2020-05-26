//
//  NNPopObjcScope.h
//  NNPopObjc
//
//  Created by GuHaijun on 2019/12/5.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#ifndef NNPopObjcScope_h
#define NNPopObjcScope_h

/**
 * external scope
 */
#define nn_pop_exscope(VAR) \
		nn_pop_scope_keywordify \
		__typeof__(VAR) nn_pop_metamacro_concat(VAR, _scope_) = (VAR);

/**
 * internal scope
 */
#define nn_pop_inscope(TYPE, VAR) \
		nn_pop_scope_keywordify \
		_Pragma("clang diagnostic push") \
		_Pragma("clang diagnostic ignored \"-Wshadow\"") \
		TYPE VAR = (TYPE)nn_pop_metamacro_concat(VAR, _scope_); \
		_Pragma("clang diagnostic pop")
		
/**
* Inspired by libextobjc: https://github.com/jspahrsummers/libextobjc
*/
#if defined(DEBUG) && !defined(NDEBUG)
#define nn_pop_scope_keywordify autoreleasepool {}
#else
#define nn_pop_scope_keywordify try {} @catch (...) {}
#endif

#endif /* NNPopObjcScope_h */
