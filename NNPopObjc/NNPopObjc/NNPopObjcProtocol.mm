//
//  NNPopObjcProtocol.m
//  NNPopObjc
//
//  Created by 顾海军 on 2019/11/8.
//

#import "NNPopObjcProtocol.h"


nn_pop_extension_node_p nn_pop_extension_node_new(void) {
    
    nn_pop_extension_node_p node = (nn_pop_extension_node_p )calloc(1, sizeof(nn_pop_extension_node_t));
    return node;
}


nn_pop_extension_node_p nn_pop_extension_node_copy(nn_pop_extension_node_p dst, nn_pop_extension_node_p src) {
    
    nn_pop_extension_node_p _dst = (nn_pop_extension_node_p)memcpy(dst, src, sizeof(nn_pop_extension_node_t));
    _dst->next = nil;
    return _dst;
}


unsigned int nn_pop_extension_list_count(nn_pop_extension_node_p *head) {
    
    nn_pop_extension_node_p _head = *head;
    
    unsigned int count = 0;
    while (_head) {
        count++;
        _head = _head->next;
    }
    return count;
}


void nn_pop_extension_list_append(nn_pop_extension_node_p *head, nn_pop_extension_node_p *entry) {
    
    if (*head) {
        nn_pop_extension_node_p node = *head;
        while (node->next != NULL) {
            node = node->next;
        }
        node->next = *entry;
    }
    else {
        *head = *entry;
    }
}


void nn_pop_extension_list_free(nn_pop_extension_node_p *head) {
    
    while (*head) {
        nn_pop_extension_node_p node = *head;
        *head = node->next;
        free(node);
    }
}


void nn_pop_extension_list_foreach(nn_pop_extension_node_p *head, void (^enumerate_block)(nn_pop_extension_node_p item, BOOL *stop)) {
    
    nn_pop_extension_node_p node = *head;
    
    BOOL stop = false;
    while (node) {
        if (enumerate_block && stop == false) {
            enumerate_block(node, &stop);
        }
        node = node->next;
    }
}


nn_pop_protocol_t *nn_pop_protocols_new(size_t protocol_count) {
    
    nn_pop_protocol_t *protocols = (nn_pop_protocol_t *)calloc(protocol_count, sizeof(nn_pop_protocol_t));
    return protocols;
}


void nn_pop_protocols_free(nn_pop_protocol_t *protocols, unsigned int protocol_count) {
    
    for (unsigned int i = 0; i < protocol_count; i++) {
        // free extension list
        nn_pop_extension_list_free(&(protocols[i].extension));
    }
    free(protocols);
}
