//
//  NMTFileViewController.m
//  NimbusTester
//
//  Created by William Remaerd on 1/12/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NITFileViewController.h"
#import <NimbusBase/NimbusBase.h>

@interface NITFileViewController ()

@end

@implementation NITFileViewController

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
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self requestContent];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (self.promise) {
        [self.promise cancel];
        self.promise = nil;
    }

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    self.promise = nil;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"progress"]) {
        NSNumber *new = change[NSKeyValueChangeNewKey];
        NSString *title = [NSString stringWithFormat:@"%3.0f%%", 100 * new.floatValue];
        self.navigationItem.rightBarButtonItem.title = title;
    }
}

#pragma mark - Events
- (void)requestContent{
    
    __weak typeof(self) bSelf = self;
    NMBPromise *promise = [self.server retrieveFile:self.file];
    [[[promise success:^(NMBPromise *promise, id response) {
        
        [bSelf contentResponse:response];
        
    }] fail:^(NMBPromise *promise, NSError *error) {
        
        NSLog(@"%@", error.userInfo);
    
    }] response:^(NMBPromise *promise, id response, NSError *error) {
        
        bSelf.promise = nil;
        
    }];
    
    self.promise = promise;
    [promise go];
}

- (void)contentResponse:(id)content{
    
}

#pragma mark - Subviews
- (void)resetEditButton{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)lockEditButton{
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - Model
- (void)setFile:(NMBFile *)file{
    
    if (_file) {
    
    }
    
    _file = file;
    
    if (_file) {
        
    }
    
}

- (void)setServer:(NMBServer *)server{
    
    if (_server) {
        
    }
    
    _server = server;
    
    if (_server) {
        
    }
    
}

- (void)setPromise:(NMBPromise *)promise{
    
    if (_promise) {
        [_promise removeObserver:self forKeyPath:@"progress"];
    }
    
    _promise = promise;
    
    if (_promise) {
        [_promise addObserver:self
                   forKeyPath:@"progress"
                      options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                      context:nil];
    }
    
    if (promise) {
        [self lockEditButton];
    } else {
        [self resetEditButton];
    }
}

@end
