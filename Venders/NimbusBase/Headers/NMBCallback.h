//
//  NMBCallback.h
//  NimbusBase
//
//  Created by William Remaerd on 8/12/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NMBPromise;

typedef void(^NMBPromiseResponse)(NMBPromise *promise, id response, NSError *error);
typedef void(^NMBPromiseSuccess)(NMBPromise *promise, id response);
typedef void(^NMBPromiseFail)(NMBPromise *promise, NSError *error);
typedef void(^NMBPromiseProgress)(NMBPromise *promise, float progress);

@interface NMBCallback : NSObject

@property (nonatomic, assign) dispatch_queue_t queue;
@property (nonatomic, readonly, copy) id handlerBlock;

- (instancetype)initWithHandlerBlock:(id)handlerBlock;

@end
