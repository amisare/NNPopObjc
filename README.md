<h1 align = "center">NNPopObjc</h1>

[![GitHub release](https://img.shields.io/github/release/amisare/NNPopObjc.svg)](https://github.com/amisare/NNPopObjc/releases)
[![CocoaPods](https://img.shields.io/cocoapods/v/NNPopObjc.svg)](https://cocoapods.org/pods/NNPopObjc)
[![CocoaPods](https://img.shields.io/cocoapods/p/NNPopObjc.svg)](https://cocoapods.org/pods/NNPopObjc)
[![GitHub license](https://img.shields.io/github/license/amisare/NNPopObjc.svg)](https://github.com/amisare/NNPopObjc/blob/master/LICENSE)


NNPopObjc is inspired by protocol oriented programming, it provides extensibility for the protocol.

[NNPopObjc 中文文档](README_zh_CN.md)

## Documents

* Read the [NNPopObjc Guide](Docs/0.2.x/usage_en.md) document.

## Quick Start

### Declaring a Procotol

Declaring the Procotol in a `.h` file

```objective-c
@protocol NNDemoProtocol <NSObject>

@optional
- (void)sayHelloPop;
+ (void)sayHelloPop;

@end
```

### Extending the Procotol

Extending the Procotol needs in a `.m` file

```objective-c
///Extending the Procotol for default implemention.
@nn_extension(NNDemoProtocol)

+ (void)sayHelloPop {
    DLog(@"+[%@ %s] code say hello pop", self, sel_getName(_cmd));
}

- (void)sayHelloPop {
    DLog(@"-[%@ %s] code say hello pop", [self class], sel_getName(_cmd));
}

@end
```

### Adopting the Procotol

- Creating a Class

```objective-c
@interface NNDemoObjc : NSObject <NNDemoNameProtocol>

@end
```

- Implementing the Class

```
@implementation NNDemoObjc

@end
```

### Using the Class

- Calling the Methods

```objective-c
[NNDemoObjc sayHelloPop];
[[NNDemoObjc new] sayHelloPop];
```

- Outputting

```objective-c
+[NNDemoObjc sayHelloPop] code say hello pop
-[NNDemoObjc sayHelloPop] code say hello pop
```

## Installation

NNPopObjc supports CocoaPods for installing the library in a project.

### Installation with CocoaPods

You can install it with the following command:

```bash
$ gem install cocoapods
```

### Podfile

To integrate NNPopObjc into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'NNPopObjc', '~> 0.2.1'
end
```

Then, run the following command:

```bash
pod install
```

#### If installation failed with error：

```bash
[!] Unable to find a specification for `NNPopObjc`
```

try install with the following command:

```bash
pod install --repo-update
```

## inspired

- [Protocol-Oriented Programming in Swift](https://developer.apple.com/videos/play/wwdc2015/408/)
- [ProtocolKit](https://github.com/forkingdog/ProtocolKit)
- [libextobjc](https://github.com/jspahrsummers/libextobjc)

## License

NNPopObjc is released under the MIT license. See LICENSE for details.
