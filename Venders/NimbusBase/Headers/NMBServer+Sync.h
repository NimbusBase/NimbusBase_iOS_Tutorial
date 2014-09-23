//
//  NMBServer+Sync.h
//  NimbusBase
//
//  Created by William Remaerd on 2/13/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NMBServer.h"

@class NMBPromise;

@interface NMBServer (Sync)

#pragma mark - Sync

/**
 * @brief The on going synchronization promise.
 */
@property (nonatomic, readonly) NMBPromise *syncPromise;

/**
 * @brief Indicates if the server is synchronizing or not.
 */
@property (nonatomic, readonly) BOOL isSynchronizing;

/**
 * @brief Synchronize with this cloud server.
 *
 * @return The synchronization promise.
 *
 * @discussion Different from file promise, the returned sync promise is fired immediately after you calling this method. So you are supposed not to add callbacks methods on it, except progress update callback. Or you can observe the attribute progress of the promise.
 */
- (NMBPromise *)synchronize;

- (NMBPromise *)synchronizeWithOptions:(NSDictionary *)options;

#pragma mark - Reset Cloud

@property (nonatomic, readonly) NMBPromise *resetCloudPromise;
@property (nonatomic, readonly) BOOL isResetingCloud;

- (NMBPromise *)resetCloud;

#pragma mark - IPush

/**
 * @brief Indicates if the server is ready to push your changes to cloud immediately.
 *
 * @discussion "iPush" is short for "immediately push". Different from synchronization, iPush only push local changes to cloud without fetching changes from cloud. And every time you save the tracked NSManagedContext, iPush is fired. To active iPush, server need to acquire directory structure of the root folder. In most cases, this means you need to sync at least once.
 */
@property (nonatomic, readonly) BOOL isReadyToIPush;

@end

extern NSString
*const NValSynchronizeErrorDomain;

extern NSInteger const
NValSynchronizeOptionsError,
NValUnacquaintedStoreError,
NValModelsNotCompatibleError,
NValPreviousSyncStillProcessingError,
NValSynchronizeError;
