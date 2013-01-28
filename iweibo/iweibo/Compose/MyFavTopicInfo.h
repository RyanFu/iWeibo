//
//  MyFavTopicInfo.h
//  iweibo
//
//  Created by Minwen Yi on 1/10/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyFavTopicInfo : NSObject {
	NSString			*topicID;			// 话题id
	NSNumber			*favNum;			// 被收藏次数
	NSNumber			*tweetNum;			// 话题下微博总数
	NSString			*textString;				// 话题名字
	NSNumber			*timeStamp;			// 收藏时间
	NSNumber			*hasAddedBefore;	// 是否在写消息中添加过
}
@property (nonatomic, retain) NSString			*topicID;			// 话题id
@property (nonatomic, retain) NSNumber			*favNum;			// 被收藏次数
@property (nonatomic, retain) NSNumber			*tweetNum;			// 话题下微博总数
@property (nonatomic, retain) NSString			*textString;				// 话题名字
@property (nonatomic, retain) NSNumber			*timeStamp;			// 收藏时间
@property (nonatomic, retain) NSNumber			*hasAddedBefore;	// 是否添加过

// 从数据库中获取数据
+ (NSMutableArray *)myFavTopicsFromDB;
// 从数据库中获取数据
+ (NSMutableArray *)mySimpleFavTopicsFromDB;
// 更新话题是否写入过状态
+ (BOOL)updateTopicByID:(NSString *)tID WithStatus:(BOOL)status;
// 更新话题是否写入过状态
+ (BOOL)updateTopicByText:(NSString *)topicText WithStatus:(BOOL)status;
// 更新话题信息
+ (BOOL)updateMyFavTopic:(NSString *)topicName WithInfo:(MyFavTopicInfo *) topicInfo;
+ (BOOL)updateMyFavTopicInfoToDB:(NSArray *)favTopicInfoArray;

// 数据更新状态
+ (int)IsUpdateMyFavTopicListFromServerNeeded;
// 更新最后更新时间到当前时间
+ (BOOL)updateMyFavTopicsLastUpdatedTimeToCurrent;
// 重置上次更新时间为0，使下次插入话题时，强制去网络更新
+ (BOOL)resetMyFavTopicsLastUpdatedTime;
// 清除一条记录
+ (BOOL)removeTopicFromDB: (NSString *)topicName;
// 清除数据
+ (BOOL)removeTopicsFromDB;
@end
