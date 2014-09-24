//
//  NSArray+Quick.m
//  NimbusBase_iOS_Tutorial
//
//  Created by William Remaerd on 9/24/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NSArray+Quick.h"

@implementation NSArray (Quick)

- (NSDictionary *)indexPathsByStringKey
{
    NSMutableDictionary *collector = [[NSMutableDictionary alloc] init];
    
    for (NSUInteger firstIndex = 0; firstIndex < self.count; firstIndex++)
    {
        NSArray *secondary = self[firstIndex];
        NSAssert([secondary isKindOfClass:[NSArray class]],
                 @"Expect NSArray as sub array, but found %@",
                 [secondary class]);
        
        for (NSUInteger secondIndex = 0; secondIndex < secondary.count; secondIndex++)
        {
            NSString *item = secondary[secondIndex];
            
            if ([item isKindOfClass:[NSString class]])
                collector[item] = [NSIndexPath indexPathForRow:secondIndex
                                                     inSection:firstIndex];
        }
    }
    
    return collector;
}

@end
