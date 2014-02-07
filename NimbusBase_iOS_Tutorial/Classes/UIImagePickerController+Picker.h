//
//  UIImagePickerController+Picker.h
//  NimbusTester
//
//  Created by William Remaerd on 1/13/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (Picker)
+ (void)showFromController:(UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate> *)controller;
@end
