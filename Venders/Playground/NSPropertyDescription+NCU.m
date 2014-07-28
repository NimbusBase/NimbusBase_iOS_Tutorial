//
//  NSPropertyDescription+NCU.m
//  NimbusTester
//
//  Created by William Remaerd on 4/3/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NSPropertyDescription+NCU.h"

@implementation NSPropertyDescription (NCU)

- (NSString *)isOptionalString
{
    return self.isOptional ? @"(Optional)" : @"(Required)";
}

@end
