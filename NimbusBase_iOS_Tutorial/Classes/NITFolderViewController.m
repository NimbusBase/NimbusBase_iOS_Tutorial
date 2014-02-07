//
//  NMTBrowserViewController.m
//  NimbusTester
//
//  Created by William Remaerd on 1/8/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NITFolderViewController.h"
#import "NimbusBase.h"

#import "NITImageViewController.h"
#import "UIImagePickerController+Picker.h"

#import "NITFileCell.h"


static NSString *CellIdentifier = @"Cell";

@interface NITFolderViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>

#pragma mark - Subviews
@property(nonatomic, weak)UITableView *tableView;

#pragma mark - Model
@property(nonatomic, strong)NSMutableArray *childrenFiles;

#pragma mark - Other
@property(nonatomic, strong)UIImage *pickedImage;

@property(nonatomic, weak)NMBPromise *promise;

@end

@implementation NITFolderViewController

- (void)viewDidLoad{
    
    [self configNavigationItems];
    
    [super viewDidLoad];
    
}

- (void)loadView{
    [super loadView];
    self.tableView = self.tableView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UITableView *tableView = self.tableView;
    [tableView.indexPathsForSelectedRows enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [tableView deselectRowAtIndexPath:obj animated:animated];
    }];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.childrenFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NITFileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NMBFile *file = self.childrenFiles[indexPath.row];
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:{
            
            if (self.promise) {
                return;
            }
            
            __weak typeof(self) bSelf = self;
            NMBPromise *promise = [self.server deleteFile:file];
            [[[promise success:^(NMBPromise *promise, NSDictionary *userInfo) {
                
                [tableView beginUpdates];
                [bSelf.childrenFiles removeObject:file];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
                
            }] fail:^(NMBPromise *promise, NSError *error) {
                NSLog(@"%@", error.userInfo);
            }] response:^(NMBPromise *promise, id response, NSError *error) {
                bSelf.promise = nil;
            }];
        
            self.promise = promise;
            [promise go];
            
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
    
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    self.pickedImage = image;
    
    [self showNamePicker];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
            
            [self showNamePicker];
            
        }break;
        case 1:{
            
            [UIImagePickerController showFromController:self];
            
        }
        default:
            break;
    }
    
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
- (void)tapButton:(UIBarButtonItem *)button{
    if (button == self.navigationItem.leftBarButtonItem) {
        [UIImagePickerController showFromController:self];
    } else if (button == self.navigationItem.rightBarButtonItem) {
        
        UIActionSheet *sheet =
        [[UIActionSheet alloc] initWithTitle:@"Add what ?"
                                    delegate:self
                           cancelButtonTitle:@"Cancel"
                      destructiveButtonTitle:nil
                           otherButtonTitles:@"Folder", @"Photo", nil];
        
        [sheet showInView:self.view];
        
    }
}

#pragma mark - Events
- (void)contentResponse:(NSArray *)files{
    
    UITableView *tableView = self.tableView;
    NSMutableArray *childrenFiles = self.childrenFiles;
    
    [childrenFiles removeAllObjects];
    [childrenFiles addObjectsFromArray:files];
    
    [tableView reloadData];
    
}

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

- (void)uploadImage:(UIImage *)image named:(NSString *)name{
    
    NMBFileForm *form = [[NMBFileForm alloc] init];
    form.name = name;
    //form.mime = @"image/png";
    form.content = UIImageJPEGRepresentation(image, 1.0f);
    
    __weak typeof(self) bSelf = self;
    NMBPromise *promise = [self.server createFileWithForm:form inParent:self.file];
    [[[promise success:^(NMBPromise *promise, NMBFile *file) {
        
        UITableView *tableView = bSelf.tableView;
        NSMutableArray *childrenFiles = bSelf.childrenFiles;
        
        [childrenFiles addObject:file];
        [tableView reloadData];
        
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
    
    [[[[self.server createFileWithForm:form inParent:self.file] success:^(NMBPromise *promise, NMBFile *file) {
        
        UITableView *tableView = self.tableView;
        NSMutableArray *childrenFiles = self.childrenFiles;
        
        [childrenFiles addObject:file];
        [tableView reloadData];
        
    }] fail:^(NMBPromise *promise, NSError *error) {
        NSLog(@"%@", error.userInfo);
    }] go];

}

#pragma mark - Subviews
- (void)configNavigationItems{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UINavigationItem *item = self.navigationItem;
    
    item.rightBarButtonItem = [[UIBarButtonItem alloc]
                               initWithTitle:@"Add"
                               style:UIBarButtonItemStyleBordered
                               target:self
                               action:@selector(tapButton:)];
    
}

- (void)resetEditButton{
    [super resetEditButton];
    self.navigationItem.rightBarButtonItem.title = @"Add";
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        UIView *superview = self.view;
        
        UITableView *tableView =  [[UITableView alloc] initWithFrame:superview.bounds];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[NITFileCell class] forCellReuseIdentifier:CellIdentifier];

        _tableView = tableView;
        [superview addSubview:tableView];
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
