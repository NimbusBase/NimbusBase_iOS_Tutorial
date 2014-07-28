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
#import "NMBase+NIT.h"
#import "NCUModelViewController.h"
#import "NCUController.h"

#import "KVOUtilities.h"
#import "UIView+AutoLayout.h"
#import "UITableView+Quick.h"

#import "NITServerViewController.h"
#import "NITServerCell.h"

static NSString
*sCellReuseIDServer = @"S",
*sCellReuseIDPlayground = @"C";

@interface NITBaseViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
NCUControllerDataSource,
NCUControllerDelegate
>

@property(nonatomic, weak)UITableView *tableView;
@property(nonatomic, strong)NSArray *servers;

@end

@implementation NITBaseViewController

- (id)init{
    if (self = [super init]) {
        if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    self.tableView = self.tableView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.servers = self.servers;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView deselectSelectedRowsAnimated:animated];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSArray *identifiers = nil;
    if (identifiers == nil) {
        identifiers = @[sCellReuseIDServer, sCellReuseIDPlayground];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiers[indexPath.section]
                                                            forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
}

#pragma mark - Actions

- (void)pushViewControllerForServer:(NMBServer *)server{
    NITServerViewController *con = [[NITServerViewController alloc] init];
    con.server = server;
    [self.navigationController pushViewController:con animated:YES];
}

- (void)pushPlaygroundViewController{
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

#pragma mark - Subviews

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
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
}

- (UITableView *)tableView{
    if (!_tableView) {
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

    }
    
    return _tableView;
}

#pragma mark - Servers
- (NSArray *)servers{
    if (!_servers) {
        _servers = [[NMBase sharedBase] servers];
    }
    
    return _servers;
}

#pragma mark - NCUModelViewControllerDataSource
- (NSManagedObjectContext *)managedObjectContextForController:(NCUController *)controller
{
    NITAppDelegate
    *appDelegate = (NITAppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}

- (NSArray *)controller:(NCUController *)controller
sortDecriptorsForEntity:(NSEntityDescription *)entity
{
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
    
    return sortDescriptors;
}

- (NSString *)controller:(NCUController *)viewController
    keyPathOfObjectTitle:(NSEntityDescription *)entity
{
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
    
    return keyPath;
}

@end
