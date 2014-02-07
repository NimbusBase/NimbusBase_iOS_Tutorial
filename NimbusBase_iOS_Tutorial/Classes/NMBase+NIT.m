//
//  NMBase+NPA.m
//  NimbusPhotoAlbum
//
//  Created by William Remaerd on 1/17/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NMBase+NIT.h"
#import "NITAppDelegate.h"

@implementation NMBase (NIT)

+ (NMBase *)sharedBase{
    static dispatch_once_t once;
    static NMBase *base;
    dispatch_once(&once, ^{
        NSManagedObjectContext *ctx = [(NITAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        base = [[NMBase alloc] initWithMOContext:ctx configs:self.configs];
    });
    return base;
}

+ (NSDictionary *)configs{
    static NSString *const kAppName = @"YourAppName";
    return @{
             NCfgK_Servers: @[
                     @{
                         NCfgK_AppName: kAppName,
                         NCfgK_Cloud: NCfgV_GDrive,
                         NCfgK_AppID: @"573163675535-5nj0q1t3lspohv5dj9bhg1b70a4ihbqh.apps.googleusercontent.com",
                         NCfgK_AppSecret: @"Jkkel_Z8XLO8ecND5sCX5uBq",
                         },
                     @{
                         NCfgK_AppName: kAppName,
                         NCfgK_Cloud: NCfgV_Dropbox,
                         NCfgK_AppID: @"vl4r226lxo4dok1",
                         NCfgK_AppSecret: @"b9d86w0aekl18ly",
                         },
                     @{
                         NCfgK_AppName: kAppName,
                         NCfgK_Cloud: NCfgV_Box,
                         NCfgK_AppID: @"eaofybj13ha01qnx4cea2auowdnvwnwc",
                         NCfgK_AppSecret: @"sTARCW3Asza5ZORLst1Ni2GjrhwlR66p",
                         },
                     ]
             };
}

@end
