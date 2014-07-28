//
//  NUIModelViewController.h
//  NimbusTester
//
//  Created by William Remaerd on 3/17/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NCUController;

@class NCUModelViewController;

@protocol NCUModelViewControllerDataSource <NSObject>
@required
- (NSManagedObjectContext *)managedObjectContextForModelViewController:(NCUModelViewController *)viewController;
- (NSArray *)modelViewController:(NCUModelViewController *)viewController sortDecriptorsForEntity:(NSEntityDescription *)entity;
- (NSString *)modelViewController:(NCUModelViewController *)viewController keyPathOfObjectTitle:(NSEntityDescription *)entity;

@end


@interface NCUModelViewController : UITableViewController

@property(nonatomic, strong)NSManagedObjectModel *model;
@property(nonatomic, strong)NCUController *controller;

@end
