# NNPopObjc 的使用

本文档是 NNPopObjc 的使用指南(在 0.1.0 以上不再适用)。

## @nn_extension

在 NNPopObjc 中，`nn_extension` 有两个参数。第一个参数是要扩展的 `procotol`，第二个参数是 `procotol` 实现所要继承的类。
关键字 `nn_extension` 只是一个宏，使用 `nn_extension` 将声明并实现一个类作为 `procotol` 扩展名，因此 `nn_extension` 只能在 `.m` 文件中使用，其定义如下 ：

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

这是一个使用 `nn_extension` 扩展 procotol 的示例：

声明一个名为 "NNDemoProcotol" 的 procotol：

```
@protocol NNDemoProtocol <NSObject>

@optional
- (void)sayHelloPop;

@end
```

使用 `nn_extension` 扩展 procotol：

```
@nn_extension(NNDemoProtocol, NSObject)

- (void)sayHelloPop {
    DLog(@"-[%@ %s] say hello pop", [self class], sel_getName(_cmd));
}

@end
```

将宏展开以后：

```
@interface __NNPopObjc_NNDemoProtocol_NSObject : NSObject <NNDemoProtocol>

@end

@implementation __NNPopObjc_NNDemoProtocol_NSObject

- (void)sayHelloPop {
    DLog(@"-[%@ %s] say hello pop", [self class], sel_getName(_cmd));
}

@end
```

## Protocol 扩展

### 提供默认实现

当 `nn_extension` 的第二个参数是 `NSObject` 时，那么它将作为当前 `protocol` 的默认扩展，遵守该 `protocol` 的所有类都将它用作默认的 `protocol` 扩展实现，例如：

```
@nn_extension(NNDemoProtocol, NSObject)

- (void)sayHelloPop {
    DLog(@"-[%@ %s] say hello pop", [self class], sel_getName(_cmd));
}

@end
```

所有符合条件的类都会自动获得此方法的实现，而无需进行任何其他修改。

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

### 向 Protocol 扩展添加类约束

将类约束写在 `nn_extension` 的第二个参数中。 例如，定义一个 NNDemoProtocol 协议的扩展，该扩展适用于继承自 NNDemoClassAA 的所有子类。

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

考虑 NNDemoProtocol 扩展的 NNDemoClassAA 的类约束，以及 NNDemoClassA ，NNDemoClassAA ， NNDemoClassAAA ，NNDemoClassAAB 之间的继承关系。

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















