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
@property (nonatomic, weak) NMBPromise *syncingPromise;

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
    self.syncingPromise = nil;
}

#pragma mark - Models

- (void)setServer:(NMBServer *)server
{
    if (_server)
    {
        [_server removeObserver:self forKeyPath:NMBServerProperties.authState];
        [_server removeObserver:self forKeyPath:NMBServerProperties.isInitialized];
        [_server removeObserver:self forKeyPath:kvo_syncPromise];
    }
    
    _server = server;
    
    if (_server)
    {
        [_server addObserver:self forKeyPath:NMBServerProperties.authState options:kvoOptNOI context:nil];
        [_server addObserver:self forKeyPath:NMBServerProperties.isInitialized options:kvoOptNOI context:nil];
        [_server addObserver:self forKeyPath:kvo_syncPromise options:kvoOptNOI context:nil];
    }
}

- (void)setSyncingPromise:(NMBPromise *)syncingPromise
{
    if (_syncingPromise)
    {
        [_syncingPromise removeObserver:self
                             forKeyPath:NMBPromiseProperties.progress];
    }
    
    _syncingPromise = syncingPromise;
    
    if (_syncingPromise)
    {
        [_syncingPromise addObserver:self
                          forKeyPath:NMBPromiseProperties.progress
                             options:kvoOptNOI
                             context:nil];
        
        [_syncingPromise onQueue:dispatch_get_main_queue() fail:
         ^(NMBPromise *promise, NSError *error)
         {
             if (promise.response.isCancelled)
                 return;
             
             NSLog(@"%@", error);
         }];
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
      @[@"Sync",],
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
    *textLabel = cell.textLabel,
    *detailTextLabel = cell.detailTextLabel;
    
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
    else if ([@"Sync" isEqualToString:key])
    {
        textLabel.text = server.syncStateAction;
        
        if (!server.isSynchronizing)
            detailTextLabel.text = @"";
    }

    /* Remove
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
        case 2:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    cell.textLabel.text = server.syncStateAction;
                    cell.textLabel.alpha = server.isInitialized ? 1.0f : 0.5f;
                    if (!server.isSynchronizing) {
                        cell.detailTextLabel.text = @"";
                    }
                    
                }break;
                default:
                    break;
            }
            
        }break;
        default:
            break;
    }
    */
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

- (void)modifySyncState:(NMBServer *)server
{
    if (server.isSynchronizing)
    {
        [server.syncPromise cancel];
    }
    else
    {
        [server synchronize];
    }
}

- (void)handleServerStateChange
{
    NSArray
    *indexPaths = [self.class.indexPathsByItem objectsForKeys:
                   @[
                     @"Browser",
                     @"Auth",
                     @"Sync",
                     ]
                                               notFoundMarker:[NSNull null]];
    
    
    typeof(self) bSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [bSelf.tableView reloadRowsAtIndexPaths:indexPaths
                               withRowAnimation:UITableViewRowAnimationFade];
    });
}

- (void)handleSyncPromiseChange:(NMBPromise *)syncPromise
{
    self.syncingPromise = syncPromise;
    NSIndexPath *indexPath = self.class.indexPathsByItem[@"Sync"];
    BOOL isNil = syncPromise == nil;
    
    typeof(self) bSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        UITableViewCell *cell = [bSelf.tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = isNil ? @"" : @"%0";
        
        [bSelf.tableView reloadRowsAtIndexPaths:@[indexPath]
                               withRowAnimation:UITableViewRowAnimationFade];
    });
}

- (void)handleSyncPromiseUpdate:(NSNumber *)progress
{
    typeof(self) bSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        UITableViewCell *cell = [bSelf.tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%3.0f%%", 100 * progress.floatValue];
        [cell setNeedsDisplay];
        [cell setNeedsLayout];
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
        else if ([keyPath isEqualToString:kvo_syncPromise])
        {
            NMBPromise *promise = change[NSKeyValueChangeNewKey];
            if ([promise isKindOfClass:[NSNull class]]) promise = nil;
            [self handleSyncPromiseChange:promise];
        }
    }
    else if (object == self.syncingPromise)
    {
        if ([keyPath isEqualToString:NMBPromiseProperties.progress])
        {
            kvo_QuickComparison(NSNumber);
            [self handleSyncPromiseUpdate:new];
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
    else if ([@"Sync" isEqualToString:key])
    {
        canBeSelected = server.isInitialized;
    }
    
    /*
    NMBServer *server = self.server;
    BOOL canBeSelected = NO;
    
    switch (indexPath.section) {
        case 0:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    canBeSelected = server.isInitialized;
                    
                }break;
                default:
                    break;
            }
            
        }break;
        case 1:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    NMBAuthState state = server.authState;
                    canBeSelected = (state == NMBAuthStateIn || state == NMBAuthStateOut);
                    
                }break;
                default:
                    break;
            }
            
        }break;
        case 2:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    canBeSelected = server.isInitialized;
                    
                }break;
                default:
                    break;
            }
            
        }break;
        default:
            break;
    }
    */
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
    else if ([@"Sync" isEqualToString:key])
    {
        [self modifySyncState:server];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }

    /* Remove
    NMBServer *server = self.server;
    
    switch (indexPath.section) {
        case 0:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    [self pushBrowser:server];
                    
                }break;
                default:
                    break;
            }
            
        }break;
        case 1:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    [self modifyAuthState:server];
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    
                }break;
                default:
                    break;
            }
            
        }break;
        case 2:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    [self modifySyncState:server];
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];

                }break;
                default:
                    break;
            }
            
        }break;
        default:
            break;
    }
*/
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell
    *cell = nil;
    switch (indexPath.section) {
        case 0:{
            cell = [tableView dequeueReusableCellWithIdentifier:vCellReuseBrowser];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:vCellReuseBrowser];
            }
        }break;
        case 1:{
            cell = [tableView dequeueReusableCellWithIdentifier:vCellReuseAuth];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:vCellReuseAuth];
            }
        }break;
        case 2:{
            cell = [tableView dequeueReusableCellWithIdentifier:vCellReuseSync];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                              reuseIdentifier:vCellReuseSync];
            }
        }break;
        default:
            break;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

@end
