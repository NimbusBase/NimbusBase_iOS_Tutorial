//
//  UITableView+Quick.m
//  NimbusBase_iOS_Tutorial
//
//  Created by William Remaerd on 2/7/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "UITableView+Quick.h"

@implementation UITableView (Quick)

- (void)deselectSelectedRowsAnimated:(BOOL)animated{
    for (NSIndexPath *i in self.indexPathsForSelectedRows) {
        [self deselectRowAtIndexPath:i animated:animated];
    }
}

@end
