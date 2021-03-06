//
//  NMBFileForm.h
//  NimbusBase
//
//  Created by William Remaerd on 1/12/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NMBFile;

/**
 * NMBFileForm is responsible for collecting information of a file when you want to create or update it.
 */
@interface NMBFileForm : NSObject

/**
 * @brief The name of the file.
 */
@property(nonatomic, copy)NSString *name;

/**
 * @brief The content of the file.
 */
@property(nonatomic, copy)NSData *content;

/**
 * @brief The mime of the file.
 */
@property(nonatomic, copy)NSString *mime;

/**
 * @brief Indicates if the file represents a folder.
 */
@property(nonatomic, assign)BOOL isFolder;

/**
 * @brief The extension of the file.
 */
@property(nonatomic, assign)NSString *extension;

/**
 * @brief When you want to update a file, this method help you to copy all properties of the file conveniently.
 *
 * @param file The source file.
 *
 * @return An instance of NMBFileForm has same properties with source file.
 */
- (instancetype)initWithFile:(NMBFile *)file;

/**
 * @brief The convenient method to new a NMBFileForm represents a folder.
 * 
 * @param name The name of the folder.
 */
+ (instancetype)folderWithName:(NSString *)name;

/**
 * @brief Initializes the receiver with the new name the related file is supposed to be renamed to.
 *
 * @param name The new name of the related file.
 * @param file The file need to be renamed.
 *
 * @return An instance of NMBFileForm has same properties with original file except the name.
 */
+ (instancetype)rename:(NSString *)name file:(NMBFile *)file;

/**
 * @brief If the file content you want to upload is on the disk, you can use this method to avoid unnecessary memory cost.
 *
 * @param fromURL The file url of the content on the disk.
 *
 * @return Whether the file content is successfully to be set.
 */
- (BOOL)setContentViaURL:(NSURL *)fromURL;


#pragma mark - Disk

/**
 * @brief When you set the property content, it will be serialized on disk. This property indicates the url of the serialized data.
 *
 * @see content
 * @see setContentViaURL:
 */
@property(nonatomic, readonly, copy)NSURL *urlOnDisk;

@end
