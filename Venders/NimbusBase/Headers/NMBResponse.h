//
//  NMBResponse.h
//  NimbusBase
//
//  Created by William Remaerd on 8/12/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NMBPromise;

@interface NMBResponse : NSObject

+ (instancetype)success:(NMBPromise *)promise result:(id)result;
+ (instancetype)fail:(NMBPromise *)promise error:(NSError *)error;

@property (nonatomic, readonly) id result;
@property (nonatomic, readonly) NSError *error;

@property (nonatomic, readonly) BOOL
isSuccess,
isCancelled;

@end
