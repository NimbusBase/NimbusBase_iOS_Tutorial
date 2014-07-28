//
//  NUIModelViewController.m
//  NimbusTester
//
//  Created by William Remaerd on 3/17/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NCUModelViewController.h"
#import "NCUEntityViewController.h"

#import "NCUController.h"

static NSString *const kReuseIdentifier = @"R";

@interface NCUModelViewController ()

//@property(nonatomic, readonly)NSManagedObjectContext *managedObjectContext;

@end

@implementation NCUModelViewController

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
    self.title = @"Model";
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSArray *entities = self.model.entities;
    return entities.count;
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
    NSEntityDescription *entity = self.model.entities[indexPath.row];
    cell.textLabel.text = entity.name;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSEntityDescription *entity = self.model.entities[indexPath.row];
    [self pushEntityViewController:entity];
}

#pragma mark - Event
- (void)pushEntityViewController:(NSEntityDescription *)entity
{
    NCUEntityViewController
    *con = [[NCUEntityViewController alloc] init];
    
    con.entity = entity;
    con.controller = self.controller;
    
    [self.navigationController pushViewController:con
                                         animated:YES];
}

#pragma mark - Model

- (NSManagedObjectModel *)model
{
    if (_model) return _model;
    
    NSManagedObjectModel
    *model = self.controller.managedObjectContext.persistentStoreCoordinator.managedObjectModel;
    
    return _model = model;
}

@end
