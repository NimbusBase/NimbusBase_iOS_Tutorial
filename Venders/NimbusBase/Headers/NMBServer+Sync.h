//
//  NMBServer+Sync.h
//  NimbusBase
//
//  Created by William Remaerd on 2/13/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NMBServer.h"

/**
 * Synchronization Commit Type
 */
typedef NS_ENUM(NSUInteger, NMBSyncCommitType) {
    /** Creation, Update or Deletion applying to an object bases on the last time the object modified, regardless of it's from cloud to local or the reverse. */
    NMBSyncCommitTypeNormal,
    /** The synchronization eliminates all the data on cloud, and upload whole data graph stored in the local database. */
    NMBSyncCommitTypePushEntirely,
    /** The synchronization eliminates all data stored in local database, and rebuild with data download from cloud. */
    NMBSyncCommitTypePullEntirely
};

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
 * @discussion Different from file promise, the returned sync promise is fired immediately after you calling this method. This method invokes synchronizeWithOptions: with NMBSyncCommitTypeNormal for key NMBSyncCommitType as options.
 *
 * @see synchronizeWithOptions:
 */
- (NMBPromise *)synchronize;

/**
 * @brief Synchronize with this cloud server with the options.
 *
 * @param options A dictionary containing key-value pairs that specify how the synchronization calculates which objects should be created, updated or deleted. This value may be nil.
 *
 * @return The synchronization promise.
 *
 * @see synchronize
 */
- (NMBPromise *)synchronizeWithOptions:(NSDictionary *)options;

#pragma mark - Reset Cloud

/**
 * @brief The on going cloud reset promise.
 */
@property (nonatomic, readonly) NMBPromise *resetCloudPromise;

/**
 * @brief Indicates if the server is being reset or not.
 */
@property (nonatomic, readonly) BOOL isResetingCloud;

/**
 * @brief Reset the reciever.
 *
 * @return The reseting promise.
 *
 * @discussion Different from file promise, the returned resetting promise is fired immediately after you calling this method. This method eliminates all the object and binary files managed by nimbus base on cloud.
 */
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
