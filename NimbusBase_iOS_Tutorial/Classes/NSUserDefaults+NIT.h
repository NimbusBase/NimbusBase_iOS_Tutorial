//
//  NSUserDefaults+NMT.h
//  NimbusTester
//
//  Created by William Remaerd on 9/5/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (NIT)

@property (nonatomic, setter = setiCloudOn:) BOOL isiCloudOn;

@end

extern NSString
*const NMTKiCloudOn;
