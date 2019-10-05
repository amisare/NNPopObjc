//
//  NNDemoLog.h
//  NNPopObjcDemo
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#ifndef NNDemoLog_h
#define NNDemoLog_h

#define DLog(format, ...) printf("%s\n", [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);

#endif /* NNDemoLog_h */
