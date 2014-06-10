//
//  NMBPromise.h
//  NimbusBase
//
//  Created by William Remaerd on 1/8/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const struct NMBPromiseProperties {
	__unsafe_unretained NSString *progress;
} NMBPromiseProperties;

@class NMBPromise;

typedef void(^NMBPromiseResponse)(NMBPromise *promise, id response, NSError *error);
typedef void(^NMBPromiseSuccess)(NMBPromise *promise, id response);
typedef void(^NMBPromiseFail)(NMBPromise *promise, NSError *error);
typedef void(^NMBPromiseProgress)(NMBPromise *promise, float progress);
typedef void(^NMBPromiseBlock)(NMBPromise *promise);
typedef BOOL(^NMBPromiseConstructBlock)(NMBPromise *promise);

/**
 * Promise Multiple type
 */
typedef NS_ENUM(NSUInteger, NMBPromiseMultipleType)
{
    /** The promise has no sub-promises */
    NMBPromiseMultipleTypeSingle,
    /** The sub-promises of this promise is fired one by one. And the consequence of previous sub-previous influences the next one. */
    NMBPromiseMultipleTypeDependent,
    /** The sub-promises are fired together and have no influence to each other. */
    NMBPromiseMultipleTypeParallel,
};

/**
 * Promise State
 */
typedef NS_ENUM(NSUInteger, NMBPromiseState)
{
    /** There may be a mistake happened, so the promise turn into an unknown state. */
    NMBPromiseStateUnknown,
    /** The promise is just initialized. */
    NMBPromiseStateInitialized,
    /** The required blocks have been set, the promise is ready to fire. */
    NMBPromiseStateReady,
    /** The promise is already fire, but get no response yet. */
    NMBPromiseStateProcessing,
    /** The promise is successful. */
    NMBPromiseStateSucceeded,
    /** The promise is failed. */
    NMBPromiseStateFailed,
    /** The promise is cancelled. */
    NMBPromiseStateCancelled,
};

/**
 * NMBPromise manages network operations. You can set success/fail callback on it, get progress of it, and more.
 */
@interface NMBPromise : NSObject

/**
 * @brief Initializes and returns a newly allocated promise object with the userInfo.
 *
 * @param userInfo An instance of NSDictionary that can be access in every blocks of the promise.
 */
- (id)initWithUserInfo:(NSDictionary *)userInfo;

/**
 * @brief The state of promise, it could be processing, succeeded, failed, cancelled and so on.
 */
@property(nonatomic, readonly, assign) NMBPromiseState state;

/**
 * @brief The method of the promise. This property describe what does the promise do in a string.
 */
@property(nonatomic, readwrite, strong) NSString *method;

/**
 * @brief On which the execution, retry and construct blocks invoked.
 */
@property(nonatomic, readwrite, strong) dispatch_queue_t callbackQueue;

/**
 * @brief On which the response, success, fail and progress blocks invoked.
 */
@property(nonatomic, readwrite, strong) dispatch_queue_t actionQueue;

#pragma mark - Progress

/**
 * @brief The progress of the network operation.
 */
@property(nonatomic, readonly)float progress;
- (void)updateProgress:(float)progress;
- (void)updateProgressWithDone:(unsigned long long)done total:(unsigned long long)total;

#pragma mark - Callbacks

/**
 * @brief Add a response callback. Will be called on both success and fail.
 *
 * @param response The block contains the callback code.
 */
- (NMBPromise *)response:(NMBPromiseResponse)response;

/**
 * @brief Add a success callback.
 *
 * @param success The block contains the callback code.
 */
- (NMBPromise *)success:(NMBPromiseSuccess)success;

/**
 * @brief Add a fail callback.
 *
 * @param fail The block contains the callback code.
 */
- (NMBPromise *)fail:(NMBPromiseFail)fail;

/**
 * @brief Add a progress callback.
 *
 * @param progress The block contains the callback code.
 */
- (NMBPromise *)progress:(NMBPromiseProgress)progress;

#pragma mark - Blocks

- (NMBPromise *)constructBlock:(NMBPromiseConstructBlock)block;

- (NMBPromise *)executionBlock:(NMBPromiseBlock)block;

- (NMBPromise *)cancelBlock:(NMBPromiseBlock)block;

- (NMBPromise *)retryBlock:(NMBPromiseBlock)block;

#pragma mark - Actions
- (void)succeedWithResponse:(id)response;
- (void)failWithError:(NSError *)error;
- (void)execute;
- (void)clean;

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

#pragma mark - Multiple
@property(nonatomic, readonly, assign)NMBPromiseMultipleType multipleType;
@property(nonatomic, readonly, weak)NMBPromise *superPromise;
@property(nonatomic, readonly, strong)NSOrderedSet *subPromises;

- (id)initWithMultipleType:(NMBPromiseMultipleType)type;
- (NMBPromise *)neighborNextOrPrevious:(BOOL)isNext;
- (void)addSubPromises:(NSOrderedSet *)promises;
- (BOOL)NO_failure:(NSError *)error;
- (BOOL)NO_success:(id)response;

@end
