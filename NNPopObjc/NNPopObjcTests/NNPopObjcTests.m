//
//  NNPopObjcTests.m
//  NNPopObjcTests
//
//  Created by GuHaijun on 2019/10/3.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import <NNPopObjc/NNPopObjc.h>
#import "NNPopObjc-Protocol.h"
#import "NNTestClassA.h"

@interface NNPopObjcTests : XCTestCase

@end

@implementation NNPopObjcTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_nn_pop_getProtocol {
    
    Protocol *targetProcotol = objc_getProtocol("NNTestProtocol");
    
    // Class
    {
        Class clazz = [NNTestClassA class];
        XCTAssertTrue(!class_isMetaClass(clazz));
        Protocol *procotol = nn_pop_getProtocol(clazz, NSSelectorFromString(@"sayHelloPop"));
        XCTAssertTrue(protocol_isEqual(procotol, targetProcotol));
    }
    
    // MetaClass
    {
        Class clazz = object_getClass([NNTestClassA class]);
        XCTAssertTrue(class_isMetaClass(clazz));
        Protocol *procotol = nn_pop_getProtocol(clazz, NSSelectorFromString(@"sayHelloPop"));
        XCTAssertTrue(protocol_isEqual(procotol, targetProcotol));
    }
}

- (void)test_nn_pop_rootProtocolClass {

    Protocol *targetProcotol = objc_getProtocol("NNTestProtocol");
    
    {
        Class rootClazz = NSClassFromString(@"NNTestClassA");
        Class clazz = nn_pop_rootProtocolClass(targetProcotol, NSClassFromString(@"NNTestClassA"));
        XCTAssertTrue(clazz == rootClazz);
    }
    
    {
        Class rootClazz = NSClassFromString(@"NNTestClassA");
        Class clazz = nn_pop_rootProtocolClass(targetProcotol, NSClassFromString(@"NNTestClassAA"));
        XCTAssertTrue(clazz == rootClazz);
    }
    
    {
        Class rootClazz = NSClassFromString(@"NNTestClassA");
        Class clazz = nn_pop_rootProtocolClass(targetProcotol, NSClassFromString(@"NNTestClassAB"));
        XCTAssertTrue(clazz == rootClazz);
    }
    
    {
        Class rootClazz = NSClassFromString(@"NNTestClassB");
        Class clazz = nn_pop_rootProtocolClass(targetProcotol, NSClassFromString(@"NNTestClassB"));
        XCTAssertTrue(clazz == rootClazz);
    }
    
    {
        Class rootClazz = NSClassFromString(@"NNTestClassB");
        Class clazz = nn_pop_rootProtocolClass(targetProcotol, NSClassFromString(@"NNTestClassBA"));
        XCTAssertTrue(clazz == rootClazz);
    }
    
    {
        Class rootClazz = NSClassFromString(@"NNTestClassB");
        Class clazz = nn_pop_rootProtocolClass(targetProcotol, NSClassFromString(@"NNTestClassBB"));
        XCTAssertTrue(clazz == rootClazz);
    }
}

- (void)test_nn_pop_copyProtocolClassList {
    
    Protocol *targetProcotol = objc_getProtocol("NNTestProtocol");
    
    // Class
    {
        unsigned int count = 0;
        Class *clazzes = nn_pop_copyProtocolClassList(targetProcotol, &count, NN_POP_CopyProtocolClassListTypeClass);
        
        XCTAssertTrue(count == 5);
        
        NSMutableSet *clazzSet = [NSMutableSet new];
        for (unsigned int i = 0; i < count; i++) {
            [clazzSet addObject:clazzes[i]];
        }
        
        
        NSSet *targetClazzSet = [NSSet setWithArray:@[
            NSClassFromString(@"__NNPopObjc_NNTestProtocol_NSObject"),
            NSClassFromString(@"__NNPopObjc_NNTestProtocol_NNTestClassBA"),
            NSClassFromString(@"NNTestClassA"),
            NSClassFromString(@"NNTestClassB"),
            NSClassFromString(@"NNTestClassBA"),
        ]];
        
        XCTAssertTrue([clazzSet isEqualToSet:targetClazzSet]);
        
        free(clazzes);
    }
    
    // MetaClass
    {
        unsigned int count = 0;
        Class *clazzes = nn_pop_copyProtocolClassList(targetProcotol, &count, NN_POP_CopyProtocolClassListTypeMetaClass);
        
        XCTAssertTrue(count == 5);
        
        NSMutableSet *clazzSet = [NSMutableSet new];
        for (unsigned int i = 0; i < count; i++) {
            [clazzSet addObject:clazzes[i]];
        }
        
        NSSet *targetClazzSet = [NSSet setWithArray:@[
            object_getClass(NSClassFromString(@"__NNPopObjc_NNTestProtocol_NSObject")),
            object_getClass(NSClassFromString(@"__NNPopObjc_NNTestProtocol_NNTestClassBA")),
            object_getClass(NSClassFromString(@"NNTestClassA")),
            object_getClass(NSClassFromString(@"NNTestClassB")),
            object_getClass(NSClassFromString(@"NNTestClassBA")),
        ]];
        
        XCTAssertTrue([clazzSet isEqualToSet:targetClazzSet]);
        
        free(clazzes);
    }
}

- (void)test_nn_pop_copyClassListMinus {
    
    {
        Class classA[5] = {0};
        classA[0] = NSClassFromString(@"__NNPopObjc_NNTestProtocol_NSObject");
        classA[1] = NSClassFromString(@"__NNPopObjc_NNTestProtocol_NNTestClassBA");
        classA[2] = NSClassFromString(@"NNTestClassA");
        classA[3] = NSClassFromString(@"NNTestClassB");
        classA[4] = NSClassFromString(@"NNTestClassBA");
        
        Class classB[5] = {0};
        classB[0] = NSClassFromString(@"__NNPopObjc_NNTestProtocol_NSObject");
        classB[1] = NSClassFromString(@"__NNPopObjc_NNTestProtocol_NNTestClassBA");
        classB[2] = NSClassFromString(@"NNTestClassA");
        classB[3] = NSClassFromString(@"NNTestClassB");
        classB[4] = NSClassFromString(@"NNTestClassBA");
        
        unsigned int count = 0;
        Class *c = nn_pop_copyClassListMinus(classA, 5, classB, 5, &count);
        
        XCTAssertTrue(count == 0);
        XCTAssertTrue(c[0] == nil);
        
        free(c);
    }
    
    {
        Class classA[5] = {0};
        classA[0] = NSClassFromString(@"__NNPopObjc_NNTestProtocol_NSObject");
        classA[1] = NSClassFromString(@"__NNPopObjc_NNTestProtocol_NNTestClassBA");
        classA[2] = NSClassFromString(@"NNTestClassBA");
        
        Class classB[5] = {0};
        classB[0] = NSClassFromString(@"__NNPopObjc_NNTestProtocol_NSObject");
        classB[1] = NSClassFromString(@"__NNPopObjc_NNTestProtocol_NNTestClassBA");
        classB[2] = NSClassFromString(@"NNTestClassA");
        classB[3] = NSClassFromString(@"NNTestClassB");
        classB[4] = NSClassFromString(@"NNTestClassBA");
        
        unsigned int count = 0;
        Class *c = nn_pop_copyClassListMinus(classA, 3, classB, 5, &count);
        
        XCTAssertTrue(count == 0);
        XCTAssertTrue(c[0] == nil);
        
        free(c);
    }
    
    {
        Class classA[5] = {0};
        classA[0] = NSClassFromString(@"__NNPopObjc_NNTestProtocol_NSObject");
        classA[1] = NSClassFromString(@"__NNPopObjc_NNTestProtocol_NNTestClassBA");
        classA[2] = NSClassFromString(@"NNTestClassA");
        classA[3] = NSClassFromString(@"NNTestClassB");
        classA[4] = NSClassFromString(@"NNTestClassBA");
        
        Class classB[5] = {0};
        classB[0] = NSClassFromString(@"__NNPopObjc_NNTestProtocol_NSObject");
        classB[1] = NSClassFromString(@"__NNPopObjc_NNTestProtocol_NNTestClassBA");
        classB[2] = NSClassFromString(@"NNTestClassBA");
        
        unsigned int count = 0;
        Class *c = nn_pop_copyClassListMinus(classA, 5, classB, 3, &count);
        
        XCTAssertTrue(count == 2);
        XCTAssertTrue(c[0] == NSClassFromString(@"NNTestClassA"));
        XCTAssertTrue(c[1] == NSClassFromString(@"NNTestClassB"));
        
        free(c);
    }
    
    {
        Class classB[5] = {0};
        classB[0] = NSClassFromString(@"__NNPopObjc_NNTestProtocol_NSObject");
        classB[1] = NSClassFromString(@"__NNPopObjc_NNTestProtocol_NNTestClassBA");
        classB[2] = NSClassFromString(@"NNTestClassBA");
        
        unsigned int count = 0;
        Class *c = nn_pop_copyClassListMinus(nil, 5, classB, 3, &count);
        
        XCTAssertTrue(count == 0);
        XCTAssertTrue(c == nil);
        
        free(c);
    }
    
    {
        Class classA[5] = {0};
        classA[0] = NSClassFromString(@"__NNPopObjc_NNTestProtocol_NSObject");
        classA[1] = NSClassFromString(@"__NNPopObjc_NNTestProtocol_NNTestClassBA");
        classA[2] = NSClassFromString(@"NNTestClassA");
        classA[3] = NSClassFromString(@"NNTestClassB");
        classA[4] = NSClassFromString(@"NNTestClassBA");
        
        unsigned int count = 0;
        Class *c = nn_pop_copyClassListMinus(classA, 5, nil, 3, &count);
        
        XCTAssertTrue(count == 5);
        XCTAssertTrue(c[0] == NSClassFromString(@"__NNPopObjc_NNTestProtocol_NSObject"));
        XCTAssertTrue(c[1] == NSClassFromString(@"__NNPopObjc_NNTestProtocol_NNTestClassBA"));
        XCTAssertTrue(c[2] == NSClassFromString(@"NNTestClassA"));
        XCTAssertTrue(c[3] == NSClassFromString(@"NNTestClassB"));
        XCTAssertTrue(c[4] == NSClassFromString(@"NNTestClassBA"));
        
        free(c);
    }
    
}

- (void)test_nn_pop_copyPopObjcClassList {
    
    Protocol *rocotol = objc_getProtocol("NNTestProtocol");
    
    // Class
    {
        unsigned int clazzesCount = 0;
        Class *clazzes = nn_pop_copyProtocolClassList(rocotol, &clazzesCount, NN_POP_CopyProtocolClassListTypeClass);
        unsigned int procotolClazzesCount = 0;
        Class *popObjcClazzes = nn_pop_copyPopObjcClassList(clazzes, clazzesCount, &procotolClazzesCount);
        
        XCTAssertTrue(procotolClazzesCount == 2);
        
        
        NSMutableSet *clazzSet = [NSMutableSet new];
        for (unsigned int i = 0; i < procotolClazzesCount; i++) {
            [clazzSet addObject:popObjcClazzes[i]];
        }
        
        
        NSSet *targetClazzSet = [NSSet setWithArray:@[
            NSClassFromString(@"__NNPopObjc_NNTestProtocol_NSObject"),
            NSClassFromString(@"__NNPopObjc_NNTestProtocol_NNTestClassBA"),
        ]];
        
        XCTAssertTrue([clazzSet isEqualToSet:targetClazzSet]);
        
        free(clazzes);
        free(popObjcClazzes);
    }
    
    // MetaClass
    {
        unsigned int clazzesCount = 0;
        Class *clazzes = nn_pop_copyProtocolClassList(rocotol, &clazzesCount, NN_POP_CopyProtocolClassListTypeMetaClass);
        unsigned int procotolClazzesCount = 0;
        Class *popObjcClazzes = nn_pop_copyPopObjcClassList(clazzes, clazzesCount, &procotolClazzesCount);
        
        XCTAssertTrue(procotolClazzesCount == 2);
        
        
        NSMutableSet *clazzSet = [NSMutableSet new];
        for (unsigned int i = 0; i < procotolClazzesCount; i++) {
            [clazzSet addObject:popObjcClazzes[i]];
        }
        
        
        NSSet *targetClazzSet = [NSSet setWithArray:@[
            object_getClass(NSClassFromString(@"__NNPopObjc_NNTestProtocol_NSObject")),
            object_getClass(NSClassFromString(@"__NNPopObjc_NNTestProtocol_NNTestClassBA")),
        ]];
        
        XCTAssertTrue([clazzSet isEqualToSet:targetClazzSet]);
        
        free(clazzes);
        free(popObjcClazzes);
    }
}

- (void)test_nn_pop_copyRootProtocolClassList {
    
    Protocol *rocotol = objc_getProtocol("NNTestProtocol");
    
    // Class
    {
        unsigned int clazzesCount = 0;
        Class *clazzes = nn_pop_copyProtocolClassList(rocotol, &clazzesCount, NN_POP_CopyProtocolClassListTypeClass);
        unsigned int procotolClazzesCount = 0;
        Class *rootClazzes = nn_pop_copyRootProtocolClassList(rocotol, clazzes, clazzesCount, &procotolClazzesCount);
        
        XCTAssertTrue(procotolClazzesCount == 3);
        
        
        NSMutableSet *clazzSet = [NSMutableSet new];
        for (unsigned int i = 0; i < procotolClazzesCount; i++) {
            [clazzSet addObject:rootClazzes[i]];
        }
        
        NSSet *targetClazzSet = [NSSet setWithArray:@[
            NSClassFromString(@"__NNPopObjc_NNTestProtocol_NSObject"),
//            NSClassFromString(@"__NNPopObjc_NNTestProtocol_NNTestClassBA"),
            NSClassFromString(@"NNTestClassA"),
            NSClassFromString(@"NNTestClassB"),
        ]];
        
        XCTAssertTrue([clazzSet isEqualToSet:targetClazzSet]);
        
        free(clazzes);
        free(rootClazzes);
    }
    
    // MetaClass
    {
        unsigned int clazzesCount = 0;
        Class *clazzes = nn_pop_copyProtocolClassList(rocotol, &clazzesCount, NN_POP_CopyProtocolClassListTypeMetaClass);
        unsigned int procotolClazzesCount = 0;
        Class *rootClazzes = nn_pop_copyRootProtocolClassList(rocotol, clazzes, clazzesCount, &procotolClazzesCount);
        
        XCTAssertTrue(procotolClazzesCount == 3);
        
        
        NSMutableSet *clazzSet = [NSMutableSet new];
        for (unsigned int i = 0; i < procotolClazzesCount; i++) {
            [clazzSet addObject:rootClazzes[i]];
        }
        
        NSSet *targetClazzSet = [NSSet setWithArray:@[
            object_getClass(NSClassFromString(@"__NNPopObjc_NNTestProtocol_NSObject")),
//            object_getClass(NSClassFromString(@"__NNPopObjc_NNTestProtocol_NNTestClassBA")),
            object_getClass(NSClassFromString(@"NNTestClassA")),
            object_getClass(NSClassFromString(@"NNTestClassB")),
        ]];
        
        XCTAssertTrue([clazzSet isEqualToSet:targetClazzSet]);
        
        free(clazzes);
        free(rootClazzes);
    }
}

- (void)test_nn_pop_separateProtocolClassList {
    
    // Class
    {
        Class clazz = NSClassFromString(@"NNTestClassA");
        
        Protocol *protocol = objc_getProtocol("NNTestProtocol");
        
        unsigned int protocolClassCount = 0;
        Class *protocolClazzList = nn_pop_copyProtocolClassList(protocol, &protocolClassCount, class_isMetaClass(clazz) ? NN_POP_CopyProtocolClassListTypeMetaClass : NN_POP_CopyProtocolClassListTypeClass);
        
        unsigned int popObjcProtocolClazzListCount = 0;
        Class *popProtocolObjcClazzList = (Class *)malloc((1 + protocolClassCount) * sizeof(Class));
        unsigned int rootProtocolClazzCount = 0;
        Class *rootProtocolClazzList = (Class *)malloc((1 + protocolClassCount) * sizeof(Class));
        unsigned int subProtocolClazzCount = 0;
        Class *subProtocolClazzList = (Class *)malloc((1 + protocolClassCount) * sizeof(Class));
        
        nn_pop_separateProtocolClassList(protocol, protocolClazzList, protocolClassCount,
                                     &rootProtocolClazzList, &rootProtocolClazzCount,
                                     &subProtocolClazzList, &subProtocolClazzCount,
                                     &popProtocolObjcClazzList, &popObjcProtocolClazzListCount);
        {
            NSMutableSet *clazzSet = [NSMutableSet new];
            for (unsigned int i = 0; i < popObjcProtocolClazzListCount; i++) {
                [clazzSet addObject:popProtocolObjcClazzList[i]];
            }
            
            NSSet *targetClazzSet = [NSSet setWithArray:@[
                NSClassFromString(@"__NNPopObjc_NNTestProtocol_NSObject"),
                NSClassFromString(@"__NNPopObjc_NNTestProtocol_NNTestClassBA"),
            ]];
            
            XCTAssertTrue([clazzSet isEqualToSet:targetClazzSet]);
        }
        
        {
            NSMutableSet *clazzSet = [NSMutableSet new];
            for (unsigned int i = 0; i < rootProtocolClazzCount; i++) {
                [clazzSet addObject:rootProtocolClazzList[i]];
            }
            
            NSSet *targetClazzSet = [NSSet setWithArray:@[
                NSClassFromString(@"NNTestClassA"),
                NSClassFromString(@"NNTestClassB"),
            ]];
            
            XCTAssertTrue([clazzSet isEqualToSet:targetClazzSet]);
        }
        
        
        {
            NSMutableSet *clazzSet = [NSMutableSet new];
            for (unsigned int i = 0; i < subProtocolClazzCount; i++) {
                [clazzSet addObject:subProtocolClazzList[i]];
            }
            
            NSSet *targetClazzSet = [NSSet setWithArray:@[
                NSClassFromString(@"NNTestClassBA"),
            ]];
            
            XCTAssertTrue([clazzSet isEqualToSet:targetClazzSet]);
        }
        
        free(protocolClazzList);
        free(popProtocolObjcClazzList);
        free(rootProtocolClazzList);
        free(subProtocolClazzList);
    }
    
    // MetaClass
    {
        Class clazz = object_getClass(NSClassFromString(@"NNTestClassA"));
        
        Protocol *protocol = objc_getProtocol("NNTestProtocol");
        
        unsigned int protocolClassCount = 0;
        Class *protocolClazzList = nn_pop_copyProtocolClassList(protocol, &protocolClassCount, class_isMetaClass(clazz) ? NN_POP_CopyProtocolClassListTypeMetaClass : NN_POP_CopyProtocolClassListTypeClass);
        
        unsigned int popObjcProtocolClazzListCount = 0;
        Class *popProtocolObjcClazzList = (Class *)malloc((1 + protocolClassCount) * sizeof(Class));
        unsigned int rootProtocolClazzCount = 0;
        Class *rootProtocolClazzList = (Class *)malloc((1 + protocolClassCount) * sizeof(Class));
        unsigned int subProtocolClazzCount = 0;
        Class *subProtocolClazzList = (Class *)malloc((1 + protocolClassCount) * sizeof(Class));
        
        nn_pop_separateProtocolClassList(protocol, protocolClazzList, protocolClassCount,
                                     &rootProtocolClazzList, &rootProtocolClazzCount,
                                     &subProtocolClazzList, &subProtocolClazzCount,
                                     &popProtocolObjcClazzList, &popObjcProtocolClazzListCount);
        
        
        {
            NSMutableSet *clazzSet = [NSMutableSet new];
            for (unsigned int i = 0; i < popObjcProtocolClazzListCount; i++) {
                [clazzSet addObject:popProtocolObjcClazzList[i]];
            }
            
            NSSet *targetClazzSet = [NSSet setWithArray:@[
                object_getClass(NSClassFromString(@"__NNPopObjc_NNTestProtocol_NSObject")),
                object_getClass(NSClassFromString(@"__NNPopObjc_NNTestProtocol_NNTestClassBA")),
            ]];
            
            XCTAssertTrue([clazzSet isEqualToSet:targetClazzSet]);
        }
        
        {
            NSMutableSet *clazzSet = [NSMutableSet new];
            for (unsigned int i = 0; i < rootProtocolClazzCount; i++) {
                [clazzSet addObject:rootProtocolClazzList[i]];
            }
            
            NSSet *targetClazzSet = [NSSet setWithArray:@[
                object_getClass(NSClassFromString(@"NNTestClassA")),
                object_getClass(NSClassFromString(@"NNTestClassB")),
            ]];
            
            XCTAssertTrue([clazzSet isEqualToSet:targetClazzSet]);
        }
        
        
        {
            NSMutableSet *clazzSet = [NSMutableSet new];
            for (unsigned int i = 0; i < subProtocolClazzCount; i++) {
                [clazzSet addObject:subProtocolClazzList[i]];
            }
            
            NSSet *targetClazzSet = [NSSet setWithArray:@[
                object_getClass(NSClassFromString(@"NNTestClassBA")),
            ]];
            
            XCTAssertTrue([clazzSet isEqualToSet:targetClazzSet]);
        }
        
        
        free(protocolClazzList);
        free(popProtocolObjcClazzList);
        free(rootProtocolClazzList);
        free(subProtocolClazzList);
    }
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
