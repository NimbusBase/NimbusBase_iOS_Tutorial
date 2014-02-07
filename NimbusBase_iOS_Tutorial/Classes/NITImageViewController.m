//
//  NMTImageViewController.m
//  NimbusTester
//
//  Created by William Remaerd on 1/12/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NITImageViewController.h"
#import <NimbusBase/NimbusBase.h>

#import "UIImagePickerController+Picker.h"

@interface NITImageViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, weak)UIImageView *imageView;

@end

@implementation NITImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self _imageView];
}

- (void)viewDidLoad{
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self setEditing:NO animated:YES];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    [self uploadImage:image];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self setEditing:NO animated:YES];
}

#pragma mark - Events
- (void)requestContent{
    
    __weak typeof(self) bSelf = self;
    NMBPromise *promise = [self.server retrieveFile:self.file];
    [[[promise success:^(NMBPromise *promise, id response) {
        [bSelf contentResponse:response];
        
    }] fail:^(NMBPromise *promise, NSError *error) {
        NSLog(@"%@", error.userInfo);
    
    }] response:^(NMBPromise *promise, id response, NSError *error) {
        bSelf.promise = nil;
    
    }];
    
    self.promise = promise;
    [promise go];
}

- (void)contentResponse:(id)content{
    
    NSData *imageData = content;
    self._imageView.image = [[UIImage alloc] initWithData:imageData];
    
}

- (void)uploadImage:(UIImage *)image{
    
    NMBFile *file = self.file;
    NMBFileForm *form = [[NMBFileForm alloc] initWithFile:file];
    form.content = UIImagePNGRepresentation(image);
    
    __weak typeof(self) bSelf = self;
    NMBPromise *promise = [self.server updateFile:file withForm:form];
    [[[promise success:^(NMBPromise *promise, NMBFile *file) {
        
        bSelf.imageView.image = [[UIImage alloc] initWithData:file.content];
        
    }] fail:^(NMBPromise *promise, NSError *error) {
        NSLog(@"%@", error.userInfo);
    
    }] response:^(NMBPromise *promise, id response, NSError *error) {
        bSelf.promise = nil;
    
    }];
    
    self.promise = promise;
    [promise go];
}

#pragma mark - Actions
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    BOOL old = self.editing;
    [super setEditing:editing animated:animated];
    
    if (editing && !old) {
        
        [UIImagePickerController showFromController:self];
        
    }
    
}

#pragma mark - Subviews
- (UIImageView *)_imageView{
    UIImageView *imageView = self.imageView;
    
    if (!imageView) {
        UIView *superview = self.view;
        imageView = [[UIImageView alloc] initWithFrame:superview.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.imageView = imageView;
        [superview addSubview:imageView];
    }
    
    return self.imageView;
}


- (void)resetEditButton{
    [super resetEditButton];
    self.navigationItem.rightBarButtonItem.title = @"Edit";
}

@end
