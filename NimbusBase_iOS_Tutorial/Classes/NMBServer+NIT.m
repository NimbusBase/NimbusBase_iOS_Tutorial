//
//  NMBServer+UI.m
//  NimbusTester
//
//  Created by William Remaerd on 1/14/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NMBServer+NIT.h"

@implementation NMBServer (NIT)

- (NSString *)authStateAction{
    NSString *string = @"None";
    switch (self.authState) {
        case NMBAuthStateSignIn:{
            string = @"Signing In";
        }break;
        case NMBAuthStateIn:{
            string = @"Sign Out";
        }break;
        case NMBAuthStateSignOut:{
            string = @"Signing Out";
        }break;
        case NMBAuthStateOut:{
            string = @"Sign In";
        }break;
        default:{
        }break;
    }
    
    return string;
}

+ (NSString *)authStateString:(NMBAuthState)state{
    NSString *string = @"None";
    switch (state) {
        case NMBAuthStateSignIn:{
            string = @"Signing In";
        }break;
        case NMBAuthStateIn:{
            string = @"In";
        }break;
        case NMBAuthStateSignOut:{
            string = @"Signing Out";
        }break;
        case NMBAuthStateOut:{
            string = @"Out";
        }break;
        default:{
        }break;
    }
    
    return string;
}

@end
