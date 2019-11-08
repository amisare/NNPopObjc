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


/// Extension description list node
typedef struct nn_pop_extension_node {
    /// Prefix of extension implementation class name
    const char *prefix;
    /// Extension implemention Class
    Class clazz;
    /// Where clause function pointer
    where_fp where_fp;
    /// Count of protocols that the adopted class should be confrom to.
    unsigned int confrom_protocols_count;
    /// Protocols that the adopted class should be confrom to.
    Protocol *confrom_protocols[20];
    /// Next extension list node.
    struct nn_pop_extension_node *next;
} nn_pop_extension_node_t, *nn_pop_extension_node_p;

/// Protocol extension description
typedef struct {
    /// Protocol be extended
    Protocol *protocol;
    /// Protocol extension descriptions
    nn_pop_extension_node_p extension;
} nn_pop_protocol_t;


nn_pop_extension_node_p nn_pop_extension_node_new();
nn_pop_extension_node_p nn_pop_extension_node_copy(nn_pop_extension_node_p dst, nn_pop_extension_node_p src);

unsigned int nn_pop_extension_list_count(nn_pop_extension_node_p *head);
void nn_pop_extension_list_append(nn_pop_extension_node_p *head, nn_pop_extension_node_p *entry);
void nn_pop_extension_list_free(nn_pop_extension_node_p *head);
void nn_pop_extension_list_foreach(nn_pop_extension_node_p *head, void (^enumerate_block)(nn_pop_extension_node_p item, BOOL *stop));

nn_pop_protocol_t *nn_pop_protocols_new(unsigned int protocol_count);
void nn_pop_protocols_free(nn_pop_protocol_t *protocols, unsigned int protocol_count);


#ifdef __cplusplus
}
#endif //__cplusplus

#endif /* NNPopObjcProtocol_h */
