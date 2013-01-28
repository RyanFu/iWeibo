//
//  MyFriendsFansInfo.h
//  iweibo
//
//	我的听众具体信息
//
//  Created by Minwen Yi on 1/11/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyFriendsFansInfo : NSObject {
	NSString			*fansname;			// 账户名
	NSString			*openid;		// 用户唯一id
	NSString			*nick;			// 昵称
	NSString			*head;			// 头像url
	NSNumber			*sex;			// 用户性别，1-男，2-女，0-未填写
	NSString			*fanslocation;		// 用户所在地
	NSString			*country_code;	// 国家码
	NSString			*province_code;	// 省份码
	NSString			*city_code;		// 城市码
	NSNumber			*isvip;			// 是否为认证用户
	NSNumber			*isCommonContact;	// 是否在写消息中添加过(即是否为常用联系人)
	// 其他字段(未完成)
}

@property (nonatomic, retain) NSString			*fansname;			// 账户名
@property (nonatomic, retain) NSString			*openid;		// 用户唯一id
@property (nonatomic, retain) NSString			*nick;			// 昵称
@property (nonatomic, retain) NSString			*head;			// 头像url
@property (nonatomic, retain) NSNumber			*sex;			// 用户性别，1-男，2-女，0-未填写
@property (nonatomic, retain) NSString			*fanslocation;		// 用户所在地
@property (nonatomic, retain) NSString			*country_code;	// 国家码
@property (nonatomic, retain) NSString			*province_code;	// 省份码
@property (nonatomic, retain) NSString			*city_code;		// 城市码
@property (nonatomic, retain) NSNumber			*isvip;			// 是否为认证用户
@property (nonatomic, retain) NSNumber			*isCommonContact;		

// 从数据库中获取数据
+ (NSMutableArray *)myFriendsFansListFromDB;
// 从数据库中获取数据
+ (NSMutableArray *)mySimpleFriendsFansListFromDB;
// 从数据库中获取常用联系人
+ (NSMutableArray *)mySimpleCommonFriendsFansListFromDB;
// 常用联系人更新: 更新是否为常用联系人
+ (BOOL)updateFans:(NSString *)fName WithStatus:(BOOL)status;
// 常用联系人更新: 将联系人(从网络搜索到的联系人)添加到常用联系人中
+ (BOOL)addFanToCommonContact:(NSString *)fName WithDicInfo:(NSDictionary *)dic;
// 更新单个听众信息
// 有则更新数据, 没有则插入新数据
+ (BOOL)updateFans:(NSString *)fName WithInfo:(MyFriendsFansInfo *) fansInfo;
// 将(服务器取回)的数据更新到数据库中
+ (BOOL)updateMyFriendsFansInfoToDB:(NSMutableArray *)fansInfoArray;
// 是否需要从服务器更新数据
+ (int)isUpdateFansFromServerNeeded;
// 更新最后更新时间到当前时间
+ (BOOL)updateFansLastUpdatedTimeToCurrent;
// 清除数据
+ (BOOL)removeFriendsFansFromDB;
// 获取对应好友用户头像数据
+ (NSData *)myFanHeadImageDataWithName:(NSString *)fName;
// 获取对应好友用户头像数据
+ (NSData *)myFanHeadImageDataWithUrl:(NSString *)url;
// 存储头像信息
+ (BOOL)updateImageData:(NSData *)imageData ForHead:(NSString *)headStr;
@end
