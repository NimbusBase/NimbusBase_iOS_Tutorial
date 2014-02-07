//
//  Header.h
//  Uploader
//
//  Created by William Remaerd on 11/15/13.
//  Copyright (c) 2013 William Remaerd. All rights reserved.
//

#ifndef Uploader_Header_h
#define Uploader_Header_h

#define kvo_QuickComparison(cls) \
cls *old = change[NSKeyValueChangeOldKey]; \
cls *new = change[NSKeyValueChangeNewKey]; \
if ([new isKindOfClass:[NSNull class]] || [old isEqual:new]) return;

static NSKeyValueObservingOptions const kvoOptNOI = NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;

#endif
