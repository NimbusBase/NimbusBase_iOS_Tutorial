//
//  NMTPlaygroundImagePickerController.m
//  NimbusTester
//
//  Created by William Remaerd on 3/21/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NMTPlaygroundImagePickerController.h"
#import "NCUObjectViewController.h"
#import "UIView+AutoLayout.h"
#import "KVOUtilities.h"

@interface NMTPlaygroundImagePickerController ()
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property(nonatomic, weak)UIImageView *imageView;

@end

@implementation NMTPlaygroundImagePickerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureNavigationItems];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.object addObserver:self
                  forKeyPath:self.attribute.name
                     options:kvoOptNOI
                     context:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.object removeObserver:self
                     forKeyPath:self.attribute.name];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.object) {
        if ([keyPath isEqualToString:self.attribute.name]) {
            kvo_QuickComparison(NSData);
            self.imageView.image = [[UIImage alloc] initWithData:new];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[(picker.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage)];
    
    self.imageView.image = image;
    
    NSData *data = UIImagePNGRepresentation(image);
    [self dismissViewControllerAnimated:YES
                             completion:
     ^{
         [self finishEditingWithData:data];
     }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - Actions
- (void)didTapCamera:(UIBarButtonItem *)button
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)didTapDelete:(UIBarButtonItem *)button
{
    self.imageView.image = nil;
    [self finishEditingWithData:nil];
}

- (void)didTapCancel:(UIBarButtonItem *)button
{
    [self.objectViewController dismissViewControllerAnimated:YES
                                                  completion:nil];
}

#pragma mark - Events
- (void)finishEditingWithData:(NSData *)data
{
    NCUObjectViewController
    *objectViewController = self.objectViewController;
    objectViewController.editingAttributeValue = data;
    
    [objectViewController dismissViewControllerAnimated:YES
                                             completion:nil];
}

#pragma mark - Subviews
- (void)configureNavigationItems
{
    UINavigationItem *item = self.navigationItem;

    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                               target:self
                               action:@selector(didTapCancel:)];
    item.leftBarButtonItem = cancel;
    
    if (self.isEditing) {
        UIBarButtonItem *image = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                  target:self
                                  action:@selector(didTapCamera:)];
        
        UIBarButtonItem *delete = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                   target:self
                                   action:@selector(didTapDelete:)];
        
        item.rightBarButtonItems = @[image, delete];
    }
}

- (UIImageView *)imageView
{
    
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
