//
//  NITAppDelegate.m
//  NimbusBase_iOS_Tutorial
//
//  Created by William Remaerd on 2/6/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NITAppDelegate.h"
#import "NimbusBase.h"
#import "NITBaseViewController.h"
#import "NSUserDefaults+NIT.h"

@implementation NITAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Database
    
    [self managedObjectContext];
    
    // UI
    
    UIWindow *window = self.window;
    window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[NITBaseViewController alloc] init]];
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [self.persistentStoreCoordinator.nimbusBase application:application
                                                           openURL:url
                                                 sourceApplication:sourceApplication
                                                        annotation:annotation];
}

#pragma mark - Database

- (void)handlePersistentStoreDidImportUbiquitousContentChangesNotification:(NSNotification *)notification
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(handlePersistentStoreDidImportUbiquitousContentChangesNotification:)
                               withObject:notification
                            waitUntilDone:NO];
        return;
    }
    
    [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
}

- (NSDictionary *)nimbusBaseConfigs
{
    static NSString *const kAppName = @"Nimbus iOS Tutorial";
    return @{
             NCfgK_Servers: @[
                     @{
                         NCfgK_AppName: kAppName,
                         NCfgK_Cloud: NCfgV_GDrive,
                         NCfgK_AppID: @"467471168650-9v08j5mruji6gcskp2ovam903o6g6nsc.apps.googleusercontent.com",
                         NCfgK_AppSecret: @"HgyksCpZ9g7m2wdOJHbB0tOs",
                         },
                     @{
                         NCfgK_AppName: kAppName,
                         NCfgK_Cloud: NCfgV_Dropbox,
                         NCfgK_AppID: @"x0e7vb4ls3lub5d",
                         NCfgK_AppSecret: @"jl1xp49sumwe7tf",
                         },
                     @{
                         NCfgK_AppName: kAppName,
                         NCfgK_Cloud: NCfgV_Box,
                         NCfgK_AppID: @"eky66lnq5fnlmulhos7080u1c4a2isv2",
                         NCfgK_AppSecret: @"6bMkjEzGKU1ghcmXbCii32ykGHJp4xZT",
                         },
                     ],
             };
}

- (NSDictionary *)persistentStoreOptions
{
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption: @YES,
                              NSInferMappingModelAutomaticallyOption: @YES,
                              };
    return options;
}

- (NSURL *)persistentStoreURLiCloudOn:(BOOL)isiCloudOn
{
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:
            isiCloudOn ?
            @"NimbusBase_iOS_Tutorial_iCloud.sqlite" :
            @"NimbusBase_iOS_Tutorial.sqlite"];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        [coordinator.nimbusBase trackChangesOfMOContext:_managedObjectContext];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NimbusBase_iOS_Tutorial" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel
                                                                                     nimbusConfigs:self.nimbusBaseConfigs];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePersistentStoreDidImportUbiquitousContentChangesNotification:)
                                                 name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                               object:_persistentStoreCoordinator];


    
    NSURL *ubiquityURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    BOOL iCloudOn = [[NSUserDefaults standardUserDefaults] isiCloudOn] && (ubiquityURL != nil);
    
    NSMutableDictionary *options = [[self persistentStoreOptions] mutableCopy];
    if (iCloudOn)
    {
        NSURL *iCloudDataURL = [ubiquityURL URLByAppendingPathComponent:@"iCloudData"];
        [options addEntriesFromDictionary:
         @{
           NSPersistentStoreUbiquitousContentNameKey: @"iCloudStore",
           NSPersistentStoreUbiquitousContentURLKey: iCloudDataURL
           }];
    }
    
    NSURL *storeURL = [self persistentStoreURLiCloudOn:iCloudOn];
    
    NSError *error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:options
                                                           error:&error]) {

        NSLog(@"Unresolved error %@, \n%@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

- (BOOL)migratePersistentStoreiCloudOn:(BOOL)iCloudOn
{
    NSPersistentStore *currentStore = _persistentStoreCoordinator.persistentStores.firstObject;
    BOOL isiCloudOnCurrently = currentStore.options[NSPersistentStoreUbiquitousContentURLKey] != nil;
    if (iCloudOn == isiCloudOnCurrently) return YES;
    
    NSMutableDictionary *options = [[self persistentStoreOptions] mutableCopy];
    if (iCloudOn)
    {
        NSURL *ubiquityURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        if (ubiquityURL)
        {
            NSURL *iCloudDataURL = [ubiquityURL URLByAppendingPathComponent:@"iCloudData"];
            [options addEntriesFromDictionary:
             @{
               NSPersistentStoreUbiquitousContentNameKey: @"iCloudStore",
               NSPersistentStoreUbiquitousContentURLKey: iCloudDataURL
               }];
        }
        else
        {
            return NO;
        }
    }
    else
    {
        [options addEntriesFromDictionary:
         @{
           NSPersistentStoreRemoveUbiquitousMetadataOption : @YES
           }];
    }
    
    NSURL *storeURL = [self persistentStoreURLiCloudOn:iCloudOn];
    NSError *error = nil;
    if (![_persistentStoreCoordinator migratePersistentStore:currentStore
                                                       toURL:storeURL
                                                     options:options
                                                    withType:NSSQLiteStoreType
                                                       error:&error]) {
        NSLog(@"Unresolved error %@, \n%@", error, [error userInfo]);
        abort();
    }
    
    return error == nil;
}

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
