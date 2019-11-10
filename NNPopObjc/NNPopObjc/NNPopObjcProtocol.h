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
#endif //__cplusplus


/// Extension description list node.
typedef struct nn_pop_extension_node {
    /// Prefix of extension implementation class name.
    const char *prefix;
    /// Extension implemention Class.
    Class clazz;
    /// Where clause function pointer.
    where_fp where_fp;
    /// Count of protocols that the adopted class should be confrom to.
    unsigned int confrom_protocols_count;
    /// Protocols that the adopted class should be confrom to.
    Protocol *confrom_protocols[20];
    /// Next extension list node.
    struct nn_pop_extension_node *next;
} nn_pop_extension_node_t, *nn_pop_extension_node_p;

/// Protocol extension description.
typedef struct {
    /// Protocol be extended.
    Protocol *protocol;
    /// Protocol extension descriptions.
    nn_pop_extension_node_p extension;
} nn_pop_protocol_t;


/// Creates a node.
nn_pop_extension_node_p nn_pop_extension_node_new(void);

/// Copys a node from src to dst.
/// @param dst dst node
/// @param src src node
nn_pop_extension_node_p nn_pop_extension_node_copy(nn_pop_extension_node_p dst, nn_pop_extension_node_p src);


/// Gets node count in list.
/// @param head A list head
unsigned int nn_pop_extension_list_count(nn_pop_extension_node_p *head);

/// Appends a node at the tail of list.
/// @param head A list head
/// @param entry A node
void nn_pop_extension_list_append(nn_pop_extension_node_p *head, nn_pop_extension_node_p *entry);

/// Frees a list.
/// @param head A list head
void nn_pop_extension_list_free(nn_pop_extension_node_p *head);

/// Executes a given block using each object in the list, starting with the first object and continuing through the list to the last object.
/// @param head A list head
void nn_pop_extension_list_foreach(nn_pop_extension_node_p *head, void (^enumerate_block)(nn_pop_extension_node_p item, BOOL *stop));


/// Creates a nn_pop_protocol_t struct array list.
/// @param protocol_count A number of nn_pop_protocol_t struct.
nn_pop_protocol_t *nn_pop_protocols_new(size_t protocol_count);

/// Frees a nn_pop_protocol_t struct array list.
/// @param protocols A nn_pop_protocol_t struct array list.
/// @param protocol_count A mumber of nn_pop_protocol_t struct.
void nn_pop_protocols_free(nn_pop_protocol_t *protocols, unsigned int protocol_count);


#ifdef __cplusplus
}
#endif //__cplusplus

#endif /* NNPopObjcProtocol_h */
