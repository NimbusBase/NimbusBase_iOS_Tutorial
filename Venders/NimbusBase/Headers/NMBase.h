//
//  NMBase.h
//  NimbusBase_iOS
//
//  Created by William Remaerd on 1/3/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NMBSerializer.h"
#import "NMBModelMapper.h"

@class NSManagedObjectContext, NSPersistentStore, NSManagedObject;
@class NMBPromise, NMBServer;

/**
 * NMBase is the root for all. It should be a singleton in project.
 */
@interface NMBase : NSObject <NMBSerializer>

/**
 * @brief The servers decribed in configs will be instantiated and can be access via this property.
 */
@property (nonatomic, readonly) NSArray *servers;

/**
 * @brief The only init method shoud be used on NMBase.
 * 
 * @param psc The NSPersistentStoreCoordinator your NSManagedObjectContext is base on.
 * @param cfgs An instance of NSDictionary contains the information of NMBase and all its servers.
 *
 * @return An instance of NMBase.
 *
 * @discussion This instance contains information of your model and the stored data of your application, base on which NMBase will access your data and transfer them to the cloud.
 */
- (id)initWithPSCoordinator:(NSPersistentStoreCoordinator *)psc configs:(NSDictionary *)cfgs;

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

#pragma mark - User Data

/**
 * @brief The NSManagedObjectContext used by NMBase to access your data.
 *
 * @discussion You are supposed not to use this context to CRUD your data, because it's created and runs on a private thread of NMBase. But you should add observer on NSNotificationCenter with event name NSManagedObjectContextDidSaveNotification. So that you can merge any changes NMBase fetching from cloud.
 */
@property (nonatomic, readonly) NSManagedObjectContext *userMOContext;
@property (nonatomic, readonly, weak) NSPersistentStoreCoordinator *userPSCoordinator;

/**
 * @brief The instance that is responsible for serializing some objects that can't be translated to JSON directly.
 *
 * @discussion If you don't implement a serializer yourself, there is already one which only capable to serialize several common class instance, like NSDate.
 */
@property (nonatomic, weak) id<NMBSerializer> serializer;

@property (nonatomic, weak) id<NMBModelMapper> modelMapper;

/**
 * @brief Track the changes of the user's NSManagedObjectContext.
 *
 * @param moc The NSManagedObjectContext you want to be tracked.
 *
 * @discussion Only the changes of tracked context can be staged by NMBase, and transfered to cloud during a synchronization. So track every context you would write on with this method.
 */
- (void)trackChangesOfMOContext:(NSManagedObjectContext *)moc;

/**
 * @brief Stop tracking changes of user's NSManagedObjectContext.
 *
 * @param moc The NSManagedObjectContext you don't want to track anymore.
 */
- (void)untrackChangesOfMOContext:(NSManagedObjectContext *)moc;

/**
 * @brief Import and stage the data from your data base.
 *
 * @return This operation will scan your whole data base, it may cost a long time, so it is designed to be async. You will be notified by the callbacks of NMBPromise if the import succeeds or fials.
 *
 * @discussion This method is useful when the first time you track your changes with NMBase but there are already some stored application data. Or you want to stage the missed changes, while there is a cessation of tracking.
 */
- (NMBPromise *)importDataFromMainMOContext;

/**
 * @brief Save all of unsaved changes NMBase make.
 *
 * @discussion This method is supposed to be called when application is going to background or be terminated.
 */
- (void)saveMOContext;

- (NMBServer *)defaultServer;

@end
