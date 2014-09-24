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
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSNotificationCenter *ntfctnCntr = [NSNotificationCenter defaultCenter];
    [ntfctnCntr removeObserver:self
                          name:NSUbiquityIdentityDidChangeNotification
                        object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Models

- (NSArray *)servers
{
    NMBase *base = [[(NITAppDelegate *)[[UIApplication sharedApplication] delegate] persistentStoreCoordinator] nimbusBase];
    return base.servers;
}

- (NSArray *)tableItems
{
    return @[
             self.servers,
             @[@"iCloud"],
             @[@"Playground"],
             ];
}

- (NSDictionary *)indexPathsByItems
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
        
        BOOL isiCloudOn = NO;
        
        UILabel *textLabel = serverCell.textLabel;
        UIImageView *imageView = serverCell.imageView;

        textLabel.text = @"iCloud";
        imageView.image = [UIImage imageNamed:@"iconiCloud"];
        
        imageView.alpha = textLabel.alpha = isiCloudOn ? 1.0f : 0.5f;
    }
    
    /* Remove
    switch (indexPath.section) {
        case 0:{
            NMBServer *server = self.servers[indexPath.row];
            ((NITServerCell *)cell).server = server;
        }break;
        case 1:
            cell.textLabel.text = @"Playground";
            break;
        default:
            break;
    }
     */
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
    
    [tableView reloadRowsAtIndexPaths:[self indexPathsByItems][@"iCloud"]
                     withRowAnimation:UITableViewRowAnimationFade];
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
    /* Remove
    switch (section) {
        case 0:
            return self.servers.count;
            break;
        case 1:
            return 1;
            break;
        default:
            break;
    }
    
    return 0;
     */
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* Remove
    static NSArray *identifiers = nil;
    if (identifiers == nil)
        identifiers = @[sCellReuseIDServer, sCellReuseIDPlayground];
     */

    
    id item = self.tableItems[indexPath.section][indexPath.row];
    
    NSString *reuserID = nil;
    if ([item isKindOfClass:[NMBServer class]] || [@"iCloud" isEqualToString:item])
        reuserID = sCellReuseIDServer;
    else if ([@"Playground" isEqual:item])
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
    /* Remove
    NSArray *sortDescriptors = nil;
    NSString *name = entity.name;
    if ([name isEqualToString:@"User"]) {
        sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    }
    else if ([name isEqualToString:@"Test"]) {
        sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"create_time" ascending:YES]];
    }
    else if ([name isEqualToString:@"Player"]) {
        sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"user.name" ascending:YES]];
    }
    */
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

    /* Remove
    NSString *keyPath = nil;
    NSString *name = entity.name;
    if ([name isEqualToString:@"User"]) {
        keyPath = @"name";
    }
    else if ([name isEqualToString:@"Test"]) {
        keyPath = @"point";
    }
    else if ([name isEqualToString:@"Player"]) {
        keyPath = @"user.name";
    }
    */
    return map[entity.name];
}

@end
