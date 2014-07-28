//
//  NUIEntityController.h
//  NimbusTester
//
//  Created by William Remaerd on 3/17/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NCUController;

@class NCUEntityViewController;

@protocol NCUEntityViewControllerDataSource <NSObject>
@required
- (NSFetchRequest *)fetchRequestForEntityViewController:(NCUEntityViewController *)viewController;
@end

@interface NCUEntityViewController : UITableViewController

@property(nonatomic, strong)NSEntityDescription *entity;

@property(nonatomic, strong)NCUController *controller;


@end
