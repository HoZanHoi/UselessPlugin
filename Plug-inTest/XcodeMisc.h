//
//  XcodeMisc.h
//  Plug-inTest
//
//  Created by Kevin on 13-6-21.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#ifndef Plug_inTest_XcodeMisc_h
#define Plug_inTest_XcodeMisc_h

#import <Cocoa/Cocoa.h>

//Miscellaneous declarations pulled from class dumps of DVTFoundation, DVTKit, IDEFoundation, IDEKit
@class DVTTextCompletionController;
@interface DVTCompletingTextView : NSTextView
@property(readonly) DVTTextCompletionController *completionController;

- (BOOL)shouldAutoCompleteAtLocation:(unsigned long long)arg1;
- (NSRange)realSelectedRange;
- (void)_replaceCellWithCellText:(id)arg1;
@end

@interface DVTTextCompletionDataSource : NSObject
- (void)generateCompletionsForDocumentLocation:(id)arg1 context:(id)arg2 completionBlock:(id)arg3;
@end

@interface DVTSourceTextView : DVTCompletingTextView
@end


@interface DVTTextCompletionSession : NSObject
@property(nonatomic) long long selectedCompletionIndex;
@property(retain) NSArray *filteredCompletionsAlpha;
@property(retain) NSArray *allCompletions;

- (BOOL)shouldAutoSuggestForTextChange;
@end

@interface DVTTextCompletionController : NSObject

@property(retain) DVTTextCompletionSession *currentSession;
@property(readonly) DVTCompletingTextView *textView;
@property(getter=isAutoCompletionEnabled) BOOL autoCompletionEnabled;

- (void)textViewDidInsertText;
- (BOOL)acceptCurrentCompletion;
- (BOOL)_showCompletionsAtCursorLocationExplicitly:(BOOL)arg1;
- (BOOL)textViewShouldChangeTextInRange:(NSRange)arg1 replacementString:(id)replacementString;

@end

#endif
