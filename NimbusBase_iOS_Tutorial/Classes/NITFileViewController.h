//
//  NMTFileViewController.h
//  NimbusTester
//
//  Created by William Remaerd on 1/12/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NMBFile, NMBServer, NMBPromise;

@interface NITFileViewController : UIViewController {
    __weak NMBPromise *_promise;
}

@property(nonatomic, strong)NMBFile* file;
@property(nonatomic, weak)NMBServer *server;

@property(nonatomic, weak)NMBPromise *promise;

- (void)requestContent;
- (void)responsed:(NMBPromise *)promise content:(id)content;
- (void)failToLoadContent:(NMBPromise *)promise error:(NSError *)error;
- (void)confirmFailToLoadContent;
- (void)setupEditButton:(BOOL)isActive;

@end
