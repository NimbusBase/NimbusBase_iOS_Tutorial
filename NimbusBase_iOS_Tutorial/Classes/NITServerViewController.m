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
#import "NSArray+Quick.h"
#import "UIAlertView+Quick.h"

#import "NITFolderViewController.h"


static NSString
*const vCellReuseBrowser = @"B",
*const vCellReuseAuth = @"A",
*const vCellReuseSync = @"S";

static NSString
*const kvo_syncPromise = @"syncPromise";


@interface NITServerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation NITServerViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.server = nil;
}

#pragma mark - Models

- (void)setServer:(NMBServer *)server
{
    if (_server)
    {
        [_server removeObserver:self forKeyPath:NMBServerProperties.authState];
        [_server removeObserver:self forKeyPath:NMBServerProperties.isInitialized];
    }
    
    _server = server;
    
    if (_server)
    {
        [_server addObserver:self forKeyPath:NMBServerProperties.authState options:kvoOptNOI context:nil];
        [_server addObserver:self forKeyPath:NMBServerProperties.isInitialized options:kvoOptNOI context:nil];
    }
}

+ (NSArray *)items
{
    static NSArray *items = nil;
    if (items != nil) return items;
    
    return items =
    @[
      @[@"Browser",],
      @[@"Auth",],
      ];
}

+ (NSDictionary *)indexPathsByItem
{
    static NSDictionary *map = nil;
    if (map != nil) return map;
    
    return map = [[NSDictionary alloc] initWithDictionary:[self.class.items indexPathsByStringKey]];
}

#pragma mark - Subviews

- (UITableView *)tableView
{
    if (_tableView) return _tableView;
    
    UIView *superview = self.view;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:superview.bounds style:UITableViewStyleGrouped];
    _tableView = tableView;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addSubview:tableView];
    
    [superview addNoMarginConstraintsToSubview:tableView];
    
    return _tableView;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NMBServer
    *server = self.server;
    
    NSString
    *key = self.class.items[indexPath.section][indexPath.row];
    
    UILabel
    *textLabel = cell.textLabel;
    
    BOOL canSelected =
    [indexPath isEqual:[self tableView:self.tableView willSelectRowAtIndexPath:indexPath]];
    
    // Default behaviour
    
    textLabel.text = key;
    textLabel.alpha = canSelected ? 1.0f : 0.5f;
    
    // Specific behaviours
    
    if ([@"Auth" isEqualToString:key])
    {
        textLabel.text = server.authStateAction;
    }
}

#pragma mark - Actions

- (void)pushBrowser:(NMBServer *)server
{
    if (server.isInitialized)
    {
        NITFolderViewController *con = [[NITFolderViewController alloc] init];
        con.server = server;
        con.file = server.root;
        [self.navigationController pushViewController:con animated:YES];
    }
}

- (void)modifyAuthState:(NMBServer *)server
{
    switch (server.authState)
    {
        case NMBAuthStateIn:
        {
            [server signOut];
        }
            break;
        case NMBAuthStateOut:
        {
            if (server.base.defaultServer == nil)
                [server authorizeWithController:self];
            else
            {
                [[UIAlertView alertTitle:@"Already signed in"
                                 message:@"Please sign out other servers before you sign in this"] show];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Events

- (void)handleServerStateChange
{
    NSArray
    *indexPaths = [self.class.indexPathsByItem objectsForKeys:@[@"Browser", @"Auth",]
                                               notFoundMarker:[NSNull null]];
    
    typeof(self) bSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [bSelf.tableView reloadRowsAtIndexPaths:indexPaths
                               withRowAnimation:UITableViewRowAnimationFade];
    });
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.server)
    {
        if ([keyPath isEqualToString:NMBServerProperties.authState] ||
            [keyPath isEqualToString:NMBServerProperties.isInitialized])
        {
            [self handleServerStateChange];
        }
    }
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NMBServer
    *server = self.server;
    NSString
    *key = self.class.items[indexPath.section][indexPath.row];
    
    BOOL canBeSelected = NO;
    
    if ([@"Browser" isEqualToString:key])
    {
        canBeSelected = server.isInitialized;
    }
    else if ([@"Auth" isEqualToString:key])
    {
        NMBAuthState state = server.authState;
        canBeSelected = (state == NMBAuthStateIn || state == NMBAuthStateOut);
    }

    return canBeSelected ? indexPath : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NMBServer
    *server = self.server;
    NSString
    *key = self.class.items[indexPath.section][indexPath.row];
    
    if ([@"Browser" isEqualToString:key])
    {
        [self pushBrowser:server];
    }
    else if ([@"Auth" isEqualToString:key])
    {
        [self modifyAuthState:server];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.class.items[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.class.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString
    *key = self.class.items[indexPath.section][indexPath.row];
    
    UITableViewCell
    *cell = nil;

    if ([@"Browser" isEqualToString:key])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:vCellReuseBrowser];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:vCellReuseBrowser];
        }
    }
    else if ([@"Auth" isEqualToString:key])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:vCellReuseAuth];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:vCellReuseAuth];
        }
    }

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

@end
