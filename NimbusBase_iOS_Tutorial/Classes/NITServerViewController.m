//
//  NMTServerViewController.m
//  NimbusTester
//
//  Created by William Remaerd on 1/14/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NITServerViewController.h"
#import <NimbusBase/NimbusBase.h>

#import "KVOUtilities.h"
#import "NMBServer+UI.h"

#import "NMTBrowserViewController.h"


static NSString *const vCellReuse = @"R";

static NSString *const kvo_authState = @"authState";

@interface NITServerViewController () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, weak)UITableView *tableView;
@end

@implementation NITServerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout=UIRectEdgeNone;
    
    [self tableView_];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UITableView *tableView = self.tableView_;
    [tableView.indexPathsForSelectedRows enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [tableView deselectRowAtIndexPath:obj animated:animated];
    }];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    self.server = nil;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == self.server) {
        if ([keyPath isEqualToString:kvo_authState]) {
            
            [self.tableView_ reloadRowsAtIndexPaths:
             @[[NSIndexPath indexPathForRow:0 inSection:0],
               [NSIndexPath indexPathForRow:0 inSection:1],]
                                   withRowAnimation:UITableViewRowAnimationFade
             ];
        
        }
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NMBServer *server = self.server;
    NMBAuthState authState = server.authState;
    
    switch (indexPath.section) {
        case 0:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    cell.textLabel.text = @"Browser";
                    cell.textLabel.alpha = (authState == NMBAuthStateIn) ? 1.0f : 0.5f;

                }break;
                default:
                    break;
            }
            
        }break;
        case 1:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    cell.textLabel.text = server.authStateAction;
                    
                    cell.textLabel.alpha =
                    (authState == NMBAuthStateIn || authState == NMBAuthStateOut)
                    ? 1.0f : 0.5f;

                }break;
                default:
                    break;
            }
            
        }break;
        default:
            break;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *ret = nil;
    NMBServer *server = self.server;
    NMBAuthState authState = server.authState;
    
    switch (indexPath.section) {
        case 0:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    if (authState == NMBAuthStateIn) {
                        NMTBrowserViewController *con = [[NMTBrowserViewController alloc] init];
                        con.server = server;
                        con.file = [NMBFile root];
                        [self.navigationController pushViewController:con animated:YES];
                        ret = indexPath;
                    }
                    
                }break;
                default:
                    break;
            }
            
        }break;
        case 1:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    switch (authState) {
                        case NMBAuthStateIn:{
                            [server signOut];
                        }break;
                        case NMBAuthStateOut:{
                            [server authorizeWithController:self];
                        }break;
                        default:
                            break;
                    }
                    
                }break;
                default:
                    break;
            }
            
        }break;
        default:
            break;
    }
    
    
    return ret;
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vCellReuse forIndexPath:indexPath];
    return cell;
}

#pragma mark - Subviews
- (UITableView *)tableView_{
    UITableView *tableView = self.tableView;
    if (!tableView) {
        UIView *superview = self.view;
        tableView = [[UITableView alloc] initWithFrame:superview.bounds style:UITableViewStyleGrouped];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:vCellReuse];
        
        [superview addSubview:tableView];
        self.tableView = tableView;
    }
    
    return tableView;
}

#pragma mark - Models
- (void)setServer:(NMBServer *)server{
    
    if (_server) {
        [_server removeObserver:self forKeyPath:kvo_authState];
    }
    
    _server = server;
    
    if (_server) {
        [_server addObserver:self forKeyPath:kvo_authState options:kvo_options context:nil];
    }
    
}

@end
