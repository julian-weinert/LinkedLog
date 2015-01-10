//
//  JTrigger.m
//  JTrigger
//
//  Created by Julian Weinert on 09.01.15.
//  Copyright (c) 2015 Julian Weinert Softwareentwicklung. All rights reserved.
//

#import "JTrigger.h"
#import "JWJobsController.h"

static JTrigger *sharedPlugin;

@interface JTrigger()

@property (nonatomic, retain) JWJobsController *jobsController;
@property (nonatomic, retain) NSInvocation *invoke;
@property (nonatomic, retain) NSTimer *timer;

@property (atomic, assign) BOOL committing;

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

#pragma mark - property getter and setter overrides

- (JWJobsController *)jobsController {
	@synchronized (self) {
		if (!_jobsController) {
			_jobsController = [JWJobsController controller];
		}
	}
	return _jobsController;
}

#pragma mark - NOOP
-(void)noop:(id)sender{}
#pragma mark - implementation

- (id)initWithBundle:(NSBundle *)plugin {
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willCommit) name:@"IDESourceControlUserWillCommitNotification" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCommit) name:@"IDESourceControlUserDidCommitNotification" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allNotifications:) name:nil object:nil];
		
        NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Product"];
		
		if (menuItem) {
			NSMenuItem *jTriggerConfigMenuItem = [[NSMenuItem alloc] initWithTitle:@"Jenkins Jobs..." action:@selector(openJenkinsJobs:) keyEquivalent:@""];
			[jTriggerConfigMenuItem setTarget:self];
			
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

- (void)willCommit {
	NSLog(@"IDESourceControlUserWillCommitNotification");
	_committing = YES;
	
}

- (void)didCommit {
	NSLog(@"IDESourceControlUserDidCommitNotification");
	[self performSelector:@selector(endCommitting) withObject:nil afterDelay:3];
}

- (void)endCommitting {
	_committing = NO;
}

- (void)allNotifications:(NSNotification *)notif {
	if ([self committing]) {
		
	}
}

- (void)openJenkinsJobs:(id)sender {
	[[self jobsController] showWindow:sender];
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
