//
//  NMBase.h
//  NimbusBase_iOS
//
//  Created by William Remaerd on 1/3/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;

/**
 * NMBase is the root for all. It should be a singleton in project.
 */
@interface NMBase : NSObject

@property(nonatomic, readonly)NSManagedObjectContext *managedObjectContex;

/**
 * @brief The servers decribed in configs will be instantiated and can be access via this property.
 */
@property(nonatomic, readonly)NSArray *servers;

/**
 * @brief The only init method shoud be used on NMBase.
 * 
 * @param moc Do not support in current version, pass a nil.
 * @param cfgs An instance of NSDictionary contains the information of NMBase of all its servers.
 *
 * @return An instance of NMBase.
 */
- (id)initWithMOContext:(NSManagedObjectContext *)moc configs:(NSDictionary *)cfgs;

#pragma mark - App Events
/**
 * @brief Handle the "openURL" event in AppDelegate. Put it in the method with same name in your AppDelegate.
 * 
 * @param application Pass the same parameter.
 * @param url Pass the same parameter.
 * @param sourceApplication Pass the same parameter.
 * @param annotation Pass the same parameter.
 *
 * @return Indicates if NimbusBase can handle this url.
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end
