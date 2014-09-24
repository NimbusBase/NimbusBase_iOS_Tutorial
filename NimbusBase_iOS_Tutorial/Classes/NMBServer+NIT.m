//
//  NMBServer+UI.m
//  NimbusTester
//
//  Created by William Remaerd on 1/14/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NMBServer+NIT.h"

@implementation NMBServer (NIT)

- (NSString *)authStateAction
{
    return [self.class authStateActionString:self.authState];
}

+ (NSString *)authStateActionString:(NMBAuthState)state
{
    NSString *string = @"None";
    switch (state) {
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

+ (NSString *)authStateString:(NMBAuthState)state
{
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

- (NSString *)cloudType
{
    static NSDictionary *map = nil;
    
    if (!map) {
        map = @{
                 NCfgV_GDrive: @"Google Drive",
                 NCfgV_Dropbox: @"Dropbox",
                 NCfgV_Box: @"Box",
                 };
    }
    
    return map[self.cloud];
}

- (NSString *)iconName
{
    static NSDictionary *map = nil;
    
    if (!map) {
        map = @{
                 NCfgV_GDrive: @"iconGDrive",
                 NCfgV_Dropbox: @"iconDropbox",
                 NCfgV_Box: @"iconBox",
                 };
    }
    
    return map[self.cloud];
}

- (NSString *)syncStateAction
{
    return self.isSynchronizing ? @"Synchronizing" : @"Synchronize";
}

@end
