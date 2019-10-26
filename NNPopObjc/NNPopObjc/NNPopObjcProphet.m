//
//  NNPopObjcProphet.m
//  NNPopObjc
//
//  Created by 顾海军 on 2019/10/26.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNPopObjcProphet.h"

typedef struct
#ifdef __LP64__
mach_header_64
#else
mach_header
#endif
nn_pop_mach_header;

static NSArray *__nn_pop_section_data = nil;

NS_INLINE NSString *__nn_pop_readSection(char *name, const nn_pop_mach_header *mhp);

NSArray *nn_pop_readSection(void) {
    return __nn_pop_section_data;
}

NS_INLINE NSString *__nn_pop_readSection(char *name, const nn_pop_mach_header *mhp) {
    
    NSString *section = @"[";
    unsigned long size = 0;
    uintptr_t *sectionItems = (uintptr_t*)getsectiondata(mhp, SEG_DATA, name, &size);
    unsigned long sectionItemCount = size/sizeof(void *);
    for(int i = 0; i < sectionItemCount; ++i){
        char *sectionItemChar = (char *)sectionItems[i];
        NSString *sectionItemString = [NSString stringWithUTF8String:sectionItemChar];
        if(!sectionItemString) {
            continue;
        }
        section = [section stringByAppendingString:sectionItemString];
        section = [section stringByAppendingString:@","];
    }
    section = [section stringByAppendingString:@"]"];
    return section;
}


NS_INLINE void dyld_callback(const nn_pop_mach_header *mhp, intptr_t vmaddr_slide) {
    
    NSString *section = __nn_pop_readSection(nn_pop_stringify(nn_pop_section_name), mhp);
    NSData *sectionData =  [section dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *sectionJSON = [NSJSONSerialization JSONObjectWithData:sectionData options:0 error:&error];
    if (error) {
        return;
    }
    if (sectionJSON.count == 0) {
        return;
    }
    __nn_pop_section_data = sectionJSON;
}


__attribute__((constructor)) void nn_pop_prophet() {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
    _dyld_register_func_for_add_image(dyld_callback);
#pragma clang diagnostic pop
}
