//
//  IWeiboASyncHttpRequest.m
//  iweibo
//
//  Created by zhaoguohui on 11-12-27.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "IWeiboASyncHttpRequest.h"
#import "NSString+QEncoding.h"
#import "IweiboOauth.h"
#import "NSString+MD5.h"
#import "SelectServer.h"
#import "IWBSvrSettingsManager.h"

#define OAuthVersion @"1.0"
#define HMACSHA1SignatureType @"HMAC-SHA1"

#define OAuthConsumerKeyKey @"oauth_consumer_key"
#define OAuthVersionKey @"oauth_version"
#define OAuthSignatureMethodKey @"oauth_signature_method"
#define OAuthSignatureKey @"oauth_signature"
#define OAuthTimestampKey @"oauth_timestamp"
#define OAuthNonceKey @"oauth_nonce"
#define OAuthTokenKey @"oauth_token" 
#define OAuthTokenSecretKey @"oauth_token_secret"

@implementation IWeiboASyncHttpRequest

// 将存放在字典中的键值对，组成一个url格式的请求键值对组成的字符串
- (NSString *)normalizedRequestParameters:(NSDictionary *)aParameters {
	NSMutableArray *parametersArray = [NSMutableArray array];
	for (NSString *key in aParameters) {
		[parametersArray addObject:[NSString stringWithFormat:@"%@=%@", key, [aParameters valueForKey:key]]];
	}
	return [parametersArray componentsJoinedByString:@"&"];
}


// 生成时间戳，防止重复攻击
- (NSString *)generateTimeStamp {
	return [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
}


// 生成单次值
- (NSString *)generateNonce {
	return [NSString stringWithFormat:@"%u", arc4random() % (9999999 - 123400) + 123400];
}


// 根据传入的参数生成一个请求URL，这是一个通用的方法，其中要加入oauth的一些标准参数
- (NSString *)generateURLWithUrl:(NSURL *)aUrl 
					  httpMethod:(NSString *)method 
					  parameters:(NSDictionary *)aParameters 
			  urlEncodeParamters:(NSDictionary *)encodeparamters {
	NSMutableString *parameterString = nil;
	
	if ([IWBSvrSettingsManager isDefaultWBServer]) {
		CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
		NSString *accessToken = actSite.userAccessToken;
		NSString *accessTokenSecret = actSite.userAccessSecrect;
		if (accessToken == nil || accessTokenSecret == nil || [accessToken isKindOfClass:[NSNull class]] || [accessTokenSecret isKindOfClass:[NSNull class]]) {
			/*
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
															message:@""
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			 */
			NSLog(@"accessToken or accessTokenSecret is nil");
			return nil;
		}
		NSString *nonce = [self generateNonce];
		NSString *timeStamp = [self generateTimeStamp];
		
		NSMutableDictionary *allParameters = nil;
		if (aParameters) {
			allParameters = [[aParameters mutableCopy] autorelease];
		} else {
			allParameters = [NSMutableDictionary dictionary];
		}

		// 添加oauth的标准参数
		[allParameters setObject:nonce forKey:OAuthNonceKey]; // 单次值 1
		[allParameters setObject:timeStamp forKey:OAuthTimestampKey]; // 时间戳 2
		[allParameters setObject:HMACSHA1SignatureType forKey:OAuthSignatureMethodKey]; // 签名方法 3
		[allParameters setObject:OAuthConsumerKey forKey:OAuthConsumerKeyKey]; // App Key 4
		[allParameters setObject:accessToken forKey:OAuthTokenKey]; // Access Token 5

		IweiboOauth *oauth = [[IweiboOauth alloc] init];
		NSString *signature = [oauth generateSignatureWithUrl:aUrl
												customeSecret:OAuthConsumerSecret
												  tokenSecret:accessTokenSecret
												   httpMethod:method
												   parameters:allParameters];
			
		NSString *str = [NSString stringWithFormat:@"%@", aUrl];
		[allParameters setObject:[str URLEncodedString] forKey:@"request_api"];
		
		// 有的接口，要对其中的某些参数进行url编码，比如在搜索用户的时候，如果关键字为中文，则需要对关键字进行url编码
		if (nil != encodeparamters) {
			for(NSString *key in encodeparamters) {
				NSString *value = [[encodeparamters objectForKey:key] URLEncodedString];
				[allParameters setObject:value forKey:key];
			}
		}
		
		parameterString = [NSMutableString stringWithFormat:@"%@", [self normalizedRequestParameters:allParameters]];
		[parameterString appendFormat:@"&oauth_signature=%@", [signature URLEncodedString]];
		[oauth release];
	}
	else {
		NSMutableDictionary *allParameters = nil;
		if (aParameters) {
			allParameters = [[aParameters mutableCopy] autorelease];
		} else {
			allParameters = [NSMutableDictionary dictionary];
		}
		NSString *str = [NSString stringWithFormat:@"%@", aUrl];
		[allParameters setObject:[str URLEncodedString] forKey:@"request_api"];
		[allParameters setObject:@"1" forKey:@"vmode"]; 
		// 有的接口，要对其中的某些参数进行url编码，比如在搜索用户的时候，如果关键字为中文，则需要对关键字进行url编码
		if (nil != encodeparamters) {
			for(NSString *key in encodeparamters) {
				NSString *value = [[encodeparamters objectForKey:key] URLEncodedString];
				[allParameters setObject:value forKey:key];
			}
		}
		parameterString = [NSMutableString stringWithFormat:@"%@", [self normalizedRequestParameters:allParameters]];
	}

	
	NSString *normalizedURL = [[[NSString alloc] initWithFormat:@"%@?%@", aUrl, parameterString] autorelease];
	//CLog(@"normalizedURL=%@", normalizedURL);
	return normalizedURL;

}

// 生成登录使用的请求URL
+ (NSString*)getIWeiboLoginURLWithName:(NSString *)name password:(NSString *)pwd {
	NSString *tempName = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *tempPwd = [pwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if (0 == [tempName length] || 0 == [tempPwd length]) {
		return nil;
	}
	// 对密码进行MD5加密一次
	NSString *password = [NSString stringWithString:[pwd MD5]];
	
	//NSString *url = [NSString stringWithFormat:@"%@?user=%@&pwd=%@", URL_IWEIBO_LOGIN, tempName, password];
	
//	NSString *encodedUrl = [URL_IWEIBO_LOGIN URLEncodedString];
    NSString *encodedUrl = [[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"private/login"] URLEncodedString];

	
//	NSString *url = [NSString stringWithFormat:@"%@?user=%@&pwd=%@&request_api=%@", URL_IWEIBO_LOGIN, tempName, password, encodedUrl];
    NSUInteger nMode = [IWBSvrSettingsManager isDefaultWBServer] ? 0 : 1;
    NSString *url = [NSString stringWithFormat:@"%@?vmode=%d&user=%@&pwd=%@&request_api=%@", [NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"private/login"], nMode, tempName, password, encodedUrl];
    
	return url;
}


// 获取主页timeline的url
- (NSString *)getTimeLineURLWithParameters:(NSDictionary *)paramters {

	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_HOME_TIMELINE] 
//						httpMethod:@"GET" 
//						parameters:paramters 
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"statuses/home_timeline"]] 
						httpMethod:@"GET" 
						parameters:paramters 
				urlEncodeParamters:nil];

	
	return url;

}


// 获取发送一条消息的url
- (NSString *)getPublishTextWeiboURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_MESSAGE_NORMAL] 
//						httpMethod:@"POST" 
//						parameters:aParamters 
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"t/add"]] 
						httpMethod:@"POST" 
						parameters:aParamters 
				urlEncodeParamters:nil];

	
	return url;
}


// 获取发送一条带图片的消息的url
- (NSString *)getPublishPictureWeiboURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_MESSAGE_PICTURE] 
//						httpMethod:@"POST" 
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"t/add_pic"]] 
						httpMethod:@"POST" 
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}


// 获取我的广播的url
- (NSString *)getBroadcastFromIWeiboURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_BROADCAST_TIMELINE] 
//						httpMethod:@"GET" 
//						parameters:aParamters 
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"statuses/broadcast_timeline"]] 
						httpMethod:@"GET" 
						parameters:aParamters 
				urlEncodeParamters:nil];

	
	return url;
}


// 获取我的听众列表的URL
- (NSString *)getFanslistOfFriendsURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_FRIENDS_FANSLIST]
//						httpMethod:@"GET" 
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"friends/fanslist"]]
						httpMethod:@"GET" 
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}


// 获取我的收听列表的URL
- (NSString *)getIdolListURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_IDOLLIST]
//						httpMethod:@"GET"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"friends/idollist"]]
						httpMethod:@"GET"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}


// 获取其他人资料的URL
- (NSString *)getOtherUserInfoURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_OTHER_INFO]
//						httpMethod:@"GET"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"user/other_info"]]
						httpMethod:@"GET"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}


// 获取已订阅的话题列表的URL
- (NSString *)getFavList_htURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_FAV_LIST_HT]
//						httpMethod:@"GET"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"fav/list_ht"]]
						httpMethod:@"GET"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}

// 获取搜索用户的URL
- (NSString *)getSearchUserURLWithParamgers:(NSDictionary *)aParamters {
	NSString *url = nil;
	NSString *key = @"keyword";
	NSString *value = [aParamters objectForKey:key];
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_SEARCH_USER]
//						httpMethod:@"GET"
//						parameters:aParamters
//				urlEncodeParamters:[NSDictionary dictionaryWithObject:value forKey:key]];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"search/user"]]
						httpMethod:@"GET"
						parameters:aParamters
				urlEncodeParamters:[NSDictionary dictionaryWithObject:value forKey:key]];

	
	return url;
}


// 生成用户的详细信息的请求URL
- (NSString *)getUserInfoURL {
	NSString *url = nil;
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
	[params setValue:@"json" forKey:@"format"];
	[params setValue:URL_USER_INFO forKey:@"request_api"];
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_USER_INFO]
//						httpMethod:@"GET"
//						parameters:params 
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"user/info"]]
						httpMethod:@"GET"
						parameters:params 
				urlEncodeParamters:nil];

	
	return url;
}

// 生成转播一条微博的URL
- (NSString *)getReAddWeiboURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_RE_ADD] 
//						httpMethod:@"POST" 
//						parameters:aParamters 
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"t/re_add"]] 
						httpMethod:@"POST" 
						parameters:aParamters 
				urlEncodeParamters:nil];

	
	return url;
}

// 生成提及我的的URL
- (NSString *)getMentions_timelineURLWithParamters:(NSDictionary *)aParaters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_MENTIONS_TIMELINE]
//						httpMethod:@"GET"
//						parameters:aParaters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"statuses/mentions_timeline"]]
						httpMethod:@"GET"
						parameters:aParaters
				urlEncodeParamters:nil];

	
	return url;
}


// 生成点评一条微博的URL
- (NSString *)getWeiboCommentURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_COMMENT]
//						httpMethod:@"POST"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"t/comment"]]
						httpMethod:@"POST"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}

// 获取一条微博的转发或点评列表URL
- (NSString *)getWeiboRelistURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_RE_LIST]
//						httpMethod:@"GET"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"t/re_list"]]
						httpMethod:@"GET"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}


// 获取回复一条微博即对话的URL
- (NSString *)getReplyURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_REPLY]
//						httpMethod:@"POST"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"t/reply"]]
						httpMethod:@"POST"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}

// 获取其他用户时间线
- (NSString *)getUserTimelineURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_USER_TIMELINE] 
//						httpMethod:@"GET"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString  stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"statuses/user_timeline"]] 
						httpMethod:@"GET"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}

// 获取收听某个用户的URL
- (NSString *)getFriendsAddURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_FRIENDS_ADD]
//						httpMethod:@"POST"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"friends/add"]]
						httpMethod:@"POST"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}

// 获取取消收听某个用户的URL
- (NSString *)getFriendsDelURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_FRIENDS_DEL]
//						httpMethod:@"POST"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"friends/del"]]
						httpMethod:@"POST"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}

// 其他账户的听众列表
- (NSString *)getUserFanListURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_USER_FANLIST]
//						httpMethod:@"GET"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"friends/user_fanslist"]]
						httpMethod:@"GET"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}

//其他账户的收听列表
- (NSString *)getUserIdolListURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_USER_IDOLLIST]
//						httpMethod:@"GET"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"friends/user_idollist"]]
						httpMethod:@"GET"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}

// 搜索微博
- (NSString *)getSearchWeiboURLWithParamters:(NSDictionary *)aParamters {

	NSString *url = nil;
	NSString *key = @"keyword";
	NSString *value = [aParamters objectForKey:key];

//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_SEARCH_WEIBO]
//						httpMethod:@"GET"
//						parameters:aParamters
//				urlEncodeParamters:[NSDictionary dictionaryWithObject:value forKey:key]];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"search/t"]]
						httpMethod:@"GET"
						parameters:aParamters
				urlEncodeParamters:[NSDictionary dictionaryWithObject:value forKey:key]];

	
	return url;
}

// 通过标签搜索用户
- (NSString *)getSearchUserByTagWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_SEARCH_USERBYTAG]
//						httpMethod:@"GET"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"search/userbytag"]]
						httpMethod:@"GET"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}


// Beta3接口
//热门话题
- (NSString *)getHotTopicURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_HOT_TOPIC]
//						httpMethod:@"GET"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"pexplore/hot_topic"]]
						httpMethod:@"GET"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}

//热门用户／推荐用户
- (NSString *)getRecommendUserURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_RECOMMEND_USER]
//						httpMethod:@"GET"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"pexplore/recommend_user"]]
						httpMethod:@"GET"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}


//最新广播／最新本地微博
- (NSString *)getLatestTimelineURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_LATEST_TIMELINE]
//						httpMethod:@"GET"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"pexplore/latest_timeline"]]
						httpMethod:@"GET"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}

- (NSString *)getHTTimelineURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
	NSString *key = @"httext";
	NSString *value = [aParamters objectForKey:key];
	
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_HT_TIMELINE]
//						httpMethod:@"GET"
//						parameters:aParamters
//				urlEncodeParamters:[NSDictionary dictionaryWithObject:value forKey:key]];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"statuses/ht_timeline"]]
						httpMethod:@"GET"
						parameters:aParamters
				urlEncodeParamters:[NSDictionary dictionaryWithObject:value forKey:key]];

	
	return url;
}

- (NSString *)getSearchTopicURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
	
	NSString *key = @"keyword";
	NSString *value = [aParamters objectForKey:key];
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_SEARCH_TOPIC]
//						httpMethod:@"GET"
//						parameters:aParamters
//				urlEncodeParamters:[NSDictionary dictionaryWithObject:value forKey:key]];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist] , @"search/ht"]]
						httpMethod:@"GET"
						parameters:aParamters
				urlEncodeParamters:[NSDictionary dictionaryWithObject:value forKey:key]];

	
	return url;
}

- (NSString *)getUpdateIntroductionURLWithparamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_UPDATE_INTRODUCTION]
//						httpMethod:@"POST"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"user/updatesummary"]]
						httpMethod:@"POST"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}


// 订阅话题
- (NSString *)getAddHTURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_ADD_HT]
//						httpMethod:@"POST"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"fav/addht"]]
						httpMethod:@"POST"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}

// 取消订阅话题
- (NSString *)getDelHTURLWithParamters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_DEL_HT]
//						httpMethod:@"POST"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"fav/delht"]]
						httpMethod:@"POST"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}

// reverse Geocoding
- (NSString *)getReverseGeocodingURLWithParameters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_REVERSE_GEOCODING]
//						httpMethod:@"POST"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"lbs/rgeoc"]]
						httpMethod:@"POST"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}

// get Geocoding
- (NSString *)getGeocodingURLWithParameters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_GET_GEOCODING]
//						httpMethod:@"POST"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"lbs/geoc"]]
						httpMethod:@"POST"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}
// get POI
- (NSString *)getPOIURLWithParameters:(NSDictionary *)aParamters {
	NSString *url = nil;
//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_GET_POI]
//						httpMethod:@"POST"
//						parameters:aParamters
//				urlEncodeParamters:nil];
    url = [self generateURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"lbs/get_poi"]]
						httpMethod:@"POST"
						parameters:aParamters
				urlEncodeParamters:nil];

	
	return url;
}

- (NSString *)generateNoVerifyURLWithUrl:(NSURL *)aUrl 
					  httpMethod:(NSString *)method 
					  parameters:(NSDictionary *)aParameters 
			  urlEncodeParamters:(NSDictionary *)encodeparamters {
	NSMutableString *parString = nil;
	//if ([IWBSvrSettingsManager isDefaultWBServer]) {
	if (NO) {
		CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
		NSString *accessToken = actSite.userAccessToken;
		NSString *accessTokenSecret = actSite.userAccessSecrect;
		if (accessToken == nil || accessTokenSecret == nil || [accessToken isKindOfClass:[NSNull class]] || [accessTokenSecret isKindOfClass:[NSNull class]]) {
			/*
			 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
			 message:@""
			 delegate:nil
			 cancelButtonTitle:@"OK"
			 otherButtonTitles:nil];
			 [alert show];
			 [alert release];
			 */
			NSLog(@"accessToken or accessTokenSecret is nil");
			return nil;
		}
		NSString *nonce = [self generateNonce];
		NSString *timeStamp = [self generateTimeStamp];
		
		NSMutableDictionary *allParameters = nil;
		if (aParameters) {
			allParameters = [[aParameters mutableCopy] autorelease];
		} else {
			allParameters = [NSMutableDictionary dictionary];
		}
		
		// 添加oauth的标准参数
		[allParameters setObject:nonce forKey:OAuthNonceKey]; // 单次值 1
		[allParameters setObject:timeStamp forKey:OAuthTimestampKey]; // 时间戳 2
		[allParameters setObject:HMACSHA1SignatureType forKey:OAuthSignatureMethodKey]; // 签名方法 3
		[allParameters setObject:OAuthConsumerKey forKey:OAuthConsumerKeyKey]; // App Key 4
		[allParameters setObject:accessToken forKey:OAuthTokenKey]; // Access Token 5
		
		IweiboOauth *oauth = [[IweiboOauth alloc] init];
		NSString *signature = [oauth generateSignatureWithUrl:aUrl
												customeSecret:OAuthConsumerSecret
												  tokenSecret:accessTokenSecret
												   httpMethod:method
												   parameters:allParameters];
		
		NSString *str = [NSString stringWithFormat:@"%@", aUrl];
		[allParameters setObject:[str URLEncodedString] forKey:@"request_api"];
		
		// 有的接口，要对其中的某些参数进行url编码，比如在搜索用户的时候，如果关键字为中文，则需要对关键字进行url编码
		if (nil != encodeparamters) {
			for(NSString *key in encodeparamters) {
				NSString *value = [[encodeparamters objectForKey:key] URLEncodedString];
				[allParameters setObject:value forKey:key];
			}
		}
		
		parString = [NSMutableString stringWithFormat:@"%@", [self normalizedRequestParameters:allParameters]];
		[parString appendFormat:@"&oauth_signature=%@", [signature URLEncodedString]];
		[oauth release];
	}
	else {
		NSMutableDictionary *allParameters = nil;
		if (aParameters) {
			allParameters = [[aParameters mutableCopy] autorelease];
		} else {
			allParameters = [NSMutableDictionary dictionary];
		}
		NSString *str = [NSString stringWithFormat:@"%@", aUrl];
		[allParameters setObject:[str URLEncodedString] forKey:@"request_api"];
		// 有的接口，要对其中的某些参数进行url编码，比如在搜索用户的时候，如果关键字为中文，则需要对关键字进行url编码
		if (nil != encodeparamters) {
			for(NSString *key in encodeparamters) {
				NSString *value = [[encodeparamters objectForKey:key] URLEncodedString];
				[allParameters setObject:value forKey:key];
			}
		}
		parString = [NSMutableString stringWithFormat:@"%@", [self normalizedRequestParameters:allParameters]];
	}
	
	NSString *normalizedURL = [[[NSString alloc] initWithFormat:@"%@?%@", aUrl, parString] autorelease];
	//CLog(@"normalizedURL=%@", normalizedURL);
	return normalizedURL;
}
//
-(NSString *)getCustomizedThemeWithUrl:(NSString *)strUrl andParameters:(NSDictionary *)aParamters {
	NSString *url = nil;
	//	url = [self generateURLWithUrl:[NSURL URLWithString:URL_GET_POI]
	//						httpMethod:@"POST"
	//						parameters:aParamters
	//				urlEncodeParamters:nil];
    url = [self generateNoVerifyURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", strUrl, @"customized/theme"]]
						httpMethod:@"GET"
						parameters:aParamters
				urlEncodeParamters:nil];
	return url;
}

// get customized siteInfo
-(NSString *)getCustomizedSiteInfoWithUrl:(NSString *)strUrl andParameters:(NSDictionary *)aParamters {
	NSString *url = nil;
    url = [self generateNoVerifyURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", strUrl, @"customized/siteinfo"]]
						httpMethod:@"GET"
						parameters:aParamters
				urlEncodeParamters:nil];
	return url;
}

// register for user
-(NSString *)registerUserWithUrl:(NSString *)strUrl andParameters:(NSDictionary *)aParamters {
	NSString *url = nil;
	NSString *key = @"user";
	NSString *value = [aParamters objectForKey:key];
    url = [self generateNoVerifyURLWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", strUrl, @"private/reg"]]
								httpMethod:@"POST"
								parameters:aParamters
						urlEncodeParamters:[NSDictionary dictionaryWithObject:value forKey:key]];
	return url;
}
@end
