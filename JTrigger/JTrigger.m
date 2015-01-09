//
//  JTrigger.m
//  JTrigger
//
//  Created by Julian Weinert on 09.01.15.
//  Copyright (c) 2015 Julian Weinert Softwareentwicklung. All rights reserved.
//

#import "JTrigger.h"

static JTrigger *sharedPlugin;

@interface JTrigger()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end

@implementation JTrigger

+ (void)pluginDidLoad:(NSBundle *)plugin {
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
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
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allNotes:) name:@"IDESourceControlUserDidCommitNotification" object:nil];
		
        NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Product"];
		
		if (menuItem) {
			NSMenuItem *jTriggerConfigMenuItem = [[NSMenuItem alloc] initWithTitle:@"Jenkins Jobs..." action:@selector(noop:) keyEquivalent:@""];
			
			NSMenu *jTriggerMenu = [[NSMenu alloc] initWithTitle:@"JTriggerMenu"];
			
			NSMenuItem *jTriggerSampleJob = [[NSMenuItem alloc] initWithTitle:@"Build Acrolinx" action:@selector(noop:) keyEquivalent:@""];
			[jTriggerMenu addItem:jTriggerSampleJob];
			
			[jTriggerMenu addItem:[NSMenuItem separatorItem]];
			[jTriggerMenu addItem:jTriggerConfigMenuItem];
			[jTriggerMenu setAutoenablesItems:NO];
			
			NSMenuItem *jTriggerMenuItem = [[NSMenuItem alloc] init];
			[jTriggerMenuItem setSubmenu:jTriggerMenu];
			[jTriggerMenuItem setTitle:@"JTrigger"];
			[jTriggerMenuItem setEnabled:YES];
			
			[[menuItem submenu] addItem:[NSMenuItem separatorItem]];
			[[menuItem submenu] addItem:jTriggerMenuItem];
        }
    }
    return self;
}

- (void)noop:(id)sender {
	
}

- (void)clickParent {
	NSLog(@"clickParent");
}

- (void)clickChild {
	NSLog(@"clickChild");
}

- (void)allNotes:(NSNotification *)notif {
	NSLog(@"notif: %@", notif);
}

// Sample Action, for menu item:
- (void)doMenuAction {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Hello, World"];
    [alert runModal];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
