//
//  NSManagedObjectContext+Quick.h
//  NimbusBase_iOS_Tutorial
//
//  Created by William Remaerd on 9/25/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Quick)

- (NSArray *)deleteAllManagedObjects;

@end
