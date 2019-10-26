//
//  NNPopObjc-Define.h
//  NNPopObjc
//
//  Created by 顾海军 on 2019/10/8.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#ifndef NNPopObjc_Define_h
#define NNPopObjc_Define_h

#ifdef DEBUG
#define NNPopObjcLog(format, ...)      {NSLog((@"NNPopObjc: [Line %04d] %s " format), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__);}
#else
#define NNPopObjcLog(format, ...)
#endif

#define nn_pop_root_class_suffix        NSObject

#endif /* NNPopObjc_Define_h */
