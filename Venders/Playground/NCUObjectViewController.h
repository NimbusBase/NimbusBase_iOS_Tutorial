//
//  NCUObjectViewController.h
//  NimbusTester
//
//  Created by William Remaerd on 3/17/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NCUController;

@interface NCUObjectViewController : UITableViewController

@property(nonatomic, strong)NSManagedObject *object;
@property(nonatomic, assign)id editingAttributeValue;
@property(nonatomic, strong)NCUController *controller;

@end
