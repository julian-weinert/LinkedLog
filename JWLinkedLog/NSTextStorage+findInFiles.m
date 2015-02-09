//
//  NSTextStorage+findInFiles.m
//  TSTest
//
//  Created by Julian Weinert on 09.02.15.
//  Copyright (c) 2015 Julian Weinert Softwareentwicklung. All rights reserved.
//

#import "NSTextStorage+findInFiles.h"

//    [\d]{4}-[\d]{2}-[\d]{2}\s[\d]{2}:[\d]{2}:[\d]{2}.[\d]{3}\s[^\[]*\[\d*:\d*\]\s(.*\.m:\d+)

@implementation NSTextStorage (findInFiles)

- (void)_fixAttributesInRange:(NSRange *)range {
	[self _fixAttributesInRange:range];
}

- (void)_processEditing {
	[self _processEditing];
	
	static NSRegularExpression *regExp;
	NSString *pattern = @"[\\d]{4}-[\\d]{2}-[\\d]{2}\\s[\\d]{2}:[\\d]{2}:[\\d]{2}.[\\d]{3}\\s[^\\[]*\\[\\d*:\\d*\\]\\s(.*\\.m:\\d+)";
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		regExp = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
	});
	
	NSRange paragraphRange = [[self string] paragraphRangeForRange:[self editedRange]];
	
	[regExp enumerateMatchesInString:[self string] options:0 range:paragraphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
		__block NSFont *font;
		NSRange range = [result rangeAtIndex:1];
		
		[self enumerateAttribute:NSFontAttributeName inRange:range options:NSAttributedStringEnumerationReverse usingBlock:^(NSFont *value, NSRange range, BOOL *stop) {
			font = [[NSFontManager sharedFontManager] fontWithFamily:[value familyName] traits:NSBoldFontMask weight:0 size:[value pointSize]];
			*stop = YES;
		}];
		
		[self removeAttribute:NSForegroundColorAttributeName range:range];
		[self removeAttribute:NSUnderlineColorAttributeName range:range];
		[self removeAttribute:NSUnderlineStyleAttributeName range:range];
		
		[self addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:range];
		
		[self addAttribute:NSFontAttributeName value:font range:range];
		[self addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
		
		[self addAttribute:NSUnderlineColorAttributeName value:[NSColor blueColor] range:range];
		[self addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
		
		[self addAttribute:@"JWLinkedLogLink" value:[[self string] substringWithRange:range] range:range];
	}];
}

@end
