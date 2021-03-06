//
//  UPViewController.m
//  Uploader
//
//  Created by William Remaerd on 11/12/13.
//  Copyright (c) 2013 William Remaerd. All rights reserved.
//

#import "NITBaseViewController.h"

#import "NITAppDelegate.h"

#import "NimbusBase.h"
#import "NCUModelViewController.h"
#import "NCUController.h"

#import "KVOUtilities.h"
#import "UIView+AutoLayout.h"
#import "UITableView+Quick.h"
#import "NSArray+Quick.h"
#import "NSUserDefaults+NIT.h"
#import "UIAlertView+Quick.h"

#import "NITServerViewController.h"
#import "NITServerCell.h"

static NSString
*const sCellReuseIDServer = @"S",
*const sCellReuseIDPlayground = @"C";

@interface NITBaseViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
NCUControllerDataSource,
NCUControllerDelegate
>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *servers;

@property (nonatomic, weak) UIAlertView *alertUnacquaintedStore;

@end

@implementation NITBaseViewController

- (id)init
{
    if (self = [super init])
    {
        if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.tableView = self.tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView deselectSelectedRowsAnimated:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSNotificationCenter *ntfctnCntr = [NSNotificationCenter defaultCenter];
    [ntfctnCntr addObserver:self
                   selector:@selector(handleUbiquityIdentityDidChangeNotification:)
                       name:NSUbiquityIdentityDidChangeNotification
                     object:nil];
    [self handleUbiquityIdentityDidChangeNotification:nil];

    [ntfctnCntr addObserver:self
                   selector:@selector(handleDefaultServerDidChangeNotification:)
                       name:NMBNotiDefaultServerDidChange
                     object:self.base];
    [self handleDefaultServerDidChangeNotification:nil];
    
    [ntfctnCntr addObserver:self
                   selector:@selector(handleNMBServerSyncDidFail:)
                       name:NMBNotiSyncDidFail
                     object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSNotificationCenter *ntfctnCntr = [NSNotificationCenter defaultCenter];
    [ntfctnCntr removeObserver:self
                          name:NSUbiquityIdentityDidChangeNotification
                        object:nil];
    [ntfctnCntr removeObserver:self
                          name:NMBNotiDefaultServerDidChange
                        object:self.base];
    [ntfctnCntr removeObserver:self
                          name:NMBNotiSyncDidFail
                        object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Nimbus Base

- (void)synchronizeWithOptions:(NSDictionary *)options
{
    NMBServer *server = self.base.defaultServer;
    if (!server.isInitialized || server.isSynchronizing) return;
    
    NMBPromise *syncPromise = options == nil ?
    [server synchronize] :
    [server synchronizeWithOptions:options];
    
    typeof(self) bSelf = self;
    
    [syncPromise fail:^(NMBPromise *promise, NSError *error) {
        if (promise.response.isCancelled) return;
        [[UIAlertView alertError:error] show];
    }];
    
    [syncPromise response:
     ^(NMBPromise *promise, id response, NSError *error)
     {
         [bSelf.tableView reloadRowsAtIndexPaths:@[bSelf.indexPathsByItem[@"Synchronize"]]
                                withRowAnimation:UITableViewRowAnimationFade];
     }];

    [syncPromise progress:
     ^(NMBPromise *promise, float progress)
     {
         [bSelf.tableView reloadRowsAtIndexPaths:@[bSelf.indexPathsByItem[@"Synchronize"]]
                                withRowAnimation:UITableViewRowAnimationNone];
     }];
}

- (void)handleDefaultServerDidChangeNotification:(NSNotification *)notification
{
    UITableView *tableView = self.tableView;
    if (tableView != nil)
        [tableView reloadRowsAtIndexPaths:@[[self indexPathsByItem][@"Synchronize"]]
                         withRowAnimation:UITableViewRowAnimationFade];
}

- (void)handleNMBServerSyncDidFail:(NSNotification *)notification
{
    if (notification.object != self.base.defaultServer) return;

    NSError *error = notification.userInfo[NKeyNotiError];
    NSString *domain = error.domain;
    NSInteger code = error.code;
    
    if ([NMBPromiseErrorDomain isEqualToString:domain] && NMBPromiseCancelError == code)
        return;
    else if ([NValSynchronizeErrorDomain isEqualToString:domain] && NValUnacquaintedStoreError == code)
    {
        UIAlertView
        *alert = [[UIAlertView alloc] initWithTitle:error.domain
                                            message:[UIAlertView messageFromError:error]
                                           delegate:self
                                  cancelButtonTitle:@"Got it"
                                  otherButtonTitles:@"Re-downloud", @"Re-upload", nil];
        self.alertUnacquaintedStore = alert;
        [alert show];
        return;
    }
}

#pragma mark - Models

- (NMBase *)base
{
    return [[(NITAppDelegate *)[[UIApplication sharedApplication] delegate] persistentStoreCoordinator] nimbusBase];
}

- (NSArray *)tableItems
{
    return @[
             self.base.servers,
             @[@"iCloud"],
             @[@"Playground", @"Synchronize"],
             ];
}

- (NSDictionary *)indexPathsByItem
{
    static NSDictionary *map = nil;
    if (map != nil) return map;
    
    return map = [[NSDictionary alloc] initWithDictionary:[self.tableItems indexPathsByStringKey]];
}

#pragma mark - Subviews

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    id item = self.tableItems[indexPath.section][indexPath.row];
    
    if ([item isKindOfClass:[NMBServer class]])
    {
        ((NITServerCell *)cell).server = item;
    }
    else if ([@"Playground" isEqual:item])
    {
        cell.textLabel.text = @"Playground";
    }
    else if ([@"iCloud" isEqual:item])
    {
        NITServerCell *serverCell = (NITServerCell *)cell;
        
        UILabel *textLabel = serverCell.textLabel;
        UIImageView *imageView = serverCell.imageView;

        textLabel.text = @"iCloud";
        imageView.image = [UIImage imageNamed:@"iconiCloud"];
        
        NITAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSPersistentStore *store = appDelegate.persistentStoreCoordinator.persistentStores.firstObject;
        BOOL isiCloudOn = store.options[NSPersistentStoreUbiquitousContentURLKey] != nil;
        imageView.alpha = textLabel.alpha = isiCloudOn ? 1.0f : 0.5f;
    }
    else if ([@"Synchronize" isEqual:item])
    {
        UILabel *textLabel = cell.textLabel;
        
        NMBPromise *syncPromise = self.base.defaultServer.syncPromise;
        
        textLabel.text = syncPromise == nil ?
        @"Synchronize" :
        [[NSString alloc] initWithFormat:@"Synchronizing %3.0f%%", syncPromise.progress * 100];
        
        textLabel.alpha = [indexPath isEqual:[self tableView:self.tableView willSelectRowAtIndexPath:indexPath]] ? 1.0f : 0.5f;
    }
}

- (UITableView *)tableView
{
    if (_tableView) return _tableView;

    UIView *superview = self.view;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:superview.bounds style:UITableViewStyleGrouped];
    _tableView = tableView;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView registerClass:[NITServerCell class] forCellReuseIdentifier:sCellReuseIDServer];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:sCellReuseIDPlayground];
    
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addSubview:tableView];
    
    [superview addNoMarginConstraintsToSubview:tableView];
    
    return _tableView;
}

#pragma mark - Actions

- (void)pushViewControllerForServer:(NMBServer *)server
{
    NITServerViewController *con = [[NITServerViewController alloc] init];
    con.server = server;
    [self.navigationController pushViewController:con animated:YES];
}

- (void)pushPlaygroundViewController
{
    NITAppDelegate
    *appDelegate = (NITAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NCUModelViewController
    *con = [[NCUModelViewController alloc] init];
    
    con.model = appDelegate.managedObjectContext.persistentStoreCoordinator.managedObjectModel;
    
    NCUController *controller = [[NCUController alloc] init];
    controller.dataSource = self;
    controller.delegate = self;
    con.controller = controller;
    
    [self.navigationController pushViewController:con
                                         animated:YES];
}

- (void)switchiCloud
{
    NITAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL targetiCloudState = !userDefaults.isiCloudOn;
    if ([appDelegate migratePersistentStoreiCloudOn:targetiCloudState])
        userDefaults.isiCloudOn = targetiCloudState;
}

#pragma mark - Events

- (void)handleUbiquityIdentityDidChangeNotification:(NSNotification *)notification
{
    UITableView *tableView = self.tableView;
    if (!tableView) return;
    
    [tableView reloadRowsAtIndexPaths:@[[self indexPathsByItem][@"iCloud"]]
                     withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.alertUnacquaintedStore == alertView)
    {
        switch (buttonIndex) {
            case 1:
                [self synchronizeWithOptions:@{NKeySyncCommitType: @(NMBSyncCommitTypePullEntirely)}];
                break;
            case 2:
                [self synchronizeWithOptions:@{NKeySyncCommitType: @(NMBSyncCommitTypePushEntirely)}];
                break;
            case 0:
            default:
                break;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *subItems = self.tableItems[section];
    return subItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = self.tableItems[indexPath.section][indexPath.row];
    
    NSString *reuserID = nil;
    if ([item isKindOfClass:[NMBServer class]] || [@"iCloud" isEqualToString:item])
        reuserID = sCellReuseIDServer;
    else if ([@"Playground" isEqual:item] || [@"Synchronize" isEqual:item])
        reuserID = sCellReuseIDPlayground;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserID
                                                            forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = self.tableItems[indexPath.section][indexPath.row];
    
    if ([item isKindOfClass:[NMBServer class]])
        [self pushViewControllerForServer:item];
    else if ([@"Playground" isEqual:item])
        [self pushPlaygroundViewController];
    else if ([@"iCloud" isEqual:item])
    {
        [self switchiCloud];
        [tableView reloadRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
    else if ([@"Synchronize" isEqual:item])
    {
        NMBServer *server = self.base.defaultServer;
        if (server.isInitialized)
        {
            if (server.isSynchronizing)
                [server.syncPromise cancel];
            else
                [self synchronizeWithOptions:nil];
        }

        [tableView reloadRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
    
    /*
    switch (indexPath.section) {
        case 0:{
            NMBServer *server = self.servers[indexPath.row];
            [self pushViewControllerForServer:server];
        }break;
        case 1:{
            [self pushPlaygroundViewController];
        }break;
        default:
            break;
    }
     */
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = self.tableItems[indexPath.section][indexPath.row];
    BOOL canSelect = YES;

    if ([@"Synchronize" isEqual:item])
    {
        NMBServer *server = self.base.defaultServer;
        canSelect = (server != nil) && server.isInitialized;
    }
    
    return canSelect ? indexPath : nil;
}

#pragma mark - NCUModelViewControllerDataSource

- (NSManagedObjectContext *)managedObjectContextForController:(NCUController *)controller
{
    NITAppDelegate
    *appDelegate = (NITAppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}

- (NSArray *)controller:(NCUController *)controller sortDecriptorsForEntity:(NSEntityDescription *)entity
{
    static NSDictionary *map = nil;
    if (map == nil)
        map = @{
                @"User": @"name",
                };

    return @[
             [[NSSortDescriptor alloc] initWithKey:map[entity.name]
                                         ascending:YES],
             ];
}

- (NSString *)controller:(NCUController *)viewController keyPathOfObjectTitle:(NSEntityDescription *)entity
{
    static NSDictionary *map = nil;
    if (map == nil)
        map = @{
                @"User": @"name",
                };

    return map[entity.name];
}

@end