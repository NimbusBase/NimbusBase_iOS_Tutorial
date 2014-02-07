//
//  NMTServerViewController.m
//  NimbusTester
//
//  Created by William Remaerd on 1/14/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NITServerViewController.h"
#import "NimbusBase.h"

#import "KVOUtilities.h"
#import "NMBServer+NIT.h"
#import "UITableView+Quick.h"
#import "UIView+AutoLayout.h"

#import "NITFolderViewController.h"


static NSString *const vCellReuse = @"R";

static NSString *const kvo_authState = @"authState";

@interface NITServerViewController () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, weak)UITableView *tableView;
@end

@implementation NITServerViewController

- (id)init{
    if (self = [super init]) {
        if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    return self;
}

- (void)loadView{
    [super loadView];
        
    [self tableView];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView deselectSelectedRowsAnimated:animated];
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
            
            [self.tableView reloadRowsAtIndexPaths:
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
    
    switch (indexPath.section) {
        case 0:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    cell.textLabel.text = @"Browser";
                    cell.textLabel.alpha = server.isInitialized ? 1.0f : 0.5f;

                }break;
                default:
                    break;
            }
            
        }break;
        case 1:{
            
            switch (indexPath.row) {
                case 0:{
                    

                    cell.textLabel.text = server.authStateAction;
                    
                    NMBAuthState authState = server.authState;
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
    
    switch (indexPath.section) {
        case 0:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    if (server.isInitialized) {
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
                    
                    switch (server.authState) {
                        case NMBAuthStateIn:{
                            ret = indexPath;
                        }break;
                        case NMBAuthStateOut:{
                            ret = indexPath;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NMBServer *server = self.server;
    
    switch (indexPath.section) {
        case 0:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    if (server.isInitialized) {
                        NITFolderViewController *con = [[NITFolderViewController alloc] init];
                        con.server = server;
                        con.file = server.root;
                        [self.navigationController pushViewController:con animated:YES];
                    }
                    
                }break;
                default:
                    break;
            }
            
        }break;
        case 1:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    switch (server.authState) {
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
- (UITableView *)tableView{
    if (!_tableView) {
        UIView *superview = self.view;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:superview.bounds style:UITableViewStyleGrouped];
        _tableView = tableView;
        
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:vCellReuse];

        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [superview addSubview:tableView];
        
        [superview addNoMarginConstraintsToSubview:tableView];
        
    }
    
    return _tableView;
}

#pragma mark - Models
- (void)setServer:(NMBServer *)server{
    
    if (_server) {
        [_server removeObserver:self forKeyPath:kvo_authState];
    }
    
    _server = server;
    
    if (_server) {
        [_server addObserver:self forKeyPath:kvo_authState options:kvoOptNOI context:nil];
    }
    
}

@end
