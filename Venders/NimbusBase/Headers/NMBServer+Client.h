//
//  NMBServer+Client.h
//  NimbusBase
//
//  Created by William Remaerd on 1/15/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NMBServer.h"

@class NMBFile, NMBFileForm, NMBPromise;

@interface NMBServer (Client)

@property(nonatomic, readonly, strong)NMBFile *root;
@property(nonatomic, readonly, assign)BOOL isInitialized;

#pragma mark - CRUD
- (NMBPromise *)createFileWithForm:(NMBFileForm *)form inParent:(NMBFile *)parent;
- (NMBPromise *)retrieveFile:(NMBFile *)file;
- (NMBPromise *)updateFile:(NMBFile *)file withForm:(NMBFileForm *)form;
- (NMBPromise *)deleteFile:(NMBFile *)file;

@end
