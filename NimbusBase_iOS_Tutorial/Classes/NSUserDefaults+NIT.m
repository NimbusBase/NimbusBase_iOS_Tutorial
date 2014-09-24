//
//  NSUserDefaults+NMT.m
//  NimbusTester
//
//  Created by William Remaerd on 9/5/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NSUserDefaults+NIT.h"

@implementation NSUserDefaults (NIT)

- (void)setiCloudOn:(BOOL)isiCLoudOn
{
    [self setValue:@(isiCLoudOn) forKey:NMTKiCloudOn];
    [self synchronize];
}

- (BOOL)isiCloudOn
{
    NSNumber *number = [self valueForKey:NMTKiCloudOn];
    return number ? number.boolValue : NO;
}

@end

NSString
*const NMTKiCloudOn = @"iCloudOn";