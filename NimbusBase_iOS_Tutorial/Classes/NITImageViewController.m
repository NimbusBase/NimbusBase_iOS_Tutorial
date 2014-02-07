//
//  NMTImageViewController.m
//  NimbusTester
//
//  Created by William Remaerd on 1/12/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NITImageViewController.h"
#import "NimbusBase.h"

#import "KVOUtilities.h"
#import "UIImagePickerController+Picker.h"
#import "UIView+AutoLayout.h"

static NSString *const kvo_progress = @"progress";

@interface NITImageViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic, weak)UIImageView *imageView;
@end

@implementation NITImageViewController

- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView = self.imageView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network
- (void)responsed:(NMBPromise *)promise content:(NSData *)content{
    
    self.imageView.image = [[UIImage alloc] initWithData:content];
    
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

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:kvo_progress]) {
        NSNumber *new = change[NSKeyValueChangeNewKey];
        NSString *title = [NSString stringWithFormat:@"%3.0f%%", 100 * new.floatValue];
        self.navigationItem.rightBarButtonItem.title = title;
    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self setEditing:NO animated:YES];
    
    UIImage *image = info[(picker.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage)];
    [self uploadImage:image];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self setEditing:NO animated:YES];
}

#pragma mark - Actions
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    BOOL old = self.editing;
    [super setEditing:editing animated:animated];
    
    if (editing && !old) {
        
        [UIImagePickerController showFromController:self];
        
    }
    
}

- (void)setPromise:(NMBPromise *)promise{
    [self setupEditButton:(_promise != promise && promise != nil)];
    
    if (_promise) {
        [_promise removeObserver:self forKeyPath:kvo_progress];
    }
    
    _promise = promise;
    
    if (_promise) {
        [_promise addObserver:self forKeyPath:kvo_progress options:kvoOptNOI context:nil];
    }
}

#pragma mark - Subviews
- (void)setupEditButton:(BOOL)isActive{
    UINavigationItem *item = self.navigationItem;
    
    if (isActive) {
        
        UIBarButtonItem *button = [[UIBarButtonItem alloc] init];
        button.title = @"0%";
        button.enabled = NO;
        
        item.rightBarButtonItem = button;
        
    } else {
        
        item.rightBarButtonItem = self.editButtonItem;
        
    }
}

- (UIImageView *)imageView{
    
    if (!_imageView) {
        UIView *superview = self.view;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:superview.bounds];
        _imageView = imageView;
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [superview addSubview:imageView];
        
        [superview addNoMarginConstraintsToSubview:imageView];

    }
    
    return _imageView;
}

@end
