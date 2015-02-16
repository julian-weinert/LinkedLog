//
//  NSTextStorage+findInFiles.h
//  LinkedLog
//
//  Created by Julian Weinert on 09.02.15.
//  Copyright (c) 2015 Julian Weinert Softwareentwicklung. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSTextStorage (findInFiles)

- (void)_fixAttributesInRange:(NSRange *)range;
- (void)_processEditing;

@end
