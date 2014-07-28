//
//  NCUObjectPickerViewController.m
//  NimbusTester
//
//  Created by William Remaerd on 3/20/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NCUObjectPickerViewController.h"

@interface NCUEntityViewController (NCUObjectPickerViewController)
@property(nonatomic, strong)NSFetchedResultsController *fetchedResultsController;
@end

@interface NCUObjectPickerViewController ()
@end

@implementation NCUObjectPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.rightBarButtonItem = nil;
    navigationItem.leftBarButtonItem = [self cancelBarButtonItem];

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
- (void)cancel
{
    id<NCUObjectPickerViewControllerDelegate> delegate = self.delegate;
    if (delegate &&
        [delegate respondsToSelector:@selector(objectPickerViewControllerDidCancel:)]) {
        [delegate objectPickerViewControllerDidCancel:self];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<NCUObjectPickerViewControllerDelegate> delegate = self.delegate;
    if (delegate &&
        [delegate respondsToSelector:@selector(objectPickerViewController:didPickObjects:)]) {
        
        NSManagedObjectContext *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [delegate objectPickerViewController:self didPickObjects:@[object]];
    }
}

@end
