//
//  NMBase+NPA.m
//  NimbusPhotoAlbum
//
//  Created by William Remaerd on 1/17/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NMBase+NIT.h"
#import "NITAppDelegate.h"

@implementation NMBase (NIT)

+ (NMBase *)sharedBase{
    static dispatch_once_t once;
    static NMBase *base;
    dispatch_once(&once, ^{
        
        NSManagedObjectContext *ctx = [(NITAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        base = [[NMBase alloc] initWithMOContext:ctx configs:self.configs];
    });
    return base;
}

+ (NSDictionary *)configs{
    return nil;
}

@end
