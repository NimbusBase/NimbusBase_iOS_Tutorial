//
//  UIImagePickerController+Picker.m
//  NimbusTester
//
//  Created by William Remaerd on 1/13/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "UIImagePickerController+Picker.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation UIImagePickerController (Picker)

+ (void)showFromController:(UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate> *)controller{
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // In case we're running the iPhone simulator, fall back on the photo library instead.
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            return;
        }
    }
    
    cameraUI.sourceType = sourceType;
    cameraUI.mediaTypes = @[(NSString *)kUTTypeImage];
    cameraUI.delegate = controller;
}

@end
