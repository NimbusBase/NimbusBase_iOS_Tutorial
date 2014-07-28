//
//  NCUObjectPickerViewController.h
//  NimbusTester
//
//  Created by William Remaerd on 3/20/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NCUEntityViewController.h"

@class NCUObjectPickerViewController;

@protocol NCUObjectPickerViewControllerDelegate <NSObject>

- (void)objectPickerViewController:(NCUObjectPickerViewController *)controller didPickObjects:(NSArray *)objects;
- (void)objectPickerViewControllerDidCancel:(NCUObjectPickerViewController *)controller;

@end

@interface NCUObjectPickerViewController : NCUEntityViewController

@property(nonatomic, strong)NSFetchRequest *fetchRequest;
@property(nonatomic, weak)id<NCUObjectPickerViewControllerDelegate> delegate;

@end
