//
//  DataSave.h
//  iweibo
//
//  Created by wangying on 1/14/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataSave : NSObject {
	NSMutableArray		*infoArray;
	NSMutableArray		*listenArray;
	NSUInteger			n;					//新广播数
	NSUInteger			nL;					//新收听数
}

@property (nonatomic, retain) NSMutableArray *infoArray;
@property (nonatomic, retain) NSMutableArray *listenArray;
@property (nonatomic, assign) NSUInteger n;
@property (nonatomic, assign) NSUInteger nL;

//存储timeline信息
- (NSArray *)storeInfoToClass:(NSDictionary *)result;

//存储收听和听众信息
- (NSMutableArray *)storeIntoClass:(NSDictionary *)dic:(NSString *)time;

@end
