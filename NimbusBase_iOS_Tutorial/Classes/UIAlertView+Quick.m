//
//  UIAlertView+Quick.m
//  NimbusBase_iOS_Tutorial
//
//  Created by William Remaerd on 9/24/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "UIAlertView+Quick.h"

@implementation UIAlertView (Quick)

+ (UIAlertView *)alertTitle:(NSString *)title
                     format:(NSString *)format, ...
{
    va_list list;
    va_start(list, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:list];
    
    UIAlertView *alert = [self alertTitle:title message:message];
    
    va_end(list);
    
    return alert;
}

+ (UIAlertView *)alertTitle:(NSString *)title
                    message:(NSString *)message
{
    UIAlertView *alert =
    [[self alloc] initWithTitle:title
                        message:message
                       delegate:nil
              cancelButtonTitle:@"OK"
              otherButtonTitles:nil];
    return alert;
}

+ (UIAlertView *)alertError:(NSError *)error
{
    UIAlertView *alert =
    [[self alloc] initWithTitle:error.domain
                        message:[self messageFromError:error]
                       delegate:nil
              cancelButtonTitle:@"OK"
              otherButtonTitles:nil];
    return alert;
    
}

+ (NSString *)messageFromError:(NSError *)error
{
    NSString
    *description = error.localizedDescription,
    *reason = error.localizedFailureReason,
    *suggestion = error.localizedRecoverySuggestion;
    
    NSMutableString *message = [[NSMutableString alloc] init];
    if (!reason && !suggestion)
        [message appendString:description];
    if (reason)
        [message appendString:reason];
    if (suggestion)
        [message appendString:suggestion];
    
    return message;
}

@end
