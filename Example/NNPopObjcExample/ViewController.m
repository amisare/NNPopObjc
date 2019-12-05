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
#import "NNCodeC.h"
#import "NNCodeObjc.h"
#import "NNCodeCpp.h"
#import "NNPopObjcExample-Swift.h"

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
    
    [NNCodeC sayHelloPop];
    [NNCodeObjc sayHelloPop];
    [NNCodeCpp sayHelloPop];
    [NNCodeSwift sayHelloPop];
    
    DLog(@"");
    
    NNCodeC *c = [NNCodeC new];
    NNCodeObjc *objc = [NNCodeObjc new];
    NNCodeCpp *cpp = [NNCodeCpp new];
    NNCodeSwift *swift = [NNCodeSwift new];
    
    [c sayHelloPop];
    [objc sayHelloPop];
    [cpp sayHelloPop];
    [swift sayHelloPop];
    
    DLog(@"");
    
    c.who = @"c";
    DLog(@"%@", c.who);
    objc.who = @"objc";
    DLog(@"%@", objc.who);
    cpp.who = @"cpp";
    DLog(@"%@", cpp.who);
    swift.who = @"swift";
    DLog(@"%@", swift.who);
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
