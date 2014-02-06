//
//  NMBFileForm.h
//  NimbusBase
//
//  Created by William Remaerd on 1/12/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NMBObject.h"

@class NMBFile;

@interface NMBFileForm : NMBObject

@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSData *content;
@property(nonatomic, copy)NSString *mime;
@property(nonatomic, assign)BOOL isFolder;
@property(nonatomic, assign)NSString *extension;

- (id)initWithFile:(NMBFile *)file;
+ (id)folderWithName:(NSString *)name;

#pragma mark - Disk
@property(nonatomic, copy, readonly)NSURL *urlOnDisk;

@end
