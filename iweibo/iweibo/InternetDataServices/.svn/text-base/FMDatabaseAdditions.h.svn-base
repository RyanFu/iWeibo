//
//  FMDatabaseAdditions.h
//  iweibo
//
//  Created by wangying on 12/30/11.
//  Copyright 2011 bysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FMDatabase (FMDatabaseAdditions)


- (int)intForQuery:(NSString*)objs, ...;
- (long)longForQuery:(NSString*)objs, ...; 
- (BOOL)boolForQuery:(NSString*)objs, ...;
- (double)doubleForQuery:(NSString*)objs, ...;
- (NSString*)stringForQuery:(NSString*)objs, ...; 
- (NSData*)dataForQuery:(NSString*)objs, ...;
- (NSDate*)dateForQuery:(NSString*)objs, ...;

// Notice that there's no dataNoCopyForQuery:.
// That would be a bad idea, because we close out the result set, and then what
// happens to the data that we just didn't copy?  Who knows, not I.


- (BOOL)tableExists:(NSString*)tableName;
- (FMResultSet*)getSchema;
- (FMResultSet*)getTableSchema:(NSString*)tableName;
- (BOOL)columnExists:(NSString*)tableName columnName:(NSString*)columnName;

- (BOOL)validateSQL:(NSString*)sql error:(NSError**)error;

@end
