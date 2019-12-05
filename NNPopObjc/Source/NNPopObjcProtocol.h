//
//  NNPopObjcProtocol.h
//  NNPopObjc
//
//  Created by GuHaijun on 2019/11/8.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#ifndef NNPopObjcProtocol_h
#define NNPopObjcProtocol_h

#import <Foundation/Foundation.h>
#import <functional>

#import "NNPopObjcDescription.h"

namespace popobjc {

/// Extension description struct.
typedef nn_pop_extension_description_t ExtensionDescription;


/// Extension list node.
struct ExtensionNode {
        
public:
    /// Prefix of extension implementation class name.
    const char *prefix;
    /// Extension implemention Class.
    Class clazz;
    /// Where clause function pointer.
    where_fp where_fp;
    /// Count of protocols that the adopted class should be confrom to.
    unsigned int confromProtocolCount;
    /// Protocols that the adopted class should be confrom to.
    Protocol *confromProtocols[20];
    /// Next extension list node.
    ExtensionNode *next;
    
    ExtensionNode() = default;
    ExtensionNode(const ExtensionDescription *extensionDescription);
    ExtensionNode(const ExtensionNode *extensionNode);
    ~ExtensionNode();
    
};


struct ExtensionList {

private:
    ExtensionNode *_head;

public:
    ExtensionList() = default;
    ~ExtensionList();
    
    unsigned int count();
    ExtensionNode *head();
    void head(ExtensionNode *node);
    void append(ExtensionNode *entry);
    void foreach(std::function<void(ExtensionNode *item, BOOL *stop)> enumerater);
    void clear();
    
};


/// Protocol extension struct.
struct ProtocolExtension{

public:
    /// Protocol be extended.
    Protocol *protocol;
    /// Protocol extension descriptions.
    ExtensionList extension;
    
    ProtocolExtension() = default;
    ProtocolExtension(const ExtensionDescription *extensionDescription);
    ~ProtocolExtension();
    
};

}

#endif /* NNPopObjcProtocol_h */
