<h1 align = "center">NNPopObjc</h1>

[![GitHub release](https://img.shields.io/github/release/amisare/NNPopObjc.svg)](https://github.com/amisare/NNPopObjc/releases)
[![CocoaPods](https://img.shields.io/cocoapods/v/NNPopObjc.svg)](https://cocoapods.org/pods/NNPopObjc)
[![CocoaPods](https://img.shields.io/cocoapods/p/NNPopObjc.svg)](https://cocoapods.org/pods/NNPopObjc)
[![GitHub license](https://img.shields.io/github/license/amisare/NNPopObjc.svg)](https://github.com/amisare/NNPopObjc/blob/master/LICENSE)


NNPopObjc is inspired by protocol oriented programming, it provides extensibility for the protocol.

[NNPopObjc 中文文档](README_zh_CN.md)

## Documents

* Read the [NNPopObjc Guide](Docs/usage_en.md) document.

## Quick Start

### Declaring a Procotol

Declaring the Procotol in a `.h` file

```objective-c
@protocol NNDemoProtocol <NSObject>

@optional
@property (nonatomic, strong) NSString* whoImI;
- (void)sayHelloPop;
+ (void)sayHelloPop;

@end
```

### Extending the Procotol

Extending the Procotol needs in a `.m` file

```objective-c
///Extending the Procotol for default implemention.
@nn_extension(NNDemoProtocol, NSObject)

+ (void)sayHelloPop {
    DLog(@"+[%@ %s] code say hello pop", self, sel_getName(_cmd));
}

- (void)sayHelloPop {
    DLog(@"-[%@ %s] code say hello pop", [self class], sel_getName(_cmd));
}

- (NSString *)whoImI {
    NSString *whoImI = [NSString stringWithFormat:@"-[%@ %s] I am %@", [self class], sel_getName(_cmd), nil];
    return whoImI;
}

- (void)setWhoImI:(NSString *)whoImI {
    DLog(@"-[%@ %s%@]", [self class], sel_getName(_cmd), whoImI);
}

@end

///Extending the Procotol for NNDemoObjc
@nn_extension(NNDemoProtocol, NNDemoObjc)

- (NSString *)whoImI {
    NSString *whoImI = [NSString stringWithFormat:@"-[%@ %s] I am %@", [self class], sel_getName(_cmd), self.name];
    return whoImI;
}

- (void)setWhoImI:(NSString *)whoImI {
    self.name = whoImI;
}

@end
```

### Adopting the Procotol

- Creating a Class

```objective-c
@interface NNDemoObjc : NSObject <NNDemoProtocol>

@property (nonatomic, strong) NSString *name;

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
NNDemoObjc *objc = [NNDemoObjc new];
[objc sayHelloPop];
objc.whoImI = @"objc";
DLog(@"%@", objc.whoImI);
```

- Outputting

```objective-c
+[NNDemoObjc sayHelloPop] code say hello pop
-[NNDemoObjc sayHelloPop] code say hello pop
-[NNDemoObjc whoImI] I am objc
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
pod 'NNPopObjc', '~> 0.0.4'
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
