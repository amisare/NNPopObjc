//
//  NNPopObjcProtocol.m
//  NNPopObjc
//
//  Created by 顾海军 on 2019/11/8.
//

#import "NNPopObjcProtocol.h"
#import <objc/runtime.h>
#import "NNPopObjcMemory.h"


nn_pop_extension_node_p nn_pop_extension_node_new(void) {
    
    nn_pop_extension_node_p _node = (nn_pop_extension_node_p)nn_pop_malloc(1 * sizeof(nn_pop_extension_node_t));
    return _node;
}

nn_pop_extension_node_p nn_pop_extension_node_init(nn_pop_extension_node_p *node) {
    
    nn_pop_extension_node_p _node = (nn_pop_extension_node_p)memset(*node, 0, sizeof(nn_pop_extension_node_t));
    return _node;
}

nn_pop_extension_node_p nn_pop_extension_node_init_with_extension_description(nn_pop_extension_node_p *node,
                                                                              nn_pop_extension_description_t *desc) {
    nn_pop_extension_node_p _node = *node;
    nn_pop_extension_description_t *_desc = desc;
    _node->prefix = _desc->prefix;
    _node->clazz = objc_getClass(_desc->clazz);
    _node->where_fp = _desc->where_fp;
    _node->confrom_protocols_count = _desc->confrom_protocols_count;
    for (unsigned int i = 0; i < _node->confrom_protocols_count; i++) {
        _node->confrom_protocols[i] = objc_getProtocol(_desc->confrom_protocols[i]);
    }
    _node->next = NULL;
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


nn_pop_protocol_t *nn_pop_protocol_new() {
    
    nn_pop_protocol_t *_protocol = (nn_pop_protocol_t *)nn_pop_malloc(1 * sizeof(nn_pop_protocol_t));
    return _protocol;
}


void nn_pop_protocol_free(nn_pop_protocol_t *protocol) {
    
    nn_pop_protocol_t *_protocol = protocol;
    nn_pop_extension_list_free(&(_protocol->extension));
    free(_protocol);
}


nn_pop_protocol_t *nn_pop_protocol_init(nn_pop_protocol_t *protocol) {
    
    nn_pop_protocol_t *_protocol = (nn_pop_protocol_t *)memset(protocol, 0, sizeof(nn_pop_protocol_t));
    nn_pop_extension_list_free(&(_protocol->extension));
    return _protocol;
}


nn_pop_protocol_t *nn_pop_protocol_init_with_extension_description(nn_pop_protocol_t *protocol,
                                                                   nn_pop_extension_description_t *desc) {
    
    nn_pop_protocol_t *_protocol = nn_pop_protocol_init(protocol);
    nn_pop_extension_description_t *_desc = desc;
    
    _protocol->protocol = objc_getProtocol(_desc->protocol);

    nn_pop_extension_node_p _extension = nn_pop_extension_node_new();
    nn_pop_extension_node_init_with_extension_description(&_extension, desc);
    nn_pop_extension_list_append(&(_protocol->extension), &_extension);
    
    return _protocol;
}

nn_pop_protocol_t **nn_pop_protocols_new(size_t protocol_count) {
    
    nn_pop_protocol_t **_protocols = (nn_pop_protocol_t **)nn_pop_malloc(protocol_count * sizeof(nn_pop_protocol_t *));
    return _protocols;
}


void nn_pop_protocols_free(nn_pop_protocol_t **protocols, unsigned int protocol_count) {
    
    for (unsigned int i = 0; i < protocol_count; i++) {
        nn_pop_protocol_free(protocols[i]);
    }
    free(protocols);
}
