//
//  NMBFolderController.h
//  NimbusBase
//
//  Created by William Remaerd on 6/14/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <CoreData/NSFetchedResultsController.h>

@class NMBFolderController;
@class NMBServer, NMBFile;

/**
 * The instance confirms this protocol is responsible to be notified when the files promises or files in the NMBFolderController changed. The usage of this protocol is much like NSFetchedResultsControllerDelegate's.
 */
@protocol NMBFolderControllerDelegate <NSObject>

@optional

/**
 * @brief Notifies the receiver that a file promise or file has been changed due to an add, remove, move, or update.
 *
 * @param controller The folder controller that sent the message.
 * @param anObject The file promise or file contained by controller that changed.
 * @param indexPath The index path of the changed object (this value is nil for insertions).
 * @param type The type of change. For valid values see “NSFetchedResultsChangeType.”
 * @param newIndexPath The destination path for the object for insertions or moves (this value is nil for a deletion).
 */
- (void)controller:(NMBFolderController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath;

/**
 * @brief Notifies the receiver of the addition or removal of a section.
 *
 * @param controller The folder controller that sent the message.
 * @param sectionInfo The section that changed.
 * @param sectionIndex The index of the changed section.
 * @param type The type of change (insert or delete). Valid values are NSFetchedResultsChangeInsert and NSFetchedResultsChangeDelete.
 */
- (void)controller:(NMBFolderController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type;

/**
 * @brief Notifies the receiver that the folder controller is about to start processing of one or more changes due to an add, remove, move, or update.
 *
 * @param controller The folder controller that sent the message.
 */

- (void)controllerWillChangeContent:(NMBFolderController *)controller;

/**
 * @brief Notifies the receiver that the folder controller has completed processing of one or more changes due to an add, remove, move, or update.
 *
 * @param controller The folder controller that sent the message.
 */

- (void)controllerDidChangeContent:(NMBFolderController *)controller;

@end

/**
 * NMBFolderController is an utility to help you implement a file browser. With it you can access the file system of NimbusBase, and be notified when changes happened. Basically, the files contained by NimbusBase are a subset of your files on the cloud. Once you access your cloud, the retrieved files can be browsed offline. The usage of NMBFolderController is much like NSFetchedResultsController's.
 */
@interface NMBFolderController : NSObject

/**
 * @brief The server you passed in method initWithFolder:server:.
 *
 * @see initWithFolder:server:
 */
@property (nonatomic, readonly, strong) NMBServer *server;

/**
 * @brief The folder you passed into method initWithFolder:server:.
 *
 * @discussion It has to be a folder type file, or you will get an exception.
 *
 * @see initWithFolder:server:
 */
@property (nonatomic, readonly, strong) NMBFile *folder;

/**
 * @brief The object that is notified when the files or file promises in this folder changed.
 */
@property (nonatomic, weak) id<NMBFolderControllerDelegate> delegate;

/**
 * @brief The sections for the file promises and files.
 *
 * @discussion The objects in the sections array implement the NSFetchedResultsSectionInfo protocol. There are always two sections returned via this property. The first one contains instances of NMBPromise, which present creating and updating operations of files. Deleting and retrieving are not contained. The second section contains instances of NMBFile, which present the files not being modified. The order of files is 'modified-recently-first'.
 */
@property (nonatomic, readonly) NSArray *sections;

/**
 * @brief Returns a folder controller initialized using the given arguments.
 *
 * @param folder The folder contains the files you want to retrieve.
 * @param server The cloud server stores the folder, which serves CRUD operations for the files.
 *
 * @return The receiver initialized with the specified folder and server.
 */
- (instancetype)initWithFolder:(NMBFile *)folder server:(NMBServer *)server;

/**
 * @brief Returns the object at the given index path in the file promises and files.
 *
 * @param indexPath An index path in file promises and files. If indexPath does not describe a valid index path in the fetch results, an exception is raised.
 *
 * @return The object at a given index path in the file promises and files.
 */
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

/**
 * @brief Executes the receiver’s fetch request.
 *
 * @param error If the fetch is not successful, upon return contains an error object that describes the problem.
 *
 * @return YES if the fetch executed successfully, otherwise NO.
 *
 * @discussion After executing this method, you can access the file promises and files contained in the receiver with the property sections.
 */
- (BOOL)performFetch:(NSError **)error;

@end
