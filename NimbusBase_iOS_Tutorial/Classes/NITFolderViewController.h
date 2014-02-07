//
//  NMTBrowserViewController.h
//  NimbusTester
//
//  Created by William Remaerd on 1/8/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NMTFileViewController.h"

@class NMBFile, NMBServer;

@interface NITFolderViewController : NMTFileViewController

@property(nonatomic, strong)NMBFile* file;
@property(nonatomic, weak)NMBServer *server;

@end
