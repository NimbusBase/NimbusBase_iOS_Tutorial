//
//  NMBase.h
//  NimbusBase_iOS
//
//  Created by William Remaerd on 1/3/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;

@interface NMBase : NSObject

@property(nonatomic, strong)NSManagedObjectContext *managedObjectContex;
@property(nonatomic, strong)NSArray *servers;

- (id)initWithMOContext:(NSManagedObjectContext *)moc configs:(NSDictionary *)cfgs;

#pragma mark - App Events
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end
