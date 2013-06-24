//
//  UselessPlugin.h
//  Plug-inTest
//
//  Created by Kevin on 13-6-20.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UselessPlugin : NSObject
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL actived;
+(id)shared;
- (BOOL)insertArrowForTextView:(NSTextView*)textView;
- (NSArray*)getLanguages;
@end
