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
    return [self.class authStateActionString:self.authState];
}

+ (NSString *)authStateActionString:(NMBAuthState)state{
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

- (NSString *)cloudType{
    NSString *className = NSStringFromClass(self.class);
    NSString *type = nil;
    if ([className isEqualToString:@"NMBGDrive"]) {
        type = @"Google Drive";
    } else if ([className isEqualToString:@"NMBDropbox"]) {
        type = @"Dropbox";
    } else if ([className isEqualToString:@"NMBBox"]) {
        type = @"Box";
    }
    return type;
}

- (NSString *)iconName{
    NSString *className = NSStringFromClass(self.class);
    NSString *name = nil;
    if ([className isEqualToString:@"NMBGDrive"]) {
        name = @"iconGDrive";
    } else if ([className isEqualToString:@"NMBDropbox"]) {
        name = @"iconDropbox";
    } else if ([className isEqualToString:@"NMBBox"]) {
        name = @"iconBox";
    }
    return name;
}

- (NSString *)syncStateAction
{
    return self.isSynchronizing ? @"Synchronizing" : @"Synchronize";
}

@end
