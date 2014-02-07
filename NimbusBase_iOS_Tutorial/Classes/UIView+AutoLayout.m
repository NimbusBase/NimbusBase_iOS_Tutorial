//
//  UIView+AutoLayout.m
//  NimbusPhotoAlbum
//
//  Created by William Remaerd on 1/22/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)

- (void)addNoMarginConstraintsToSubview:(UIView *)view{
    
    NSDictionary *viewsDic = NSDictionaryOfVariableBindings(view);
    
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                             options:0
                                             metrics:nil
                                               views:viewsDic]];
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|"
                                             options:0
                                             metrics:nil
                                               views:viewsDic]];
    [self addConstraints:constraints];
    
}

@end
