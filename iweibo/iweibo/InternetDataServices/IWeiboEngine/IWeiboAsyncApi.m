//
//  IWeiboAsyncApi.m
//  iweibo
//
//  Created by zhaoguohui on 11-12-27.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "IWeiboAsyncApi.h"
#import "IWeiboASyncHttpRequest.h"
#import "JSON.h"
#import "NSString+QEncoding.h"
#import "DataCheck.h"
#import "iweiboAppDelegate.h"

@implementation DelegateObject

@synthesize delegate;

@end

@implementation IWeiboAsyncApi

- (id)init {
	self = [super init];
	if (nil != self) {
		httpRequests = [[NSMutableArray alloc] initWithCapacity:2];
	}
	
	return self;
}

- (ASIHTTPRequest *)getHttpRequestWithURL:(NSURL *)requestUrl
								  headers:(NSMutableDictionary *)header
									 body:(NSMutableData *)body
								   method:(NSString *)method
								 delegate:(id)delegate
								onSuccess:(SEL)successCallback
								onFailure:(SEL)failureCallback {
	
	temp_delegate = delegate;
	onSuccessCallback = successCallback;
	onFailureCallback = failureCallback;
	
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:3];
	for (int i = 0; i < [httpRequests count]; i++) {
		NSDictionary *dicItem = [httpRequests objectAtIndex:i];
		ASIHTTPRequest *request = (ASIHTTPRequest *)[dicItem objectForKey:@"Request"];
		if (YES == request.complete) {
			[tmpArray addObject:dicItem]; 
		}
	}
	[httpRequests removeObjectsInArray:tmpArray];
	
	ASIHTTPRequest *newRequest = [[[ASIHTTPRequest alloc] initWithURL:requestUrl] autorelease];
	[newRequest setRequestMethod:method];
	[newRequest setDelegate:self];
	[newRequest setDidFailSelector:@selector(failWithError:)];
	[newRequest setTimeOutSeconds:20];
	if (nil != header) {
		[newRequest setRequestHeaders:header];
	}
	if (nil != body) {
		[newRequest setPostBody:body];
	}
	NSMutableDictionary *dicItem = [[NSMutableDictionary alloc] initWithCapacity:3];
	[dicItem setObject:newRequest forKey:@"Request"];
	if (delegate != nil) {
		DelegateObject *del = [[DelegateObject alloc] init];
		del.delegate = delegate;
		[dicItem setObject:del forKey:@"Delegate"];
		[del release];
	}
	if (successCallback != nil) {
		[dicItem setObject:NSStringFromSelector(successCallback) forKey:@"SuccessCallBack"];
	}
	if (failureCallback != nil) {
		[dicItem setObject:NSStringFromSelector(failureCallback)  forKey:@"FailureCallback"];
	}
	[httpRequests addObject:dicItem];
	[dicItem release];
	return newRequest;
}

// 登录接口
- (void)iweiboLoginWithUserName:(NSString *)name 
					   password:(NSString *)pwd 
					   delegate:(id)delegate 
					  onSuccess:(SEL)successCallback 
					  onFailure:(SEL)failureCallback {
	
	ASIHTTPRequest *httpRequest = nil;
	NSString *result = [IWeiboASyncHttpRequest getIWeiboLoginURLWithName:name password:pwd];
	if (nil == result) {
		return;
	}else {

		NSArray *array = [result componentsSeparatedByString:@"?"];
		NSString *url = [array objectAtIndex:0];
		NSString *body = [array objectAtIndex:1];
		NSMutableData *postBody = [NSMutableData dataWithData:[body dataUsingEncoding:NSUTF8StringEncoding]];
		
		NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithCapacity:2];
		[headers setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
		
		httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
														  headers:headers
															 body:postBody
														   method:@"POST"
														 delegate:delegate
														onSuccess:successCallback
														onFailure:failureCallback];
	}
	[httpRequest startAsynchronous];
	
}

- (void)iweiboCheckHostWithUrl:(NSString *)strUrl 
					  delegate:(id)delegate 
					 onSuccess:(SEL)successCallback 
					 onFailure:(SEL)failureCallback {
	ASIHTTPRequest *httpRequest = nil;
	NSString *encodedUrl = [NSString stringWithFormat:@"%@%@", strUrl, @"private/check"] ;
	httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:encodedUrl]
									  headers:nil
										 body:nil
									   method:@"POST"
									 delegate:delegate
									onSuccess:successCallback
									onFailure:failureCallback];
	[httpRequest startAsynchronous];
}


// 主页时间线
- (void)getHomeTimelineMsgWithParamters:(NSDictionary *)paramters
								 delegate:(id)delegate 
								onSuccess:(SEL)successCallback 
								onFailure:(SEL)failureCallback {

	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getTimeLineURLWithParameters:paramters];
	[request release];
	if (nil == url) {
		return;
	}
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObject:@"image/gif" forKey:@"Accept"];
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:dictionary
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}

// 发布一条文本微博
- (void)publishTextWeiboWithParamters:(NSDictionary *)paramters 
							 delegate:(id)delegate 
							onSuccess:(SEL)successCallback
							onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *result = [request getPublishTextWeiboURLWithParamters:paramters];
	
	[request release];
	if (nil == result) {
		return;
	}
	NSArray *array = [result componentsSeparatedByString:@"?"];
	NSString *url = [array objectAtIndex:0];
	NSString *body = [array objectAtIndex:1];
	NSMutableData *postBody = [NSMutableData dataWithData:[body dataUsingEncoding:NSUTF8StringEncoding]];

	NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithCapacity:2];
	[headers setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:headers
														 body:postBody
													   method:@"POST"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}


// 发布一条带图片的微博
- (void)publishPictureWeiboWithFiles:(NSDictionary *)files 
						   paramters:(NSDictionary *)paramters 
							delegate:(id)delegate 
						   onSuccess:(SEL)successCallback 
						   onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request1 = [[IWeiboASyncHttpRequest alloc] init];
	NSString *result = [request1 getPublishPictureWeiboURLWithParamters:paramters];
	[request1 release];
	
	if (nil == result) {
		return;
	}
	NSArray *array = [result componentsSeparatedByString:@"?"];
	NSString *url = [array objectAtIndex:0];
	NSString *body = [array objectAtIndex:1];
	
	NSMutableDictionary *header = [NSMutableDictionary dictionaryWithCapacity:5];
	
	//generate boundary string
	CFUUIDRef       uuid;
    CFStringRef     uuidStr;
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
    CFRelease(uuidStr);
    CFRelease(uuid);
	
	NSData *boundaryBytes = [[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
	[header setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forKey:@"Content-Type"];
	
	NSMutableData *bodyData = [NSMutableData data];
	NSString *formDataTemplate = @"\r\n--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@";
	
	NSDictionary *listParams = [NSURL parseURLQueryString:body];
	for (NSString *key in listParams) {
		
		NSString *value = [listParams valueForKey:key];
		NSString *formItem = [NSString stringWithFormat:formDataTemplate, boundary, key, value];
		[bodyData appendData:[formItem dataUsingEncoding:NSUTF8StringEncoding]];
	}
	[bodyData appendData:boundaryBytes];
	
	NSString *headerTemplate = @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: \"application/octet-stream\"\r\n\r\n";
	for (NSString *key in files) {
		
		NSData *fileData =  [NSData dataWithData:[files objectForKey:key]];
		NSString *header = [NSString stringWithFormat:headerTemplate, key, @"test.jpg"];
		[bodyData appendData:[header dataUsingEncoding:NSUTF8StringEncoding]];
		[bodyData appendData:fileData];
		[bodyData appendData:boundaryBytes];
	}
	
	[header setValue:[NSString stringWithFormat:@"%d", [bodyData length]] forKey:@"Content-Length"];
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:header
														 body:bodyData
													   method:@"POST"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}


// 获取我的广播信息
- (void)getBroadcastFromIweiboWithParamters:(NSDictionary *)paramters 
								   delegate:(id)delegate 
								  onSuccess:(SEL)successCallback 
								  onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getBroadcastFromIWeiboURLWithParamters:paramters];
	[request release];
	if (nil == url) {
		return;
	}
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}


// 获取我的听众列表
- (void)getFanslistOfFriendsWithparamters:(NSDictionary *)paramters 
								 delegate:(id)delegate 
								onSuccess:(SEL)successCallback 
								onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getFanslistOfFriendsURLWithParamters:paramters];
	[request release];
	if (nil == url) {
		return;
	}
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}


// 获取已订阅的话题列表
- (void)getFavList_htWithParamters:(NSDictionary *)paramters 
						  delegate:(id)delegate 
						 onSuccess:(SEL)successCallback 
						 onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getFavList_htURLWithParamters:paramters];
	[request release];
	if (nil == url) {
		return;
	}
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}


// 搜索用户
- (void)searchUserWithParamters:(NSDictionary *)paramters 
					   delegate:(id)delegate 
					  onSuccess:(SEL)successCallback 
					  onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getSearchUserURLWithParamgers:paramters];
	[request release];
	if (nil == url) {
		return;
	}
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}


// 获取当前用户自己的详细信息
- (void)getUserInfoWithDelegate:(id)delegate onSuccess:(SEL)successCallback onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getUserInfoURL];
	[request release];
	if (nil == url) {
		return;
	}
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}


// 转播一条微博
- (void)reAddWeiboWithParamters:(NSDictionary *)paramters 
					   delegate:(id)delegate 
					  onSuccess:(SEL)successCallback 
					  onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *result = [request getReAddWeiboURLWithParamters:paramters];
	[request release];
	if (nil == result) {
		return;
	}
	NSArray *array = [result componentsSeparatedByString:@"?"];
	NSString *url = [array objectAtIndex:0];
	NSString *body = [array objectAtIndex:1];
	
	NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithCapacity:2];
	[headers setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
	
	NSMutableData *bodyData = [NSMutableData dataWithData:[body dataUsingEncoding:NSUTF8StringEncoding]];
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:headers
														 body:bodyData
													   method:@"POST"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}


// 获取我的收听列表
- (void)getMyIdolListWithParamters:(NSDictionary *)paramters 
						  delegate:(id)delegate
						 onSuccess:(SEL)successCallback 
						 onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getIdolListURLWithParamters:paramters];
	[request release];
	if (nil == url) {
		return;
	}
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}


// 获取其他人的资料
- (void)getOtherUserInfoWithParamters:(NSDictionary *)paramters
							 delegate:(id)delegate
							onSuccess:(SEL)successCallback
							onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getOtherUserInfoURLWithParamters:paramters];
	[request release];
	if (nil == url) {
		return;
	}
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}

// 获取用户提及时间线
- (void)getMentionsTimeLineWithParamters:(NSDictionary *)paramters 
								delegate:(id)delegate
							   onSuccess:(SEL)successCallback 
							   onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getMentions_timelineURLWithParamters:paramters];
	[request release];
	if (nil == url) {
		return;
	}
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}

// 点评一条微博
- (void)commentWeiboWithParamters:(NSDictionary *)paramters 
						 delegate:(id)delegate
						onSuccess:(SEL)successCallback
						onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *result = [request getWeiboCommentURLWithParamters:paramters];
	[request release];
	if (nil == result) {
		return;
	}
	NSArray *array = [result componentsSeparatedByString:@"?"];
	NSString *url = [array objectAtIndex:0];
	NSString *body = [array objectAtIndex:1];
	
	NSMutableData *bodyData = [NSMutableData dataWithData:[body dataUsingEncoding:NSUTF8StringEncoding]];
	NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithCapacity:2];
	[headers setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:headers
														 body:bodyData
													   method:@"POST"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}


// 获取单条微博的转发或点评列表
- (void)getWeiboRelistWithParamteers:(NSDictionary *)paramters
							delegate:(id)delegate
						   onSuccess:(SEL)successCallback
						   onFailure:(SEL)failureCallback {
		
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getWeiboRelistURLWithParamters:paramters];
	[request release];
	if (nil == url) {
		return;
	}
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}

// 回复一条微博，即对话
- (void)replyWithParamters:(NSDictionary *)paramters
				  delegate:(id)delegate
				 onSuccess:(SEL)successCallback
				 onFailure:(SEL)failureCallback {
		
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *result = [request getReplyURLWithParamters:paramters];
	[request release];
	if (nil == result) {
		return;
	}
	NSArray *array = [result componentsSeparatedByString:@"?"];
	NSString *url = [array objectAtIndex:0];
	NSString *body = [array objectAtIndex:1];
	
	NSMutableData *bodyData = [NSMutableData dataWithData:[body dataUsingEncoding:NSUTF8StringEncoding]];
	NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithCapacity:2];
	[headers setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:headers
														 body:bodyData
													   method:@"POST"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}

// 收听某个用户
- (void)friendsAddWithParamters:(NSDictionary *)paramters
					   delegate:(id)delegate
					  onSuccess:(SEL)successCallback
					  onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *result = [request getFriendsAddURLWithParamters:paramters];
	[request release];
	if (nil == result) {
		return;
	}
	NSArray *array = [result componentsSeparatedByString:@"?"];
	NSString *url = [array objectAtIndex:0];
	NSString *body = [array objectAtIndex:1];
	
	NSMutableData *bodyData = [NSMutableData dataWithData:[body dataUsingEncoding:NSUTF8StringEncoding]];
	NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithCapacity:2];
	[headers setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:headers
														 body:bodyData
													   method:@"POST"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}


- (void)friendsDelWithParamters:(NSDictionary *)paramters
					   delegate:(id)delegate
					  onSuccess:(SEL)successCallback
					  onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *result = [request getFriendsDelURLWithParamters:paramters];
	[request release];
	if (nil == result) {
		return;
	}
	NSArray *array = [result componentsSeparatedByString:@"?"];
	NSString *url = [array objectAtIndex:0];
	NSString *body = [array objectAtIndex:1];

	NSMutableData *bodyData = [NSMutableData dataWithData:[body dataUsingEncoding:NSUTF8StringEncoding]];
	NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithCapacity:2];
	[headers setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:headers
														 body:bodyData
													   method:@"POST"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}

// 获取其他人的时间线
- (void)getUserTimeLineWithParamters:(NSDictionary *)paramters
							delegate:(id)delegate
						   onSuccess:(SEL)successCallback
						   onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getUserTimelineURLWithParamters:paramters];
	[request release];
	if (nil == url) {
		return;
	}
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}


// 其他账户的听众列表
- (void)getUserFanListWithParamters:(NSDictionary *)paramters
						   delegate:(id)delegate
						  onSuccess:(SEL)successCallback
						  onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getUserFanListURLWithParamters:paramters];
	[request release];
	if (nil == url) {
		return;
	}
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}

// 其他账户的收听列表
- (void)getUserIdolListWithParamters:(NSDictionary *)paramters
							delegate:(id)delegate
						   onSuccess:(SEL)successCallback
						   onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getUserIdolListURLWithParamters:paramters];
	[request release];
	if (nil == url) {
		return;
	}
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}

// 搜索微博
- (void)searchWeiboWithParamters:(NSDictionary *)paramters
						delegate:(id)delegate
					   onSuccess:(SEL)successCallback
					   onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getSearchWeiboURLWithParamters:paramters];
	[request release];
	if (nil == url) {
		return;
	}
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}

// 通过标签搜索用户
- (void)searchUserByTagWithParamters:(NSDictionary *)paramters
							delegate:(id)delegate 
						   onSuccess:(SEL)successCallback 
						   onFailure:(SEL)failureCallback {
		
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getSearchUserByTagWithParamters:paramters];
	[request release];
	if (nil == url) {
		return;
	}
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	
	[httpRequest startAsynchronous];
}


// Beta3接口
/*
 function: 热门话题
 */
- (void)getHotTopicWithParamters:(NSDictionary *)aParamters
						delegate:(id)delegate
					   onSuccess:(SEL)successCallback
					   onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getHotTopicURLWithParamters:aParamters];
	[request release];
	if (nil == url) {
		return;
	}
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}

/*
 function: 热门用户／推荐用户
 */
- (void)getRecommendUserWithParamters:(NSDictionary *)aParamters
							 delegate:(id)delegate
							onSuccess:(SEL)successCallback
							onFailure:(SEL)failureCallback {
		
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getRecommendUserURLWithParamters:aParamters];
	[request release];
	if (nil == url) {
		return;
	}
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	
	[httpRequest startAsynchronous];
}

/*
 function：最新广播／最新本地微博
 */
- (void)getLatestTimelineWithParamters:(NSDictionary *)aParamters
							  delegate:(id)delegate
							 onSuccess:(SEL)successCallback
							 onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getLatestTimelineURLWithParamters:aParamters];
	[request release];
	if (nil == url) {
		return;
	}
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}

/*
 function: 话题时间线
 */
- (void)getHTTimelineWithParamters:(NSDictionary *)aParamters
						  delegate:(id)delegate
						 onSuccess:(SEL)successCallback
						 onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getHTTimelineURLWithParamters:aParamters];
	[request release];
	if (nil == url) {
		return;
	}
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}

- (void)searchTopicWithparamters:(NSDictionary *)aParamters
						delegate:(id)delegate
					   onSuccess:(SEL)successCallback
					   onFailure:(SEL)failureCallback {
	
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getSearchTopicURLWithParamters:aParamters];
	[request release];
	if (nil == url) {
		return;
	}
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}

// 取消当前请求
- (void)cancelCurrentRequest {
	//[httpRequest clearDelegatesAndCancel];
}

+ (void)clearSession {
	[ASIHTTPRequest clearSession];
}

- (void)cancelSpecifiedRequest {
	for (int i = 0; i < [httpRequests count]; i++) {
		NSDictionary *dicItem = [httpRequests objectAtIndex:i];
		ASIHTTPRequest *requestItem = (ASIHTTPRequest *)[dicItem objectForKey:@"Request"];
		if (!(requestItem.complete)) {
			[requestItem clearDelegatesAndCancel];
		}
	}
}

- (NSDictionary *)updatePersonalIntroductionWithParamters:(NSDictionary *)aParamters {
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *result = [request getUpdateIntroductionURLWithparamters:aParamters];
	[request release];
	if (nil == result) {
		return nil;
	}
	NSArray *array = [result componentsSeparatedByString:@"?"];
	NSString *url = [array objectAtIndex:0];
	NSString *body = [array objectAtIndex:1];
	
	NSMutableData *bodyData = [NSMutableData dataWithData:[body dataUsingEncoding:NSUTF8StringEncoding]];
	NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithCapacity:2];
	[headers setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:headers
														 body:bodyData
													   method:@"POST"
													 delegate:nil
													onSuccess:nil
													onFailure:nil];
	[httpRequest startSynchronous];
	NSDictionary *retValue = [[httpRequest responseString] JSONValue];
	
	return retValue;
}

// 订阅话题
- (NSDictionary *)addHUWithParamters:(NSDictionary *)aParamters {
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *result = [request getAddHTURLWithParamters:aParamters];
	[request release];
	if (nil == result) {
		return nil;
	}
	NSArray *array = [result componentsSeparatedByString:@"?"];
	NSString *url = [array objectAtIndex:0];
	NSString *body = [array objectAtIndex:1];
	
	NSMutableData *bodyData = [NSMutableData dataWithData:[body dataUsingEncoding:NSUTF8StringEncoding]];
	NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithCapacity:2];
	[headers setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:headers
														 body:bodyData
													   method:@"POST"
													 delegate:nil
													onSuccess:nil
													onFailure:nil];
	[httpRequest startSynchronous];
	NSDictionary *retValue = [[httpRequest responseString] JSONValue];
	
	return retValue;
}

// 取消订阅话题
- (NSDictionary *)delHTWithParamters:(NSDictionary *)aParamters {
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *result = [request getDelHTURLWithParamters:aParamters];
	[request release];
	if (nil == result) {
		return nil;
	}
	NSArray *array = [result componentsSeparatedByString:@"?"];
	NSString *url = [array objectAtIndex:0];
	NSString *body = [array objectAtIndex:1];
	
	NSMutableData *bodyData = [NSMutableData dataWithData:[body dataUsingEncoding:NSUTF8StringEncoding]];
	NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithCapacity:2];
	[headers setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:headers
														 body:bodyData
													   method:@"POST"
													 delegate:nil
													onSuccess:nil
													onFailure:nil];
	[httpRequest startSynchronous];
	NSDictionary *retValue = [[httpRequest responseString] JSONValue];
	
	return retValue;
	
}

- (void)reverseGeocodingWithParamters:(NSDictionary *)aParamters
							 delegate:(id)delegate
							onSuccess:(SEL)successCallback
							onFailure:(SEL)failureCallback {
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getReverseGeocodingURLWithParameters:aParamters];
	[request release];
	if (nil == url) {
		return;
	}	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}

/* 2012-04-01 By Yi Minwen
 LBS相关/通过地理位置获取经纬度
 */
- (void)getGeocodingWithParamters:(NSDictionary *)aParamters
						 delegate:(id)delegate
						onSuccess:(SEL)successCallback
						onFailure:(SEL)failureCallback {
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getGeocodingURLWithParameters:aParamters];
	[request release];
	if (nil == url) {
		return;
	}	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}

- (void)getPOIWithParamters:(NSDictionary *)aParamters
				   delegate:(id)delegate
				  onSuccess:(SEL)successCallback
				  onFailure:(SEL)failureCallback {
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getPOIURLWithParameters:aParamters];
	[request release];
	if (nil == url) {
		return;
	}	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}
// 主题拉取接口：customized/theme
-(void)getCustomizedThemeWithUrl:(NSString *)strUrl
					  Parameters:(NSDictionary *)aParamters
						delegate:(id)delegate
					   onSuccess:(SEL)successCallback
					   onFailure:(SEL)failureCallback {
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getCustomizedThemeWithUrl:strUrl andParameters:aParamters];
	[request release];
	if (nil == url) {
		return;
	}	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}

-(void)getCustomizedSiteInfoWithUrl:(NSString *)strUrl
						 Parameters:(NSDictionary *)aParamters
								  delegate:(id)delegate
								 onSuccess:(SEL)successCallback
								 onFailure:(SEL)failureCallback {
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request getCustomizedSiteInfoWithUrl:strUrl andParameters:aParamters];
	[request release];
	if (nil == url) {
		return;
	}	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"GET"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}


- (void)iweiboRegisterUserWithUrl:(NSString *)strUrl
					   Parameters:(NSDictionary *)aParamters
						 delegate:(id)delegate
						onSuccess:(SEL)successCallback 
						onFailure:(SEL)failureCallback {
	IWeiboASyncHttpRequest *request = [[IWeiboASyncHttpRequest alloc] init];
	NSString *url = [request registerUserWithUrl:strUrl andParameters:aParamters];
	[request release];
	if (nil == url) {
		return;
	}	
	ASIHTTPRequest *httpRequest = [self getHttpRequestWithURL:[NSURL URLWithString:url]
													  headers:nil
														 body:nil
													   method:@"POST"
													 delegate:delegate
													onSuccess:successCallback
													onFailure:failureCallback];
	[httpRequest startAsynchronous];
}
#pragma mark -
#pragma mark ASIHTTPRequestDelegate Methods
- (void)requestFinished:(id)request {
	if ([httpRequests count] > 1) {
		CLog(@"%s [httpRequests count]:%d", __FUNCTION__, [httpRequests count]);
	}
	for (int i = 0; i < [httpRequests count]; i++) {
		NSDictionary *dicItem = [httpRequests objectAtIndex:i];
		ASIHTTPRequest *requestItem = (ASIHTTPRequest *)[dicItem objectForKey:@"Request"];
		if (request == requestItem) {
			temp_delegate = ((DelegateObject *)[dicItem objectForKey:@"Delegate"]).delegate;
			onSuccessCallback = NSSelectorFromString([dicItem objectForKey:@"SuccessCallBack"]);
			onFailureCallback = NSSelectorFromString([dicItem objectForKey:@"FailureCallback"]);
			break;
		}
	}
	if ([temp_delegate respondsToSelector:onSuccessCallback]) {
		NSString *result = [request responseString];
		//NSString *msgDecode = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		id jsonValue = [result JSONValue];	
		// 判断登陆态
		if ([jsonValue isKindOfClass:[NSDictionary class]]) {
			NSDictionary *dic = (NSDictionary *)jsonValue;
			NSNumber *ret = [DataCheck checkDictionary:dic forKey:@"ret" withType:[NSNumber class]];
			if ([ret isKindOfClass:[NSNumber class]] && [ret intValue] == -309) {
				// 登陆态失效
				iweiboAppDelegate *delegate = (iweiboAppDelegate*)[UIApplication sharedApplication].delegate;
				[delegate performSelector:@selector(onLoginUserExpired)];	
				return;
			}	
		}
        else {
            CLog(@"%s httpRequests:%@", __FUNCTION__, httpRequests);
        }
		[temp_delegate performSelector:onSuccessCallback withObject:jsonValue];
	}
}

- (void)failWithError:(ASIHTTPRequest *)request {
	if ([httpRequests count] > 1) {
		CLog(@"%s [httpRequests count]:%d", __FUNCTION__, [httpRequests count]);
	}
	for (int i = 0; i < [httpRequests count]; i++) {
		NSDictionary *dicItem = [httpRequests objectAtIndex:i];
		ASIHTTPRequest *requestItem = (ASIHTTPRequest *)[dicItem objectForKey:@"Request"];
		if (request == requestItem) {
			temp_delegate = ((DelegateObject *)[dicItem objectForKey:@"Delegate"]).delegate;
			onSuccessCallback = NSSelectorFromString([dicItem objectForKey:@"SuccessCallBack"]);
			onFailureCallback = NSSelectorFromString([dicItem objectForKey:@"FailureCallback"]);
			break;
		}
	}
	if ([temp_delegate respondsToSelector:onFailureCallback]) {
		[temp_delegate performSelector:onFailureCallback withObject:request.error];
	}
}

- (void)dealloc {
	for (int i = 0; i < [httpRequests count]; i++) {
		NSDictionary *dicItem = [httpRequests objectAtIndex:i];
		ASIHTTPRequest *requestItem = (ASIHTTPRequest *)[dicItem objectForKey:@"Request"];
		if (!(requestItem.complete)) {
			[requestItem clearDelegatesAndCancel];
		}
	}
	
	[httpRequests release];
	
	[super dealloc];
}
@end
