//
//  Database.m
//  iweibo
//
//  Created by wangying on 12/30/11.
//  Copyright 2011 bysoft. All rights reserved.
//

#import "Database.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

static Database *sharedManagerSqliteDao = nil;

@implementation Database
@synthesize db;

-(NSString *)GetDatabaseName{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"iweibo.db"];
	return path;
}


+(Database *)sharedManager{
	if (sharedManagerSqliteDao == nil) {
			sharedManagerSqliteDao = [[self alloc] init];
		}
	return sharedManagerSqliteDao;
}

-(void)setupDB{  
	NSError *error;
	NSString *dbRealPath = [self GetDatabaseName];
	NSFileManager *fileManager = [NSFileManager defaultManager]; 
	BOOL find = [fileManager fileExistsAtPath:dbRealPath];
	if (!find) { 
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"iweibo.db"];
		BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:dbRealPath error:&error];
		if (!success) {
		 CLog(@"Failed to copy database '%@'.", [error localizedDescription]);
		}
	}
}

- (void) connectDB
{
    if (db == nil) {
        db = [[FMDatabase alloc]initWithPath:[self GetDatabaseName]];
        if (! [db open]) {
            NSLog(@"Could not open database.");
        }
    }else {
        NSLog(@"Database has already opened.");
    }
}

- (void) closeDB
{
    [db close];
}

@end
