//
//  NCUAttributeViewCell.m
//  NimbusTester
//
//  Created by William Remaerd on 3/19/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NCUAttributeViewCell.h"
#import "NCUController.h"

#import "NSPropertyDescription+NCU.h"

@interface NCUAttributeViewCell ()

@property(nonatomic, weak)UITextField *textField;

@property(nonatomic, weak)NCUController *controller;
@property(nonatomic, strong)NSAttributeDescription *attribute;
@property(nonatomic, strong)NSManagedObject *object;

@property(nonatomic, weak)UIDatePicker *datePicker;

@end

@implementation NCUAttributeViewCell

- (id)initWithController:(NCUController *)controller
         reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:reuseIdentifier])
    {
        self.controller = controller;
        
        UILabel *detailTextLabel = self.detailTextLabel;
        detailTextLabel.textColor = [UIColor lightGrayColor];
        detailTextLabel.adjustsFontSizeToFitWidth = YES;
        detailTextLabel.minimumScaleFactor = 0.5f;

        UILabel *textLabel = self.textLabel;
        textLabel.text = @" ";
        
        UITextField *textField = self.textField;
        textField.font = [UIFont systemFontOfSize:textField.font.pointSize];
        textField.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    self.attribute = nil;
}

#pragma mark - UITextField

- (UITextField *)textField
{
    if (_textField) return _textField;
    
    UIView *superview = self.contentView;
    UITextField *textField = [[UITextField alloc] init];
    
    textField.backgroundColor = [UIColor clearColor];
    textField.adjustsFontSizeToFitWidth = YES;
    textField.minimumFontSize = 1.0f;
    textField.inputAccessoryView = [self toolBar];

    textField.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addSubview:textField];
    
    NSDictionary *viewsDic = NSDictionaryOfVariableBindings(textField);
    
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[textField]-8-|"
                                             options:0
                                             metrics:nil
                                               views:viewsDic]];
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[textField]-13-|"
                                             options:0
                                             metrics:nil
                                               views:viewsDic]];
    [superview addConstraints:constraints];
    
    return _textField = textField;
}

- (void)setDelegate:(id<NCUAttributeViewCellDelegate>)delegate
{
    self.textField.delegate = delegate;
}

- (id<NCUAttributeViewCellDelegate>)delegate
{
    return (id<NCUAttributeViewCellDelegate>)self.textField.delegate;
}

#pragma mark - Actions

- (void)didTapSaveButton:(UIBarButtonItem *)button
{
    BOOL should = YES;
    
    id<NCUAttributeViewCellDelegate> delegate = self.delegate;
    if (delegate &&
        [delegate respondsToSelector:@selector(shouldAttributeCell:confirmTappingSaveButton:)]) {
        should = [delegate shouldAttributeCell:self
             confirmTappingSaveButton:button];
    }
    
    if (should) {
        [self endEditing];
    }
}

- (void)didTapCancelButton:(UIBarButtonItem *)button
{
    BOOL should = YES;

    id<NCUAttributeViewCellDelegate> delegate = self.delegate;
    if (delegate &&
        [delegate respondsToSelector:@selector(shouldAttributeCell:confirmTappingCancelButton:)]) {
        should = [delegate shouldAttributeCell:self
           confirmTappingCancelButton:button];
    }

    if (should) {
        [self endEditing];
    }
}

- (void)didChangeDate:(UIDatePicker *)picker
{
    NSDateFormatter
    *dateFormatter =
    [self.controller dateFormatterForAttribute:self.attribute
                                      ofEntity:self.object.entity];
    NSString *text = [dateFormatter stringFromDate:picker.date];
    self.textField.text = text;
}

#pragma mark - Edit

- (void)startToEdit
{
    UITextField *textField = self.textField;
    NSAttributeDescription *attribute = self.attribute;
    NSManagedObject *object = self.object;
    switch (attribute.attributeType) {
        case NSDateAttributeType:{
            UIDatePicker *datePicker = [self datePicker];
            NSDate *value = [object valueForKey:attribute.name];
            if (value) {
                datePicker.date = value;
            }
            textField.inputView = datePicker;
        }break;
        default:{
        }break;
    }
    
    textField.userInteractionEnabled = YES;
    [textField becomeFirstResponder];
}

- (void)endEditing
{
    UITextField *textField = self.textField;
    [textField resignFirstResponder];
    textField.userInteractionEnabled = NO;
}

#pragma mark - Subviews

- (UIToolbar *)toolBar
{
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    UIBarButtonItem
    *buttonCancel =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                  target:self
                                                  action:@selector(didTapCancelButton:)],
    *buttonSave =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                  target:self
                                                  action:@selector(didTapSaveButton:)],
    *space =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                  target:nil
                                                  action:nil];
    toolBar.items = @[buttonCancel, space, buttonSave];
    
    return toolBar;
}

- (UIDatePicker *)datePicker
{
    if (_datePicker) return _datePicker;
    
    UIDatePicker
    *datePicker =
    [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self
                   action:@selector(didChangeDate:)
         forControlEvents:UIControlEventValueChanged];

    return _datePicker = datePicker;
}


#pragma mark - Model

- (void)setAttribute:(NSAttributeDescription *)attribute
{
    if (_attribute) {
        [self.object removeObserver:self forKeyPath:_attribute.name];
    }
    
    _attribute = attribute;
    
    if (_attribute) {
        [self.object addObserver:self
                      forKeyPath:_attribute.name
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                         context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSAttributeDescription *attribute = self.attribute;
    if ([keyPath isEqualToString:self.attribute.name]) {
        self.textField.text = [self.controller stringFromAttribute:attribute
                                                          ofObject:object];
    }
}

- (id)value
{
    id value = nil;
    
    NSAttributeDescription *attribute = self.attribute;
    switch (attribute.attributeType) {
        case NSDateAttributeType:{
            value = self.datePicker.date;
        }break;
        default:{
            value =
            [self.controller valueFromAttrbute:attribute
                                      ofEntity:self.object.entity
                                    withString:self.textField.text];
        }break;
    }
    
    return value;
}

#pragma mark - Object
- (void)setAttribute:(NSAttributeDescription *)attribute
            ofObject:(NSManagedObject *)object;
{
    NCUController *con = self.controller;
    self.object = object;
    self.attribute = attribute;
    
    UITextField *textField = self.textField;
    textField.placeholder = attribute.isOptionalString;
    switch (attribute.attributeType) {
        case NSDateAttributeType:{
            textField.clearButtonMode = UITextFieldViewModeNever;
        }break;
        default:{
            textField.inputView = nil;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.keyboardType =
            [self.controller keyboardTypeFromAttribute:attribute
                                              ofEntity:object.entity];
        }break;
    }
    
    self.detailTextLabel.text = [con stringFromAttribute:attribute ofEntity:object.entity];
}


@end
