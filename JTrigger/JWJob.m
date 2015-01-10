//
//  JWJob.m
//  JTrigger
//
//  Created by Julian Weinert on 09.01.15.
//  Copyright (c) 2015 Julian Weinert Softwareentwicklung. All rights reserved.
//

#import "JWJob.h"
#import "SSKeychain.h"

@implementation JWJob

- (instancetype)init {
	if (self = [super init]) {
		_jobName = @"Name";
		_XcodeProject = @"Project name";
	}
	return self;
}

- (void)deletePassword {
	[SSKeychain deletePasswordForService:[self jobURL] account:[self userID]];
}

- (void)savePassword:(NSString *)password {
	[SSKeychain setPassword:password forService:[self jobURL] account:[self userID]];
}

- (BOOL)isPasswordCorrect:(NSString *)password {
	return [password isEqualToString:[SSKeychain passwordForService:[self jobURL] account:[self userID]]];
}

@end
