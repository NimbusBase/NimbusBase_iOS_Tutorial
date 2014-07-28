//
//  NCUObjectCreatorViewController.m
//  NimbusTester
//
//  Created by William Remaerd on 3/20/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NCUObjectCreatorViewController.h"
#import "NCUController.h"

@interface NCUObjectViewController (NCUObjectCreatorViewController)
- (BOOL)validateAndSave:(NSError **)error allowRollback:(BOOL)allow;
@end

@interface NCUObjectCreatorViewController ()

@end

@implementation NCUObjectCreatorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [self cancelBarButtonItem];
    
    self.object = [self createObject];
    [self setEditing:YES animated:NO];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Subviews

- (UIBarButtonItem *)cancelBarButtonItem
{
    UIBarButtonItem
    *cancel =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                  target:self
                                                  action:@selector(didTapCancelButton:)];
    
    return cancel;
}

#pragma mark - Actions

- (void)didTapCancelButton:(UIBarButtonItem *)button
{
    [self cancel];
}

#pragma mark - Events

- (BOOL)validateAndSave:(NSError **)error
          allowRollback:(BOOL)allow
{
    BOOL isValid = [super validateAndSave:error allowRollback:allow];
    if (!isValid) return NO;
    
    id<NCUObjectCreatorViewControllerDelegate> delegate = self.delegate;
    if (delegate &&
        [delegate respondsToSelector:@selector(objectCreatorViewController:didSucceedToCreateObject:)]) {
        [delegate objectCreatorViewController:self didSucceedToCreateObject:self.object];
    }
    
    return YES;
}

- (BOOL)isObjectValidForSaving:(NSError **)error
{
    return [self.object validateForInsert:error];
}

- (void)cancel
{
    NSManagedObjectContext *moc = self.object.managedObjectContext;
    NSManagedObject *object = self.object;
    
    [moc deleteObject:object];
    
    NSError *error = nil;
    [moc save:&error];

    id<NCUObjectCreatorViewControllerDelegate> delegate = self.delegate;
    if (delegate &&
        [delegate respondsToSelector:@selector(objectCreatorViewControllerDidCancel:)]) {
        [delegate objectCreatorViewControllerDidCancel:self];
    }
}

- (NSManagedObject *)createObject
{
    NSAssert(self.entity, @"Expect entity.");
    NSAssert(self.controller, @"Expect controller.");

    NSManagedObject
    *object =
    [[NSManagedObject alloc] initWithEntity:self.entity
             insertIntoManagedObjectContext:self.controller.managedObjectContext];
    
    return object;
}

@end
