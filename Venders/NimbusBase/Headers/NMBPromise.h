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

@interface NMBPromise : NSObject

#pragma mark - Progress
@property(nonatomic, readonly)float progress;
- (void)updateProgress:(float)progress;
- (void)updateProgressWithDone:(unsigned long long)done total:(unsigned long long)total;

#pragma mark - Blocks

- (NMBPromise *)response:(NMBPromiseResponse)response;
- (NMBPromise *)success:(NMBPromiseSuccess)success;
- (NMBPromise *)fail:(NMBPromiseFail)fail;
- (NMBPromise *)execution:(NMBPromiseExecuation)block;
- (NMBPromise *)progress:(NMBPromiseProgress)progress;
- (NMBPromise *)cancelBlock:(NMBPromiseCancel)block;

#pragma mark - Actions
- (void)doSuccess:(NMBPromise *)promise response:(id)response;
- (void)doFail:(NMBPromise *)promise error:(NSError *)error;
- (void)go;
- (void)cancel;
- (void)clean;

#pragma mark - User Info
@property(nonatomic, copy)NSDictionary *userInfo;
- (id)objectForKeyedSubscript:(id)key;

@end
