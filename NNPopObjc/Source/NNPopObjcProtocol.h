//
//  NNPopObjcProtocol.h
//  NNPopObjc
//
//  Created by GuHaijun on 2019/11/8.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#ifndef NNPopObjcProtocol_h
#define NNPopObjcProtocol_h

#import <Foundation/Foundation.h>
#import <functional>
#import <vector>
#import <unordered_map>

#import "NNPopObjcDescription.h"

using namespace std;

namespace popobjc {

/// Extension description struct.
typedef nn_pop_extension_description_t ExtensionDescription;

/// Protocol extension struct.
struct ProtocolExtension {

public:
    /// Protocol be extended.
    vector<const char *> protocols;
    /// Protocol extension descriptions.
    unordered_map<const char *, vector<ExtensionDescription *>> extensions;
    /// All protocol extension classes.
    vector<const char *> clazzes;
    
    void append(ExtensionDescription *extensionDescription, unsigned int count);
    
    ProtocolExtension() = default;
    ~ProtocolExtension();
};

}

#endif /* NNPopObjcProtocol_h */
