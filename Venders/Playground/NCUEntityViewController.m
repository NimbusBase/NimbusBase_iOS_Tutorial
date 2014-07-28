//
//  NUIEntityController.m
//  NimbusTester
//
//  Created by William Remaerd on 3/17/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NCUEntityViewController.h"

#import "NCUObjectViewController.h"
#import "NCUObjectCreatorViewController.h"

#import "NCUController.h"
#import "NSManagedObject+NCU.h"

static NSString *const kReuseIdentifier = @"R";

@interface NCUEntityViewController ()
<NSFetchedResultsControllerDelegate,
NCUObjectCreatorViewControllerDelegate>

@property(nonatomic, strong)NSFetchRequest *fetchRequest;
@property(nonatomic, strong)NSFetchedResultsController *fetchedResultsController;

@property(nonatomic, readonly)UIBarButtonItem *addButtonItem;

@end

@implementation NCUEntityViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    self.navigationItem.rightBarButtonItem = self.addButtonItem;
    
    self.fetchedResultsController = self.fetchedResultsController;
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    self.title = self.fetchedResultsController.fetchRequest.entity.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *sections = self.fetchedResultsController.sections;
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSArray *sections = self.fetchedResultsController.sections;
    if (sections.count > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = sections[section];
        return sectionInfo.numberOfObjects;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kReuseIdentifier];
        UILabel *label = cell.textLabel;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.5f;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject
    *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [managedObject titleWithController:self.controller];
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject
    *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self pushObjectViewController:managedObject];
}


- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteObjectByCellAtIndexPath:indexPath];
    }
}


#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - NCUObjectCreatorViewControllerDelegate

- (void)objectCreatorViewController:(NCUObjectCreatorViewController *)viewController
           didSucceedToCreateObject:(NSManagedObject *)object
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)objectCreatorViewControllerDidCancel:(NCUObjectCreatorViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (void)didTapAddButton:(UIBarButtonItem *)button
{
    [self presentObjectCreatorViewController];
}

#pragma mark - Event

- (NCUObjectViewController *)pushObjectViewController:(NSManagedObject *)managedObject
{
    NCUObjectViewController
    *con = [[NCUObjectViewController alloc] init];
    
    con.object = managedObject;
    con.controller = self.controller;
    
    [self.navigationController pushViewController:con
                                         animated:YES];
    
    return con;
}

- (NCUObjectCreatorViewController *)presentObjectCreatorViewController
{
    NCUObjectCreatorViewController
    *con = [[NCUObjectCreatorViewController alloc] init];
    
    con.entity = self.entity;
    con.controller = self.controller;
    con.delegate = self;
    
    UINavigationController
    *nav = [[UINavigationController alloc] initWithRootViewController:con];
    
    [self presentViewController:nav
                       animated:YES
                     completion:nil];
    
    return con;
}

- (void)deleteObjectByCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSFetchedResultsController
    *fetchedResultsController = self.fetchedResultsController;
    
    NSManagedObject
    *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
    
    NSManagedObjectContext
    *moc = fetchedResultsController.managedObjectContext;
    
    [moc deleteObject:managedObject];

    NSError *error = nil;
    [moc save:&error];
}

- (NSManagedObject *)createObject
{
    NSFetchedResultsController
    *fetchedResultsController = self.fetchedResultsController;
    
    NSManagedObjectContext
    *moc = fetchedResultsController.managedObjectContext;

    NSEntityDescription
    *entity = fetchedResultsController.fetchRequest.entity;
    
    NSManagedObject
    *object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:moc];
    
    return object;
}

#pragma mark - Subviews

- (UIBarButtonItem *)addButtonItem
{
    UIBarButtonItem
    *button =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(didTapAddButton:)];
    
    return button;
}

#pragma mark - Model
- (NSEntityDescription *)entity
{
    if (_entity) return _entity;
    return _entity = self.fetchRequest.entity;
}

- (NSFetchRequest *)fetchRequest
{
    if (_fetchRequest) return _fetchRequest;
    
    NSString *entityName = self.entity.name;
    
    NSFetchRequest
    *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    fetchRequest.sortDescriptors = self.controller.sortDecriptorsByEntityName[entityName];
    
    return _fetchRequest = fetchRequest;
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) return _fetchedResultsController;
    
    
    NSFetchRequest
    *request = self.fetchRequest;
    
    NSManagedObjectContext
    *moc = self.controller.managedObjectContext;
    
    NSFetchedResultsController
    *con = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                               managedObjectContext:moc
                                                 sectionNameKeyPath:nil
                                                          cacheName:nil];
    con.delegate = self;
    
    return _fetchedResultsController = con;
}

@end
