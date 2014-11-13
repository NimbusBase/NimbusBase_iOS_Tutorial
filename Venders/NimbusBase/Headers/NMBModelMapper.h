//
//  NMBModelRouter.h
//  NimbusBase
//
//  Created by William Remaerd on 8/5/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSPropertyDescription, NSEntityDescription;

/**
 * The instance confirms this protocol is responsible for mapping entities and properties among different versions of NSManagedObjectModel.
 */

@protocol NMBModelMapper <NSObject>

@optional

/**
 * @brief Ask the model mapper to return the NSPropertyDescription for the given name of the given entity in currently used model.
 *
 * @param name The name of the property being asked.
 * @param entity The entity which the being asked property belongs to.
 * @param context The object asking this information.
 *
 * @return The NSPropertyDescription for the given name of the given entity.
 *
 * @discussion If the method returns nil, the property is considerred abandoned, and related objects will be deleted. If this method is not implemented, the property is searched in currently used model.
 */
- (NSPropertyDescription *)propertyNamed:(NSString *)name
                                ofEntity:(NSEntityDescription *)entity
                                 context:(id)context;

/**
 * @brief Ask the model mapper to return the NSEntityDescription for the given name in currently used model.
 *
 * @param name The NSEntityDescription of the property being asked.
 * @param context The object asking this information.
 *
 * @return The NSEntityDescription for the given name.
 *
 * @discussion If the method returns nil, the entity is considerred abandoned, and related objects will be deleted with the entity folder. If this method is not implemented, the entity is searched in currently used model.
 */
- (NSEntityDescription *)entityNamed:(NSString *)name
                             context:(id)context;

/**
 * @brief Ask the model mapper the order of the 2 given groups of verion identifiers.
 *
 * @param versionIDs1 The first group of version identifiers need to be compared.
 * @param versionIDs2 The second group of version identifiers need to be compared.
 * @param context The object asking this information.
 *
 * @return If the first group of version identifiers is lower then the second group.
 *
 * @discussion If this method is not implemented, identifiers are treatd as pure number and the average values are used to compare.
 */
- (BOOL)isModelVersionIDs:(NSSet *)versionIDs1
 lowerThanModelVersionIDs:(NSSet *)versionIDs2
                  context:(id)context;

/**
 * @brief Ask the model mapper the bundles contain the model files.
 *
 * @param context The object asking this information.
 *
 * @return An array of bundles contain model files.
 *
 * @discussion If this method is not implemented, main bundle is used.
 */
- (NSArray *)bundlesContainModelFilesContext:(id)context;

/**
 * @brief Ask the model mapper which version does the managed object model currently use.
 *
 * @param momdName The name of managed object model directory being asked.
 * @param bundle The bundle containts the managed object model directory being asked.
 * @param context The object asking this information.
 *
 * @return The file name of model's current version.
 *
 * @discussion If this method is not implemented, the name of the model is searched in the managed object model directory (momd).
 */
- (NSString *)currentMOModelNameOfMOMDirectory:(NSString *)momdName
                                        bundle:(NSBundle *)bundle
                                       context:(id)context;

/**
 * @brief Ask the model mapper if the migration between stores presented by the 2 given metadata is a lightweight migration.
 *
 * @param fromStoreMetadata The metadata presents the source store of the migration.
 * @param toStoreMetadata The metadata presents the destination store of the migration.
 * @param context The object asking this information.
 *
 * @return If the migration between stores presented by the 2 given metadata is a lightweight migration.
 *
 * @discussion If this method is not implemented, the migration is treated as lightweight, and if a proper mapping model can't be inferred, an exception will be thrown.
 */
- (BOOL)isMigrationLightweightFromStore:(NSDictionary *)fromStoreMetadata
                                toStore:(NSDictionary *)toStoreMetadata
                                context:(id)context;

@end
