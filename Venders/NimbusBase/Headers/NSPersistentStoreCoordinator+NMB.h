//
//  NSPersistentStoreCoordinator+NMB.h
//  NimbusBase
//
//  Created by William Remaerd on 9/11/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <CoreData/CoreData.h>

@class NMBase;

/**
 * This category provides convenient properties and methods for the cooperation between NMBase and NSPersistentStoreCoordinator.
 */
@interface NSPersistentStoreCoordinator (NMB)

/**
 * @brief The nimbus base bound to the reciever.
 *
 * @see initWithManagedObjectModel:nimbusConfigs:
 */
@property (nonatomic, readonly) NMBase *nimbusBase;

/**
 * @brief A convenient method to bind a nimbus base to the reciever with configs.
 *
 * @param model A managed object model.
 * @param nmbCnfigs A collection of configs with which the nimbus base should be configured with.
 *
 * @return The receiver, initialized with model and nimbus base configured with nimbusConfigs.
 *
 * @discussion This init method is used to merge method initWithManagedObjectModel: of the reciever and method initWithPSCoordinator:configs: of NMBase, so that an instance of nimbus base can be bound to the reciever, and don't need to store it anywhere else.
 *
 * @see nimbusBase
 */
- (instancetype)initWithManagedObjectModel:(NSManagedObjectModel *)model
                             nimbusConfigs:(NSDictionary *)nmbCnfigs;

@end
