//
//  NMBModelRouter.h
//  NimbusBase
//
//  Created by William Remaerd on 8/5/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSPropertyDescription, NSEntityDescription;

@protocol NMBModelMapper <NSObject>

@optional

- (NSPropertyDescription *)propertyNamed:(NSString *)name
                                ofEntity:(NSEntityDescription *)entity
                                 context:(id)context;

- (NSEntityDescription *)entityNamed:(NSString *)name
                             context:(id)context;

- (BOOL)isModelVersionIDs:(NSSet *)localVerIDs
 lowerThanModelVersionIDs:(NSSet *)cloudVerIDs
                  context:(id)context;

- (NSArray *)bundlesContainModelFilesContext:(id)context;

- (NSString *)currentMOModelNameOfMOMDirectory:(NSString *)momdName
                                        bundle:(NSBundle *)bundle
                                       context:(id)context;

- (BOOL)isMigrationLightweightFromStore:(NSDictionary *)fromStoreMetadata
                                toStore:(NSDictionary *)toStoreMetadata
                                context:(id)context;

@end
