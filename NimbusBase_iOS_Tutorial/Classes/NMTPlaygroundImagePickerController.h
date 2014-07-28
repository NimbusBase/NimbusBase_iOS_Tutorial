//
//  NMTPlaygroundImagePickerController.h
//  NimbusTester
//
//  Created by William Remaerd on 3/21/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NCUObjectViewController;

@interface NMTPlaygroundImagePickerController : UIViewController

@property(nonatomic, weak)NCUObjectViewController *objectViewController;
@property(nonatomic, strong)NSManagedObject *object;
@property(nonatomic, strong)NSAttributeDescription *attribute;

@end
