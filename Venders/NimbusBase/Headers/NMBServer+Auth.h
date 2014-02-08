//
//  NMBServer+Auth.h
//  NimbusBase
//
//  Created by William Remaerd on 1/15/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NMBServer.h"

/**
 * Authentication State
 */
typedef NS_ENUM(NSUInteger, NMBAuthState) {
    /** In the progress of signing in. */
    NMBAuthStateSignIn,
    /** Succeed to sign in. */
    NMBAuthStateIn,
    /** In the progress of signing out. */
    NMBAuthStateSignOut,
    /** Already sign out. */
    NMBAuthStateOut,
};

@interface NMBServer (Auth)

/**
 * @brief Indicates the current state of NMBServer in authentication flow.
 */
@property(nonatomic, readonly)NMBAuthState authState;

/**
 * @brief Authenticate with a instance of UIViewController can interact with user.
 *
 * @param controller The instance of UIViewController will present the authentication controller.
 *
 * @return Indicates whether the server is in proper state and can authenticate with UIViewController.
 */
- (BOOL)authorizeWithController:(UIViewController *)controller;

/**
 * @brief Sign out.
 */
- (void)signOut;

@end
