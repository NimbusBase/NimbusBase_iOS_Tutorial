//
//  NMTFileCell.m
//  NimbusTester
//
//  Created by William Remaerd on 1/8/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NITFileCell.h"
#import "NimbusBase.h"

@implementation NITFileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFile:(NMBFile *)file{
    
    _file = file;
    
    if (_file) {
        self.textLabel.text = _file.name;
        self.detailTextLabel.text = _file.mime;
    }
    
}

@end
