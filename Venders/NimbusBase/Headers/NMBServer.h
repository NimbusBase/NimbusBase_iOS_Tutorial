//
//  NMBServer.h
//  NimbusBase_iOS
//
//  Created by William Remaerd on 1/3/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NMBConfigurableObject.h"

extern const struct NMBServerProperties {
	__unsafe_unretained NSString *authState;
	__unsafe_unretained NSString *isInitialized;
	__unsafe_unretained NSString *isSynchronizing;
} NMBServerProperties;

@class NMBase;

/**
 * NMBServer represents an app of Google Drive, Dropbox or Box.
 */
@interface NMBServer : NMBConfigurableObject

@property(nonatomic, readonly, weak)NMBase *base;
@property(nonatomic, readonly, copy)NSString *cloud;
@property(nonatomic, readonly, copy)NSString *name;

- (BOOL)run;

@end
