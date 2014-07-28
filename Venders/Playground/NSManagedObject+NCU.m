//
//  NSManagedObject+NCU.m
//  NimbusTester
//
//  Created by William Remaerd on 3/17/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NSManagedObject+NCU.h"
#import "NCUController.h"

@implementation NSManagedObject (NCU)

- (NSString *)ncuTitle
{
    NSURL *uri = self.objectID.URIRepresentation;
    
    NSArray* pathComponents = uri.pathComponents;
    NSUInteger count = pathComponents.count;
    NSArray *lastTwoArray = [pathComponents subarrayWithRange:NSMakeRange(count - 2, 2)];
    NSString* lastTwoPath = [NSString pathWithComponents:lastTwoArray];
    
    return lastTwoPath;
}

- (NSString *)titleWithController:(NCUController *)controller
{
    NSString *title = nil;
    
    NSString *keyPath = controller.keyPathOfObjectTitleByEntityName[self.entity.name];
    if (keyPath) {
        id value = [self valueForKeyPath:keyPath];
        title = value ? [NSString stringWithFormat:@"%@", value] : nil;
    }
    
    if (!title || title.length == 0) {
        title = self.ncuTitle;
    }
    
    return title;
}

@end
