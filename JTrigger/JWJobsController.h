//
//  JWJobsController.h
//  JTrigger
//
//  Created by Julian Weinert on 09.01.15.
//  Copyright (c) 2015 Julian Weinert Softwareentwicklung. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JWJobsController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate>

+ (instancetype)controller;

@end
