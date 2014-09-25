//
//  NSManagedObjectContext+Quick.m
//  NimbusBase_iOS_Tutorial
//
//  Created by William Remaerd on 9/25/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NSManagedObjectContext+Quick.h"

@implementation NSManagedObjectContext (Quick)

- (NSArray *)deleteAllManagedObjects
{
    NSManagedObjectContext *moc = self;
    NSManagedObjectModel *model = moc.persistentStoreCoordinator.managedObjectModel;
    
    NSMutableArray *collector = [[NSMutableArray alloc] init];
    for (NSEntityDescription *entityDesc in model)
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = entityDesc;
        request.includesSubentities = NO;
        request.returnsObjectsAsFaults = YES;
        request.includesPropertyValues = NO;
        
        NSError *error = nil;
        NSArray *results = [moc executeFetchRequest:request
                                              error:&error];
        NSAssert(error == nil, @"\n%@", error);
        
        for (NSManagedObject *obj in results)
        {
            [collector addObject:obj];
        }
    }
    
    for (NSManagedObject *obj in collector)
    {
        [moc deleteObject:obj];
    }
    
    return [collector valueForKey:@"objectID"];
}

@end
