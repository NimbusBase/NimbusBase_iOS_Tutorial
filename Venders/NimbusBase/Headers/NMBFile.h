//
//  NMBFile.h
//  NimbusBase
//
//  Created by William Remaerd on 1/8/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NMBObject.h"
#import "NMBConstants.h"


@class NMBFileForm;

@interface NMBFile : NMBObject

#pragma mark - Cloud File
- (id)initWithCloudFile:(id)cloudFile;
- (id)initWithCloudFile:(id)cloudFile form:(NMBFileForm *)form;
- (void)updateWithCloudFile:(id)cloudFile;
- (void)updateWithCloudFile:(id)cloudFile form:(NMBFileForm *)form;

#pragma mark - Root
@property(nonatomic, readonly)BOOL isRoot;

#pragma mark - Meta
@property(nonatomic, copy, readonly)NSString *identifier;
@property(nonatomic, copy, readonly)NSString *name;
@property(nonatomic, copy, readonly)NSString *mime;
@property(nonatomic, copy, readonly)NSData *content;
@property(nonatomic, copy, readonly)NSDate *modifiedDate;
@property(nonatomic, readonly)NSString *extension;

#pragma mark - Mime type
@property(nonatomic, assign, readonly)BOOL isFolder;
+ (NSString *)mimeWithCloudFile:(id)cloudFile;

#pragma mark - Disk
@property(nonatomic, readonly)NSURL *urlOnDisk;
@property(nonatomic, readonly)BOOL contentExists;

@end


