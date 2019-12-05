//
//  NNPopObjc.h
//  NNPopObjc
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for NNPopObjc.
FOUNDATION_EXPORT double NNPopObjcVersionNumber;

//! Project version string for NNPopObjc.
FOUNDATION_EXPORT const unsigned char NNPopObjcVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <NNPopObjc/PublicHeader.h>

#if __has_include(<NNPopObjc/NNPopObjc.h>)
#import <NNPopObjc/NNPopObjcMetaMacros.h>
#import <NNPopObjc/NNPopObjcMacros.h>
#import <NNPopObjc/NNPopObjcDefines.h>
#import <NNPopObjc/NNPopObjcWhere.h>
#import <NNPopObjc/NNPopObjcDescription.h>
#import <NNPopObjc/NNPopObjcExtension.h>
#import <NNPopObjc/NNPopObjcScope.h>
#else
#import "NNPopObjcMetaMacros.h"
#import "NNPopObjcMacros.h"
#import "NNPopObjcDefines.h"
#import "NNPopObjcWhere.h"
#import "NNPopObjcDescription.h"
#import "NNPopObjcExtension.h"
#import "NNPopObjcScope.h"
#endif

/**
 * Protocol Extensions
 *
 * Protocols can be extended to provide method, and computed property implementations to
 * conforming types. This allows you to define behavior on protocols themselves, rather
 * than in each type’s individual conformance.
 *
 * The parameters of nn_extension include two parts, protocol and variable parameter.
 * The protocol is required and the variable parameter is optional.
 * The variable parameter can also be divided into two parts, @nn_where and confrom protocol list.
 *
 * A complete protocol extension:
 * @nn_extension(protocol, @nn_where(...), confrom_protocol_0, confrom_protocol_1, ..., confrom_protocol_n)
 *
 * An omitted confrom_protocols extension:
 * @nn_extension(protocol, @nn_where(...))
 *
 * An omitted where clause and confrom protocol list extension:
 * @nn_extension(protocol)
 *
 * @param protocol A protocol.
 * @param @nn_where A where clause for protocol extension, it is used to add constraints to the
 * conforming classes.
 * @param confrom_protocols... A class that adopt protocol extension must confrom to all the protocols in this list.
 *
 * @note
 *
 * 1. Providing Default Implementations
 * You can use protocol extensions to provide a default implementation to any method or
 * computed property requirement of that protocol. If a conforming type provides its own
 * implementation of a required method or property, that implementation will be used instead
 * of the one provided by the extension.
 *
 * 2. Adding Constraints to Protocol Extensions
 * When you define a protocol extension, you can specify constraints that conforming types
 * must satisfy before the methods and properties of the extension are available. You write
 * these constraints after the name of the protocol you’re extending by writing a where clause.
 *
 */
#define nn_extension(protocol, ...)     nn_pop_extension_(protocol, __VA_ARGS__)

/**
 * Where Clause for Protocol Extension
 *
 * This provids where clause for Extension, the clause's variable parameter can pass up to
 * two parameters.
 *
 * A complete where clause:
 * @nn_where(unique_id, expression)
 *
 * An omitted unique_id where clause:
 * @nn_where(expression)
 * it is equivalent to @nn_where(_, expression)
 *
 * An omitted unique_id and expression where clause:
 * @nn_where()
 * it is equivalent to @nn_where(_, nn_where_block_default_)
 *
 * @param unique_id An unique id for where clause, When implementing multiple extensions
 * for a protocol, the unique_id is used to differentiate extensions. The unique_id will
 * be concat into the name of the extension struct variable in section, function and extension
 * class.
 * @param expression An expression that returns a bool value. You can use a variable named
 * `self` in expression, the variable is the class that adopt to the extended protocol.
 *
 * @code
 
    // 0. Example of @nn_where(unique_id, expression)
    @nn_extension(NNHelloWorld, @nn_where(id_english, self == [NNEnglish class]))
    ...
    @end

    // 1. Example of @nn_where(expression)
    @nn_extension(NNHelloWorld, @nn_where(self == [NNEnglish class]))
    ...
    @end

    // 2. Example of @nn_where()
    @nn_extension(NNHelloWorld, @nn_where())
    ...
    @end
 
 * @endcode
 *
 */
#define nn_where(...)                   nn_pop_where_(__VA_ARGS__)

/**
 * Simplify the type cast
 *
 * @discussion  The type of \c self is lost in the implementation of protocol extension
 *
 * @code
 
	A *a = [A new];
	@nn_exscope(a) {
		@nn_inscope(B *, a)
		a.var = @"var";
		...
	}
 
 * @endcode
 */
#define nn_exscope(VAR)					nn_pop_exscope(VAR)
#define nn_inscope(TYPE, VAR)			nn_pop_inscope(TYPE, VAR)
