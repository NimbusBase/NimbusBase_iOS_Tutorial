//
//  NMBServer+UI.h
//  NimbusTester
//
//  Created by William Remaerd on 1/14/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NimbusBase.h"

@interface NMBServer (NIT)

@property (nonatomic, readonly) NSString
*authStateAction,
*syncStateAction,
*cloudType,
*iconName;

+ (NSString *)authStateActionString:(NMBAuthState)state;

+ (NSString *)authStateString:(NMBAuthState)state;

@end
