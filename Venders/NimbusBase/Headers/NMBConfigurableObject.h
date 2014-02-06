//
//  NMBObject.h
//  NimbusBase_iOS
//
//  Created by William Remaerd on 1/3/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NMBObject.h"

@interface NMBConfigurableObject : NMBObject{
    NSDictionary *_configs;
}
@property(nonatomic, strong)NSDictionary *configs;
- (id)initWithConfigs:(NSDictionary *)configs;
@end
