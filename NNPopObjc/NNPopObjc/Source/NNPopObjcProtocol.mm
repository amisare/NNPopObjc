//
//  NNPopObjcProtocol.m
//  NNPopObjc
//
//  Created by 顾海军 on 2019/11/8.
//

#import "NNPopObjcProtocol.h"
#import <objc/runtime.h>

#import "NNPopObjcMemory.h"


nn_pop_extensionNode_p nn_pop_extensionNodeNew(void) {
    
    nn_pop_extensionNode_p _node = (nn_pop_extensionNode_p)nn_pop_malloc(1 * sizeof(nn_pop_extensionNode_t));
    return _node;
}

nn_pop_extensionNode_p nn_pop_extensionNodeInit(nn_pop_extensionNode_p *node) {
    
    nn_pop_extensionNode_p _node = (nn_pop_extensionNode_p)memset(*node, 0, sizeof(nn_pop_extensionNode_t));
    return _node;
}

nn_pop_extensionNode_p nn_pop_extensionNodeInitWithExtensionDescription(nn_pop_extensionNode_p *node,
                                                                        nn_pop_extensionDescription_t *extensionDescription) {
    nn_pop_extensionNode_p _node = *node;
    nn_pop_extensionDescription_t *_extensionDescription = extensionDescription;
    _node->prefix = _extensionDescription->prefix;
    _node->clazz = objc_getClass(_extensionDescription->clazz);
    _node->where_fp = _extensionDescription->where_fp;
    _node->confromProtocolCount = _extensionDescription->confrom_protocol_count;
    for (unsigned int i = 0; i < _node->confromProtocolCount; i++) {
        _node->confromProtocols[i] = objc_getProtocol(_extensionDescription->confrom_protocols[i]);
    }
    _node->next = NULL;
    
    return _node;
}

nn_pop_extensionNode_p nn_pop_extensionNodeCopy(nn_pop_extensionNode_p dst, nn_pop_extensionNode_p src) {
    
    nn_pop_extensionNode_p _dst = (nn_pop_extensionNode_p)memcpy(dst, src, sizeof(nn_pop_extensionNode_t));
    _dst->next = nil;
    return _dst;
}

unsigned int nn_pop_extensionListCount(nn_pop_extensionNode_p *head) {
    
    nn_pop_extensionNode_p _head = *head;
    
    unsigned int count = 0;
    while (_head) {
        count++;
        _head = _head->next;
    }
    return count;
}

void nn_pop_extensionListAppend(nn_pop_extensionNode_p *head, nn_pop_extensionNode_p *entry) {
    
    if (*head) {
        nn_pop_extensionNode_p node = *head;
        while (node->next != NULL) {
            node = node->next;
        }
        node->next = *entry;
    }
    else {
        *head = *entry;
    }
}

void nn_pop_extensionListFree(nn_pop_extensionNode_p *head) {
    
    while (*head) {
        nn_pop_extensionNode_p node = *head;
        *head = node->next;
        free(node);
    }
}

void nn_pop_extensionListForeach(nn_pop_extensionNode_p *head, void (^enumerateBlock)(nn_pop_extensionNode_p item, BOOL *stop)) {
    
    nn_pop_extensionNode_p node = *head;
    
    BOOL stop = false;
    while (node) {
        if (enumerateBlock && stop == false) {
            enumerateBlock(node, &stop);
        }
        node = node->next;
    }
}

nn_pop_protocolExtension_t *nn_pop_protocolExtensionNew() {
    
    nn_pop_protocolExtension_t *_protocol = (nn_pop_protocolExtension_t *)nn_pop_malloc(1 * sizeof(nn_pop_protocolExtension_t));
    return _protocol;
}

void nn_pop_protocolExtensionFree(nn_pop_protocolExtension_t *protocolExtension) {
    
    nn_pop_protocolExtension_t *_protocolExtension = protocolExtension;
    nn_pop_extensionListFree(&(_protocolExtension->extension));
    free(_protocolExtension);
}

nn_pop_protocolExtension_t *nn_pop_protocolExtensionInit(nn_pop_protocolExtension_t *protocolExtension) {
    
    nn_pop_protocolExtension_t *_protocolExtension = (nn_pop_protocolExtension_t *)memset(protocolExtension, 0, sizeof(nn_pop_protocolExtension_t));
    nn_pop_extensionListFree(&(_protocolExtension->extension));
    return _protocolExtension;
}

nn_pop_protocolExtension_t *nn_pop_protocolExtensionInitWithExtensionDescription(nn_pop_protocolExtension_t *protocolExtension,
                                                                                 nn_pop_extensionDescription_t *extensionDescription) {
    
    nn_pop_protocolExtension_t *_protocolExtension = nn_pop_protocolExtensionInit(protocolExtension);
    nn_pop_extensionDescription_t *_extensionDescription = extensionDescription;
    
    _protocolExtension->protocol = objc_getProtocol(_extensionDescription->protocol);
    
    nn_pop_extensionNode_p _extension = nn_pop_extensionNodeNew();
    nn_pop_extensionNodeInitWithExtensionDescription(&_extension, extensionDescription);
    nn_pop_extensionListAppend(&(_protocolExtension->extension), &_extension);
    
    return _protocolExtension;
}

nn_pop_protocolExtension_t **nn_pop_protocolExtensionsNew(size_t protocolExtensionCount) {
    
    nn_pop_protocolExtension_t **_protocolExtensions = (nn_pop_protocolExtension_t **)nn_pop_malloc(protocolExtensionCount * sizeof(nn_pop_protocolExtension_t *));
    return _protocolExtensions;
}

void nn_pop_protocolExtensionsFree(nn_pop_protocolExtension_t **protocolExtensions, unsigned int protocolExtensionCount) {
    
    for (unsigned int i = 0; i < protocolExtensionCount; i++) {
        nn_pop_protocolExtensionFree(protocolExtensions[i]);
    }
    free(protocolExtensions);
}
