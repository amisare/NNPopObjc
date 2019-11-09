# NNPopObjc usage

This document is a guide for NNPopObjc (version 0.2.x) .

## @nn_extension (Protocol Extensions)


### Parameters

The parameters of `nn_extension` include two parts, protocol and variable parameter. The protocol is required and the variable parameter is optional. The variable parameter can also be divided into two parts, @nn_where and confrom protocol list.

```
@nn_extension(protocol, @nn_where(...), confrom_protocol_0, confrom_protocol_1, ..., confrom_protocol_n)
```

 * `protocol`: A protocol is extended.
 * `@nn_where`: A where clause for protocol extension, it is used to add constraints to the conforming classes.
 * `confrom_protocols`: A class that adopt protocol extension must confrom to all the protocols in this list.

### Examples

#### A complete protocol extension

```
@nn_extension(protocol, @nn_where(...), confrom_protocol_a, confrom_protocol_b, ...)
```


#### An omitted confrom_protocols extension

```
@nn_extension(protocol, @nn_where(...))
```

#### An omitted where clause and confrom protocol list extension

```
@nn_extension(protocol)
```

### Discussion

The key word `nn_extension` is just a macro, using the `nn_extension` macro, it will declare and implement a class as the procotol `extension`, so you can only use `nn_extension` in `.m` file.

## @nn_where (Where Clause for Protocol Extension)

### Parameters

@nn_where provids where clause for Extension, the clause's variable parameter can pass up to two parameters.

 * `unique_id`: An unique id for where clause, When implementing multiple extensions for a protocol, the unique_id is used to differentiate extensions. The unique_id will be concat into the name of the extension struct variable in section, function and extension class.
 * `expression`: An expression that returns a bool value. You can use a variable named `self` in expression, the variable is the class that adopt to the extended protocol.


### Examples

#### A complete where clause

```
@nn_where(unique_id, expression)
```

#### An omitted unique_id where clause

```
@nn_where(expression)
```
it is equivalent to @nn_where(_, expression)

#### An omitted unique_id and expression where clause

```
@nn_where()
```
it is equivalent to @nn_where(_, nn_where_block_default_)


## Protocol Extensions


### Providing Default Implementations

You can use protocol extensions to provide a default implementation to any method or computed property requirement of that protocol. If a conforming type provides its own implementation of a required method or property, that implementation will be used instead of the one provided by the extension.

### Adding Constraints to Protocol Extensions

When you define a protocol extension, you can specify constraints that conforming types must satisfy before the methods and properties of the extension are available. You write these constraints after the name of the protocol you’re extending by writing a where clause.
