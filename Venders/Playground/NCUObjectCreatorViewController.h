//
//  NCUObjectCreatorViewController.h
//  NimbusTester
//
//  Created by William Remaerd on 3/20/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NCUObjectViewController.h"

@class NCUObjectCreatorViewController;

@protocol NCUObjectCreatorViewControllerDelegate <NSObject>

- (void)objectCreatorViewController:(NCUObjectCreatorViewController *)viewController didSucceedToCreateObject:(NSManagedObject *)object;
- (void)objectCreatorViewControllerDidCancel:(NCUObjectCreatorViewController *)viewController;

@end

@interface NCUObjectCreatorViewController : NCUObjectViewController

@property(nonatomic, strong)NSEntityDescription *entity;

@property(nonatomic, weak)id<NCUObjectCreatorViewControllerDelegate> delegate;

@end
