//
//  UPViewController.m
//  Uploader
//
//  Created by William Remaerd on 11/12/13.
//  Copyright (c) 2013 William Remaerd. All rights reserved.
//

#import "NITBaseViewController.h"
#import "NimbusBase.h"

#import "KVOUtilities.h"

#import "NITServerViewController.h"
#import "NITServerCell.h"

@interface NITBaseViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak)UITableView *tableView;
@property(nonatomic, strong)NSArray *servers;

@end

@implementation NITBaseViewController

- (void)loadView{
    [super loadView];
    
    if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout=UIRectEdgeNone;
    
    [self tableView];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self regiterNotifications];
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

- (void)dealloc{
    [NSNoti removeObserver:self];
}

#pragma mark - Notifications
- (void)regiterNotifications{
    
    
    NSArray *names = @[NMBNotiAuthBegin,
                       NMBNotiAuthDidSucceed,
                       NMBNotiAuthDidFail,
                       NMBNotiAuthDidCancel,
                       NMBNotiAuthDidSignOut,];
    
    [names enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
        [NSNoti addObserver:self selector:@selector(receiveNotification:) name:name object:nil];
    }];
    
}

- (void)receiveNotification:(NSNotification *)noti{
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[[UIAlertView alloc] initWithTitle:noti.name
                                    message:@"Just show it to test, will disappear in production."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
    });
    */
}

#pragma mark - Subviews
- (UITableView *)tableView{
    if (!_tableView) {
        UIView *superview = self.view;
        
        CGRect frame = superview.bounds;
        CGFloat originY = 0.0f;
        frame.origin.y = originY;
        frame.size.height = CGRectGetHeight(superview.bounds) - originY;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        tableView.allowsMultipleSelection = YES;
        
        [superview addSubview:tableView];
        self.tableView = tableView;
        
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.servers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * const reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[NITServerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NMBServer *server = self.servers[indexPath.row];
    ((NITServerCell *)cell).server = server;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NMBServer *server = self.servers[indexPath.row];
    NITServerViewController *con = [[NITServerViewController alloc] init];
    con.server = server;
    [self.navigationController pushViewController:con animated:YES];
    
    return indexPath;
}

#pragma mark - Servers
- (NSArray *)servers{
    if (!_servers) {
        NSArray *servers = [[(NMTAppDelegate *)[[UIApplication sharedApplication] delegate] base] servers];
        
        self.servers = servers.copy;
    }
    
    return _servers;
}

@end
