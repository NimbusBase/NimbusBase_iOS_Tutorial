//
//  NMBFileForm.h
//  NimbusBase
//
//  Created by William Remaerd on 1/12/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NMBObject.h"

@class NMBFile;

/**
 * NMBFileForm is responsible for collecting information of a file when you want to create or update it.
 */
@interface NMBFileForm : NMBObject

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
 * @brief The extension of the file
 */
@property(nonatomic, assign)NSString *extension;

/**
 * @brief When you want to update a file, this method help you to copy all properties of the file conveniently.
 *
 * @param file The source file.
 *
 * @return An instance of NMBFileForm has same properties with source file.
 */
- (id)initWithFile:(NMBFile *)file;

/**
 * @brief The convenient method to new a NMBFileForm represents a folder.
 * 
 *@param name The name of the folder.
 */
+ (id)folderWithName:(NSString *)name;

#pragma mark - Disk
/**
 * @brief When you set the property content, it will be serialized on disk. This property indicates the url of the serialized data.
 */
@property(nonatomic, copy, readonly)NSURL *urlOnDisk;

@end
