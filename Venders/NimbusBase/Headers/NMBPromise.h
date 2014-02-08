//
//  NMBPromise.h
//  NimbusBase
//
//  Created by William Remaerd on 1/8/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NMBPromise;

typedef void(^NMBPromiseResponse)(NMBPromise *promise, id response, NSError *error);
typedef void(^NMBPromiseSuccess)(NMBPromise *promise, id response);
typedef void(^NMBPromiseFail)(NMBPromise *promise, NSError *error);
typedef void(^NMBPromiseExecuation)(NMBPromise *promise);
typedef void(^NMBPromiseProgress)(NMBPromise *promise, float progress);
typedef void(^NMBPromiseCancel)(NMBPromise *promise);

/**
 * NMBPromise manages network operations. You can set success/fail callback on it, get progress of it, and more.
 */
@interface NMBPromise : NSObject

#pragma mark - Progress

/**
 * @brief The progress of the network operation.
 */
@property(nonatomic, readonly)float progress;
- (void)updateProgress:(float)progress;
- (void)updateProgressWithDone:(unsigned long long)done total:(unsigned long long)total;

#pragma mark - Blocks

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

- (NMBPromise *)executionBlock:(NMBPromiseExecuation)block;

- (NMBPromise *)cancelBlock:(NMBPromiseCancel)block;

#pragma mark - Actions
- (void)doSuccess:(NMBPromise *)promise response:(id)response;
- (void)doFail:(NMBPromise *)promise error:(NSError *)error;
- (void)clean;

/**
 * @brief After you get an instance of NMBPromise don't forget to call method go on it, or nothing will happen.
 */
- (void)go;

/**
 * @brief Cancel the network operation. Not all kinds of operations can be cancelled.
 */
- (void)cancel;

#pragma mark - User Info
@property(nonatomic, copy)NSDictionary *userInfo;
- (id)objectForKeyedSubscript:(id)key;

@end
