//
//  NCUController.h
//  NimbusTester
//
//  Created by William Remaerd on 3/18/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NCUController, NCUObjectViewController;

@protocol NCUControllerDataSource <NSObject>
@required;
- (NSManagedObjectContext *)managedObjectContextForController:(NCUController *)controller;
- (NSArray *)controller:(NCUController *)controller sortDecriptorsForEntity:(NSEntityDescription *)entity;
- (NSString *)controller:(NCUController *)viewController keyPathOfObjectTitle:(NSEntityDescription *)entity;
@optional

@end

@protocol NCUControllerDelegate <NSObject>
@optional
- (BOOL)shouldObjectViewController:(NCUObjectViewController *)viewController startEditingAttribute:(NSAttributeDescription *)attribute ofObject:(NSManagedObject *)object;
- (void)objectViewController:(NCUObjectViewController *)viewController displayAttribute:(NSAttributeDescription *)attribute ofObject:(NSManagedObject *)object;
@end

@interface NCUController : NSObject

@property(nonatomic, readonly)NSManagedObjectContext *managedObjectContext;
@property(nonatomic, readonly)NSDictionary *sortDecriptorsByEntityName;
@property(nonatomic, readonly)NSDictionary *keyPathOfObjectTitleByEntityName;
@property(nonatomic, weak)id<NCUControllerDataSource> dataSource;
@property(nonatomic, weak)id<NCUControllerDelegate> delegate;

- (NSString *)stringFromAttribute:(NSAttributeDescription *)attribute ofEntity:(NSEntityDescription *)entity;
- (NSInteger)keyboardTypeFromAttribute:(NSAttributeDescription *)attribute ofEntity:(NSEntityDescription *)entity;;

- (NSString *)stringFromAttribute:(NSAttributeDescription *)attribute ofObject:(NSManagedObject *)object;
- (id)valueFromAttrbute:(NSAttributeDescription *)attribute ofEntity:(NSEntityDescription *)entity withString:(NSString *)string;

- (NSDateFormatter *)dateFormatterForAttribute:(NSAttributeDescription *)attribute ofEntity:(NSEntityDescription *)entity;

- (BOOL)shouldObjectViewController:(NCUObjectViewController *)viewController startEditingAttribute:(NSAttributeDescription *)attibute ofObject:(NSManagedObject *)object;
- (void)objectViewController:(NCUObjectViewController *)viewController displayAttribute:(NSAttributeDescription *)attibute ofObject:(NSManagedObject *)object;

@end
