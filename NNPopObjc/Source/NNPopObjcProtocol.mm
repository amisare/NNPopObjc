//
//  NNPopObjcProtocol.m
//  NNPopObjc
//
//  Created by GuHaijun on 2019/11/8.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNPopObjcProtocol.h"
#import <objc/runtime.h>
#import "NNPopObjcLogging.h"

namespace popobjc {

void ProtocolExtension::append(ExtensionDescription *extensionDescription, unsigned int count) {
    
    for (unsigned int i = 0; i < count; i++) {
        ExtensionDescription *_extensionDescription = &extensionDescription[i];
        this->extensions[_extensionDescription->protocol].push_back(_extensionDescription);
        this->clazzes.push_back(_extensionDescription->clazz);
    }
    this->protocols.clear();
    for (auto extension : this->extensions) {
        this->protocols.push_back(extension.first);
    }
     
    // Sort by protocol's priority，reverse order
    std::sort(this->protocols.begin(), this->protocols.end(), [=](const char *lhs, const char *rhs) {
        // A higher return value here means a higher priority
        std::function<int(const char *protocol)> protocolPriority = [=](const char *protocol) {
            int runningTotal = 0;
            for (auto extension : this->extensions) {
                if (extension.first == protocol) {
                    continue;
                }
                if (protocol_conformsToProtocol(objc_getProtocol(protocol), objc_getProtocol(extension.first))) {
                    runningTotal++;
                }
            }
            return runningTotal;
        };
        int l_protocolPriority = protocolPriority(lhs);
        int r_protocolPriority = protocolPriority(rhs);
        return l_protocolPriority > r_protocolPriority;
    });
}

ProtocolExtension::~ProtocolExtension() {
    
}

} // namespace popobjc

