<h1 align = "center">NNPopObjc</h1>

[![GitHub release](https://img.shields.io/github/release/amisare/NNPopObjc.svg)](https://github.com/amisare/NNPopObjc/releases)
[![CocoaPods](https://img.shields.io/cocoapods/v/NNPopObjc.svg)](https://cocoapods.org/pods/NNPopObjc)
[![CocoaPods](https://img.shields.io/cocoapods/p/NNPopObjc.svg)](https://cocoapods.org/pods/NNPopObjc)
[![GitHub license](https://img.shields.io/github/license/amisare/NNPopObjc.svg)](https://github.com/amisare/NNPopObjc/blob/master/LICENSE)

## 介绍

使用 runtime 实现 procotol 扩展，达到 Objective-C 面向协议的编程（ POP ，Protocol Oriented Programming ）。

## 使用

### 声明协议

- 声明协议

```
@protocol NNDemoProtocol <NSObject>

@optional
@property (nonatomic, strong) NSString* whoImI;
- (void)sayHelloPop;
+ (void)sayHelloPop;

@end

```

- 扩展协议

```
@nn_extension(NNDemoProtocol, NSObject)

+ (void)sayHelloPop {
    DLog(@"+[%@ %s] say hello pop", self, sel_getName(_cmd));
}

- (void)sayHelloPop {
    DLog(@"-[%@ %s] say hello pop", [self class], sel_getName(_cmd));
}

- (NSString *)whoImI {
    NSString *whoImI = [NSString stringWithFormat:@"-[%@ %s] I am %@", [self class], sel_getName(_cmd), nil];
    return whoImI;
}

- (void)setWhoImI:(NSString *)whoImI {
    DLog(@"-[%@ %s%@]", [self class], sel_getName(_cmd), whoImI);
}

@end
```

### 创建类

- 声明类并遵守协议

```
@interface NNDemoObjc : NSObject <NNDemoProtocol>

@property (nonatomic, strong) NSString *name;

@end

```

- 实现类

```
@implementation NNDemoObjc

@end
```

### 使用类

- 调用

```
[NNDemoObjc sayHelloPop];
NNDemoObjc *objc = [NNDemoObjc new];
[objc sayHelloPop];
objc.whoImI = @"objc";
DLog(@"%@", objc.whoImI);
    
```

- 输出结果

```
+[NNDemoObjc sayHelloPop] objc say hello pop
-[NNDemoObjc sayHelloPop] objc say hello pop
-[NNDemoObjc whoImI] I am objc
```

## 安装

### CocoaPods

安装最新版的 CocoaPods：

```bash
$ gem install cocoapods
```

在 `podfile` 中添加：

```ruby
pod 'NNPopObjc', '~> 0.0.3'
```

然后在终端执行：

```bash
$ pod install
```

如安装失败，提示：

```bash
[!] Unable to find a specification for `NNPopObjc`
```

尝试使用命令：

```bash
pod install --repo-update
```
