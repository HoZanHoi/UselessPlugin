//
//  UselessPlugin.m
//  Plug-inTest
//
//  Created by Kevin on 13-6-20.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "UselessPlugin.h"
#import "MethodSwizzle.h"
#import "XcodeMisc.h"

@interface NSObject (DevToolsInterfaceAdditions)
// XCTextStorageAdditions
- (id)language;
@end

static NSArray*			CodingLanguages	=	nil;
static UselessPlugin*	sharedPlugin	=	nil;
static NSString*		kUselessPluginEnableKey	=	@"UselessPlugin";

@implementation UselessPlugin
+(void)pluginDidLoad:(NSBundle*) plugin
{
	[self shared];
}

+(id)shared
{
	static	dispatch_once_t once;

	dispatch_once(&once, ^{
		sharedPlugin	=	[[self alloc] init];
	});
	return sharedPlugin;
}

+(void)load
{
	if (![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.Xcode"]) {
		return;
	}
	CodingLanguages	=	[[NSArray alloc] initWithObjects:@"xcode.lang.objcpp", nil];
}

-(id)init
{
	if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(applicationDidFinishLaunching:)
													 name:NSApplicationDidFinishLaunchingNotification
												   object:nil];
	}
	return self;
}


-(void) applicationDidFinishLaunching:(NSNotification*)noti
{
	MethodSwizzle([NSTextView class], @selector(keyDown:), @selector(swizzled_keyDown:));
	[self createMenuItem];
}

- (BOOL)insertArrowForTextView:(NSTextView*)textView
{
	if (![[textView selectedRanges] count]) {
		NSLog(@"count < 0");
		return NO;
	}
	NSRange	selectedRange	=	[[[textView selectedRanges] lastObject] rangeValue];
	if (selectedRange.length > 0) {
		NSLog(@"selectedRange length > 0");
		return NO;
	}
	NSString*	preString = [[[textView textStorage] string]
							 substringWithRange:NSMakeRange(selectedRange.location-2, 2)];
	if (![preString isEqualToString:@"->"]) {
		[textView replaceCharactersInRange:selectedRange withString:@"->"];
		[textView setSelectedRange:NSMakeRange(selectedRange.location+2, 0)];
		return YES;
	}
	return NO;
}

- (NSArray*)getLanguages
{
	return CodingLanguages;
}

- (void)createMenuItem
{
	NSMenuItem*	editMenuItem	=	[[NSApp mainMenu] itemWithTitle:@"Edit"];
	if (editMenuItem)
	{
		NSUserDefaults*	userDefaults	=	[NSUserDefaults standardUserDefaults];
		BOOL	enabled	=	[userDefaults boolForKey:kUselessPluginEnableKey];
		
		[[editMenuItem submenu] addItem:[NSMenuItem separatorItem]];
		
		NSMenuItem*	item	=	[[NSMenuItem alloc] initWithTitle:@"Enable UselessPlugin"
													  action:@selector(toggle:)
											   keyEquivalent:@""];
		item.target	=	self;
		item.state	=	enabled ? NSOnState : NSOffState;
		
		[[editMenuItem submenu] addItem:item];
		[item release];
	}
}

- (void)toggle:(id)sender
{
	self.enabled = !self.enabled;
	
    // Update menu item
    NSMenuItem *menuItem = (NSMenuItem *)sender;
    menuItem.state = self.enabled ? NSOnState : NSOffState;

	[[NSUserDefaults standardUserDefaults] setBool:self.enabled forKey:kUselessPluginEnableKey];
}

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}
@end
