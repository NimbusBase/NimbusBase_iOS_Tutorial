//
//  NCUController.m
//  NimbusTester
//
//  Created by William Remaerd on 3/18/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NCUController.h"

@interface NCUController ()

@property(nonatomic, strong)NSManagedObjectContext *managedObjectContext;
@property(nonatomic, readonly)NSManagedObjectModel *managedObjectModel;
@property(nonatomic, strong)NSDictionary *sortDecriptorsByEntityName;
@property(nonatomic, strong)NSDictionary *keyPathOfObjectTitleByEntityName;

@property(nonatomic, strong)NSDateFormatter *dateFormatter;

@end

@implementation NCUController

- (NSManagedObjectModel *)managedObjectModel
{
    return self.managedObjectContext.persistentStoreCoordinator.managedObjectModel;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) return _managedObjectContext;
    
    NSManagedObjectContext *moc = nil;
    id<NCUControllerDataSource> dataSource = self.dataSource;
    if (dataSource && [dataSource respondsToSelector:@selector(managedObjectContextForController:)]) {
        moc = [dataSource managedObjectContextForController:self];
    }
    
    return _managedObjectContext = moc;
}

- (NSDictionary *)sortDecriptorsByEntityName
{
    if (_sortDecriptorsByEntityName) return _sortDecriptorsByEntityName;
    
    NSArray
    *entities = self.managedObjectModel.entities;
    NSMutableDictionary
    *dic = [[NSMutableDictionary alloc] initWithCapacity:entities.count];
    
    id<NCUControllerDataSource> dataSource = self.dataSource;
    if (dataSource &&
        [dataSource respondsToSelector:@selector(controller:sortDecriptorsForEntity:)]) {
        
        for (NSEntityDescription *entity in entities) {
            NSArray
            *descriptors = [dataSource controller:self sortDecriptorsForEntity:entity];
            dic[entity.name] = descriptors;
        }
        
    }

    return _sortDecriptorsByEntityName = dic;
}

- (NSDictionary *)keyPathOfObjectTitleByEntityName
{
    if (_keyPathOfObjectTitleByEntityName) return _keyPathOfObjectTitleByEntityName;
    
    NSArray
    *entities = self.managedObjectModel.entities;
    NSMutableDictionary
    *dic = [[NSMutableDictionary alloc] initWithCapacity:entities.count];
    
    id<NCUControllerDataSource> dataSource = self.dataSource;
    if (dataSource &&
        [dataSource respondsToSelector:@selector(controller:keyPathOfObjectTitle:)]) {
        
        for (NSEntityDescription *entity in entities) {
            NSString
            *keyPath = [dataSource controller:self keyPathOfObjectTitle:entity];
            dic[entity.name] = keyPath;
        }
    }
    
    return _keyPathOfObjectTitleByEntityName = dic;
}

#pragma mark - Attribute

- (NSString *)stringFromAttributeType:(NSAttributeType)type
{
    static NSDictionary *dic = nil;
    if (!dic) {
        dic =
        @{
          @(NSUndefinedAttributeType): @"Undefined",
          @(NSInteger16AttributeType): @"Integer16",
          @(NSInteger32AttributeType): @"Integer32",
          @(NSInteger64AttributeType): @"Integer64",
          @(NSDecimalAttributeType): @"Decimal",
          @(NSDoubleAttributeType): @"Double",
          @(NSFloatAttributeType): @"Float",
          @(NSStringAttributeType): @"String",
          @(NSBooleanAttributeType): @"Boolean",
          @(NSDateAttributeType): @"Date",
          @(NSBinaryDataAttributeType): @"Binary",
          @(NSTransformableAttributeType): @"Transformable",
          @(NSObjectIDAttributeType): @"ObjectID",
          };
    }

    return dic[@(type)];
}

- (NSString *)stringFromAttribute:(NSAttributeDescription *)attribute
                         ofEntity:(NSEntityDescription *)entity
{
    return [self stringFromAttributeType:attribute.attributeType];
}

- (NSInteger)keyboardTypeForAttributeType:(NSAttributeType)type
{
    static NSDictionary *dic = nil;
    if (!dic) {
        dic =
        @{
          @(NSUndefinedAttributeType): @(UIKeyboardTypeDefault),
          @(NSInteger16AttributeType): @(UIKeyboardTypeNumberPad),
          @(NSInteger32AttributeType): @(UIKeyboardTypeNumberPad),
          @(NSInteger64AttributeType): @(UIKeyboardTypeNumberPad),
          @(NSDecimalAttributeType): @(UIKeyboardTypeDecimalPad),
          @(NSDoubleAttributeType): @(UIKeyboardTypeDecimalPad),
          @(NSFloatAttributeType): @(UIKeyboardTypeDecimalPad),
          @(NSStringAttributeType): @(UIKeyboardTypeDefault),
          @(NSBooleanAttributeType): @(UIKeyboardTypeASCIICapable),
          @(NSDateAttributeType): @(UIKeyboardTypeASCIICapable),
          };
    }
    
    return [dic[@(type)] integerValue];
}

- (NSInteger)keyboardTypeFromAttribute:(NSAttributeDescription *)attribute
                              ofEntity:(NSEntityDescription *)entity
{
    return [self keyboardTypeForAttributeType:attribute.attributeType];
}

- (BOOL)shouldObjectViewController:(NCUObjectViewController *)viewController
             startEditingAttribute:(NSAttributeDescription *)attibute
                          ofObject:(NSManagedObject *)object
{
    id<NCUControllerDelegate> delegate = self.delegate;
    if (delegate &&
        [delegate respondsToSelector:@selector(shouldObjectViewController:startEditingAttribute:ofObject:)]) {
        return [delegate shouldObjectViewController:viewController
                              startEditingAttribute:attibute
                                           ofObject:object];
    }
    
    return NO;
}

- (void)objectViewController:(NCUObjectViewController *)viewController
            displayAttribute:(NSAttributeDescription *)attibute
                    ofObject:(NSManagedObject *)object
{
    id<NCUControllerDelegate> delegate = self.delegate;
    if (delegate &&
        [delegate respondsToSelector:@selector(objectViewController:displayAttribute:ofObject:)]) {
        [delegate objectViewController:viewController
                      displayAttribute:attibute
                              ofObject:object];
    }
}

#pragma mark - Value

- (NSString *)stringFromAttribute:(NSAttributeDescription *)attribute
                         ofObject:(NSManagedObject *)object
{
    id value = [object valueForKey:attribute.name];
    if (!value || [value isKindOfClass:[NSNull class]]) return nil;
    
    NSString *ret = value;
    
    switch (attribute.attributeType) {
        case NSUndefinedAttributeType:{
            ret = [NSString stringWithFormat:@"%@", value];
        }break;
        case NSInteger16AttributeType:{
            ret = [value stringValue];
        }break;
        case NSInteger32AttributeType:{
            ret = [value stringValue];
        }break;
        case NSInteger64AttributeType:{
            ret = [value stringValue];
        }break;
        case NSDecimalAttributeType:{
            ret = [value stringValue];
        }break;
        case NSDoubleAttributeType:{
            ret = [value stringValue];
        }break;
        case NSFloatAttributeType:{
            ret = [value stringValue];
        }break;
        case NSStringAttributeType:{
            ret = value;
        }break;
        case NSBooleanAttributeType:{
            ret = [value boolValue] ? @"YES" : @"NO";
        }break;
        case NSDateAttributeType:{
            NSDateFormatter *dateFormatter = [self dateFormatterForAttribute:attribute ofEntity:object.entity];
            ret = [dateFormatter stringFromDate:value];
        }break;
        case NSBinaryDataAttributeType:{
            NSData *data = value;
            ret = [NSString stringWithFormat:@"%u", data.length];
        }break;
        case NSTransformableAttributeType:{
            ret = [value description];
        }break;
        case NSObjectIDAttributeType:{
            ret = [value description];
        }break;
        default:
            break;
    }
    
    return ret;
}

- (id)valueFromAttrbute:(NSAttributeDescription *)attribute
               ofEntity:(NSEntityDescription *)entity
             withString:(NSString *)string
{
    if (string.length == 0) return nil;
    
    id ret = string;
    
    switch (attribute.attributeType) {
        case NSUndefinedAttributeType:{
            ret = string;
        }break;
        case NSInteger16AttributeType:{
            ret = @(string.integerValue);
        }break;
        case NSInteger32AttributeType:{
            ret = @(string.integerValue);
        }break;
        case NSInteger64AttributeType:{
            ret = @(string.integerValue);
        }break;
        case NSDecimalAttributeType:{
            ret = [NSDecimalNumber decimalNumberWithString:string];
        }break;
        case NSDoubleAttributeType:{
            ret = @([string doubleValue]);
        }break;
        case NSFloatAttributeType:{
            ret = @([string floatValue]);
        }break;
        case NSStringAttributeType:{
            ret = string;
        }break;
        case NSBooleanAttributeType:{
            ret = [[string capitalizedString] isEqualToString:@"YES"] ? @(YES) : @(NO);
        }break;
        case NSDateAttributeType:{
            NSDateFormatter *dateFormatter = [self dateFormatterForAttribute:attribute ofEntity:entity];
            ret = [dateFormatter dateFromString:string];
        }break;
        default:
            break;
    }
    
    return ret;
}

#pragma mark - DateFormatter
- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter) return _dateFormatter;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterLongStyle;
    dateFormatter.timeStyle = kCFDateFormatterLongStyle;
    
    return _dateFormatter = dateFormatter;
}

- (NSDateFormatter *)dateFormatterForAttribute:(NSAttributeDescription *)attribute ofEntity:(NSEntityDescription *)entity
{
    return self.dateFormatter;
}

@end
