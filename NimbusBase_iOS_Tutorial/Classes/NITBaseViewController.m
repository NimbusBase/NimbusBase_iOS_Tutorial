//
//  UPViewController.m
//  Uploader
//
//  Created by William Remaerd on 11/12/13.
//  Copyright (c) 2013 William Remaerd. All rights reserved.
//

#import "NITBaseViewController.h"
#import "NimbusBase.h"
#import "NMBase+NIT.h"

#import "KVOUtilities.h"
#import "UIView+AutoLayout.h"
#import "UITableView+Quick.h"

#import "NITServerViewController.h"
#import "NITServerCell.h"

@interface NITBaseViewController () <UITableViewDataSource, UITableViewDelegate>

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NMBServer *server = self.servers[indexPath.row];
    NITServerViewController *con = [[NITServerViewController alloc] init];
    con.server = server;
    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark - Subviews
- (UITableView *)tableView{
    if (!_tableView) {
        UIView *superview = self.view;
        
        UITableView *tableView = [[UITableView alloc] init];
        _tableView = tableView;

        tableView.delegate = self;
        tableView.dataSource = self;
        
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

@end
