//
//  JWJobsController.m
//  JTrigger
//
//  Created by Julian Weinert on 09.01.15.
//  Copyright (c) 2015 Julian Weinert Softwareentwicklung. All rights reserved.
//

#import "JWJobsController.h"
#import "JWJob.h"

@interface JWJobsController ()

@property (nonatomic, retain) IBOutlet NSTableView			*jobsTableView;
@property (nonatomic, retain) IBOutlet NSButton				*removeJobButton;
@property (nonatomic, retain) IBOutlet NSButton				*addJobButton;

@property (nonatomic, retain) IBOutlet NSTextField			*jobURL;
@property (nonatomic, retain) IBOutlet NSTextField			*userID;
@property (nonatomic, retain) IBOutlet NSSecureTextField	*password;

@property (nonatomic, retain) NSMutableArray *addedJobs;
@property (nonatomic, retain) NSMutableArray *deleteJobs;
@property (nonatomic, retain) NSMutableArray *dataSource;

@end

@implementation JWJobsController

+ (instancetype)controller {
	return [[self alloc] initWithWindowNibName:@"JWJobsController"];
}

- (void)windowDidLoad {
    [super windowDidLoad];
	
	_addedJobs = [NSMutableArray array];
	_deleteJobs = [NSMutableArray array];
	_dataSource = [NSMutableArray array];
}

- (NSArray *)intersectedDataSource {
	NSMutableArray *intersection = [self dataSource];
	[intersection removeObjectsInArray:[self deleteJobs]];
	[intersection addObjectsFromArray:[self addedJobs]];
	
	return intersection;
}

#pragma mark UI interaction

- (IBAction)addJob:(id)sender {
	JWJob *newJob = [[JWJob alloc] init];
	
	[[self dataSource] addObject:newJob];
	
	[[self jobsTableView] beginUpdates];
	[[self jobsTableView] insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:[[self dataSource] indexOfObject:newJob]] withAnimation:NSTableViewAnimationSlideDown];
	[[self jobsTableView] endUpdates];
}

- (IBAction)removeJob:(id)sender {
	JWJob *oldJob = [[self dataSource] objectAtIndex:[[self jobsTableView] selectedRow]];
	[oldJob deletePassword];
	
	[[self jobsTableView] beginUpdates];
	[[self jobsTableView] removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:[[self dataSource] indexOfObject:oldJob]] withAnimation:NSTableViewAnimationSlideUp];
	[[self jobsTableView] endUpdates];
	
	[[self dataSource] removeObject:oldJob];
}

- (IBAction)saveJobs:(id)sender {
	[[self dataSource] removeObjectsInArray:[self deleteJobs]];
	[[self dataSource] addObjectsFromArray:[self addedJobs]];
	
	NSLog(@"%@", [self dataSource]);
}

- (IBAction)abortJobs:(id)sender {
	[self close];
}

#pragma mark - NSTableViewDataSource & NSTableViewDelegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [[self intersectedDataSource] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	JWJob *job = [[self intersectedDataSource] objectAtIndex:row];
	
	if ([[tableColumn identifier] isEqualToString:@"jobNameColumn"]) {
		return [job jobName];
	}
	else if ([[tableColumn identifier] isEqualToString:@"XcodeProjectColumn"]) {
		return [job XcodeProject];
	}
	return nil;
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	return YES;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	JWJob *job = [[self intersectedDataSource] objectAtIndex:row];
	
	if ([[tableColumn identifier] isEqualToString:@"jobNameColumn"]) {
		[job setJobName:object];
	}
	else if ([[tableColumn identifier] isEqualToString:@"XcodeProjectColumn"]) {
		[job setXcodeProject:object];
	}
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
	[[self removeJobButton] setEnabled:(BOOL)[[self jobsTableView] selectedRow] + 1];
}

@end
