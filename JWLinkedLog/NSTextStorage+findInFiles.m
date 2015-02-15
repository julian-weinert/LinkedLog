//
//  NSTextStorage+findInFiles.m
//  TSTest
//
//  Created by Julian Weinert on 09.02.15.
//  Copyright (c) 2015 Julian Weinert Softwareentwicklung. All rights reserved.
//

#import "NSTextStorage+findInFiles.h"

@implementation NSTextStorage (findInFiles)

- (void)_fixAttributesInRange:(NSRange *)range {
	[self _fixAttributesInRange:range];
}

- (void)_processEditing {
	static NSRegularExpression *regExp;
	NSString *pattern = @"[\\d]{4}-[\\d]{2}-[\\d]{2}\\s[\\d]{2}:[\\d]{2}:[\\d]{2}.[\\d]{3}\\s[^\\[]*\\[\\d*:\\d*\\]\\s(.+\\/([^\\/:]+:\\d+)):\\s.*";
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		regExp = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
	});
	
	NSRange paragraphRange = [[self string] paragraphRangeForRange:[self editedRange]];
	
	[regExp enumerateMatchesInString:[self string] options:0 range:paragraphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
		NSRange range = [result rangeAtIndex:1];
		
		NSString *replacement = [[self string] substringWithRange:[result rangeAtIndex:2]];
		NSString *filePath = [[self string] substringWithRange:[result rangeAtIndex:1]];
		
		NSArray *filePathParts = [filePath componentsSeparatedByString:@":"];
		
		filePath = [filePathParts firstObject];
		NSString *lineNumber = [filePathParts lastObject];
		
		[self replaceCharactersInRange:range withString:replacement];
		range.length = [replacement length];
		
		[self addAttribute:NSLinkAttributeName value:@"" range:range];
		[self addAttribute:@"JWLinkedLogLink" value:filePath range:range];
		[self addAttribute:@"JWLinkedLogLine" value:lineNumber range:range];
	}];
	
	[self _processEditing];
}

@end
