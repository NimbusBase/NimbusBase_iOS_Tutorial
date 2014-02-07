//
//  UPServerCell.h
//  Uploader
//
//  Created by William Remaerd on 11/13/13.
//  Copyright (c) 2013 William Remaerd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NMBServer;

@interface NITServerCell : UITableViewCell
@property(nonatomic, weak)NMBServer *server;
@end

extern NSString * const kvo_name;
extern NSString * const kvo_logo;
extern NSString * const kvo_isAuthorized;
extern NSString * const kvo_progress;