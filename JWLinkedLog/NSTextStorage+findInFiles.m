//
//  NSTextStorage+findInFiles.m
//  LinkedLog
//
//  Created by Julian Weinert on 09.02.15.
//  Copyright (c) 2015 Julian Weinert Softwareentwicklung. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

#import "NSTextStorage+findInFiles.h"

@implementation NSTextStorage (findInFiles)

- (void)_fixAttributesInRange:(NSRange *)range {
	[self _fixAttributesInRange:range];
}

- (void)_processEditing {
	static NSRegularExpression *regExp;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSString *pattern = @"^[\\d]{4}-[\\d]{2}-[\\d]{2}\\s[\\d]{2}:[\\d]{2}:[\\d]{2}.[\\d]{3}\\s[^\\[]*\\[\\d*:\\d*\\]\\s(.+\\/([^\\/:]+:\\d+)):\\s.*";
		regExp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAnchorsMatchLines error:NULL];
	});
	
	NSString *consoleText = [self string];
	NSRange paragraphRange = [consoleText paragraphRangeForRange:[self editedRange]];
	
	__block NSRange messageRange;
	__block NSRange fileNameLineRange;
	
	NSArray *matches = [regExp matchesInString:consoleText options:NSMatchingReportProgress range:paragraphRange];
	
	for (NSTextCheckingResult *result in [matches reverseObjectEnumerator]) {
		if ([result numberOfRanges] >= 3) {
			messageRange = [result rangeAtIndex:1];
			fileNameLineRange = [result rangeAtIndex:2];
			
			if (messageRange.location != NSNotFound && fileNameLineRange.location != NSNotFound
				&& [consoleText length] >= messageRange.location + messageRange.length
				&& [consoleText length] >= fileNameLineRange.location + fileNameLineRange.length) {
				
				NSString *replacement = [consoleText substringWithRange:fileNameLineRange];
				NSString *filePath = [consoleText substringWithRange:messageRange];
				
				NSArray *filePathParts = [filePath componentsSeparatedByString:@":"];
				
				filePath = [filePathParts firstObject];
				NSString *lineNumber = [filePathParts lastObject];
				
				[self replaceCharactersInRange:messageRange withString:replacement];
				messageRange.length = [replacement length];
				
				[self addAttribute:NSLinkAttributeName value:@"" range:messageRange];
				[self addAttribute:@"JWLinkedLogLink" value:filePath range:messageRange];
				[self addAttribute:@"JWLinkedLogLine" value:lineNumber range:messageRange];
			}
		}
	}
	
	[self _processEditing];
}

@end
