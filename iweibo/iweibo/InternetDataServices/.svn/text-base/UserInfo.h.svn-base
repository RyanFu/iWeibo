//
//  UserInfo.h
//  iweibo
//
//  Created by zhaoguohui on 12-1-13.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserInfo : NSObject {
	NSString *birth_day;		// 出生天
	NSString *birth_month;		// 出生月
	NSString *birth_year;		// 出生年
	NSString *city_code;		// 城市id
	NSString *country_code;		// 国家id
	/*
	 id：教育信息记录id
	 year：入学年
	 schoolid：学校id
	 departmentid： 院系id
	 level：学历级别
	 */
	NSString *edu;				
	NSString *email;			// 邮箱
	NSNumber *fansnum;			// 听众数
	NSString *head;				// 头像url
	NSNumber *idolnum;			// 收听的人数
	NSString *introduction;		// 个人介绍
	NSString *isent;			// 是否企业机构
	NSString *isrealname;		// 是否真是姓名
	NSString *isvip;			// 是否认证用户
	NSString *location;			// 所在地
	NSString *name;				// 用户账户名
	NSString *nick;				// 用户昵称
	NSString *openid;			// 用户唯一id，与name相对应
	NSString *province_code;	// 地区id
	NSString *sex;				// 用户性别，1－男， 2－女 0－未填写
	NSString *tag;				// id：个人标签id    name：标签名
	NSNumber *tweetnum;			// 发表的微博数
	NSString *verifyinfo;		// 认证信息
}

@property (nonatomic, retain) NSString *birth_day;	
@property (nonatomic, retain) NSString *birth_month;	
@property (nonatomic, retain) NSString *birth_year;	
@property (nonatomic, retain) NSString *city_code;	
@property (nonatomic, retain) NSString *country_code;	
@property (nonatomic, retain) NSString *edu;			
@property (nonatomic, retain) NSString *email;		
@property (nonatomic, retain) NSNumber *fansnum;		
@property (nonatomic, retain) NSString *head;			
@property (nonatomic, retain) NSNumber *idolnum;		
@property (nonatomic, retain) NSString *introduction;	
@property (nonatomic, retain) NSString *isent;		
@property (nonatomic, retain) NSString *isrealname;	
@property (nonatomic, retain) NSString *isvip;		
@property (nonatomic, retain) NSString *location;		
@property (nonatomic, retain) NSString *name;			
@property (nonatomic, retain) NSString *nick;			
@property (nonatomic, retain) NSString *openid;		
@property (nonatomic, retain) NSString *province_code;
@property (nonatomic, retain) NSString *sex;			
@property (nonatomic, retain) NSString *tag;			
@property (nonatomic, retain) NSNumber *tweetnum;		
@property (nonatomic, retain) NSString *verifyinfo;	

+ (UserInfo *)sharedUserInfo;
- (void)clearUserInfo;
- (BOOL)saveUserDataToUserInfo:(NSDictionary *)info;
// 从数据库加载初始数据
-(void)loadDataFromDB;
@end
