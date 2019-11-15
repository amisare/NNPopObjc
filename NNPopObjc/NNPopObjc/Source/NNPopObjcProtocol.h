//
//  NNPopObjcProtocol.h
//  NNPopObjc
//
//  Created by 顾海军 on 2019/11/8.
//

#ifndef NNPopObjcProtocol_h
#define NNPopObjcProtocol_h

#import <Foundation/Foundation.h>

#import "NNPopObjc.h"

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */


/// Extension description struct.
typedef nn_pop_extension_description_t nn_pop_extensionDescription_t;

/// Extension list node.
typedef struct nn_pop_extensionNode {
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
    struct nn_pop_extensionNode *next;
} nn_pop_extensionNode_t, *nn_pop_extensionNode_p;

/// Protocol extension struct.
typedef struct {
    /// Protocol be extended.
    Protocol *protocol;
    /// Protocol extension descriptions.
    nn_pop_extensionNode_p extension;
} nn_pop_protocolExtension_t;

/// Creates a nn_pop_extension_node_p node.
nn_pop_extensionNode_p nn_pop_extensionNodeNew(void);

/// Initialize a nn_pop_extension_node_p node
/// @param node A nn_pop_extension_node_p node pointer.
/// @param extensionDescription A nn_pop_extensionDescription_t pointer.
nn_pop_extensionNode_p nn_pop_extensionNodeInitWithExtensionDescription(nn_pop_extensionNode_p *node,
                                                                        nn_pop_extensionDescription_t *extensionDescription);

/// Copys a node from src to dst.
/// @param dst dst node
/// @param src src node
nn_pop_extensionNode_p nn_pop_extensionNodeCopy(nn_pop_extensionNode_p dst, nn_pop_extensionNode_p src);

/// Gets node count in list.
/// @param head A list head
unsigned int nn_pop_extensionListCount(nn_pop_extensionNode_p *head);

/// Appends a node at the tail of list.
/// @param head A list head
/// @param entry A node
void nn_pop_extensionListAppend(nn_pop_extensionNode_p *head, nn_pop_extensionNode_p *entry);

/// Frees a list.
/// @param head A list head
void nn_pop_extensionListFree(nn_pop_extensionNode_p *head);

/// Executes a given block using each object in the list, starting with the first object and continuing through the list to the last object.
/// @param head A list head
void nn_pop_extensionListForeach(nn_pop_extensionNode_p *head, void (^enumerateBlock)(nn_pop_extensionNode_p item, BOOL *stop));


/// Creates a nn_pop_protocol_extension_t struct.
nn_pop_protocolExtension_t *nn_pop_protocolExtensionNew(void);

/// Frees a nn_pop_protocol_extension_t struct.
/// @param protocolExtension A nn_pop_protocol_extension_t struct pointer.
void nn_pop_protocolExtensionFree(nn_pop_protocolExtension_t *protocolExtension);

/// Initialize a nn_pop_protocol_extension_t struct
/// @param protocolExtension A nn_pop_protocol_extension_t struct pointer
nn_pop_protocolExtension_t *nn_pop_protocolExtensionInit(nn_pop_protocolExtension_t *protocolExtension);

/// Initialize a nn_pop_protocol_extension_t struct
/// @param protocolExtension A nn_pop_protocol_extension_t struct pointer
nn_pop_protocolExtension_t *nn_pop_protocolExtensionInitWithExtensionDescription(nn_pop_protocolExtension_t *protocolExtension,
                                                                                 nn_pop_extensionDescription_t *extensionDescription);

/// Creates a nn_pop_protocol_extension_t struct array list.
/// @param protocolExtensionCount A number of nn_pop_protocol_extension_t struct.
nn_pop_protocolExtension_t **nn_pop_protocolExtensionsNew(size_t protocolExtensionCount);

/// Frees a nn_pop_protocol_extension_t struct array list.
/// @param protocolExtensions A nn_pop_protocol_extension_t struct array list.
/// @param protocolExtensionCount A mumber of nn_pop_protocol_extension_t struct.
void nn_pop_protocolExtensionsFree(nn_pop_protocolExtension_t **protocolExtensions, unsigned int protocolExtensionCount);

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* NNPopObjcProtocol_h */
