//
//  NSManagedObject+NCU.h
//  NimbusTester
//
//  Created by William Remaerd on 3/17/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <CoreData/CoreData.h>

@class NCUController;

@interface NSManagedObject (NCU)

@property(nonatomic, readonly)NSString *ncuTitle;

- (NSString *)titleWithController:(NCUController *)controller;

@end
