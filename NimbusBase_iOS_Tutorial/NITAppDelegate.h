//
//  NITAppDelegate.h
//  NimbusBase_iOS_Tutorial
//
//  Created by William Remaerd on 2/6/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NITAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)mergeNMBMOContextWithNotification:(NSNotification *)notification;
- (void)handleNMBUserContextSaveErrorNotification:(NSNotification *)notification;

@end
