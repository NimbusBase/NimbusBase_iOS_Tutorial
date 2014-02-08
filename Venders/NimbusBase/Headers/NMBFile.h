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

/**
 * NMBFile represents a file on cloud. You should never create an instance of it by yourself, they are always returned by instance of NMBServer. NimbusBase regards folder as file too. The difference is in the callback of retrieving a file, you get instance of NSData as response, but in callback of retrieving folder you get instance of NSArray, which contains its children.
 */
@interface NMBFile : NMBObject

#pragma mark - Root
/**
 * @brief Indicates if the file represents the root folder of the app.
 */
@property(nonatomic, readonly)BOOL isRoot;

#pragma mark - Meta
/**
 * @brief The identifier of the file.
 */
@property(nonatomic, copy, readonly)NSString *identifier;

/**
 * @brief The name of the file.
 */
@property(nonatomic, copy, readonly)NSString *name;

/**
 * @brief The mime of the file.
 */
@property(nonatomic, copy, readonly)NSString *mime;

/**
 * @brief The content of the file. If the file represents a folder, this property will be nil.
 */
@property(nonatomic, copy, readonly)NSData *content;

/**
 * @brief The last modified date of the file.
 */
@property(nonatomic, copy, readonly)NSDate *modifiedDate;

/**
 * @brief The extension of the file
 */
@property(nonatomic, readonly)NSString *extension;

/**
 * @brief Indicates if the file represents a folder.
 */
@property(nonatomic, assign, readonly)BOOL isFolder;

#pragma mark - Disk
/**
 * @brief If the file has been retrieved, this property indicates the url of the content on disk.
 */
@property(nonatomic, readonly)NSURL *urlOnDisk;

/**
 * @brief Indicates if content exist on disk.
 */
@property(nonatomic, readonly)BOOL contentExists;

@end


