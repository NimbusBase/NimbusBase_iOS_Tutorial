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

extern NSString *const NMBNotiAuthBegin;
extern NSString *const NMBNotiAuthDidSucceed;
extern NSString *const NMBNotiAuthDidFail;
extern NSString *const NMBNotiAuthDidCancel;
extern NSString *const NMBNotiAuthDidSignOut;

extern NSString *const NMBNotiInitializeDidSucceed;
extern NSString *const NMBNotiInitializeDidFail;

extern NSString *const NKeyMethod;