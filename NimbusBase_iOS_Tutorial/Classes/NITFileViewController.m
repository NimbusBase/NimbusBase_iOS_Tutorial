//
//  NMTFileViewController.m
//  NimbusTester
//
//  Created by William Remaerd on 1/12/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NITFileViewController.h"
#import "NimbusBase.h"

@interface NITFileViewController ()

@end

@implementation NITFileViewController

- (id)init{
    if (self = [super init]) {
        if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    return self;
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

#pragma mark - Events
- (void)requestContent{
    
    __weak typeof(self) bSelf = self;
    NMBPromise *promise = [self.server retrieveFile:self.file];
    [[[promise success:^(NMBPromise *promise, id response) {
        
        [bSelf responsed:promise content:response];
        
    }] fail:^(NMBPromise *promise, NSError *error) {
        
        [bSelf failToLoadContent:promise error:error];
        
    }] response:^(NMBPromise *promise, id response, NSError *error) {
        
        bSelf.promise = nil;
        
    }];
    
    self.promise = promise;
    [promise go];
}

- (void)responsed:(NMBPromise *)promise content:(id)content{
}

- (void)failToLoadContent:(NMBPromise *)promise error:(NSError *)error{
}

- (void)confirmFailToLoadContent{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupEditButton:(BOOL)isActive{
    
}

#pragma mark - Model
- (void)setPromise:(NMBPromise *)promise{
    [self setupEditButton:(_promise != promise && promise != nil)];
    _promise = promise;
}

- (void)setFile:(NMBFile *)file{
    _file = file;
    self.title = [file.name stringByDeletingPathExtension];
}

@end
