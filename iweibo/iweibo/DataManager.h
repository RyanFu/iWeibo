//
//  DataManager.h
//  iweibo
//
//  基础数据库操作
//
//  Created by wangying on 1/14/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Asyncimageview.h"

@class Info;
@class NamenickInfo;
@class MusicInfo;
@class TransInfo;
@class videoUrl;
@class HotBroadcastInfo;
@class Draft;

// 当前SQL表版本
#define SQL_LITE_DB_VIER_BASE	1000
#define	SQL_LITE_DB_VER_05_28	1001

#define LIMITNUM 500

typedef enum{
	getNew = 0,
	getlatest,
	
}getType;

typedef enum{
	weibo  = 0,
	messageWeibo = 1,
	sourceWeibo = 2,
	sourceMessageWeibo = 3,
}weiboType;

@interface DataManager : UIViewController {
	NSMutableArray	*transSource;
	NSMutableArray  *videoUrlList;
	NSMutableArray  *imageSaveArray;
	NSMutableArray  *musicList;
	NSMutableArray  *arrayAll;
	NSString		*type;
}

@property (nonatomic, retain) NSMutableArray *transSource;
@property (nonatomic, retain) NSMutableArray *videoUrlList;
@property (nonatomic, retain) NSMutableArray *imageSaveArray;
@property (nonatomic, retain) NSMutableArray *musicList;
@property (nonatomic, retain) NSMutableArray *arrayAll;
@property (nonatomic, retain) NSString		 *type;

// 清除超500条数据
- (void)deleteSuperfluousData;

// 存储timeline信息入库
- (void)insertDataToDatabase:(Info *)dataInfo;

//更新timeline中source源信息
- (void)updateSourceWeibo:(NSString *)uid;

//更新微博中用户名和站点信息
- (void)updateWeiboWithSite:(NSString *)userName site:(NSString *)site withWhere:(NSString *)id;

// 数据库存储@提及我的
- (void)insertMessageToDatabase:(Info *)dataInfo;

//更新提及我的中source源信息
- (void)updateSourceMessageWeibo:(NSString *)uid;

//更新消息页中用户名和站点信息
- (void)updateMessageWithSite:(NSString *)userName site:(NSString *)site withWhere:(NSString *)id;

// 请求图片数据
- (void)requestImage:(Info *)requestInfo;

// 加载图片
- (void)loadImage:(NSString *)urlString:(NSString *)id:(MultiMediaType)typeM;

// 数据库读取timeline信息
- (NSMutableArray *)getDataFromWeibo:(NSString *)time type:(NSString *)typeType userName:(NSString *)nameInfo site:(NSString *)siteInfo;

// 数据库读取转播源信息
- (NSMutableArray *)getDataFromTransWeibo:(NSString *)idString type:(NSString *)str;

// 管理音频信息
- (MusicInfo *)manageMusicInfo:(NSDictionary *)info;

// 管理视频信息
- (videoUrl *)manageVideoInfo:(NSDictionary *)videoInfo;

// 管理转播源信息
- (TransInfo *)manageSourceInfo:(NSDictionary *)sourceInfo weiboId:(NSString *)id;

// 热门广播信息存入数据库
- (void) insertHotBroadCastToDatabase:(HotBroadcastInfo *)hotBroadcastInfo;

// 数据库读取热门广播信息
+ (NSMutableArray *)getHotBroadCastFromDatabase:(NSString *)id getType:(NSUInteger)readType;

// 获取数据库中最新的30条记录
+ (NSMutableArray *)getLatestBroadCast;

// 获取localid小于当前值的所有记录
+ (NSMutableArray *)getHotBroadCastLessThanLocalID:(NSString *)localID;

// 获取本地最新广播的转播源
+ (NSMutableArray *)getFromHotBroadTransWeibo:(NSString *)idString; 

// rss订阅存储到数据库
+ (void)insertHotWordSearchToDatabase:(NSString *)userName  hotWord:(NSString *)hotWord hotType:(NSString *)hotype;

// rss订阅查询
+ (NSMutableArray *)getHotWordSearchFromDatabase : (NSString *) hotype ;

// 热词搜索存入数据库
+ (void)insertHotSearchToDatabase:(NSString *)hotSearch;

// 热词搜索查询
+ (NSMutableArray *)getHotSearchFromDatabase;

+ (BOOL)removeHotSearch;
// 草稿箱存储
+ (void)insertDraftToDatabase:(Draft *)draftComposed;

+ (BOOL)alterDraftColoum:(NSString *)coloum;
// 草稿箱查询
+ (NSMutableArray *)getDraftFromDatabase:(NSString *)userName;
// 草稿箱草稿个数查询
+ (NSInteger )getDraftCountFromDatabase:(NSString *)userName;
// 草稿图片获取
+ (NSData *)getDraftAttachedData:(NSString *)time userName:(NSString *)name;
// 草稿删除操作
+ (BOOL)removeDraft:(NSString *)time userName:(NSString *)name;

//userInfo存储到数据库
+ (void)insertUserInfoToDB:(NamenickInfo *)info;
+ (void)insertUserInfoToDBWithDic:(NSDictionary *)nameNickInfoDic;

//userInfo查询
+ (NSMutableArray *)getUserInfoFromDB;
// 删除
+ (BOOL)removeAllUserNameNickInfo;
//读取主页最新一条记录的时间
+ (NSString *)readNewTimeWithUser:(NSString *)userName andSite:(NSString *)siteName;
//读取提及我的最新一条记录的时间
+ (NSString *)readMessageNewTimeWithUser:(NSString *)userName andSite:(NSString *)siteName;
//添加数据库脚本
+ (BOOL)alterWeiboColoum:(NSString *)coloum andType:(NSUInteger)typeWhere;

+ (BOOL)alterHotSearchColoum:(NSString *)coloum;

+ (BOOL)alterHotWordSearchColoum:(NSString *)coloum;

+ (BOOL)removeHotWordSearch;

+ (BOOL)removeHotWordSearch:(NSString *)rssContent hotype:(NSString *) hotype;

+ (BOOL)removeWeiboInfoFromDB;

+ (BOOL)removeMessageWeiboInfoFromDB;

+ (BOOL)removeMessageSourceInfoFromDB;

+ (BOOL)removeSourceInfoFromDB;

+ (BOOL)removeVideoInfoFromDB;

+ (BOOL)removeHotBCFromDB;

+ (BOOL)removeHotBCTransFromDB;

// 2012-05-28 By Yi Minwen
// 执行数据库表结构升级脚本
+ (BOOL)executeSQLDBUpdate;
// 2012-07-09 By Yi Minwen
// 查找缓存图像
+ (NSData *)getCachedImageFromDB:(NSString *)strUrl withType:(IMAGE_TYPE)typeImage;
+ (BOOL)insertCachedImageToDB:(NSString *)strUrl withData:(NSData *)dataImage andType:(IMAGE_TYPE)typeImage;
+ (BOOL)removeCachedImagesFromDB;
@end
