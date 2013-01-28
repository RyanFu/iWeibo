//
//  Database.h
//  iweibo
//
//  Created by wangying on 12/30/11.
//  Copyright 2011 bysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "Info.h"
@class FMDatabase;

@interface Database : NSObject {
	FMDatabase *db;
}

@property (nonatomic, retain) FMDatabase *db;
+(Database *)sharedManager;
-(void)setupDB;
- (void)connectDB;
- (void)closeDB;
-(NSString *)GetDatabaseName;

@end
