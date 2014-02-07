//
//  NMTBrowserViewController.m
//  NimbusTester
//
//  Created by William Remaerd on 1/8/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NITFolderViewController.h"
#import "NimbusBase.h"

#import "UIImagePickerController+Picker.h"
#import "UITableView+Quick.h"
#import "UIView+AutoLayout.h"

#import "NITFileCell.h"
#import "NITImageViewController.h"

static NSString *const vCellReuse = @"R";

@interface NITFolderViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

#pragma mark - Subviews
@property(nonatomic, weak)UITableView *tableView;

#pragma mark - Model
@property(nonatomic, strong)NSMutableArray *childrenFiles;

#pragma mark - Reference
@property(nonatomic, weak)UIBarButtonItem *addButtonFolder;
@property(nonatomic, weak)UIBarButtonItem *addButtonImage;
@property(nonatomic, strong)UIImage *pickedImage;

@end

@implementation NITFolderViewController

- (void)loadView{
    [super loadView];
    self.tableView = self.tableView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self configNavigationItems];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView deselectSelectedRowsAnimated:animated];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network
- (void)responsed:(NMBPromise *)promise content:(NSArray *)files{
    [super responsed:promise content:files];
    NSMutableArray *childrenFiles = self.childrenFiles;
    [childrenFiles removeAllObjects];
    [childrenFiles addObjectsFromArray:files];
    
    [self updateTableView];
}

- (void)failToLoadContent:(NMBPromise *)promise error:(NSError *)error{
    NMBFile *file = promise[NKeyPrmsFile];
    NSLog(@"An error occured during load files in folder '%@'", file.name);
    NSLog(@"Reason: %@", error.localizedFailureReason);
}

- (void)uploadImage:(UIImage *)image named:(NSString *)name{
    
    NMBFileForm *form = [[NMBFileForm alloc] init];
    form.name = name;
    form.mime = @"image/png";
    form.content = UIImagePNGRepresentation(image);
    
    __weak typeof(self) bSelf = self;
    NMBPromise *promise = [self.server createFileWithForm:form inParent:self.file];
    [[[promise success:^(NMBPromise *promise, NMBFile *file) {
        
        [bSelf.childrenFiles addObject:file];
        [bSelf updateTableView];
        
    }] fail:^(NMBPromise *promise, NSError *error) {
        
        NSLog(@"%@", error.userInfo);
        
    }] response:^(NMBPromise *promise, NSDictionary *userInfo, NSError *error) {
        
        bSelf.pickedImage = nil;
        bSelf.promise = nil;
        
    }];
    
    self.promise = promise;
    [promise go];
}

- (void)createFolderNamed:(NSString *)name{
    
    NMBFileForm *form = [NMBFileForm folderWithName:name];
    
    __weak typeof(self) bSelf = self;
    NMBPromise *promise = [self.server createFileWithForm:form inParent:self.file];
    [[[promise success:^(NMBPromise *promise, NMBFile *file) {
        
        [bSelf.childrenFiles addObject:file];
        [bSelf updateTableView];
        
    }] fail:^(NMBPromise *promise, NSError *error) {
        
        NSLog(@"%@", error.userInfo);
        
    }] response:^(NMBPromise *promise, NSDictionary *userInfo, NSError *error) {
        
        bSelf.promise = nil;
        
    }];
    
    self.promise = promise;
    [promise go];
}

- (void)deleteFile:(NMBFile *)file atIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) bSelf = self;
    NMBPromise *promise = [self.server deleteFile:file];
    [[[promise success:^(NMBPromise *promise, NSDictionary *userInfo) {
        
        NMBFile *file = promise[NKeyPrmsFile];
        [bSelf.childrenFiles removeObject:file];
        [bSelf updateTableView];
        
    }] fail:^(NMBPromise *promise, NSError *error) {
        
        NSLog(@"%@", error.localizedFailureReason);
        
    }] response:^(NMBPromise *promise, id response, NSError *error) {
        
        bSelf.promise = nil;
        
    }];
    
    self.promise = promise;
    [promise go];
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.childrenFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NITFileCell *cell = [tableView dequeueReusableCellWithIdentifier:vCellReuse forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NMBFile *file = self.childrenFiles[indexPath.row];
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:{
            
            if (!self.promise) {
                [self deleteFile:file atIndexPath:indexPath];
            }

        }break;
        default:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NMBFile *file = self.childrenFiles[indexPath.row];
    [(NITFileCell *)cell setFile:file];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NMBFile *file = self.childrenFiles[indexPath.row];
    
    NITFileViewController *con = nil;
    if (file.isFolder) {
        
        con = [[NITFolderViewController alloc] init];
        
    } else if ([file.mime hasPrefix:@"image/"]) {
        
        con = [[NITImageViewController alloc] init];
        
    }
    if (con) {
        con.server = self.server;
        con.file = file;
        
        [self.navigationController pushViewController:con animated:YES];
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[(picker.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage)];
    
    self.pickedImage = image;
    
    [self showNamePicker];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        
        UITextField *nameField = [alertView textFieldAtIndex:0];
        NSString *text = nameField.text;
        if (!text || [text isEqualToString:@""]) {
            return;
        }
        
        if (self.pickedImage) {
            [self uploadImage:self.pickedImage named:text];
        } else {
            [self createFolderNamed:text];
        }
        
    }
}

#pragma mark - Actions
- (void)tapNavigationBarButton:(UIBarButtonItem *)button{
    if (button == self.addButtonFolder) {
        [self showNamePicker];
    } else if (button == self.addButtonImage) {
        [self presentCamera];
    }
}

#pragma mark - Events
- (void)showNamePicker{
    UIAlertView *folderNamePrompt =
    [[UIAlertView alloc] initWithTitle:@"Add File/Folder"
                               message:@"Name:"
                              delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"OK", nil];
    
    folderNamePrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
    [folderNamePrompt show];
}

- (void)presentCamera{
    [UIImagePickerController showFromController:self];
}

- (void)updateTableView{
    [self.tableView reloadData];
}

#pragma mark - Subviews
- (void)configNavigationItems{
    [self setupEditButton:YES];
}

- (void)setupEditButton:(BOOL)isActive{
    UINavigationItem *item = self.navigationItem;
    
    if (isActive) {
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activity startAnimating];
        UIBarButtonItem *button = [[UIBarButtonItem alloc]
                                   initWithCustomView:activity];
        button.enabled = NO;
        
        item.rightBarButtonItems = nil;
        item.rightBarButtonItem = button;
        
    } else {
        
        UIBarButtonItem *folder = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                   target:self
                                   action:@selector(tapNavigationBarButton:)];
        
        UIBarButtonItem *image = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                  target:self
                                  action:@selector(tapNavigationBarButton:)];
        
        item.rightBarButtonItem = nil;
        item.rightBarButtonItems = @[self.addButtonImage = image,
                                     self.addButtonFolder = folder,];
        
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        UIView *superview = self.view;
        
        UITableView *tableView = [[UITableView alloc] init];
        _tableView = tableView;
        
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[NITFileCell class] forCellReuseIdentifier:vCellReuse];

        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [superview addSubview:tableView];
        
        [superview addNoMarginConstraintsToSubview:tableView];
        
    }
    
    return _tableView;
}

#pragma mark - Model
- (NSMutableArray *)childrenFiles{
    if (!_childrenFiles) {
        self.childrenFiles = [[NSMutableArray alloc] init];
    }
    
    return _childrenFiles;
}

@end
