//
//  NMBSettings.h
//  NimbusBase_iOS
//
//  Created by William Remaerd on 1/3/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMBConfigs : NSObject
@end

extern NSString *const NCfgK_Servers;
extern NSString *const NCfgK_Cloud;
extern NSString *const NCfgV_GDrive;
extern NSString *const NCfgV_Dropbox;
extern NSString *const NCfgV_Box;

extern NSString *const NCfgK_AppName;

//GDriveClientID, DropboxAppKey
extern NSString *const NCfgK_AppID;
//GDriveClientSecret, DropboxAppSecret
extern NSString *const NCfgK_AppSecret;

//kGTLAuthScope*, DropBoxAccessType
extern NSString *const NCfgK_AuthScope;
extern NSString *const NCfgV_Root;
extern NSString *const NCfgV_AppData;


