# NNPopObjc 的使用

本文档是 NNPopObjc 的使用指南 (0.2.x 版本) 。

## @nn_extension (协议扩展)


### 参数

`nn_extension` 参数分为两部分： protocol 参数和可变参数。 protocol 参数为必须参数，可变参数为可选参数。
可变参数部分同样分为两部分：@nn_where 分句和符合协议列表。

```
@nn_extension(protocol, @nn_where(...), confrom_protocol_0, confrom_protocol_1, ..., confrom_protocol_n)
```

 * `protocol`: 被扩展的协议
 * `@nn_where`: 协议扩展的 where 分句，用于增加对遵守协议类的约束。
 * `confrom_protocols`: 遵守该扩展协议的类，必须要遵守此列表总的所有协议。

### 示例

#### 一个完整参数的协议扩展

```
@nn_extension(protocol, @nn_where(...), confrom_protocol_a, confrom_protocol_b, ...)
```


#### 省略 confrom_protocols 参数的协议扩展

```
@nn_extension(protocol, @nn_where(...))
```

#### 省略 where 分句 和 confrom_protocols 参数的协议扩展

```
@nn_extension(protocol)
```

### 讨论

关键字 `nn_extension` 只是一个宏，使用 `nn_extension` 将声明并实现一个类作为 `procotol` 扩展名，因此 `nn_extension` 只能在 `.m` 文件中使用。

## @nn_where (用于协议扩展的 where 分句)

### 参数


@nn_where 为协议扩展提供 where 分句，分句的可变参数最多可接受两个参数。

 * `unique_id`: 一个 where 分句的唯一标示符，当为一个协议实现多个扩展时，`unique_id` 参数用来区分这些扩展。`unique_id` 会被拼接到扩展中变量，函数，以及类的命名当中。
 * `expression`: 一个返回布尔值的表达式。表达式中可以引用一个名为 `self` 的变量，该变量即为遵守扩展协议类的类对象。


### 实例

#### 一个完整参数的 where 分句

```
@nn_where(unique_id, expression)
```

#### 省略 unique_id 参数的 where 分句

```
@nn_where(expression)
```
等价于 @nn_where(_, expression)

#### 省略 unique_id 和 expression 参数的 where 分句

```
@nn_where()
```
等价于 @nn_where(_, nn_where_block_default_)


## 协议扩展


### 提供默认实现

你可以使用协议扩展为该协议提供任意默认实现或计算属性。如果符合扩展的类提供了自己的所需方法或属性的实现，则将使用该实现而不是扩展提供的实现。

### 为协议扩展增加约束

定义协议扩展时，可以指定符合扩展的类必须符合的特定的约束。可以通过在要扩展的协议名称后编写 where 分句实现这些约束。
