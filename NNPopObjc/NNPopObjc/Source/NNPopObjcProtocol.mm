//
//  NNPopObjcProtocol.m
//  NNPopObjc
//
//  Created by 顾海军 on 2019/11/8.
//

#import "NNPopObjcProtocol.h"
#import <objc/runtime.h>

#import "NNPopObjcMemory.h"


nn_pop_extensionNode::nn_pop_extensionNode(nn_pop_extensionDescription_t *extensionDescription) : nn_pop_extensionNode() {
    
    nn_pop_extensionDescription_t *_extensionDescription = extensionDescription;
    this->prefix = _extensionDescription->prefix;
    this->clazz = objc_getClass(_extensionDescription->clazz);
    this->where_fp = _extensionDescription->where_fp;
    this->confromProtocolCount = _extensionDescription->confrom_protocol_count;
    for (unsigned int i = 0; i < this->confromProtocolCount; i++) {
        this->confromProtocols[i] = objc_getProtocol(_extensionDescription->confrom_protocols[i]);
    }
    this->next = NULL;
}

nn_pop_extensionNode::~nn_pop_extensionNode(void) {
    
}

nn_pop_extensionNode *nn_pop_extensionNode::copy(void) {
    
    nn_pop_extensionNode *newNode = new nn_pop_extensionNode();
    newNode->prefix = this->prefix;
    newNode->clazz = this->clazz;
    newNode->where_fp = this->where_fp;
    newNode->confromProtocolCount = this->confromProtocolCount;
    for (unsigned int i = 0; i < this->confromProtocolCount; i++) {
        newNode->confromProtocols[i] = this->confromProtocols[i];
    }
    newNode->next = NULL;
    return newNode;
}


nn_pop_extensionList::~nn_pop_extensionList(void) {
    
    this->clear();
}

unsigned int nn_pop_extensionList::count(void) {
    
    nn_pop_extensionNode *_head = this->_head;
    
    unsigned int count = 0;
    while (_head) {
        count++;
        _head = _head->next;
    }
    return count;
}

nn_pop_extensionNode *nn_pop_extensionList::head(void) {
    
    return this->_head;
}

void nn_pop_extensionList::head(nn_pop_extensionNode *node) {
    
    this->_head = node;
}

void nn_pop_extensionList::append(nn_pop_extensionNode *entry) {
    
    nn_pop_extensionNode *_head = this->_head;
    
    if (_head) {
          nn_pop_extensionNode *node = _head;
          while (node->next != NULL) {
              node = node->next;
          }
          node->next = entry;
      }
      else {
          this->_head = entry;
      }
}

void nn_pop_extensionList::foreach(std::function<void(nn_pop_extensionNode *item, BOOL *stop)> enumerater) {
    
    nn_pop_extensionNode *node = this->_head;
    
    BOOL stop = false;
    while (node) {
        if (enumerater && stop == false) {
            enumerater(node, &stop);
        }
        node = node->next;
    }
}

void nn_pop_extensionList::clear(void) {
    
    while (this->_head) {
        nn_pop_extensionNode *node = this->_head;
        this->_head = node->next;
        delete node;
    }
}


nn_pop_protocolExtension::nn_pop_protocolExtension(nn_pop_extensionDescription_t *extensionDescription) : nn_pop_protocolExtension() {
    
    nn_pop_extensionNode *_extension = new nn_pop_extensionNode(extensionDescription);
    this->protocol = objc_getProtocol(extensionDescription->protocol);
    this->extension.append(_extension);
}

nn_pop_protocolExtension::~nn_pop_protocolExtension(void) {
    
}

