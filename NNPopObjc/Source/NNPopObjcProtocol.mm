//
//  NNPopObjcProtocol.m
//  NNPopObjc
//
//  Created by 顾海军 on 2019/11/8.
//

#import "NNPopObjcProtocol.h"
#import <objc/runtime.h>
#import "NNPopObjcLogging.h"

namespace popobjc {

ExtensionNode::ExtensionNode(const ExtensionNode *extensionNode) : ExtensionNode() {
    
    const ExtensionNode *_extensionNode = extensionNode;
    this->prefix = _extensionNode->prefix;
    this->clazz = _extensionNode->clazz;
    this->where_fp = _extensionNode->where_fp;
    this->confromProtocolCount = _extensionNode->confromProtocolCount;
    for (unsigned int i = 0; i < this->confromProtocolCount; i++) {
        this->confromProtocols[i] = _extensionNode->confromProtocols[i];
    }
    this->next = NULL;
}

ExtensionNode::ExtensionNode(const ExtensionDescription *extensionDescription) : ExtensionNode() {
    
    const ExtensionDescription *_extensionDescription = extensionDescription;
    this->prefix = _extensionDescription->prefix;
    this->clazz = objc_getClass(_extensionDescription->clazz);
    this->where_fp = _extensionDescription->where_fp;
    this->confromProtocolCount = _extensionDescription->confrom_protocol_count;
    for (unsigned int i = 0; i < this->confromProtocolCount; i++) {
        this->confromProtocols[i] = objc_getProtocol(_extensionDescription->confrom_protocols[i]);
    }
    this->next = NULL;
}

ExtensionNode::~ExtensionNode() {
    
}


ExtensionList::~ExtensionList() {
    
    this->clear();
}

unsigned int ExtensionList::count() {
    
    ExtensionNode *_head = this->_head;
    
    unsigned int count = 0;
    while (_head) {
        count++;
        _head = _head->next;
    }
    return count;
}

ExtensionNode *ExtensionList::head() {
    
    return this->_head;
}

void ExtensionList::head(ExtensionNode *node) {
    
    this->_head = node;
}

void ExtensionList::append(ExtensionNode *entry) {
    
    ExtensionNode *_head = this->_head;
    
    if (_head) {
        ExtensionNode *node = _head;
        while (node->next != NULL) {
            node = node->next;
        }
        node->next = entry;
    }
    else {
        this->_head = entry;
    }
}

void ExtensionList::foreach(std::function<void(ExtensionNode *item, BOOL *stop)> enumerater) {
    
    ExtensionNode *node = this->_head;
    
    BOOL stop = false;
    while (node) {
        if (enumerater && stop == false) {
            enumerater(node, &stop);
        }
        node = node->next;
    }
}

void ExtensionList::clear() {
    
    while (this->_head) {
        ExtensionNode *node = this->_head;
        this->_head = node->next;
        delete node;
    }
}


ProtocolExtension::ProtocolExtension(const ExtensionDescription *extensionDescription) : ProtocolExtension() {
    
    ExtensionNode *_extension = new ExtensionNode(extensionDescription);
    this->protocol = objc_getProtocol(extensionDescription->protocol);
    this->extension.append(_extension);
}

ProtocolExtension::~ProtocolExtension() {
    
}

} // namespace popobjc

