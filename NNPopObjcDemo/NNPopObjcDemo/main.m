//
//  main.m
//  NNPopObjcDemo
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#include <mach-o/getsect.h>
#include <mach-o/ldsyms.h>

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        
//        NSMutableArray *configs = [NSMutableArray array];
//          unsigned long size = 0;
//          uintptr_t *memory = (uintptr_t*)getsectiondata(&_mh_execute_header, SEG_DATA, metamacro_stringify(nn_pop_section_name), &size);
//          
//          unsigned long counter = size/sizeof(void*);
//          for(int idx = 0; idx < counter; ++idx){
//              char *string = (char*)memory[idx];
//              NSString *str = [NSString stringWithUTF8String:string];
//              if(!str)continue;
//              
//              if(str) [configs addObject:str];
//          }
        
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
