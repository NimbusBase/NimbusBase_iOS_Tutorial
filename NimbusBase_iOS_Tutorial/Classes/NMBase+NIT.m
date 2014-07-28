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
        
        NITAppDelegate *appDelegate = (NITAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        base = [[NMBase alloc] initWithPSCoordinator:appDelegate.persistentStoreCoordinator
                                             configs:self.configs];
        
        NSManagedObjectContext *nmbMOC = base.userMOContext;
        
        NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
        [noti addObserver:appDelegate
                 selector:@selector(mergeNMBMOContextWithNotification:)
                     name:NSManagedObjectContextDidSaveNotification
                   object:nmbMOC];
        
        [noti addObserver:appDelegate
                 selector:@selector(handleNMBUserContextSaveErrorNotification:)
                     name:NMBNotiUserContextSaveError
                   object:base];

    });
    return base;
}

+ (NSDictionary *)configs{
    static NSString *const kAppName = @"Nimbus iOS Tutorial";
    return @{
             NCfgK_Servers: @[
                     @{
                         NCfgK_AppName: kAppName,
                         NCfgK_Cloud: NCfgV_GDrive,
                         NCfgK_AppID: @"467471168650-9v08j5mruji6gcskp2ovam903o6g6nsc.apps.googleusercontent.com",
                         NCfgK_AppSecret: @"HgyksCpZ9g7m2wdOJHbB0tOs",
                         },
                     @{
                         NCfgK_AppName: kAppName,
                         NCfgK_Cloud: NCfgV_Dropbox,
                         NCfgK_AppID: @"x0e7vb4ls3lub5d",
                         NCfgK_AppSecret: @"jl1xp49sumwe7tf",
                         },
                     @{
                         NCfgK_AppName: kAppName,
                         NCfgK_Cloud: NCfgV_Box,
                         NCfgK_AppID: @"eky66lnq5fnlmulhos7080u1c4a2isv2",
                         NCfgK_AppSecret: @"6bMkjEzGKU1ghcmXbCii32ykGHJp4xZT",
                         },
                     ]
             };
}

@end
