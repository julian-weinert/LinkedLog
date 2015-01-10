//
//  JWJob.h
//  JTrigger
//
//  Created by Julian Weinert on 09.01.15.
//  Copyright (c) 2015 Julian Weinert Softwareentwicklung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWJob : NSObject

@property (nonatomic, retain) NSString *jobName;
@property (nonatomic, retain) NSString *jobURL;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *XcodeProject;

- (void)deletePassword;
- (void)savePassword:(NSString *)password;
- (BOOL)isPasswordCorrect:(NSString *)password;

@end
