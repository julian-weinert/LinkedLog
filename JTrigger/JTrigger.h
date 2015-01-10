//
//  JTrigger.h
//  JTrigger
//
//  Created by Julian Weinert on 09.01.15.
//  Copyright (c) 2015 Julian Weinert Softwareentwicklung. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface JTrigger : NSObject

@property (nonatomic, retain) NSBundle *bundle;

+ (instancetype)sharedPlugin;

@end