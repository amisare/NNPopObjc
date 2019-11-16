//
//  NNPopObjcProtocol.h
//  NNPopObjc
//
//  Created by 顾海军 on 2019/11/8.
//

#ifndef NNPopObjcProtocol_h
#define NNPopObjcProtocol_h

#import <Foundation/Foundation.h>
#import <functional>

#import "NNPopObjcDescription.h"

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */


/// Extension description struct.
typedef nn_pop_extension_description_t nn_pop_extensionDescription_t;

/// Extension list node.
struct nn_pop_extensionNode {
        
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
    nn_pop_extensionNode *next;
    
    nn_pop_extensionNode(void) = default;
    nn_pop_extensionNode(nn_pop_extensionDescription_t *extensionDescription);
    ~nn_pop_extensionNode(void);
    
    nn_pop_extensionNode *copy(void);
    
};

struct nn_pop_extensionList {

private:
    nn_pop_extensionNode *_head;

public:
    nn_pop_extensionList(void) = default;
    ~nn_pop_extensionList(void);
    
    unsigned int count(void);
    nn_pop_extensionNode *head(void);
    void head(nn_pop_extensionNode *node);
    void append(nn_pop_extensionNode *entry);
    void foreach(std::function<void(nn_pop_extensionNode *item, BOOL *stop)> enumerater);
    void clear(void);
    
};


/// Protocol extension struct.
struct nn_pop_protocolExtension{

public:
    /// Protocol be extended.
    Protocol *protocol;
    /// Protocol extension descriptions.
    nn_pop_extensionList extension;
    
    nn_pop_protocolExtension(void) = default;
    nn_pop_protocolExtension(nn_pop_extensionDescription_t *extensionDescription);
    ~nn_pop_protocolExtension(void);
    
};

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* NNPopObjcProtocol_h */
