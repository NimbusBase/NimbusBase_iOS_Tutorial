//
//  NMBConstants.h
//  NimbusBase
//
//  Created by William Remaerd on 1/8/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString
*const NValMIMEFolder,
*const NValMIMEBinary;

extern NSString
*const NKeyPrmsFile,
*const NKeyPrmsForm,
*const NKeyPrmsParent;

extern NSString
*const NValMethodCreate,
*const NValMethodRetrieve,
*const NValMethodUpdate,
*const NValMethodDelete,
*const NValMethodRename,
*const NValMethodUserMe,
*const NValMethodSync;

extern NSString
*const NKeyAccountID,
*const NKeyPassword;

extern NSString
*const NKeySyncCommitType;

typedef NS_ENUM(NSUInteger, NMBSyncCommitType) {
    NMBSyncCommitTypeNormal,
    NMBSyncCommitTypePushEntirely,
    NMBSyncCommitTypePullEntirely
};