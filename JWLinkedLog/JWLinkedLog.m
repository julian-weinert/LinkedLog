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
	
	if (![attributes objectForKey:@"JWLinkedLogLink"]) {
		[self _mouseDown:theEvent];
		return;
	}
	
	NSLog(@"here: %@", [attributes objectForKey:@"JWLinkedLogLink"]);
}
@end

static JWLinkedLog *sharedPlugin;

@interface JWLinkedLog()

@end

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
