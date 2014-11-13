//
//  NMBPromise.h
//  NimbusBase
//
//  Created by William Remaerd on 1/8/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NMBCallback.h"

extern const struct NMBPromiseProperties {
	__unsafe_unretained NSString *progress;
} NMBPromiseProperties;

@class NMBPromise, NMBResponse;

/**
 * Promise State
 */
typedef NS_ENUM(NSUInteger, NMBPromiseState)
{
    /** There may be a mistake happened, so the promise turn into an unknown state. */
    NMBPromiseStateUnknown,
    /** The promise is just initialized. */
    NMBPromiseStatePending,
    /** The promise is already fire, but get no response yet. */
    NMBPromiseStateRunning,
    /** The promise is successful. */
    NMBPromiseStateSucceeded,
    /** The promise is failed. */
    NMBPromiseStateFailed,
    /** The promise is cancelled. */
    NMBPromiseStateCancelled,
};

@protocol NMBPromiseDelegate <NSObject>

@optional
- (BOOL)promiseShouldClean:(NMBPromise *)promise;
- (void)promiseDidCallback:(NMBPromise *)promise;

@end

/**
 * NMBPromise manages network operations. You can set success/fail callback on it, get progress of it, and more.
 */
@interface NMBPromise : NSObject

/**
 * @brief Initialize a newly allocated promise object with the userInfo.
 *
 * @param userInfo An instance of NSDictionary that can be access in every blocks of the promise.
 */
- (id)initWithUserInfo:(NSDictionary *)userInfo;

/**
 * @brief The state of promise, it could be processing, succeeded, failed, cancelled and so on.
 */
@property (nonatomic, readonly) NMBPromiseState state;

/**
 * @brief The method of the promise. This property describe what does the promise do in a string.
 */
@property (nonatomic, copy) NSString *method;

@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, weak) id<NMBPromiseDelegate> delegate;

@property (nonatomic, readonly) NMBResponse *response;

#pragma mark - Progress

/**
 * @brief The progress of the network operation.
 */
@property (nonatomic, readonly) float progress;

#pragma mark - Callbacks

/**
 * @brief Add a response callback. Will be called in consequence of success or fail.
 *
 * @param response The block contains the callback code.
 * 
 * @see onQueue:response:
 */
- (instancetype)response:(NMBPromiseResponse)response;

/**
 * @brief Add a response callback on the specific queue. Will be called in consequence of success or fail.
 *
 * @param response The block contains the callback code.
 * @param queue The queue on which the callback will be called. If nil passed, the callback will be run on the main queue.
 *
 * @see response:
 */
- (instancetype)onQueue:(dispatch_queue_t)queue
               response:(NMBPromiseResponse)response;

/**
 * @brief Add a success callback.
 *
 * @param success The block contains the callback code.
 *
 * @see onQueue:success:
 */
- (instancetype)success:(NMBPromiseSuccess)success;

/**
 * @brief Add a success callback on the specific queue.
 *
 * @param success The block contains the callback code.
 * @param queue The queue on which the callback will be called. If nil passed, the callback will be run on the main queue.
 *
 * @see success:
 */
- (instancetype)onQueue:(dispatch_queue_t)queue
                success:(NMBPromiseSuccess)success;

/**
 * @brief Add a fail callback.
 *
 * @param fail The block contains the callback code.
 *
 * @see onQueue:fail:
 */
- (instancetype)fail:(NMBPromiseFail)fail;

/**
 * @brief Add a fail callback on the specific queue.
 *
 * @param fail The block contains the callback code.
 * @param queue The queue on which the callback will be called. If nil passed, the callback will be run on the main queue.
 *
 * @see fail:
 */
- (instancetype)onQueue:(dispatch_queue_t)queue
                   fail:(NMBPromiseFail)fail;
/**
 * @brief Add a progress callback.
 *
 * @param progress The block contains the callback code.
 *
 * @see onQueue:progress:
 */
- (instancetype)progress:(NMBPromiseProgress)progress;

/**
 * @brief Add a progress callback on the specific queue.
 *
 * @param progress The block contains the callback code.
 * @param queue The queue on which the callback will be called. If nil passed, the callback will be run on the main queue.
 *
 * @see progress:
 */
- (instancetype)onQueue:(dispatch_queue_t)queue
               progress:(NMBPromiseProgress)progress;

#pragma mark - Actions

/**
 * @brief After you get an instance of NMBPromise don't forget to call method go on it, or nothing will happen.
 */
- (void)go;

/**
 * @brief Cancel the network operation. Not all kinds of operations can be cancelled.
 */
- (void)cancel;

/**
 * @brief Retry the promise if it is failed.
 */
- (void)retry;


#pragma mark - User Info
@property(nonatomic, readonly, strong)NSMutableDictionary *userInfo;
- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)object forKeyedSubscript:(id <NSCopying>)aKey;

@end

extern NSString
*const NMBPromiseDetailedErrorsKey,
*const NMBPromiseErrorDomain;

extern NSInteger const
NMBPromiseCancelError,
NMBMultiplePromiseErrorsError;

extern NSString
*const NMBPromiseErrorKey;

