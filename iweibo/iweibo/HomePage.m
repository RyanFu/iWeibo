//
//  HomePage.m
//  iweibo
//
//  Created by LiQiang on 11-12-22.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import "HomePage.h"
#import "DetailsPage.h"
#import "iweiboAppDelegate.h"
#import "IWBSvrSettingsManager.h"
#import "ComposeViewControllerBuilder.h"
#import "EGORefreshTableHeaderView.h"
#import "HpThemeManager.h"
#import "WebUrlViewController.h"

#import "IWeiboAsyncApi.h"
#import "Canstants_Data.h"
#import "Canstants.h"
#import "Reachability.h"
#import "FMResultSet.h"
#import "FMDatabase.h"

#import "videoUrl.h"
#import "MusicInfo.h"
#import "UserInfo.h"
#import "TimeTrack.h"
#import "HomelineCell.h"
#import "MessageViewUtility.h"
#import "DetailPageConst.h"
#import "CustomNavigationbar.h"
#import "NamenickInfo.h"
#import "SCAppUtils.h"
#import "HomelineCellEx.h"

#define FOOTERHEIGHT  50
#define PARAMETERTYPE @"0"
#define LOADMORETYPE  @"1"
#define REQUESTFIVE	  @"15"	
#define REQUESTNUM    @"30"
#define ISCREATED	  @"isCreated"

static NSMutableDictionary			*g_stNickNameDic = nil;		// 昵称转换字典
static NSMutableDictionary			*g_stEmotionDic = nil;		// 昵称转换字典

@interface HomePage (Private)

- (void)dataSourceDidFinishLoadingNewData;

@end

@implementation HomePage
@synthesize reloading;
@synthesize homePageArray,musicList,databaseArray,homePageDic;
@synthesize broadCastLabel,broadCastImage,errorCastImage,IconCastImage;
@synthesize oldTimeStamp,newTimeStamp,midNewTimeStamp,pullOldTimeStamp,isTageTime,databaseOldTimestamp,draftSendTimestamp;
@synthesize plistDict;
@synthesize draftId;
@synthesize pushType;
@synthesize _statusBar;
@synthesize aApi;
@synthesize homePageTable;
@synthesize textHeightDic;
@synthesize siteInfo,userNameInfo;

// 获取全局保存昵称字典
+ (NSMutableDictionary *)nickNameDictionary {
	if (nil == g_stNickNameDic) {
		g_stNickNameDic = [[NSMutableDictionary alloc] initWithCapacity:10];
	}
	return g_stNickNameDic;
}
// 表情字典
+ (NSMutableDictionary *)emotionDictionary {
	if (nil == g_stEmotionDic) {
		TextExtract *textExtract = [[TextExtract alloc] init];//声明文本解析对象
		NSMutableDictionary *EmotionDic = [textExtract getEmoDictionary];//获取表情字典
		g_stEmotionDic = [[NSMutableDictionary alloc] initWithDictionary:EmotionDic copyItems:YES];
		[textExtract release];
	}
	return g_stEmotionDic;
}

// 插入数据到当前字典
+ (void)insertNickNameToDictionaryWithDic:(NSDictionary *)sourceDic {
	if (![sourceDic isKindOfClass:[NSDictionary class]]) {
		return;
	}	
	NSMutableDictionary *dic = [HomePage nickNameDictionary];
	NSArray *nameArray = [sourceDic allKeys];
	for (NSString *userName in nameArray) {
		NSString *userNick = [sourceDic objectForKey:userName];
		if ([userName isKindOfClass:[NSString class]] && [userNick isKindOfClass:[NSString class]]) {
			[dic setObject:userNick forKey:userName];
		}	
	}
}

#pragma mark -
#pragma mark MainMethod Methods

- (void)setDraftSendTime:(NSNumber *)time andID:(NSString *)dId{
	if (draftSendTimestamp == nil || draftId == nil) {
		draftSendTimestamp = [NSNumber numberWithInt:0];
        draftId = [[NSString alloc]initWithFormat:@"0"];
        
	}
	if ([time compare:draftSendTimestamp] != NSOrderedSame) {
		[draftSendTimestamp release];
		draftSendTimestamp = [time retain];
	}
    if ([dId compare:draftId] != NSOrderedSame) {
        [draftId release];
        draftId = [dId retain];
    }
}

- (void) hideTabBar:(BOOL) hidden{ 
    [UIView beginAnimations:nil context:NULL]; 
    [UIView setAnimationDuration:0]; 
    for(UIView *view in self.tabBarController.view.subviews) { 
        if([view isKindOfClass:[UITabBar class]]) { 
            if (hidden) { 
                [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)]; 
            } else { 
                [view setFrame:CGRectMake(view.frame.origin.x, 433, view.frame.size.width, view.frame.size.height)]; 
            } 
        } 
        else { 
            if (hidden) { 
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)]; 
            } else { 
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 433)]; 
            } 
        } 
    } 
    [UIView commitAnimations]; 
}

-(void)isSuccess:(NSDictionary *)result{
	NSString *msg = [result objectForKey:@"msg"];
	NSString *msgDecode = [msg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	CLog(@"msg:%@", msgDecode);
	draftNum = 0;
	pullRefreshCount = 0;
	isLoading = YES;
	homeButtonSelected = YES;
	int i = 0;
	if (self.pushType == draftRequest) {
		//取与发送消息相同的时间
		NSDictionary *data =[DataCheck checkDictionary:result forKey:HOMEDATA withType:[NSDictionary class]];
		NSArray *info = [DataCheck checkDictionary:data forKey:HOMEINFO withType:[NSArray class]];
		if (![info isKindOfClass:[NSNull class]]) {
			// 存储用户昵称
			NSDictionary *userNicks = [DataCheck checkDictionary:data forKey:@"user" withType:[NSDictionary class]];
			if ([userNicks isKindOfClass:[NSDictionary class]]) {
				// 存到数据库
				[DataManager insertUserInfoToDBWithDic:userNicks];
				// 存到本地字典
				[HomePage insertNickNameToDictionaryWithDic:userNicks];
			}
//          比较去掉重复旧的数据
			for (NSDictionary *sts in info) {
				NSNumber *draftTime = [sts objectForKey:HOMETIME];
//                NSString *draftId = [sts objectForKey:HOMEID];
				i++;
                // draftSendTimestamp这是发消息的时间戳，如果发消息的时间戳等于服务器取的时间就把这条消息展示在界面上  
				if ([draftSendTimestamp isEqualToNumber:draftTime] == YES) {
					[self handleDraftSendMessage:sts];
					break;
				}
//				if (i == 15) {
//					//如果没有取到，就取最新的，这里试过用3，或5，都有问题，所以取较大值
//					[self handleDraftSendMessage:[info objectAtIndex:0]];
//				}
			}
		}
	}
	else {
		[self getNewTimesStamp:result];
		if (!isHasNext) {
			[loadCell setState:loadMore1];
		}
		else {
			[loadCell setState:loadFinished];
		}
	}
}

-(void)isFailure:(NSError * )error{
	[self hiddenMBProgress];
//	_refreshHeaderView.isConnect = NO;
	self.homePageTable.contentOffset = CGPointZero;

	if ([error code] == ASIRequestTimedOutErrorType || [error code] == ASIConnectionFailureErrorType) {
		broadCastLabel.text = @"网络错误，请重试";
		errorCastImage.hidden = NO;
		IconCastImage.hidden = YES;
	}
	[self moveDown];
	[self dataSourceDidFinishLoadingNewData];
}

-(void) requstWebService:(NSString *)pageflag:(NSString *)pagetime:(NSString *)type:(NSString *)contenttype:(NSString *)reqNum{
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithCapacity:10];
	[parameters setValue:@"json" forKey:@"format"];
	[parameters setValue:pageflag forKey:@"pageflag"];
	[parameters setValue:reqNum forKey:@"reqnum"];
	[parameters setValue:pagetime forKey:@"pagetime"];
	[parameters setValue:type forKey:@"type"];
	[parameters setValue:contenttype forKey:@"contenttype"];
	[parameters setValue:URL_HOME_TIMELINE forKey:@"request_api"];
	
	[aApi getHomeTimelineMsgWithParamters:parameters delegate:self onSuccess:@selector(isSuccess:) onFailure:@selector(isFailure:)]; 
	[parameters release];
}

//计算返回的新的微博数
-(int)returnNewCount:(NSDictionary *)result timestampNew:(NSString *)timeStamp{
	int newWeiboCount = 0;
	if (pushType != draftRequest) {
		NSDictionary *data =[DataCheck checkDictionary:result forKey:HOMEDATA withType:[NSDictionary class]];
		NSArray *info = [DataCheck checkDictionary:data forKey:HOMEINFO withType:[NSArray class]];
		if (![info isKindOfClass:[NSNull class]]) {
			for (NSDictionary *sts in info) {
				if ([sts isKindOfClass:[NSDictionary class]] && sts) {
					NSString *time = [NSString stringWithFormat:@"%@",[sts objectForKey:HOMETIME]];
					if ([time compare: timeStamp]== NSOrderedDescending) {
						newWeiboCount++;
					}
					
				}
			}
		}
		
	}
	else {
		NSString *time = [NSString stringWithFormat:@"%@",[result objectForKey:HOMETIME]];
		if ([time compare: timeStamp]== NSOrderedDescending) {
			newWeiboCount++;
		}
		
	}
	return newWeiboCount;
}

- (NSMutableArray *)storeInfoToClass:(NSDictionary *)sts{
	Info *weiboInfo = [[Info alloc] init];
	NSMutableArray *sys = [[NSMutableArray alloc] init];
	weiboInfo.uid = [sts objectForKey:HOMEID];
	weiboInfo.name = [sts objectForKey:HOMENAME];
	weiboInfo.nick = [sts objectForKey:HOMENICK];
	weiboInfo.origtext = [sts objectForKey:HOMEORITEXT];
	weiboInfo.from = [sts objectForKey:HOMEFROM];
	weiboInfo.head = [sts objectForKey:HOMEHEAD];
	weiboInfo.userLatitude = [[sts objectForKey:LATITUDE] doubleValue];
	weiboInfo.userLongitude = [[sts objectForKey:LONGITUDE] doubleValue];
	NSString *vip = [[NSString alloc] initWithFormat:@"%@",[sts objectForKey:HOMEISVIP]];  //NSNumber类型
	weiboInfo.isvip = vip;
	[vip release];
	NSString *auth = [[NSString alloc] initWithFormat:@"%@",[sts objectForKey:@"is_auth"]];
	weiboInfo.localAuth = auth;
	[auth release];
	NSString *time = [[NSString alloc] initWithFormat:@"%@",[sts objectForKey:HOMETIME]];
	weiboInfo.timeStamp = time;
	[time release];
	NSString *emotion = [[NSString alloc] initWithFormat:@"%@",[sts objectForKey:HOMEEMOTION]];
	weiboInfo.emotionType = emotion;
	[emotion release];
	NSString *count = [[NSString alloc] initWithFormat:@"%@",[sts objectForKey:HOMECOUNT]];
	weiboInfo.count = count;
	[count release];
	NSString *mscount = [[NSString alloc] initWithFormat:@"%@",[sts objectForKey:HOMEMCOUNT]];
	weiboInfo.mscount = mscount;
	[mscount release];
	NSString *type = [[NSString alloc] initWithFormat:@"%@",[sts objectForKey:HOMETYPE]];
	weiboInfo.type = type;
	[type release];
	
	if (![[sts objectForKey:HOMEIMAGE]isEqual:[NSNull null]]) {
		NSArray *imagelist = [[NSArray alloc]initWithArray:[sts objectForKey:HOMEIMAGE]];
		if ([imagelist count]!=0) {
			NSString *image = [imagelist objectAtIndex:0];
			weiboInfo.image = image;
		}
		[imagelist release];
	}
	
	if (![[sts objectForKey:HOMEVIDEO] isEqual:[NSNull null]]) {
		NSDictionary *video = [[NSDictionary alloc]initWithDictionary:[sts objectForKey:HOMEVIDEO]];
		weiboInfo.video = video;
		[video release];
	}
	
	if (![[sts objectForKey:HOMEMUSIC] isEqual:[NSNull null]]) {
		NSDictionary *musci = [[NSDictionary alloc] initWithDictionary:[sts objectForKey:HOMEMUSIC]];
		weiboInfo.music = musci;	
		[musci release];
	}
	
	if (![[sts objectForKey:HOMESOURCE] isEqual:[NSNull null]]){
		NSDictionary *source = [[NSDictionary alloc] initWithDictionary:[sts objectForKey:HOMESOURCE]];
		weiboInfo.source =[NSDictionary dictionaryWithDictionary:[sts objectForKey:HOMESOURCE]];
		[source release];
	}
	[sys addObject:weiboInfo];
	[weiboInfo release];
	return [sys autorelease];
}

// 处理写消息展示到timeline逻辑
- (void)handleDraftSendMessage:(NSDictionary *)stsDraft{
	Info *draftInfo = nil;
	[textHeightDic removeAllObjects];
	NSArray *infoQueue =[self storeInfoToClass:stsDraft];
	draftInfo = [infoQueue objectAtIndex:draftNum];
	[draftArray insertObject:draftInfo atIndex:0];
	[homePageArray insertObject:draftInfo atIndex:0];
	[dataToDatabase insertDataToDatabase:draftInfo];
	[dataToDatabase updateWeiboWithSite:self.userNameInfo site:self.siteInfo withWhere:draftInfo.uid];	
	
	[homePageTable reloadData];
}

//服务器返回的数据存到数组和数据库
- (void)getNewTimesStamp:(NSDictionary *)result{ 
	pullRefreshCount = 0;
	NSDictionary *data =[DataCheck checkDictionary:result forKey:HOMEDATA withType:[NSDictionary class]];
	NSNumber *hasNext = [DataCheck checkDictionary:data forKey:HOMEHASNEXT withType:[NSNumber class]];
	if ([hasNext isKindOfClass:[NSNumber class]]) {
		isHasNext = [hasNext boolValue];
	}
	else {
		isHasNext = 0;
	}
	switch (pushType) {
		case firstRequest:
			[textHeightDic removeAllObjects];
			break;
		case loadMoreRequest:
			break;
//      暂时注掉，断层
//		case faultageRequest:
//			[textHeightDic removeAllObjects];
//			pullRefreshCount = [self returnNewCount:result timestampNew:self.midNewTimeStamp];
//			break;
		case pullRefreshRequest:
		{
			[textHeightDic removeAllObjects];
			[homePageArray removeObjectsInArray:draftArray];
			if ([draftArray count]!=0 ) {
				[draftArray release];
				draftArray = [[NSMutableArray alloc] init];
			}
			pullRefreshCount = [self returnNewCount:result timestampNew:newTimeStamp];
			[self doneLoadingTableViewData];
		}
			break;
//		case draftRequest:
//			[textHeightDic removeAllObjects];
//			pullRefreshCount = [self returnNewCount:result timestampNew:self.newTimeStamp];
//			break;
		default:
			break;
	}
	[self caculateHomeline:result];
	// 存储用户昵称
	NSDictionary *userNicks = [DataCheck checkDictionary:data forKey:@"user" withType:[NSDictionary class]];
	if ([userNicks isKindOfClass:[NSDictionary class]]) {
		// 存到数据库
		[DataManager insertUserInfoToDBWithDic:userNicks];
		// 存到本地字典
		[HomePage insertNickNameToDictionaryWithDic:userNicks];
	}
	[homePageTable reloadData];
    [self hiddenMBProgress];
	[dataToDatabase deleteSuperfluousData];

}
	
- (void)recordingTimestamp:(Info *) info atTimeType:(NSUInteger)calTimeType{
	if (info != nil) {
		switch (calTimeType) {
			case calNewTimeStamp:
				self.newTimeStamp = [NSString stringWithFormat:@"%@",[info timeStamp]];
				[[NSUserDefaults standardUserDefaults] setObject:newTimeStamp forKey:@"NewTimeStamp"];
				[[NSUserDefaults standardUserDefaults] synchronize];
				break;
			case calOldTimeStamp:
				self.oldTimeStamp = [NSString stringWithFormat:@"%@",[info timeStamp]];
				[[NSUserDefaults standardUserDefaults] setObject:oldTimeStamp forKey:@"OldTimeStamp"];
				[[NSUserDefaults standardUserDefaults] synchronize];
				break;
			case calPullOldTimeStamp:
				self.pullOldTimeStamp = [NSString stringWithFormat:@"%@",[info timeStamp]];
				break;
			case calIsTageTime:
				self.isTageTime = [NSString stringWithFormat:@"%@",[info timeStamp]];
				break;
			default:
				break;
		}
	}
}

//记录时间戳，这里不需要更新写消息的时间戳
- (void)recordingTimestamp:(NSArray *)infoQueue{
	Info *midInfo = nil;
	int draftCount = [draftArray count];
	int midNum = pullRefreshCount - draftCount - 1;
	NSUInteger bigNum = [infoQueue count]-1;
	Info *newInfo = [infoQueue objectAtIndex:0];
	Info *oldInfo = [infoQueue objectAtIndex:bigNum];
	if (midNum >= 0 ) {
		midInfo = [infoQueue objectAtIndex:midNum];
	}

	switch (pushType) {
		case firstRequest:
			[self recordingTimestamp:newInfo atTimeType:calNewTimeStamp];
			[self recordingTimestamp:oldInfo atTimeType:calOldTimeStamp];
			self.midNewTimeStamp = newTimeStamp;
			break;
		case loadMoreRequest:
			[self recordingTimestamp:oldInfo atTimeType:calOldTimeStamp];
			break;
		case pullRefreshRequest:
			[self recordingTimestamp:newInfo atTimeType:calNewTimeStamp];
			[self recordingTimestamp:midInfo atTimeType:calPullOldTimeStamp];
			[self recordingTimestamp:oldInfo atTimeType:calIsTageTime]; //用来判断是否有断层的时间戳
            [self recordingTimestamp:oldInfo atTimeType:calOldTimeStamp];
			break;
//		case faultageRequest:
//			[self recordingTimestamp:midInfo atTimeType:calPullOldTimeStamp];
//			[self recordingTimestamp:oldInfo atTimeType:calIsTageTime];
//			break;
		default:
			break;
	}	
}

- (void)storeInfoToArray:(NSArray *)infoQueue{
	Info *dataInfo = nil;
	for (int i=0; i<[infoQueue count]; i++) {
		dataInfo = [infoQueue objectAtIndex:i];
		[homePageArray addObject:dataInfo];
		[dataToDatabase insertDataToDatabase:dataInfo];
		[dataToDatabase updateWeiboWithSite:self.userNameInfo site:self.siteInfo withWhere:dataInfo.uid];
	}
}

//将断层数据更新到数组里
- (void)faultageInsertToArray:(NSArray *)infoQueue{
	Info *dataInfo = nil;
	NSUInteger index = 0;
	NSString *tangeTime = [NSString stringWithFormat:@"%d",[self.pullOldTimeStamp longLongValue]-1];
	for (int i = 0; i <[homePageArray count]; i++) {
		NSString *findTime = [[homePageArray objectAtIndex:i] timeStamp];
		if ([tangeTime compare:findTime] == NSOrderedDescending) {
			index = i;
			faultageRowIndex = i - 1 + 30;
			break;
		}
	}
	for (int i = 0; i<[infoQueue count]; i++) {
		dataInfo = [infoQueue objectAtIndex:i];
		[homePageArray insertObject:dataInfo atIndex:index++];
		[dataToDatabase insertDataToDatabase:dataInfo];
		[dataToDatabase updateWeiboWithSite:self.userNameInfo site:self.siteInfo withWhere:dataInfo.uid];
	}
}

//判断是否有断层
- (BOOL)isHasFaultage{
	BOOL hasFaultage = NO;
	CLog(@"self.midNewTimeStamp:%@", self.midNewTimeStamp);
	//每次下拉刷新的最后一条记录时间戳和主页显示的第一条时间戳进行比较，如果大于就有断层faultage＝yes，否则没有
	if ([self.isTageTime compare:self.midNewTimeStamp]== NSOrderedDescending) {
		//如果有断层就需要重复请求数据并且和midNewTimeStamp比较，所以不能更新这个值
		hasFaultage = YES;
	}
	else {
		hasFaultage = NO;
		//没有断层了更新midNewTimeStamp的值，要保证当前页面显示的最新记录时间作为midNewTimeStamp，因为只留最新的断层
		self.midNewTimeStamp = newTimeStamp;
	}
	return hasFaultage;
}

- (void)caculateHomeline:(NSDictionary *)result{
	Info *dataInfo = nil;
	int i = 0;

	NSArray *infoQueue =[dataSaveToClass storeInfoToClass:result];
	if ([infoQueue count]>0) {
		[self recordingTimestamp:infoQueue];
		if (pushType == pullRefreshRequest || pushType == draftRequest) {
			if (pullRefreshCount < 30) {  //写消息后刷新主timeline
				i = pullRefreshCount-1;
			}else {
				i = [infoQueue count] - 1;
			}
		}

		switch (pushType) {
			case firstRequest:
			case loadMoreRequest:
				[self storeInfoToArray:infoQueue];
				break;
//       断层，暂时注掉
//			case faultageRequest:
//				hasfaultage = [self isHasFaultage];
//				//定位到homepageArray需要添加的那条记录,将请求回来的数据插入到数组中
//				[self faultageInsertToArray:infoQueue];
//				break;
			case pullRefreshRequest:
				faultageRowIndex = pullRefreshCount - 1;
				hasfaultage = [self isHasFaultage];
				if (pullRefreshCount != 0) {
					for (; i >= 0; i--) {
						dataInfo = [infoQueue objectAtIndex:i];
						[homePageArray insertObject:dataInfo atIndex:0];
						[dataToDatabase insertDataToDatabase:dataInfo];
						[dataToDatabase updateWeiboWithSite:self.userNameInfo site:self.siteInfo withWhere:dataInfo.uid];
					}
				}

				break;				
//			case draftRequest:
//				for (draftNum = i; draftNum >= 0; draftNum--) {
//					dataInfo = [infoQueue objectAtIndex:draftNum];
//					[draftArray insertObject:dataInfo atIndex:0];
//					[homePageArray insertObject:dataInfo atIndex:0];
//					[dataToDatabase insertDataToDatabase:dataInfo];
//					[dataToDatabase updateWeiboWithSite:self.userNameInfo site:self.siteInfo withWhere:dataInfo.uid];
//				}
//				break;
			default:
				break;
		}
		
	}else {
		self.homePageTable.contentOffset = CGPointZero;
	}
}

- (void)showErrorView:(NSString *)errorMsg{
    UIImageView *errorBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
    [self.view bringSubviewToFront:errorView];  
    errorView.labelText = errorMsg;  
    errorView.labelFont = [UIFont systemFontOfSize:12];
    errorView.removeFromSuperViewOnHide = YES;
    errorView.customView = errorBg;
    errorView.mode = MBProgressHUDModeCustomView;
    [errorView show:YES];  
    [errorBg release];
    [self performSelector:@selector(hiddenAlertView) withObject:nil afterDelay:2];
}

#pragma mark -
#pragma mark read from db
- (void)dbSetState{
	[loadCell setState:loadMore1];
}

-(void)reStructerFromDB:(requestFromDBType)readType{
	NSArray *infoWeibo = nil;
	NSArray *info;
	isLoading = YES;//只要数据库里有数据isLoading就应该是yes，允许滑动设值
	if (readType == firstRequestFromDB) {
		if ([dataToDatabase.transSource count]!=0) {
			[dataToDatabase.transSource removeAllObjects];
		}
		if ([homePageArray count]!=0) {
			[homePageArray removeAllObjects];
		}
		//取数据库最新时间,因为要考虑切换站点的情况
		//self.newTimeStamp = [[NSUserDefaults standardUserDefaults] objectForKey:@"NewTimeStamp"];
		self.newTimeStamp = [DataManager readNewTimeWithUser:userNameInfo andSite:siteInfo];
		self.midNewTimeStamp = newTimeStamp;
		infoWeibo = [dataToDatabase getDataFromWeibo:newTimeStamp type:@"homelineType" userName:self.userNameInfo site:self.siteInfo];
		
	}
	else {
		if (readType == loadMoreFromDB) {
			self.databaseOldTimestamp = [[NSUserDefaults standardUserDefaults] objectForKey:@"dataBaseOldtime"];
			infoWeibo = [dataToDatabase getDataFromWeibo:self.databaseOldTimestamp type:@"homelineType" userName:self.userNameInfo site:self.siteInfo];  
			
		}
	}

	if ([infoWeibo count]>0) {
		isHasNext = 0;
		for (int i = 0; i<[infoWeibo count]; i++) {
			[homePageArray addObject:[infoWeibo objectAtIndex:i]];
		}
		self.databaseOldTimestamp = [[infoWeibo objectAtIndex:[infoWeibo count]-1] timeStamp];
		//因为这里与首次从数据库加载时间有冲突，故减1操作
		self.databaseOldTimestamp = [NSString stringWithFormat:@"%d",[self.databaseOldTimestamp longLongValue]-1];
		self.oldTimeStamp = self.databaseOldTimestamp;
		[[NSUserDefaults standardUserDefaults]setObject:self.databaseOldTimestamp forKey:@"dataBaseOldtime"];
		[[NSUserDefaults standardUserDefaults]synchronize];
		if([infoWeibo count]>1){
			for (int i = 0; i<[infoWeibo count]; i++) {
				info = [dataToDatabase getDataFromTransWeibo:[[infoWeibo objectAtIndex:i] uid]type:@"homelineType"];
				if ([info count]!=0) {
					[dataToDatabase.transSource addObject:[info objectAtIndex:0]];
				}
			}
		}
		[homePageTable reloadData];  
		[self hiddenMBProgress];
	}
	else {
		[self doneLoadingTableViewDataWithNetError];
	}
	[self performSelector:@selector(dbSetState) withObject:nil afterDelay:2];
}

#pragma mark -
#pragma mark  pull refresh

- (void)moveUp{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	broadCastImage.frame = CGRectMake(0, -30, 320, 30);
	[UIView commitAnimations];
}

- (void)moveDown{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
    broadCastImage.frame = CGRectMake(0, 0, 320, 30);
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(moveUp)];
	[UIView commitAnimations];
}

//下拉刷新后设置提示条
- (void)doneLoadingTableViewData{
	if (pullRefreshCount>0) {
		if(pullRefreshCount > 0 && pullRefreshCount <= 30) {
			int num = pullRefreshCount - draftNum;
			broadCastLabel.text = [NSString stringWithFormat:@"%d条新广播",num];
		}
		errorCastImage.hidden = YES;
		IconCastImage.hidden = NO;
	}
	else{
		broadCastLabel.text = @"没有新广播";
		errorCastImage.hidden = YES;
		IconCastImage.hidden = NO;
	}
	[self moveDown];
	[self dataSourceDidFinishLoadingNewData];
}

- (void)doneLoadingTableViewDataWithNetError{
	broadCastLabel.text = @"网络错误，请重试";   
	errorCastImage.hidden = NO;
	IconCastImage.hidden = YES;
	[self moveDown];
	[self dataSourceDidFinishLoadingNewData];
}

- (void)doAnimationUp{
	float duration = 0.0f;
	[refreshHeaderView setState:EGOOPullRefreshLoading];
	[UIView beginAnimations:nil context:NULL];
	if (pullRefreshCount == 0) {
		duration = 1.5f;
	}else {
		if (pullRefreshCount > 0 && pullRefreshCount < 15) {
			duration = 2.5f;
		}
		else {
			duration = 4.0f;
		}
	}
	[UIView setAnimationDuration:duration];
	homePageTable.contentOffset = CGPointMake(0, 0);
	[UIView commitAnimations];
}

- (void)setAnimation{
	
	[refreshHeaderView setState:EGOOPullRefreshLoading];
	// 2012-02-21 By Yi Minwen 更新状态
	[refreshHeaderView setCurrentDate:EGOHomelinelastTime withDateUpdated:YES];
	homePageTable.contentOffset = CGPointMake(0, 0);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	//homePageTable.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
	homePageTable.contentOffset = CGPointMake(0, -55);
	[UIView setAnimationDidStopSelector:@selector(doAnimationUp)];
	[UIView commitAnimations];
	
}

- (void)refresh{
	[self performSelectorInBackground:@selector(reloadNewDataSource:) withObject:pullRefreshRequest];
	[self setAnimation];
	
}

- (void)reloadNewDataSource:(requestType)refreshType{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	iweiboAppDelegate *delegate = (iweiboAppDelegate *) [UIApplication sharedApplication].delegate; 
	[delegate.mainContent showNewMsgBubble :PARAMETERTYPE];
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
		&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		[self performSelector:@selector(doneLoadingTableViewDataWithNetError) withObject:nil afterDelay:2.0];
	}
	else {
		self.pushType = refreshType;
		switch (refreshType) {
			case pullRefreshRequest:
				if (hasLocked) {
					[self requstWebService: PARAMETERTYPE : PARAMETERTYPE : PARAMETERTYPE :PARAMETERTYPE : REQUESTNUM ];
				}
				break;
			case draftRequest:
				[self requstWebService: PARAMETERTYPE : PARAMETERTYPE : PARAMETERTYPE :PARAMETERTYPE : REQUESTFIVE];
				break;
			default:
				break;
		}
	}
    [pool release];
}

- (void)dataSourceDidFinishLoadingNewData{
	reloading = NO;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2.0];
	[homePageTable setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[refreshHeaderView setState:EGOOPullRefreshNormal];
	//[_refreshHeaderView setCurrentDate:EGOHomelinelastTime];  
}

- (void)setMutex:(BOOL)status{
	hasLocked = status;
}

#pragma mark -
#pragma mark scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	if (scrollView.isDragging) {
		//CLog(@"%s, scrollView.contentOffset.y:%f", __FUNCTION__, scrollView.contentOffset.y);
		// 非刷新模式下状态更新
		if (!reloading) {
			// 假如_refreshHeaderView偏移度处于-65.0f到0之间，则状态为"下拉刷新"，并更新上次到现在的时间间隔
			if (scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f ) {
				[refreshHeaderView setState:EGOOPullRefreshNormal];
				// 计算距离上一次更新的时间间隔并更新界面
				[refreshHeaderView setCurrentDate:EGOHomelinelastTime withDateUpdated:NO];
			}
			else {
				[refreshHeaderView setState:EGOOPullRefreshPulling];
				// 设置最后更新时间为当前时间，不更新界面
				NSTimeInterval now=[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
				[refreshHeaderView setLasttimeState:EGOHomelinelastTime :now];
			}
		}
	}
	if ([scrollView isKindOfClass:[UITableView class]]) {
		UITableView *tableView = (UITableView *)scrollView;
		NSArray *indexPathes = [tableView indexPathsForVisibleRows];
		if (indexPathes.count > 0) {
			int rowCounts = [tableView numberOfRowsInSection:0];
			NSIndexPath *lastIndexPath = [indexPathes objectAtIndex:indexPathes.count-1];
			if (rowCounts - lastIndexPath.row < 2 && isLoading) {
				isLoading = NO;
				reloading = NO;
				homePageTable.tableFooterView.hidden = NO;  //added by wangying 解决首次进入会显示表尾的问题
				//判断从数据库读和网络读两种情况
				if (!isHasNext) {
					[self performSelector:@selector(handleTimer) withObject:nil afterDelay:2];	
				}
			}
		}
	}
}
- (void)loadImagesForOnscreenRows
{
	NSArray *visiblePaths = [homePageTable indexPathsForVisibleRows];
	//CLog(@"visiblePaths:%@",visiblePaths);
	for (NSIndexPath *indexPath in visiblePaths) {
		HomelineCell *cell = (HomelineCell *)[homePageTable cellForRowAtIndexPath:indexPath];
		if (cell) {
			[cell startIconDownload];
		}
		else {
			CLog(@"cell not found");
		}
		
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (scrollView.contentOffset.y <= - 65.0f && !reloading) {
		reloading = YES;
		[self reloadNewDataSource:pullRefreshRequest];
		[refreshHeaderView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		homePageTable.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
//	NSArray *visiblePaths = [homePageTable indexPathsForVisibleRows];
//	for (NSIndexPath *indexPath in visiblePaths) {
//		UITableViewCell *cell = [homePageTable cellForRowAtIndexPath:indexPath];
//		[cell setNeedsDisplay];
//	}
	if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnscreenRows];
	// added by wangying 20120530 解决发送消息后，马上点刷新，刷新条不回去的现象
	if (reloading) {
		[self dataSourceDidFinishLoadingNewData];
	}
	//
//	NSArray *visiblePaths = [homePageTable indexPathsForVisibleRows];
//	for (NSIndexPath *indexPath in visiblePaths) {
//		 UITableViewCell *cell = [homePageTable cellForRowAtIndexPath:indexPath];
//		[cell setNeedsDisplay];
//	}
}
#pragma mark -
#pragma mark loadMore From DB
// 加载更多
- (void)handleTimer{//:(NSTimer *)timer
	[loadCell setState:loading1];
	[self loadMoreStatuses];
}

- (void)loadMoreStatuses{  //加载获取更多
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
		&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		[self reStructerFromDB:loadMoreFromDB];
	}
	else {
		self.pushType = loadMoreRequest;
		[self requstWebService:LOADMORETYPE : self.oldTimeStamp : PARAMETERTYPE :PARAMETERTYPE : REQUESTNUM];
	}
}

-(float) calculateHeightOfTextFromWidth:(NSString*) text: (UIFont*)withFont: (float)width :(UILineBreakMode)lineBreakMode
{
	[text retain];
	[withFont retain];
	CGSize suggestedSize = [text sizeWithFont:withFont constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:lineBreakMode];
	
	[text release];
	[withFont release];
	
	return suggestedSize.height;
}

- (CGSize)getStringSize:(NSString *)string withFontSize:(CGFloat)fontSize{
	return [string sizeWithFont:[UIFont systemFontOfSize:fontSize] 
			  constrainedToSize:CGSizeMake(200,1024) 
				  lineBreakMode:UILineBreakModeWordWrap];
}

- (NSString *)intervalSinceNow: (double) theDate 
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-theDate;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
		if ([timeString compare:@"0.1"]==NSOrderedAscending) {
			timeString = [NSString stringWithFormat:@"刚刚"];
		}
		else {
			timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
		}
    }
	if (cha/3600>1&&cha/86400<1) {
		timeString = [NSString stringWithFormat:@"%f", cha/3600];
		timeString = [timeString substringToIndex:timeString.length-7];
		timeString=[NSString stringWithFormat:@"%@小时前", timeString];
	}
	if (cha/86400>1&&cha/172800<1) {
        timeString= @"昨天";
	}
	if (cha/172800>1&&cha/259200<1) {
		timeString = @"前天";
	}
	if (cha/259200>1) {
		NSDate *currentStamp = [NSDate dateWithTimeIntervalSinceNow:-cha];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"MM-dd"];
		timeString = [dateFormatter stringFromDate:currentStamp];
		[dateFormatter release];		
	}
	
    return timeString;
}

- (CGFloat)getRowHeight:(NSUInteger)row{
	NSString *rowString = [[NSString alloc] initWithFormat:@"%d", row];
	if ([textHeightDic objectForKey:rowString]) {
	//if (NO) {
		NSMutableDictionary *dic = [textHeightDic objectForKey:rowString];
		assert(dic);
		CGFloat origHeight = [[dic objectForKey:@"origHeight"] floatValue];
		CGFloat sourceHeight = [[dic objectForKey:@"sourceHeight"] floatValue];
		//CLog(@"rowString First:%@ origHeight:%f, sourceHeight:%f", rowString, origHeight, sourceHeight);
		[rowString release];
		CGFloat retValue = 0.0f;
		if (sourceHeight > 1) {
			retValue += sourceHeight + VSBetweenSourceFrameAndFrom;
		}
		CGFloat fromHeight = [@"来自..." sizeWithFont:[UIFont systemFontOfSize:12]].height + VSpaceBetweenOriginFrameAndFrom;
		retValue += origHeight + fromHeight;
		return retValue;
	}
	else {
		Info *info = [homePageArray objectAtIndex:row];
		CGFloat origHeight = 0.0f;
		CGFloat sourceHeight = 0.0f;
		CGFloat retValue = 0.0f;
		origHeight = [MessageViewUtility getTimelineOriginViewHeight:info];
		if ([dataToDatabase.transSource count] > 0) {
			for (TransInfo *transInfo in dataToDatabase.transSource) {
				if ([[transInfo transNick] length] > 0 && [transInfo.transId isEqualToString:info.uid]) {
					sourceHeight = [MessageViewUtility getTimelineSourceViewHeight:transInfo];
					retValue += sourceHeight + VSBetweenSourceFrameAndFrom;
					break;
				}
			}
		}
		// 来自...高度
		CGFloat fromHeight = [@"来自..." sizeWithFont:[UIFont systemFontOfSize:12]].height + VSpaceBetweenOriginFrameAndFrom;
		retValue += origHeight + fromHeight;
		
		NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
		NSString *origHeightStr = [[NSString alloc] initWithFormat:@"%f", origHeight];
		NSString *sourceHeightStr = [[NSString alloc] initWithFormat:@"%f", sourceHeight];
		[dic setObject:origHeightStr forKey:@"origHeight"];
		[dic setObject:sourceHeightStr forKey:@"sourceHeight"];
		[textHeightDic setObject:dic forKey:rowString];
		//CLog(@"rowString First:%@ origHeight:%f, sourceHeight:%f", rowString, origHeight, sourceHeight);
		[origHeightStr release];
		[sourceHeightStr release];
		[dic release];
		[rowString release];
		return retValue;
	}

}

#pragma mark -
#pragma mark UITableViewDataSource Methods
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if ([self.homePageArray count] > 0) {
	//	NSLog(@"array count=%d", [homePageArray count]);
		return [homePageArray count];
	}else {
		return 0;
	}
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	//TimeTrack* timeTrack = [[TimeTrack alloc] initWithName:[NSString stringWithFormat:@"%s: row:%d",__FUNCTION__, indexPath.row]];
	CGFloat height = 0.0f;
	if (indexPath.row < [homePageArray count]) {
		height = [self getRowHeight:indexPath.row];
		// 2012-05-14 By Yimiwen 增加断层处理
//		if (hasfaultage && indexPath.row == faultageRowIndex) {
//			height += 40;
//		}
	}
	else {
		height = homePageTable.bounds.size.height+FOOTERHEIGHT;  //added by wangying
	}
	//[timeTrack release];
	return height;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//	if([homePageArray count]==0){
//		return 0.0f;
//	}
//	else {
//		return 50.0f;
//	}
//
//}

- (void)initCellInfo:(NSMutableDictionary *)dic{
	HomelineCell *cell = [dic objectForKey:@"cell"];
	NSNumber *rowNum = [dic objectForKey:@"rowNum"];
	NSInteger row= [rowNum intValue];
	cell.rootContrlType = 1;
	cell.contentView.backgroundColor = [UIColor clearColor];
	
	UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
	aView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:0.933];
	cell.selectedBackgroundView = aView; 
	[aView release];
	
	
	cell.heightDic = self.textHeightDic;
	cell.remRow = [NSString stringWithFormat:@"%d", row];
	
	cell.homeInfo = [homePageArray objectAtIndex:row];
	
	[cell setLabelInfo:[homePageArray objectAtIndex:row]];
	
	if (![[[homePageArray objectAtIndex:row] source] isMemberOfClass:[NSNull class]]){
		if ([dataToDatabase.transSource count]!=0) {
			for (TransInfo *transInfo in dataToDatabase.transSource) {
				if ([transInfo.transId isEqualToString:[[homePageArray objectAtIndex:row] uid]]) {
					cell.sourceInfo = transInfo;
					break;
				}
				[cell remove];//将转播源从屏幕移除
			}
		}
	}
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   // CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
	NSUInteger row = indexPath.row;
	UITableViewCell *tableViewCell = nil;
	//[MessageViewUtility printAvailableMemory];
	if (row < [homePageArray count]) {
		static NSString *cellIdentifier = @"homeCellIdentifier";
		HomelineCell *cell = (HomelineCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		
		if (cell == nil) {
			cell = [[[HomelineCellEx alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier showStyle:HomeShowSytle sourceStyle:HomeSourceSytle containHead:YES] autorelease];
			cell.myHomelineCellVideoDelegate = self;
			cell.rootContrlType = 1;
			cell.contentView.backgroundColor = [UIColor clearColor];
		} 
//		if (hasfaultage && indexPath.row == faultageRowIndex) {
//			cell.hasFaultageAction = YES;
//		}
//		else {
//			cell.hasFaultageAction = NO;
//		}

		cell.heightDic = self.textHeightDic;
		cell.remRow = [NSString stringWithFormat:@"%d", row];
		//CFAbsoluteTime First = CFAbsoluteTimeGetCurrent();
//		CLog(@"%s First took %2.5f secs", __FUNCTION__, First - start);
		cell.homeInfo = [homePageArray objectAtIndex:row];
		
					
		[cell setLabelInfo:[homePageArray objectAtIndex:row]];
		//CFAbsoluteTime Second = CFAbsoluteTimeGetCurrent();
//		CLog(@"%s Second took %2.5f secs", __FUNCTION__, Second - start);
			
			if (![[[homePageArray objectAtIndex:row] source] isMemberOfClass:[NSNull class]]){
				if ([dataToDatabase.transSource count]!=0) {
					//CFAbsoluteTime forstart = CFAbsoluteTimeGetCurrent();
					NSString *strUid = [[homePageArray objectAtIndex:row] uid];
					BOOL bFound = NO;
					for (TransInfo *transInfo in dataToDatabase.transSource) {
						if (!bFound && [transInfo.transId isEqualToString:strUid]) {
							cell.sourceInfo = transInfo;
							bFound = YES;
							break;
						}				
					}
					if (!bFound) {
						[cell remove];//将转播源从屏幕移除	do	
					}
					//CFAbsoluteTime forEnd = CFAbsoluteTimeGetCurrent();
//					CLog(@"%s for took %2.5f secs", __FUNCTION__, forEnd - forstart);
				}
			}			
	//	CFAbsoluteTime Third = CFAbsoluteTimeGetCurrent();
//		CLog(@"%s Third took %2.5f secs", __FUNCTION__, Third - Second);
		if (homePageTable.dragging == NO && homePageTable.decelerating == NO)
		{
		//	CLog(@"indexPath:%@, startIconDownload", indexPath);
			[cell startIconDownload];
		}
		tableViewCell = cell;
	}
	else {
		NSString *cellIdentifier = @"cellIdentifier";
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		}
		tableViewCell = cell;
	}
	
   // CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
//    CLog(@"%s took %2.5f secs", __FUNCTION__, end - start);
    return tableViewCell;
}


//#pragma mark -
//#pragma mark UITableViewDelegate Methods
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	// 设置发送状态代理
	// 2012-02-21 放到iweiboAppDelegate里边处理
	//[[DraftController sharedInstance] setMyDraftControllerDelegate:self];
	[self.tabBarController performSelector:@selector(hideNewTabBar)];//隐藏tabbar
	if (indexPath.row < [homePageArray count]) {
		DetailsPage   *details = [[DetailsPage alloc] init];
		details.rootContrlType = 1;
		details.homeInfo = [homePageArray objectAtIndex:indexPath.row];
		if (![[[homePageArray objectAtIndex:indexPath.row] source] isMemberOfClass:[NSNull class]]){
			if ([dataToDatabase.transSource count]!=0) {
				for (TransInfo *transInfo in dataToDatabase.transSource) {
					if ([transInfo.transId isEqualToString:[[homePageArray objectAtIndex:indexPath.row] uid]]) {
						details.sourceInfo = transInfo;
						break;
					}
				}
			}
		}
		[self.navigationController pushViewController:details animated:YES];
		[details release];
	}
	else {
		[self loadMoreStatuses];
		NSArray *indexPathes = [tableView indexPathsForVisibleRows];
		NSIndexPath *lastIndexPath = [indexPathes objectAtIndex:indexPathes.count-1];
		[tableView reloadData];
		[tableView scrollToRowAtIndexPath:lastIndexPath
						 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
}

- (void)showBar{
	self.navigationController.navigationBarHidden = NO;
	[self hideTabBar:NO];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"showStatus" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
	[reloadBtn release];
	[writeWeiboBtn release];
	[op cancelAllOperations];
	[op release];
	[aApi release];
	[MBprogress release];
	[userNameInfo release];
	[siteInfo release];
	// 2012-02-21 放到iweiboAppDelegate里边处理
	//[[DraftController sharedInstance] setMyDraftControllerDelegate:nil];
	[newTimeStamp release];
	[oldTimeStamp release];
	[midNewTimeStamp release];
	[isTageTime release];
	[pullOldTimeStamp release];
	[homePageArray release];
	[_statusBar release];
    [draftArray release];
	[refreshHeaderView release];
	[textHeightDic release];
	textHeightDic = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning{

    [super didReceiveMemoryWarning];
}

//#pragma mark - View lifecycle

- (void)reloadHomePage{
    CLog(@"刷新首页");
}

//click write weibo btn invoke this function
- (void)writeWeibo{
    CLog(@"写微博界面");
    /*   WriteWeiboPage *writeWeibo = [[WriteWeiboPage alloc] init];
     writeWeibo.currentNavTitle = @"广播";
     writeWeibo.weibo = @"";
     writeWeibo.sendAction = 1;
     UINavigationController  *writeWeiboController = [[[UINavigationController alloc] initWithRootViewController:writeWeibo] autorelease];
     [self presentModalViewController:writeWeiboController animated:YES];
     [writeWeibo release];
     */
	// 关于发送消息，当点击发送返回主界面后，顶层有发送状态变更
	// 目前推想处理逻辑: 发送消息界面在点发送时，先给当前homepage发送通知，告诉它有消息发送，
	// 异步消息，需要监听下边的协议来更新最后发送状态
	// 监听消息回调
    NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    UIImage *imageWriteNav = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]];
	ComposeBaseViewController   *composeViewController =  [ComposeViewControllerBuilder createWithComposeMsgType:BROADCAST_MESSAGE];
	UINavigationController	*composeNavController = [[[UINavigationController alloc] initWithRootViewController:composeViewController] autorelease];
    [SCAppUtils navigationController:composeNavController setImage:imageWriteNav];
    [self presentModalViewController:composeNavController animated:YES];
	// composeViewController无需手动释放
	//[ComposeViewControllerBuilder desposeViewController:composeViewController];
}

#pragma mark DraftControllerDelegate

-(void)DraftSendOnSuccess:(NSDictionary *)dict {
	// 异步消息发送成功回调
	CLog(@"HomePage:DraftSendOnSuccess:%@", dict);
	NSNumber *ret = [dict objectForKey:@"ret"];
	NSString *msg = [dict objectForKey:@"msg"];
	NSString *msgDecode = [msg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	// 2012-02-03 By Yi Minwen 
	// 此处为什么注释掉，是因为在消息详情页产生的评论，转播消息都会发送到当前homepage，假如置空，则会取不到回调
	// 2012-02-21 放到iweiboAppDelegate里边处理
	//[[DraftController sharedInstance] setMyDraftControllerDelegate:nil];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDelay:3.5];
	[UIView setAnimationDuration:1.5];
	 self._statusBar.type = statusTypeSuccess;
	if ([ret intValue] == 0) {
		[self._statusBar showWithStatusMessage:@"发送成功!"];
	}
	else {
		[self._statusBar showWithStatusMessage:msgDecode];
	}
	[self._statusBar setNeedsDisplay];
	[UIView setAnimationDidStopSelector:@selector(successCallBack)];
	[UIView commitAnimations];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDraftNotification" object:nil];
}

-(void)DraftSendOnFailure:(NSError *)error {
	// 异步消息发送失败回调
	CLog(@"HomePage:DraftSendOnFailure");
	// 2012-02-03 By Yi Minwen 
	// 此处为什么注释掉，是因为在消息详情页产生的评论，转播消息都会发送到当前homepage，假如置空，则会取不到回调
	// 2012-02-21 放到iweiboAppDelegate里边处理
	//[[DraftController sharedInstance] setMyDraftControllerDelegate:nil];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDelay:3.5];
	[UIView setAnimationDuration:1.5];
	self._statusBar.type = statusTypeSuccess;
	[self._statusBar showWithStatusMessage:@"发送失败"];
	[self._statusBar setNeedsDisplay];
	[UIView setAnimationDidStopSelector:@selector(successCallBack)];
	[UIView commitAnimations];
}

- (void)showMBProgress{
    if (MBprogress == nil) {
        MBprogress = [[MBProgressHUD alloc] initWithFrame:CGRectMake(30, 80, 260, 200)]; 
    }
    [self.view addSubview:MBprogress];  
    [self.view bringSubviewToFront:MBprogress];  
    MBprogress.labelText = @"载入中...";  
    MBprogress.removeFromSuperViewOnHide = YES;
    [MBprogress show:YES];  
}

- (void) hiddenMBProgress{
    [homePageTable setHidden:NO];
    [MBprogress hide:YES];
}

- (void)hiddenAlertView{
	[homePageTable setHidden:NO];
	[errorView hide:YES];
}

#pragma mark -
#pragma mark Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)updateTheme:(NSNotificationCenter *)noti{
    self.plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
	NSString *themePathTmp = [plistDict objectForKey:@"TimelineImage"];
    NSArray *pathArray = [themePathTmp componentsSeparatedByString:@"/"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
	[reloadBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:RELOADBTN]] forState:UIControlStateNormal];
    [reloadBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:RELOADBTNSEL]] forState:UIControlStateHighlighted];
	[writeWeiboBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:WRITEWEIBO]] forState:UIControlStateNormal];
	[writeWeiboBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:WRITEWEIBOSEL]] forState:UIControlStateHighlighted];
     if([[pathArray objectAtIndex:0] isEqualToString:@"FirstSkin"]){
         reloadBtn.frame = CGRectMake(0, 5, 32, 32);
         writeWeiboBtn.frame = CGRectMake(290, 5, 32, 32);
     }
     else{
         reloadBtn.frame = CGRectMake(0, 5, 50, 32);
         writeWeiboBtn.frame = CGRectMake(290, 5, 50, 32);
     }
         
}

- (void)viewDidLoad{
	[super viewDidLoad];	
	isLoading = YES;
	hasLocked = YES;
	homeButtonSelected = NO;
	textHeightDic = [[NSMutableDictionary alloc] initWithCapacity:30];
	homePageArray = [[NSMutableArray alloc]initWithCapacity:30];
	dataToDatabase = [[DataManager alloc] init];
	dataSaveToClass = [[DataSave alloc] init];
	draftArray = [[NSMutableArray alloc] init];
    
    // _tableView高度延长两个像素，与下方tableBar衔接整齐，解决最下方空隙处有白边的问题。   2012-7-20
	UITableView *_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 366+2) style:UITableViewStylePlain];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	homePageTable = _tableView;
    CLog(@"UIScrollViewDecelerationRateNormal: %f, %f",UIScrollViewDecelerationRateNormal, UIScrollViewDecelerationRateFast );
//	homePageTable.decelerationRate = UIScrollViewDecelerationRateNormal + (1 - UIScrollViewDecelerationRateNormal) / 2.0f;
//	homePageTable.decelerationRate = UIScrollViewDecelerationRateFast;
	homePageTable.separatorColor = [UIColor colorWithRed:0.827 green:0.843 blue:0.855 alpha:1];
    
    // 加载更多
	loadCell = [[LoadCell alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
	homePageTable.tableFooterView = loadCell;
	homePageTable.tableFooterView.hidden = YES;   
    //	_reloading = YES;
	[self.view addSubview:homePageTable];
	
	aApi = [[IWeiboAsyncApi alloc] init];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"bgLabel" ofType:@"png"];
	broadCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
	broadCastImage.frame = CGRectMake(0, -30, 320, 30);
	
	NSString *pathError = [[NSBundle mainBundle] pathForResource:@"errorler" ofType:@"png"];
	errorCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pathError]];
	errorCastImage.frame = CGRectMake(90, 5, 20, 20);
	errorCastImage.backgroundColor = [UIColor clearColor];
	errorCastImage.hidden = YES;
	[broadCastImage addSubview:errorCastImage];
	[errorCastImage release];
	
	NSString *pathIcon = [[NSBundle mainBundle] pathForResource:@"iconPull" ofType:@"png"];IconCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pathIcon]];
	IconCastImage.frame = CGRectMake(100, 8, 15, 15);
	IconCastImage.backgroundColor = [UIColor clearColor];
	IconCastImage.hidden = YES;
	[broadCastImage addSubview:IconCastImage];
	[IconCastImage release];
	
	broadCastLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 180, 30)];
	broadCastLabel.backgroundColor = [UIColor clearColor];
	broadCastLabel.textColor = [UIColor colorWithRed:166/255.0 green:137/255.0 blue:67/255.0 alpha:1.];
	broadCastLabel.font = [UIFont systemFontOfSize:15];
	[broadCastImage addSubview:broadCastLabel];
	[broadCastLabel release];
	[self.view addSubview:broadCastImage];
	[broadCastImage release];
	
	if (refreshHeaderView == nil) {
		//homePageTable.bounds.size.height
		refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - 65.0f, self.view.frame.size.width, 65.0f)];
		[refreshHeaderView setTimeState:EGOHomelinelastTime];
	}
	[homePageTable addSubview:refreshHeaderView];

	//数据表增加userName和site两个字段
	NSString *isCreated = [[NSUserDefaults standardUserDefaults] objectForKey:ISCREATED];
	if (!isCreated) {
		BOOL isAlterUserNameOK = [DataManager alterWeiboColoum:USERNAME andType:weibo];
		BOOL isAlterSiteOK = [DataManager alterWeiboColoum:SITE andType:weibo];
		BOOL isSourceUserNameOK = [DataManager alterWeiboColoum:USERNAME andType:sourceWeibo];
		BOOL isSourceSiteOK = [DataManager alterWeiboColoum:SITE andType:sourceWeibo];
		if (isAlterSiteOK && isAlterUserNameOK && isSourceUserNameOK && isSourceSiteOK) {
			[[NSUserDefaults standardUserDefaults] setObject:@"OK" forKey:ISCREATED];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		CLog(@"%d,%d",isAlterUserNameOK,isAlterSiteOK);
	}	
	//获取用户name
	self.userNameInfo = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite.loginUserName;
	//获取站点信息
	self.siteInfo = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite.descriptionInfo.svrName;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (!actSite.bUserFirstLogin) {
		//非首次登陆
		[self reStructerFromDB:firstRequestFromDB];
//		// 加载昵称信息
//		NSMutableArray *nickNameArr = [DataManager getUserInfoFromDB];
//		NSMutableDictionary *dic = [HomePage nickNameDictionary];
//		for (NamenickInfo *nickInfo in nickNameArr) {
//			[dic setObject:nickInfo.userNick forKey:nickInfo.userName];
//		}
    }

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBar) name:@"showBar" object:nil];
    
    NSDictionary *pathDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"ThemePath"];
    if ([pathDic count] == 0) {
        self.plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
        if ([plistDict count] == 0) {
            NSString *skinPath = [[NSBundle mainBundle] pathForResource:@"ThemeManager" ofType:@"plist"];
            self.plistDict = [[NSArray arrayWithContentsOfFile:skinPath] objectAtIndex:0];
        }
    }
    else{
        self.plistDict = pathDic;
    }
        

	NSString *themePathTmp = [plistDict objectForKey:@"TimelineImage"];
    NSArray *pathArray = [themePathTmp componentsSeparatedByString:@"/"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
	if (themePath) {
		reloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 32, 32)];
		[reloadBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:RELOADBTN]] forState:UIControlStateNormal];
        [reloadBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:RELOADBTNSEL]]forState:UIControlStateHighlighted];
		[reloadBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *reloadHomePageBarBtn = [[UIBarButtonItem alloc] initWithCustomView:reloadBtn];
		self.navigationItem.leftBarButtonItem = reloadHomePageBarBtn;
		[reloadHomePageBarBtn release];
		
		writeWeiboBtn = [[UIButton alloc] initWithFrame:CGRectMake(290, 5, 32, 32)];
		[writeWeiboBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:WRITEWEIBO]] forState:UIControlStateNormal];
		[writeWeiboBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:WRITEWEIBOSEL]] forState:UIControlStateHighlighted];
		[writeWeiboBtn addTarget:self action:@selector(writeWeibo) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *writeWeiboBarbBtn = [[UIBarButtonItem alloc] initWithCustomView:writeWeiboBtn];
		self.navigationItem.rightBarButtonItem = writeWeiboBarbBtn;
		[writeWeiboBarbBtn release];
        if([[pathArray objectAtIndex:0] isEqualToString:@"FirstSkin"]){
            reloadBtn.frame = CGRectMake(0, 5, 32, 32);
            writeWeiboBtn.frame = CGRectMake(290, 5, 32, 32);
        }
        else{
            reloadBtn.frame = CGRectMake(0, 5, 50, 32);
            writeWeiboBtn.frame = CGRectMake(290, 5, 50, 32);
        }
	}
    
	errorView = [[MBProgressHUD alloc] initWithFrame:CGRectMake(80, 148, 160, 125)]; 
    [self.view addSubview:errorView]; 
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDraftStatus) name:@"showStatus" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
	op 	= [[NSOperationQueue alloc] init];
}

-(void)removeTextHeightDic {
    [textHeightDic removeAllObjects];
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	//[textHeightDic removeAllObjects];
	[self.tabBarController performSelector:@selector(showNewTabBar)];
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	delegate.draws = 1;
	UserInfo *info = [UserInfo sharedUserInfo];
	if (info.name == nil || [info.name length] == 0) {
		[info loadDataFromDB];
	}
	//获取用户name ，切换用户时不调用viewDidLoad
	self.userNameInfo = info.name;

	NSLog(@"nick=%@", info.nick);
	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
	[customLab setTextColor:[UIColor whiteColor]];
	[customLab setText:info.nick];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	//self.navigationItem.title = info.nick;  
	//获取站点信息
	self.siteInfo = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite.descriptionInfo.svrName;

	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin && actSite.bUserFirstLogin) {
		if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
			&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
			NSString *errorMsg = @"网络错误，请重试"; 
			[self showErrorView:errorMsg]; 
		}
		else{
			[self hiddenAlertView];
			if (!homeButtonSelected) {
				[self showMBProgress];
				self.pushType = firstRequest;
				[self requstWebService: PARAMETERTYPE :PARAMETERTYPE :PARAMETERTYPE :PARAMETERTYPE : REQUESTNUM];
			}
		}
	}

}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:YES];
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	delegate.window.backgroundColor = [UIColor whiteColor];
}

- (void)setHomeButtonSelected{
	homeButtonSelected = NO;
}

- (void)viewDidUnload
{
	[IconCastImage release];
	[broadCastImage release];
	[broadCastLabel release];
	[errorCastImage release];
	[errorView release];
	[loadCell	release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)successCallBack{
    NSLog(@"successCallBack");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.5];
    [UIView setAnimationDuration:1.5];
    [self._statusBar setFrame:CGRectMake(0, -20, 320, 20)];
    [UIView commitAnimations];
}

- (void)showDraftStatus{
	if (self._statusBar == nil) {
		_statusBar = [[CustomStatusBar alloc] init];
	}
	[UIView beginAnimations:nil context:nil];
	self._statusBar.frame = CGRectZero;
	self._statusBar.type = statusTypeLoading;
	[self._statusBar showWithStatusMessage:@"发送中..."];
	[UIView commitAnimations];
}
#pragma mark -
#pragma mark protocol HomelineCellVideoDelegate<NSObject> 视频点击事件
- (void)HomelineCellVideoClicked:(NSString *)urlVideo {	
	[self.tabBarController performSelector:@selector(hideNewTabBar)];
	CLog(@"HomelineCellVideoClicked:%@", urlVideo);
	WebUrlViewController *webUrlViewController = [[WebUrlViewController alloc] init];
	webUrlViewController.webUrl = urlVideo;
	[self.navigationController pushViewController:webUrlViewController animated:YES];
	[webUrlViewController release];
}

-(void)HomelineCellFaultageViewClick {
	CLog(@"%s", __FUNCTION__);
	//在断层处继续向下请求30条数据  这由界面控制看是否自动请求还是需要点击请求 ，敏文加到适当位置
	//单开一个请求类型是因为，断层请求后可能还会有断层，比如最新有67条数据，要记录最后一条记录的时间，用于比较。
	self.pushType = faultageRequest;
	NSString *timeTange = [NSString stringWithFormat:@"%d",[self.pullOldTimeStamp longLongValue]-1];
	[self requstWebService:LOADMORETYPE : timeTange : PARAMETERTYPE :PARAMETERTYPE : REQUESTNUM];
}

@end
