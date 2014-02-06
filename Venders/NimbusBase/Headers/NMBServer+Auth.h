//
//  NMBServer+Auth.h
//  NimbusBase
//
//  Created by William Remaerd on 1/15/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NMBServer.h"

typedef enum {
    NMBAuthStateSignIn,
    NMBAuthStateIn,
    NMBAuthStateSignOut,
    NMBAuthStateOut,
}NMBAuthState;

typedef enum {
    NMBAuthMethodUndefined,
    NMBAuthMethodUI,
    NMBAuthMethodKeychain,
    NMBAuthMethodNetwork,
}NMBAuthMethod;

@interface NMBServer (Auth)

@property(nonatomic, readonly)NMBAuthState authState;
- (BOOL)authorizeWithController:(UIViewController *)controller;
- (void)signOut;

@end
