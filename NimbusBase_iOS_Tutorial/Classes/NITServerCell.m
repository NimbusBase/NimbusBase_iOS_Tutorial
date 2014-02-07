//
//  UPServerCell.m
//  Uploader
//
//  Created by William Remaerd on 11/13/13.
//  Copyright (c) 2013 William Remaerd. All rights reserved.
//

#import "NITServerCell.h"
#import "KVOUtilities.h"
#import <NimbusBase/NimbusBase.h>
#import "NMBServer+UI.h"

@implementation NITServerCell

NSString * const kvo_name = @"name";
NSString * const kvo_logo = @"logo";
NSString * const kvo_authState = @"authState";
NSString * const kvo_progress = @"progress";


- (void)setServer:(NMBServer *)server{
    
    if (_server) {
        //[_server removeObserver:self forKeyPath:kvo_name];
        //[_server removeObserver:self forKeyPath:kvo_logo];
        [_server removeObserver:self forKeyPath:kvo_authState];
        //[_server removeObserver:self forKeyPath:kvo_progress];
    }

    _server = server;
    
    if (_server) {
        //[_server addObserver:self forKeyPath:kvo_name options:kvo_options context:nil];
        //[_server addObserver:self forKeyPath:kvo_logo options:kvo_options context:nil];
        [_server addObserver:self forKeyPath:kvo_authState options:kvo_options context:nil];
        //[_server addObserver:self forKeyPath:kvo_progress options:kvo_options context:nil];
    }
    
    NSString *logoName = nil;
    NSString *clsName = NSStringFromClass(server.class);
    if ([clsName isEqualToString:@"NMBGDrive"]) {
        logoName = @"logo_googledrive";
    } else if ([clsName isEqualToString:@"NMBDropbox"]) {
        logoName = @"logo_dropbox";
    } else if ([clsName isEqualToString:@"NMBBox"]) {
        logoName = @"logo_box";
    }
    
    
    self.textLabel.text = [self.class nameFromAppID:server.configs[NCfgK_AppID]];
    NSString *logoPath = [[NSBundle mainBundle] pathForResource:logoName ofType:@"png"];
    self.imageView.image = [[UIImage alloc] initWithContentsOfFile:logoPath];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:kvo_name]) {
        
        kvo_QuickComparison(NSString)
        self.textLabel.text = new;
        
    } else if ([keyPath isEqualToString:kvo_logo]) {
        
        kvo_QuickComparison(UIImage)
        self.imageView.image = new;
        
    } else if ([keyPath isEqualToString:kvo_authState]) {
        
        kvo_QuickComparison(NSNumber)
        
        self.detailTextLabel.text = [NMBServer authStateString:new.integerValue];
        self.imageView.alpha = self.textLabel.alpha = (new.integerValue == NMBAuthStateIn) ? 1.0f : 0.5f;
        
    } else if ([keyPath isEqualToString:kvo_progress]) {
        
        kvo_QuickComparison(NSNumber)
        self.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%3.0f%%", 100 * new.floatValue];
        
    }
        
}

- (void)dealloc{
    self.server = nil;
}

+ (NSString *)nameFromAppID:(NSString *)appID{
    NSDictionary *dic = @{
                      @"573163675535-5nj0q1t3lspohv5dj9bhg1b70a4ihbqh.apps.googleusercontent.com": @"NimbusTester Alpha",
                      @"43792987740-63otpqkeph60ptn9s6kno6i94oe8s902.apps.googleusercontent.com": @"NimbusTester Beta",
                      @"vl4r226lxo4dok1": @"NimbusTester Alpha",
                      @"vdj0rb6e0trrr4n": @"NimbusTester Beta",
                      @"eaofybj13ha01qnx4cea2auowdnvwnwc": @"NimbusTester Alpha",
                      };
    
    return dic[appID];
}

@end
