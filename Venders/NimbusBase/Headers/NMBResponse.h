//
//  NMBResponse.h
//  NimbusBase
//
//  Created by William Remaerd on 8/12/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NMBPromise;

/**
 * NMBResponse represents the result of NMBPromise. It contains a result value if the promise succeeds, or an error if the promise fails.
 */
@interface NMBResponse : NSObject

/**
 * @brief Initializes a new response contains a result of a succeeded promise.
 *
 * @param promise The related promise.
 * @param result The result of the succeeded promise.
 */
+ (instancetype)success:(NMBPromise *)promise result:(id)result;

/**
 * @brief Initializes a new response contains an error of a failed promise.
 *
 * @param promise The related promise.
 * @param error The error of the failed promise.
 */
+ (instancetype)fail:(NMBPromise *)promise error:(NSError *)error;

/**
 * @brief The result of the succeeded promise. It is always nil if the promise fails.
 */
@property (nonatomic, readonly) id result;

/**
 * @brief The error of the failed promise. It is always nil if the promise succeeds.
 */
@property (nonatomic, readonly) NSError *error;

/**
 * @brief Indicates if the reciever is a response of a succeeded promise or a failed promise.
 */
@property (nonatomic, readonly) BOOL isSuccess;

/**
 * @brief Indicates if the reciever is a response of a cancelled promise.
 *
 * @discussion Because a cancelled promise is regarded as a failed promise, and returns a special cancel error. Thereby this attribute returns YES if the related promise fails due to being cancelled, and returns NO if the promise fails due to other reason or succeeds.
 */
@property (nonatomic, readonly) BOOL isCancelled;

@end
