//
//  UIAlertView+Quick.h
//  NimbusBase_iOS_Tutorial
//
//  Created by William Remaerd on 9/24/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Quick)

+ (UIAlertView *)alertTitle:(NSString *)title
                     format:(NSString *)format, ...;

+ (UIAlertView *)alertTitle:(NSString *)title
                    message:(NSString *)message;

+ (UIAlertView *)alertError:(NSError *)error;

+ (NSString *)messageFromError:(NSError *)error;

@end
