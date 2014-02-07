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
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else {
        // In case we're running the iPhone simulator, fall back on the photo library instead.
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            return;
        }
    }
    
    cameraUI.mediaTypes = @[(NSString *)kUTTypeImage];
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = controller;
    [controller presentViewController:cameraUI animated:YES completion:nil];

}

@end
