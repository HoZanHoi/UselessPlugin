//
//  NSTextView+UselessPlugin.m
//  Plug-inTest
//
//  Created by Kevin on 13-6-24.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "NSTextView+UselessPlugin.h"
#import "MethodSwizzle.h"
#import "UselessPlugin.h"
#import "XcodeMisc.h"

@implementation NSTextView (UselessPlugin)

+(void)load
{
}

-(void)swizzled_keyDown:(NSEvent*)event
{
	BOOL didInsert	=	NO;
	if ([[UselessPlugin shared] enabled]) {
		if ([[event characters] isEqualToString:@"`"])
		{
			didInsert = [[UselessPlugin shared] insertArrowForTextView:self];
			if (didInsert) {
				if ([self isKindOfClass:[DVTSourceTextView class]])
				{
					if ([(DVTSourceTextView*)self completionController])
					{
						[[(DVTSourceTextView*)self completionController] _showCompletionsAtCursorLocationExplicitly:NO];
					}
				}
			}
		}
	}
	if (!didInsert) {
		if ([self respondsToSelector:@selector(swizzled_keyDown:)]) {
			[self swizzled_keyDown:event];
		}
	}
}

@end
