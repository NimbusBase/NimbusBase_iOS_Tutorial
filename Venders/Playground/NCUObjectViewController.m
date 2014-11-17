//
//  NCUObjectViewController.m
//  NimbusTester
//
//  Created by William Remaerd on 3/17/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NCUObjectViewController.h"

#import "NSManagedObject+NCU.h"
#import "NSPropertyDescription+NCU.h"

#import "NCUController.h"
#import "NCUAttributeViewCell.h"

#import "NCUObjectPickerViewController.h"

static NSString
*const kReuseIdentifierAttribute = @"RA",
*const kReuseIdentifierRelationship = @"RR";

@interface NCUObjectViewController ()
<NCUAttributeViewCellDelegate,
NCUObjectPickerViewControllerDelegate>

@property(nonatomic, strong)NSOrderedSet *orderedPropertyNames;
@property(nonatomic, strong)NSIndexSet *toManyRelationshipsIndexSet;

@property(nonatomic, strong)NSIndexPath *editingIndexPath;

@end

@implementation NCUObjectViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = [self.object valueForKeyPath:self.controller.keyPathOfObjectTitleByEntityName[self.object.entity.name]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        NSError *error = nil;
        BOOL isValid = [self validateAndSave:&error allowRollback:YES];
        if (!isValid) {
            [self showValidationError:error];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.orderedPropertyNames.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = 0;
    
    NSManagedObject *object = self.object;
    NSString *propertyName = self.orderedPropertyNames[section];
    NSPropertyDescription *property = object.entity.propertiesByName[propertyName];
    
    if ([property isKindOfClass:[NSAttributeDescription class]]) {
        count = 1;
    }
    else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
        NSRelationshipDescription *relationship = (NSRelationshipDescription *)property;
        if (relationship.isToMany) {
            NSSet *relatedObjects = [object valueForKey:propertyName];
            count = self.isEditing ?
            (relatedObjects.count) + 1 :
            relatedObjects.count;
        }
        else {
            count = 1;
        }
    }

    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = self.object;
    NSString *propertyName = [self propertyNameWithIndexPath:indexPath];
    NSPropertyDescription *property = object.entity.propertiesByName[propertyName];
    
    UITableViewCell *cell = nil;
    if ([property isKindOfClass:[NSAttributeDescription class]]) {
        
        NCUAttributeViewCell *attrCell =
        [tableView dequeueReusableCellWithIdentifier:kReuseIdentifierAttribute];
        if (!attrCell) {
            attrCell =
            [[NCUAttributeViewCell alloc] initWithController:self.controller
                                             reuseIdentifier:kReuseIdentifierAttribute];
            [attrCell setDelegate:self];
        }
        
        [attrCell setAttribute:(NSAttributeDescription *)property
                      ofObject:object];
        cell = attrCell;
    }
    else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifierRelationship];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:kReuseIdentifierRelationship];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        }
        [self configureCell:cell
                atIndexPath:indexPath
           withRelationship:(NSRelationshipDescription *)property
                   ofObject:object];
    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isEditing) return NO;
    
    NSManagedObject *object = self.object;
    NSString *propertyName = [self propertyNameWithIndexPath:indexPath];
    NSRelationshipDescription *property = object.entity.relationshipsByName[propertyName];
    
    BOOL canMove =
    property != nil &&  // This section represents a relationship
    property.isToMany &&
    property.isOrdered &&
    (indexPath.row != 0);   // This cell is not add cell
    
    return canMove;
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath
{
    if ([fromIndexPath isEqual:toIndexPath]) return;
    
    NSManagedObject *object = self.object;
    NSString *propertyName = [self propertyNameWithIndexPath:fromIndexPath];
    NSRelationshipDescription *property = object.entity.relationshipsByName[propertyName];

    if (!property) return;
    
    NSMutableOrderedSet *relateObjects = [object mutableOrderedSetValueForKey:propertyName];
    
    NSUInteger
    fromIndex = fromIndexPath.row - 1,  // Avoid the add cell
    toIndex = toIndexPath.row - 1;
    
    [relateObjects moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:fromIndex]
                                toIndex:toIndex];
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL canSelect = NO;
    
    NSManagedObject *object = self.object;
    NSString *propertyName = [self propertyNameWithIndexPath:indexPath];
    
    NSPropertyDescription *property = object.entity.propertiesByName[propertyName];
    BOOL isEditing = self.isEditing;
    if ([property isKindOfClass:[NSAttributeDescription class]]) {
        
        NSAttributeDescription *attribute = (NSAttributeDescription *)property;
        switch (attribute.attributeType) {
            case NSBinaryDataAttributeType:
                canSelect = YES;
                break;
            default:
                canSelect = isEditing;
                break;
        }
    }
    else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
        
        NSRelationshipDescription *relationship = (NSRelationshipDescription *)property;
        if (relationship.isToMany) {
            if (isEditing) {
                //  To-many, editing, select the first cell to add new object to relationship
                canSelect = (indexPath.row == 0);
            }
            else {
                //  To-many, not editing, select to view.
                canSelect = YES;
            }
        }
        else {
            if (isEditing) {
                //  To-one, editing, select to edit
                canSelect = YES;
            }
            else {
                //  To-one, not editing, if related object is not nil, select to view it.
                canSelect = ([object valueForKey:relationship.name] != nil);
            }
        }
    }
    
    return canSelect ? indexPath : nil;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEditing) {
        NSIndexPath *oldIndexPath = self.editingIndexPath;
        if (oldIndexPath != nil) {
            NCUAttributeViewCell
            *cell = (NCUAttributeViewCell *)[self.tableView cellForRowAtIndexPath:oldIndexPath];
            [self validateAndSaveEditingAttribute:nil
                                     withNewValue:cell.value
                                       allowReset:YES];
        }
        
        self.editingIndexPath = indexPath;
    }
    
    NSManagedObject *object = self.object;
    NSString *propertyName = [self propertyNameWithIndexPath:indexPath];
    NSPropertyDescription *property = object.entity.propertiesByName[propertyName];
    BOOL isEditing = self.isEditing;
    
    if ([property isKindOfClass:[NSAttributeDescription class]]) {
        
        NSAttributeDescription
        *attribute = (NSAttributeDescription *)property;
        
        switch (attribute.attributeType) {
            case NSBinaryDataAttributeType:{
                if (isEditing) {
                    BOOL shouldEdit =
                    [self.controller shouldObjectViewController:self
                                          startEditingAttribute:attribute
                                                       ofObject:object];
                    if (!shouldEdit) {
                        [tableView deselectRowAtIndexPath:indexPath
                                                 animated:YES];
                        [self didEndEditingAttribute];
                    }
                }
                else {
                    [self.controller objectViewController:self
                                         displayAttribute:attribute
                                                 ofObject:object];
                }
            }break;
            default:{
                NCUAttributeViewCell
                *cell = (NCUAttributeViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                [cell startToEdit];
                
                [tableView deselectRowAtIndexPath:indexPath
                                         animated:YES];
                [tableView scrollToRowAtIndexPath:indexPath
                                 atScrollPosition:UITableViewScrollPositionTop
                                         animated:YES];
            }break;
        }
    }
    else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
        
        NSRelationshipDescription
        *relationship = (NSRelationshipDescription *)property;
        NSString
        *key = relationship.name;
        
        if (relationship.isToMany) {
            if (isEditing) {
                BOOL isAddCell = (indexPath.row == 0);
                if (isAddCell) {
                    [self pushObjectPickerControllerWithRelationship:relationship];
                }
            } else {
                NSSet
                *relatedObjects = [object valueForKey:key];
                NSManagedObject
                *relatedObject = relatedObjects.allObjects[indexPath.row];
                
                [self pushObjectViewControllerWithRelatedObject:relatedObject];
            }
        }
        else {
            
            isEditing ?
            [self pushObjectPickerControllerWithRelationship:relationship] :
            [self pushObjectViewControllerWithRelatedObject:[object valueForKey:key]];
            
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL canEdit = YES;
    
    NSManagedObject *object = self.object;
    NSString *propertyName = [self propertyNameWithIndexPath:indexPath];
    NSPropertyDescription *property = object.entity.propertiesByName[propertyName];
    
    if ([property isKindOfClass:[NSAttributeDescription class]]) {
        //  No need to show edit accessory for attribute cell
        canEdit = NO;
    }
    else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
        NSRelationshipDescription
        *relationship = (NSRelationshipDescription *)property;
        
        if (relationship.isToMany) {
            //  No need to show edit accessory for attribute cell
            BOOL hasValue = ([[object valueForKey:propertyName] count] != 0);
            BOOL isAddCell = self.isEditing && (indexPath.row == 0);
            canEdit =
            isAddCell ||                                            // Show '+'
            (!isAddCell && hasValue) ||                             // Show '-'
            (!isAddCell && !hasValue && relationship.isOptional);   // Show '-'
        }
        else {
            BOOL hasValue = ([object valueForKey:propertyName] != nil);
            canEdit = hasValue && relationship.isOptional;  //  Show '-'
        }
    }
    
    return canEdit;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
    
    NSManagedObject *object = self.object;
    NSString *propertyName = [self propertyNameWithIndexPath:indexPath];
    NSPropertyDescription *property = object.entity.propertiesByName[propertyName];

    //  Only relationship can be edited.
    if ([property isKindOfClass:[NSRelationshipDescription class]]) {
        NSRelationshipDescription
        *relationship = (NSRelationshipDescription *)property;
        
        if (relationship.isToMany) {
            //  No need to test self.isEditing, if not editing, add cell even not exit
            BOOL isAddCell = indexPath.row == 0;
            style =
            (isAddCell) ?
            UITableViewCellEditingStyleInsert :
            UITableViewCellEditingStyleDelete;
        }
        else {
            BOOL hasValue = ([object valueForKey:propertyName] != nil);
            style =
            (hasValue && relationship.isOptional) ?
            UITableViewCellEditingStyleDelete :
            UITableViewCellEditingStyleNone;
        }
    }
    
    return style;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEditing) {
        self.editingIndexPath = indexPath;
    }

    NSManagedObject *object = self.object;
    NSString *propertyName = [self propertyNameWithIndexPath:indexPath];
    NSRelationshipDescription *relationship = object.entity.relationshipsByName[propertyName];

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *difference = nil;
        id oldValue = nil;
        id newValue = nil;
        if (relationship.isToMany) {
            NSUInteger relatedRow = indexPath.row - 1;
            NSSet *relatedObjects = [object valueForKey:relationship.name];
            NSManagedObject *relatedObject = relatedObjects.allObjects[relatedRow];
            
            NSMutableSet *copy = relatedObjects.mutableCopy;
            NSAssert([copy containsObject:relatedObject], @"Expect containing relatedObject");
            [copy removeObject:relatedObject];
            
            oldValue = relatedObjects;
            newValue = copy;
            difference = @[relatedObject];
        }
        else {
            NSManagedObject *relatedObject = [object valueForKey:relationship.name];
            NSAssert(relatedObject, @"Expect relatedObject");
            
            oldValue = relatedObject;
            newValue = nil;
            difference = @[relatedObject];
        }
        
        NSError *error = nil;
        BOOL isValid =
        [self validateAndSaveEditingRelationship:&error
                                        oldValue:oldValue
                                        newValue:newValue
                                      difference:difference];
        
        if (!isValid) {
            [self showValidationError:error];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self pushObjectPickerControllerWithRelationship:relationship];
    }
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    NSString *propertyName = self.orderedPropertyNames[section];
    return propertyName;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (
        sourceIndexPath.section != proposedDestinationIndexPath.section ||  // Move to other property
        proposedDestinationIndexPath.row == 0 // Move to add cell
        )
    {
        return sourceIndexPath;
    }
    
    return proposedDestinationIndexPath;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath = self.editingIndexPath;
    if (indexPath) {
        NCUAttributeViewCell
        *cell = (NCUAttributeViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [self validateAndSaveEditingAttribute:nil
                                 withNewValue:cell.value
                                   allowReset:YES];
    }
    
    [self didEndEditingAttribute];
}

#pragma mark - NCUAttributeViewCellDelegate

- (BOOL)shouldAttributeCell:(NCUAttributeViewCell *)cell
   confirmTappingSaveButton:(UIBarButtonItem *)button
{
    NSError *error = nil;
    BOOL isValid =
    [self validateAndSaveEditingAttribute:&error
                             withNewValue:cell.value
                               allowReset:NO];
    if (!isValid) {
        [self showValidationError:error];
    }
    
    return isValid;
}

- (BOOL)shouldAttributeCell:(NCUAttributeViewCell *)cell
 confirmTappingCancelButton:(UIBarButtonItem *)button
{
    [self resetEditingAttribute];
    return YES;
}

#pragma mark - NCUObjectPickerViewControllerDelegate

- (void)objectPickerViewController:(NCUObjectPickerViewController *)controller
                    didPickObjects:(NSArray *)objects
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSIndexPath *indexPath = self.editingIndexPath;
    
    NSManagedObject *object = self.object;
    NSString *propertyName = [self propertyNameWithIndexPath:indexPath];
    NSRelationshipDescription *relationship = object.entity.relationshipsByName[propertyName];
    
    NSArray *difference = nil;
    id oldValue = nil;
    id newValue = nil;
    if (relationship.isToMany) {
        NSSet
        *relatedObjects = [object valueForKey:relationship.name];
        NSMutableSet
        *copy = relatedObjects.mutableCopy;
        [copy addObjectsFromArray:objects];
        
        oldValue = relatedObjects;
        newValue = copy;
        difference = objects;
    }
    else {
        oldValue = [object valueForKey:relationship.name];
        newValue = objects.firstObject;
        difference = objects;
    }
    
    NSError *error = nil;
    BOOL isValid =
    [self validateAndSaveEditingRelationship:&error
                                    oldValue:oldValue
                                    newValue:newValue
                                  difference:difference];
    
    if (!isValid) {
        [self showValidationError:error];
    }
}

- (void)objectPickerViewControllerDidCancel:(NCUObjectPickerViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self didEndEditingRelationshipUpdated:NO];
}

#pragma mark - Actions
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (self.isEditing && !editing) {
        BOOL should = [self shouldCancelEditState];
        if (!should) return;
    }
    
    [super setEditing:editing animated:animated];
    
    [self reloadSections];
}

- (BOOL)shouldCancelEditState
{
    NSError *error = nil;
    BOOL isValid = NO;
    
    NSIndexPath *indexPath = self.editingIndexPath;
    if (indexPath) {
        NCUAttributeViewCell
        *cell = (NCUAttributeViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        isValid =
        [self validateAndSaveEditingAttribute:&error
                                 withNewValue:cell.value
                                   allowReset:NO];
        
        if (!isValid) {
            [self showValidationError:error];
            return NO;
        }
    }

    isValid = [self validateAndSave:&error
                      allowRollback:NO];
    if (!isValid) {
        [self showValidationError:error];
        return NO;
    }
    
    return YES;
}

#pragma mark - Events
- (void)showValidationError:(NSError *)error
{
    NSString *keyString = error.userInfo[NSValidationKeyErrorKey];
    if (!keyString) {
        NSString *keyPath = [NSString stringWithFormat:@"userInfo.%@", NSValidationKeyErrorKey];
        NSArray *keys = [error.userInfo[NSDetailedErrorsKey] valueForKeyPath:keyPath];
        keyString = [keys componentsJoinedByString:@", "];
    }
    
    NSString *title = [NSString stringWithFormat:@"Invalid value for key(s) ‘%@’", keyString];
    
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:title
                               message:error.localizedFailureReason
                              delegate:nil
                     cancelButtonTitle:@"Get it"
                     otherButtonTitles:nil];
    [alert show];
}

- (void)pushObjectPickerControllerWithRelationship:(NSRelationshipDescription *)relationship
{
    NCUObjectPickerViewController *con = [[NCUObjectPickerViewController alloc] init];
    con.controller = self.controller;
    con.delegate = self;
    
    NSManagedObject *object = self.object;
    NSString *entityName = relationship.destinationEntity.name;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    request.sortDescriptors = self.controller.sortDecriptorsByEntityName[entityName];
    if (relationship.isToMany) {
        NSSet *relatedObjects = [object valueForKey:relationship.name];
        request.predicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", relatedObjects];
    }
    else {
        NSManagedObject *relatedObject = [object valueForKey:relationship.name];
        request.predicate = [NSPredicate predicateWithFormat:@"SELF != %@", relatedObject];
    }

    con.fetchRequest = request;
    
    UINavigationController
    *nav = [[UINavigationController alloc] initWithRootViewController:con];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)pushObjectViewControllerWithRelatedObject:(NSManagedObject *)object
{
    NCUObjectViewController *con = [[NCUObjectViewController alloc] init];
    con.controller = self.controller;
    con.object = object;
    
    [self.navigationController pushViewController:con animated:YES];
}

- (void)reloadSections
{
    [self.tableView reloadSections:self.toManyRelationshipsIndexSet
                  withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Object

- (BOOL)validateAndSave:(NSError **)error
          allowRollback:(BOOL)allow
{
    BOOL isValid = [self isObjectValidForSaving:error];
    
    NSManagedObjectContext *moc = self.object.managedObjectContext;
    if (!isValid) {
        if (allow) {
            // Rollback invalid changes
            [moc rollback];
        }
        else {
            return NO;
        }
    }
    
    NSError *saveError = nil;
    [moc save:&saveError];
    
    return isValid;
}

- (BOOL)isObjectValidForSaving:(NSError **)error
{
    return [self.object validateForUpdate:error];
}

#pragma mark - Attributes

- (BOOL)validateAndSaveEditingAttribute:(NSError **)error
                           withNewValue:(id)value
                             allowReset:(BOOL)allow
{
    NSIndexPath *indexPath = self.editingIndexPath;
    NSAssert(indexPath, @"Expect indexPath");
    
    NSManagedObject *object = self.object;
    NSString *key = self.orderedPropertyNames[indexPath.section];
    
    BOOL isValid = [object validateValue:&value
                                  forKey:key
                                   error:error];
    
    if (isValid) {
        [object setValue:value forKey:key];
    }
    else {
        if (allow) {
            [object willChangeValueForKey:key];
            [object didChangeValueForKey:key];
            
            [self didEndEditingAttribute];
        }
        return NO;
    }
    
    [self didEndEditingAttribute];
    return YES;
}

- (void)resetEditingAttribute
{
    NSIndexPath *indexPath = self.editingIndexPath;
    NSManagedObject *object = self.object;
    NSString *name = self.orderedPropertyNames[indexPath.section];
    
    [object willChangeValueForKey:name];
    [object didChangeValueForKey:name];
    
    [self didEndEditingAttribute];
}

- (void)didEndEditingAttribute
{
    NSIndexPath *indexPath = self.editingIndexPath;
    if (!indexPath) return;
    
    NCUAttributeViewCell
    *cell = (NCUAttributeViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell endEditing];
    
    self.editingIndexPath = nil;
}

- (id)editingAttributeValue
{
    NSIndexPath *indexPath = self.editingIndexPath;
    if (!indexPath) return nil;
    
    NSString *key = [self propertyNameWithIndexPath:indexPath];
    id value = [self.object valueForKey:key];
    
    return value;
}

- (void)setEditingAttributeValue:(id)editingAttributeValue
{
    NSIndexPath *indexPath = self.editingIndexPath;
    if (!indexPath) return;
    
    NSError *error = nil;
    BOOL isValid =
    [self validateAndSaveEditingAttribute:&error
                             withNewValue:editingAttributeValue
                               allowReset:NO];
    if (!isValid) {
        [self showValidationError:error];
    }
    
    [self didEndEditingAttribute];
}

#pragma mark - Relationships
- (BOOL)validateAndSaveEditingRelationship:(NSError **)error
                                  oldValue:(id)oldValue
                                  newValue:(id)newValue
                                difference:(NSArray *)difference
{
    NSIndexPath *indexPath = self.editingIndexPath;
    NSAssert(indexPath, @"Expect indexPath");
    
    NSManagedObject *object = self.object;
    NSString *key = self.orderedPropertyNames[indexPath.section];
    
    BOOL isObjectValid =
    [object validateValue:&newValue
                   forKey:key
                    error:error];
    
    if (isObjectValid) {
        [object setValue:newValue forKey:key];
    }
    
    BOOL isDifferentObjectsValid = YES;
    for (NSManagedObject *differentObject in difference) {
        //if (differentObject.isDeleted) continue;
        isDifferentObjectsValid = [differentObject validateForUpdate:error];
        if (!isDifferentObjectsValid) break;
    }
    if (!isDifferentObjectsValid) {
        [object setValue:oldValue forKey:key];
    }
    
    [self didEndEditingRelationshipUpdated:YES];
    return isObjectValid && isDifferentObjectsValid;
}

- (void)didEndEditingRelationshipUpdated:(BOOL)isUpdated
{
    NSIndexPath *indexPath = self.editingIndexPath;
    
    if (isUpdated) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                      withRowAnimation:UITableViewRowAnimationFade];
    }

    self.editingIndexPath = nil;
}

#pragma mark - Functions
- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
     withRelationship:(NSRelationshipDescription *)relationship
             ofObject:(NSManagedObject *)object
{
    NSString *destinationEntityName = relationship.destinationEntity.name;
    cell.detailTextLabel.text = destinationEntityName;
    
    NSString *key = relationship.name;
    if (relationship.isToMany) {
        if (self.isEditing && (indexPath.row < 1)) //  isEditing and isAddCell
        {
            NSString *text = [NSString stringWithFormat:@"Add %@", relationship.isOptionalString];
            cell.textLabel.text = text;
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
        else
        {
            NSUInteger relatedRow = self.isEditing ? (indexPath.row - 1) : indexPath.row;
            
            NSManagedObject *relatedObject = nil;
            if (relationship.isOrdered)
            {
                NSOrderedSet *relatedObjects = [object valueForKey:key];
                relatedObject = relatedObjects[relatedRow];
            }
            else
            {
                NSSet *relatedObjects = [object valueForKey:key];
                relatedObject = relatedObjects.allObjects[relatedRow];
            }
            
            NSString *title = [relatedObject titleWithController:self.controller];
            cell.textLabel.text = title;
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    else
    {
        NSManagedObject *relatedObject = [object valueForKey:key];
        NSString *title = [relatedObject titleWithController:self.controller];
        cell.textLabel.text = title ? title : relationship.isOptionalString;
        cell.textLabel.textColor = title ? [UIColor blackColor] : [UIColor lightGrayColor];
    }
}

#pragma mark - Model

- (NSOrderedSet *)orderedPropertyNames
{
    if (_orderedPropertyNames) return _orderedPropertyNames;
    
    NSEntityDescription *entity = self.object.entity;
    
    NSMutableOrderedSet *collector = [[NSMutableOrderedSet alloc] initWithCapacity:entity.properties.count];
    [collector addObjectsFromArray:entity.attributesByName.allKeys];
    [collector addObjectsFromArray:entity.relationshipsByName.allKeys];
    
    return _orderedPropertyNames = collector;
}

- (NSIndexSet *)toManyRelationshipsIndexSet
{
    if (_toManyRelationshipsIndexSet) return _toManyRelationshipsIndexSet;
    
    NSMutableIndexSet *collector = [[NSMutableIndexSet alloc] init];
    NSDictionary *relationshipsByName = self.object.entity.relationshipsByName;
    [self.orderedPropertyNames enumerateObjectsUsingBlock:
     ^(NSString *name,
       NSUInteger idx,
       BOOL *stop) {
         NSRelationshipDescription *relationship = relationshipsByName[name];
         if (relationship.isToMany) {
             [collector addIndex:idx];
         }
     }];
    
    return _toManyRelationshipsIndexSet = [[NSIndexSet alloc] initWithIndexSet:collector];
}

- (NSString *)propertyNameWithIndexPath:(NSIndexPath *)indexPath
{
    return self.orderedPropertyNames[indexPath.section];
}

@end

