//
//  NSPersistentStoreCoordinator+NMB.h
//  NimbusBase
//
//  Created by William Remaerd on 9/11/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <CoreData/CoreData.h>

@class NMBase;

@interface NSPersistentStoreCoordinator (NMB)

@property (nonatomic, readonly) NMBase *nimbusBase;

- (instancetype)initWithManagedObjectModel:(NSManagedObjectModel *)model
                             nimbusConfigs:(NSDictionary *)nmbCnfigs;

@end
