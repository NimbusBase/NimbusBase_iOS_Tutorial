//
//  NMBNotificationCenter.h
//  NimbusBase_iOS
//
//  Created by William Remaerd on 1/3/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSNoti ([NSNotificationCenter defaultCenter])
#define NMBNoti NSNoti

extern NSString
*const NMBNotiAuthBegin,
*const NMBNotiAuthDidSucceed,
*const NMBNotiAuthDidFail,
*const NMBNotiAuthDidCancel,
*const NMBNotiAuthDidSignOut;

extern NSString
*const NMBNotiInitializeDidSucceed,
*const NMBNotiInitializeDidFail;

extern NSString
*const NKeyNotiResponse,
*const NKeyNotiMethod,
*const NKeyNotiAccountInfo,
*const NKeyNotiError;

extern NSString
*const NMBNotiUserContextSaveError;

extern NSString
*const NMBNotiSyncDidSucceed,
*const NMBNotiSyncDidFail;

/** This category is used by NimbusBase to post notifications via NSNotificationCenter.
 
 The supported names of notifications by now.
 
 
 About Authorize:
 
 - NMBNotiAuthBegin
 - NMBNotiAuthDidSucceed
 - NMBNotiAuthDidFail
 - NMBNotiAuthDidCancel
 - NMBNotiAuthDidSignOut

 
 About Initialize:
 
 - NMBNotiInitializeDidSucceed
 - NMBNotiInitializeDidFail
 
 
 About Sync:

 - NMBNotiSyncDidSucceed
 - NMBNotiSyncDidFail
 - NMBNotiUserContextSaveError

 */
@interface NSNotificationCenter (NMBNotification)

- (void)postOnMainThreadName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;
- (void)postOnMainThreadName:(NSString *)aName object:(id)anObject;

@end