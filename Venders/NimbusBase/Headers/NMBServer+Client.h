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

/**
 * @brief The root folder of the server.
 */
@property(nonatomic, readonly, strong) NMBFile *root;

/**
 * @brief Indicates whether the server is initialized. Only when this property is YES, you can call CRUD method.
 */
@property(nonatomic, readonly, assign) BOOL isInitialized;

#pragma mark - CRUD

/**
 * @brief Create a file or a folder in location where parent represents.
 *
 * @param form The information collection of the file will be created. For example, if it is a file or a folder.
 * @param parent Indicates the location where the new file will be.
 *
 * @return An object to manage netwrok operation. See NMBPromise.
 */
- (NMBPromise *)createFileWithForm:(NMBFileForm *)form inParent:(NMBFile *)parent;

/**
 * @brief Retrieve the content of the file. For a folder, content means it's children files. For a file, content means an instance of NSData, which contains an image or something else.
 *
 * @param file The file you want to retrieve.
 *
 * @return An object to manage netwrok operation. See NMBPromise.
 */
- (NMBPromise *)retrieveFile:(NMBFile *)file;

/**
 * @brief Update a file.
 *
 * @param file The file you want to update, should not represent folder.
 * @param form The information collection of the file's change.
 *
 * @return An object to manage netwrok operation. See NMBPromise.
 */
- (NMBPromise *)updateFile:(NMBFile *)file withForm:(NMBFileForm *)form;

/**
 * @brief Delete a file or a folder parameter file represents.
 *
 * @param file The file you want to delete.
 *
 * @return An object to manage netwrok operation. See NMBPromise.
 */
- (NMBPromise *)deleteFile:(NMBFile *)file;

#pragma mark - Promises

/**
 * @brief Instead of `go` method of NMBPromise, we recommand you to fire a promise with this method if the promise itself is related to an instance of NMBServer (e.g. CRUD file on cloud server).
 *
 * @param promise The promise you want to fire.
 */
- (void)firePromise:(NMBPromise *)promise;

/**
 * @brief Query the on going promises for file creation in specific parent folder.
 *
 * @param parent The specific parent folder.
 *
 * @return An array of eligible promises.
 */
- (NSArray *)prmoisesForFilesBeingCreatedInParent:(NMBFile *)parent;

/**
 * @brief Delete a file or a folder parameter file represents.
 *
 * @param file The file you want to query on.
 * @param methods The promises with which methods you want to select. Should be chosen in `NValMethodRetrieve`, `NValMethodUpdate` or `NValMethodDelete`.
 *
 * @return An array of eligible promises.
 */
- (NSArray *)promisesForFile:(NMBFile *)file methods:(NSSet *)methods;

@end
