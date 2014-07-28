//
//  NCUAttributeViewCell.h
//  NimbusTester
//
//  Created by William Remaerd on 3/19/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NCUController, NCUAttributeViewCell;

@protocol NCUAttributeViewCellDelegate <UITextFieldDelegate>

- (BOOL)shouldAttributeCell:(NCUAttributeViewCell *)cell confirmTappingSaveButton:(UIBarButtonItem *)button;
- (BOOL)shouldAttributeCell:(NCUAttributeViewCell *)cell confirmTappingCancelButton:(UIBarButtonItem *)button;

@end

@interface NCUAttributeViewCell : UITableViewCell

@property(nonatomic, readonly)id value;
@property(nonatomic, assign)id<NCUAttributeViewCellDelegate> delegate;

- (id)initWithController:(NCUController *)controller
        reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setAttribute:(NSAttributeDescription *)attribute ofObject:(NSManagedObject *)object;

- (void)startToEdit;
- (void)endEditing;

@end
