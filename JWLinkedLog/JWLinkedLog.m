//
//  JWLinkedLog.m
//  JWLinkedLog
//
//  Created by Julian Weinert on 09.01.15.
//  Copyright (c) 2015 Julian Weinert Softwareentwicklung. All rights reserved.
//

#import "JWLinkedLog.h"
#import "JRSwizzle.h"
#import "NSTextStorage+findInFiles.h"

#import "DVTSourceExpression.h"
#import "DVTTextDocumentLocation.h"

#import "DTXcodeUtils.h"
#import "DTXcodeHeaders.h"

#import <objc/objc-class.h>

@implementation NSTextView (mouseDown)
- (void)_mouseDown:(NSEvent *)theEvent {
	NSPoint clickPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	NSInteger charIndex = [self characterIndexForInsertionAtPoint:clickPoint];
	NSRange rangePointer;
	
	if ((![self isKindOfClass:NSClassFromString(@"IDEConsoleTextView")]) || ([[self attributedString] length] < 1) || (charIndex > [[self attributedString] length] - 1)) {
		[self _mouseDown:theEvent];
		return;
	}
	
	NSDictionary *attributes = [[self attributedString] attributesAtIndex:charIndex effectiveRange:&rangePointer];
	
	if (![attributes objectForKey:@"JWLinkedLogLink"] || ![attributes objectForKey:@"JWLinkedLogLine"]) {
		[self _mouseDown:theEvent];
		return;
	}
	
	NSString *filePath = [attributes objectForKey:@"JWLinkedLogLink"];
	NSUInteger lineNumber = [[attributes objectForKey:@"JWLinkedLogLine"] integerValue] - 1;
	
	IDEWorkspaceWindowController *workspaceController = [DTXcodeUtils currentWorkspaceWindowController];
	
	if (workspaceController) {
		if ([(id<NSApplicationDelegate>)[NSApp delegate] application:NSApp openFile:filePath]) {
			IDESourceCodeEditor *editor = [DTXcodeUtils currentSourceCodeEditor];
			
			if (editor) {
				NSTextView *textView = [editor textView];
				
				if (textView) {
					NSString *sourceCode = [textView string];
					
					NSArray *results = [[NSRegularExpression regularExpressionWithPattern:@"\n" options:0 error:nil] matchesInString:sourceCode options:NSMatchingReportCompletion range:NSMakeRange(0, [sourceCode length])];
					
					if ([results count] <= lineNumber) {
						return;
					}
					
					NSTextCheckingResult *checkingResult = [results objectAtIndex:lineNumber];
					NSUInteger location = checkingResult.range.location;
					
					NSRange lineRange = [sourceCode lineRangeForRange:NSMakeRange(location, 0)];
					
					[textView scrollRangeToVisible:lineRange];
					[textView setSelectedRange:lineRange];
				}
			}
		}
	}
}
@end

static JWLinkedLog *sharedPlugin;

@implementation JWLinkedLog

+ (void)pluginDidLoad:(NSBundle *)plugin {
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
		dispatch_once(&onceToken, ^{
			
			sharedPlugin = [[self alloc] initWithBundle:plugin];
			
			SEL orgSelector = @selector(fixAttributesInRange:);
			SEL newSelector = @selector(_fixAttributesInRange:);
			
			NSError *swizzlingError;
			
			if (![NSTextStorage jr_swizzleMethod:orgSelector withMethod:newSelector error:&swizzlingError]) {
				NSLog(@"swizzling error: %@", swizzlingError);
			}
			
			orgSelector = @selector(processEditing);
			newSelector = @selector(_processEditing);
			
			swizzlingError = nil;
			
			if (![NSTextStorage jr_swizzleMethod:orgSelector withMethod:newSelector error:&swizzlingError]) {
				NSLog(@"swizzling error: %@", swizzlingError);
			}
			
			orgSelector = @selector(mouseDown:);
			newSelector = @selector(_mouseDown:);
			
			swizzlingError = nil;
			
			if (![NSTextView jr_swizzleMethod:orgSelector withMethod:newSelector error:&swizzlingError]) {
				NSLog(@"swizzling error: %@", swizzlingError);
			}
		});
    }
}

+ (instancetype)sharedPlugin {
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin {
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
    }
	
    return self;
}

@end
