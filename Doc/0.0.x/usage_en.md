# NNPopObjc usage

This document is a guide for NNPopObjc (version 0.0.x) .

## @nn_extension

In NNPopObjc, `nn_extension` has two parameters. The frist parameter is protocol to be extended, the second parameter is the class that the `extension` inherits.
The key word `nn_extension` is just a macro, using the `nn_extension` macro, it will declare and implement a class as the procotol `extension`, so you can only use it in `.m` file, it is defined as follow:

```
#define nn_extension(protocol, clazz) \
\
interface __NNPopObjc##_##protocol##_##clazz : clazz <protocol> \
\
@end \
\
@implementation __NNPopObjc##_##protocol##_##clazz \
\
```

This is an example of using `nn_extension` to extend a procotol:

Declare a protocol named "NNDemoProcotol":

```
@protocol NNDemoProtocol <NSObject>

@optional
- (void)sayHelloPop;

@end
```

Use the `nn_extension` to extend procotol:

```
@nn_extension(NNDemoProtocol, NSObject)

- (void)sayHelloPop {
    DLog(@"-[%@ %s] say hello pop", [self class], sel_getName(_cmd));
}

@end
```

The following is the content after the macro is expanded：

```
@interface __NNPopObjc_NNDemoProtocol_NSObject : NSObject <NNDemoProtocol>

@end

@implementation __NNPopObjc_NNDemoProtocol_NSObject

- (void)sayHelloPop {
    DLog(@"-[%@ %s] say hello pop", [self class], sel_getName(_cmd));
}

@end
```

## Protocol Extensions

### Providing Default Implementations

When the second parameter of `nn_extension` is `NSObject`, it is the default extension of the current protocol. All classes that adapting the protocol will use it as the default procotol extention implementation, for example:

```
@nn_extension(NNDemoProtocol, NSObject)

- (void)sayHelloPop {
    DLog(@"-[%@ %s] say hello pop", [self class], sel_getName(_cmd));
}

@end
```

All conforming classes automatically gain this method implementation without any additional modification.

```
@interface NNDemoClassA: NSObject <NNDemoProtocol> @end
@interface NNDemoClassAA: NNDemoClassA <NNDemoProtocol> @end
@interface NNDemoClassB: NSObject <NNDemoProtocol> @end

[[NNDemoClassA new] sayHelloPop];
[[NNDemoClassAA new] sayHelloPop];
[[NNDemoClassB new] sayHelloPop];

//Prints "-[NNDemoClassA sayHelloPop] say hello pop"
//Prints "-[NNDemoClassAA sayHelloPop] say hello pop"
//Prints "-[NNDemoClassB sayHelloPop] say hello pop"
```

### Adding Class Constraints to Protocol Extensions

Write the class constraints in the second parameter of `nn_extension`. For example, you can define an extension to the NNDemoProtocol protocol that applies to any class whose inherited from from NNDemoClassAA.

```
@nn_extension(NNDemoProtocol, NSObject)

- (void)sayHelloPop {
    DLog(@"-[%@ %s] say hello pop", [self class], sel_getName(_cmd));
}

@end

@nn_extension(NNDemoProtocol, NNDemoClassAA)

- (void)sayHelloPop {
    DLog(@"-[%@ %s] ClassAA say hello pop", [self class], sel_getName(_cmd));
}

@end
```

Consider the NNDemoClassAA class constraint to NNDemoProtocol procotol extentsion, and  the inheritance relationship between NNDemoClassA, NNDemoClassAA, NNDemoClassAAA, NNDemoClassAAB.

```
@interface NNDemoClassA: NSObject <NNDemoProtocol> @end
@interface NNDemoClassAA: NNDemoClassA <NNDemoProtocol> @end
@interface NNDemoClassAAA: NNDemoClassAA <NNDemoProtocol> @end
@interface NNDemoClassAAB: NNDemoClassAA <NNDemoProtocol> @end
@interface NNDemoClassB: NSObject <NNDemoProtocol> @end

[[NNDemoClassA new] sayHelloPop];
[[NNDemoClassAA new] sayHelloPop];
[[NNDemoClassAAA new] sayHelloPop];
[[NNDemoClassAAB new] sayHelloPop];
[[NNDemoClassB new] sayHelloPop];

//Prints "-[NNDemoClassA sayHelloPop] say hello pop"
//Prints "-[NNDemoClassAA sayHelloPop] ClassAA say hello pop"
//Prints "-[NNDemoClassAAA sayHelloPop] ClassAA say hello pop"
//Prints "-[NNDemoClassAAB sayHelloPop] ClassAA say hello pop"
//Prints "-[NNDemoClassB sayHelloPop] say hello pop"
```















