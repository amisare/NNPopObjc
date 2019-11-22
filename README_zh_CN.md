<h1 align = "center">NNPopObjc</h1>

[![GitHub release](https://img.shields.io/github/release/amisare/NNPopObjc.svg)](https://github.com/amisare/NNPopObjc/releases)
[![CocoaPods](https://img.shields.io/cocoapods/v/NNPopObjc.svg)](https://cocoapods.org/pods/NNPopObjc)
[![CocoaPods](https://img.shields.io/cocoapods/p/NNPopObjc.svg)](https://cocoapods.org/pods/NNPopObjc)
[![GitHub license](https://img.shields.io/github/license/amisare/NNPopObjc.svg)](https://github.com/amisare/NNPopObjc/blob/master/LICENSE)


NNPopObjc 受面向协议编程的启发，为协议提供了实现扩展的功能。

[NNPopObjc English Document](README_zh_CN.md)

## 文档

* 阅读 [NNPopObjc Guide](Docs/0.2.x/usage_zh_CN.md) 文档。

## 快速开始

### 声明协议

在 `.h` 文件中声明协议

```objective-c
@protocol NNDemoProtocol <NSObject>

@optional
- (void)sayHelloPop;
+ (void)sayHelloPop;

@end
```

### 扩展协议

扩展协议需要在 `.m` 中实现

```objective-c
/// 默认协议扩展
@nn_extension(NNDemoProtocol)

+ (void)sayHelloPop {
    DLog(@"+[%@ %s] code say hello pop", self, sel_getName(_cmd));
}

- (void)sayHelloPop {
    DLog(@"-[%@ %s] code say hello pop", [self class], sel_getName(_cmd));
}

@end
```

### 遵守协议

- 创建类

```objective-c
@interface NNDemoObjc : NSObject <NNDemoNameProtocol>

@end
```

- 实现类

```
@implementation NNDemoObjc

@end
```

### 使用类

- 调用方法

```objective-c
[NNDemoObjc sayHelloPop];
[[NNDemoObjc new] sayHelloPop];
```

- 输出日志

```objective-cc
+[NNDemoObjc sayHelloPop] code say hello pop
-[NNDemoObjc sayHelloPop] code say hello pop
```

## 安装

NNPopObjc 支持 CocoaPods 方式集成。

### 安装 CocoaPods

使用以下命令安装：

```bash
$ gem install cocoapods
```

### Podfile

将 NNPopObjc 添加到 `Podfile` ，通过 CocoaPods 集成 NNPopObjc 到 Xcode 项目：

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
    pod 'NNPopObjc'
end
```

执行命令：

```bash
pod install
```

#### 如安装失败，提示：

```bash
[!] Unable to find a specification for `NNPopObjc`
```

尝试使用命令：

```bash
pod install --repo-update
```
