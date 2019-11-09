//
//  ViewController.m
//  NNPopObjcDemo
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "ViewController.h"
#import <NNPopObjc/NNPopObjc.h>
#import "NNDemoLog.h"
#import "NNDemoProtocol.h"
#import "NNDemoCpp.h"
#import "NNDemoC.h"
#import "NNDemoObjc.h"
#import "NNDemoSwift.h"

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
    
    [self popDemo];
 }

- (void)popDemo {
    
    DLog(@"");
    
    [NNDemoC sayHelloPop];
    [NNDemoObjc sayHelloPop];
    [NNDemoCpp sayHelloPop];
    [NNDemoSwift sayHelloPop];
    
    DLog(@"");
    
    NNDemoC *c = [NNDemoC new];
    NNDemoObjc *objc = [NNDemoObjc new];
    NNDemoCpp *cpp = [NNDemoCpp new];
    NNDemoSwift *swift = [NNDemoSwift new];
    
    [c sayHelloPop];
    [objc sayHelloPop];
    [cpp sayHelloPop];
    [swift sayHelloPop];
    
    DLog(@"");
    
    c.whoImI = @"c";
    DLog(@"%@", c.whoImI);
    objc.whoImI = @"objc";
    DLog(@"%@", objc.whoImI);
    cpp.whoImI = @"cpp";
    DLog(@"%@", cpp.whoImI);
    swift.whoImI = @"swift";
    DLog(@"%@", swift.whoImI);
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
