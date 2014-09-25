//
//  UPServerCell.m
//  Uploader
//
//  Created by William Remaerd on 11/13/13.
//  Copyright (c) 2013 William Remaerd. All rights reserved.
//

#import "NITServerCell.h"
#import "NimbusBase.h"

#import "KVOUtilities.h"
#import "NMBServer+NIT.h"

@implementation NITServerCell

- (void)dealloc
{
    self.server = nil;
}

- (void)setServer:(NMBServer *)server
{
    if (_server)
    {
        [self ignoreServer:_server];
    }
    
    _server = server;
    
    if (_server)
    {
        [self observeServer:_server];
    }
    
}

- (void)observeServer:(NMBServer *)server
{
    self.textLabel.text = server.cloudType;
    self.imageView.image = [UIImage imageNamed:server.iconName];
    [server addObserver:self forKeyPath:NMBServerProperties.authState options:kvoOptNOI context:nil];
}

- (void)ignoreServer:(NMBServer *)server
{
    [server removeObserver:self forKeyPath:NMBServerProperties.authState];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NMBServerProperties.authState])
    {
        kvo_QuickComparison(NSNumber)
        
        self.detailTextLabel.text = [NMBServer authStateString:new.integerValue];
        self.imageView.alpha = self.textLabel.alpha = (new.integerValue == NMBAuthStateIn) ? 1.0f : 0.5f;
    }
}

@end
