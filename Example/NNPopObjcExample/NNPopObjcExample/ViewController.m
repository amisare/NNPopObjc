//
//  ViewController.m
//  NNPopObjcExample
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "ViewController.h"
#import "NNCodeLog.h"
#import "NNCodeProtocol.h"
#import "NNCode.h"
#import "NNCodeC.h"
#import "NNCodeObjc.h"
#import "NNCodeCpp.h"
#import "NNPopObjcExample-Swift.h"

#import <NNPopObjcDynamicExample/NNPopObjcDynamicExample.h>
#import <NNPopObjcStaticExample/NNPopObjcStaticExample.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.logTextView.text = @"";
    self.logTextView.editable = NO;
    
    [self redirectSTD:STDOUT_FILENO];
    [self redirectSTD:STDERR_FILENO];
    
    [self popExample];
 }

- (void)popExample {
    
    DLog(@"");
    
    [NNCode sayHelloPop];
    [NNCodeC sayHelloPop];
    [NNCodeCpp sayHelloPop];
    [NNCodeObjc sayHelloPop];
    [NNCodeSwift sayHelloPop];
    
    DLog(@"");
    
    NNCode *code = [NNCode new];
    NNCodeC *codeC = [NNCodeC new];
    NNCodeCpp *codeCpp = [NNCodeCpp new];
    NNCodeObjc *codeObjc = [NNCodeObjc new];
    NNCodeSwift *codeSwift = [NNCodeSwift new];
    
    [code sayHelloPop];
    [codeC sayHelloPop];
    [codeCpp sayHelloPop];
    [codeObjc sayHelloPop];
    [codeSwift sayHelloPop];
    
    DLog(@"");
    
    codeC.who = @"c";
    DLog(@"%@", codeC.who);
    codeCpp.who = @"cpp";
    DLog(@"%@", codeCpp.who);
    codeObjc.who = @"objc";
    DLog(@"%@", codeObjc.who);
    codeSwift.who = @"swift";
    DLog(@"%@", codeSwift.who);
    
    DLog(@"");
    
    [NNDynamic sayHelloPop];
    [[NNDynamic new] sayHelloPop];
    
    [NNStatic sayHelloPop];
    [[NNStatic new] sayHelloPop];
}

- (void)redirectNotificationHandle:(NSNotification *)notification{
    NSData *data = [[notification userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    self.logTextView.text = [NSString stringWithFormat:@"%@%@",self.logTextView.text, str];
    NSRange range;
    range.location = [self.logTextView.text length] - 1;
    range.length = 0;
    [self.logTextView scrollRangeToVisible:range];
    
    [[notification object] readInBackgroundAndNotify];
}

- (void)redirectSTD:(int )fd{
    NSPipe * pipe = [NSPipe pipe] ;
    NSFileHandle *pipeReadHandle = [pipe fileHandleForReading] ;
    dup2([[pipe fileHandleForWriting] fileDescriptor], fd) ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redirectNotificationHandle:)
                                                 name:NSFileHandleReadCompletionNotification
                                               object:pipeReadHandle] ;
    [pipeReadHandle readInBackgroundAndNotify];
}

@end
