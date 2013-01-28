//
//  PushAndRequest.m
//  iweibo
//
//  Created by LiQiang on 12-2-10.
//  Copyright 2012年 Beyondsoft. All rights reserved.
//

#import "PushAndRequest.h"
#import "Canstants_Data.h"
#import "IWeiboAsyncApi.h"
#import "PersonalMsgViewController.h"
#import "iweiboAppDelegate.h"

@implementation PushAndRequest
@synthesize personMsg;
static PushAndRequest *push = nil;
+ (PushAndRequest *)shareInstance
{
    if (push == nil) {
        push = [[self alloc] init];
    }
    return push;
}

- (void)pushControllerType:(int)controllerType withName:(NSString *)userName{
	if (personMsg==nil) {
        personMsg = [[IWeiboAsyncApi alloc] init];
    }
	personMsgController = [[PersonalMsgViewController alloc] init];
    personMsgController.tempPersonMsgDic = NULL;
//    personMsgController.requestApi = personMsg;
    personMsgController.accountName = userName;
    [personMsgController tableViewDataSource];
    [personMsgController addTitleAndRightBarBtn];
    iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *rootContrl = nil;
    switch (controllerType) {
        case 1:
            rootContrl = delegate.homeNav;
            personMsgController.pushControllerType = 1;
            break;
        case 2:
            rootContrl = delegate.msgNav;
            personMsgController.pushControllerType = 2;
            break;
	case 3:
		rootContrl = delegate.searchNav;
		personMsgController.pushControllerType = 3;
		break;
        case 4:
            rootContrl = delegate.moreNav;
            personMsgController.pushControllerType = 4;
        default:
            break;
    }
    [rootContrl pushViewController:personMsgController animated:YES];
    [rootContrl.tabBarController performSelector:@selector(hideNewTabBar)];
    [personMsgController showMBProgress];
    
//    NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                URL_OTHER_INFO,@"request_api",
//                                @"json",@"format", 
//                                userName,@"name",
//                                nil];
//    [personMsg getOtherUserInfoWithParamters:requestDic delegate:self onSuccess:@selector(getOtherUserMsgSucc:) onFailure:@selector(getOtherUserMsgFail:)];
}
- (void)getOtherUserMsgSucc:(NSDictionary *)personInfo
{
    CLog(@"%s", __FUNCTION__);
//	NSLog(@"获取的信息%@",personInfo);
	// 对返回的数据做验证处理，即如果返回的数据为空，则做响应的处理
	if (nil == personInfo || ![personInfo isKindOfClass:[NSDictionary class]]) {
		return;
	}
	id personDataDic = [DataCheck checkDictionary:personInfo forKey:@"data" withType:[NSDictionary class]];
	if (personDataDic == [NSNull null]) {
		[personMsgController hiddenMBProgress];
		return;
	}
							   						   
	//NSDictionary *personDataDic = [personInfo objectForKey:@"data"];
	personMsgController.tempPersonMsgDic = personDataDic;
	[personMsgController tableViewDataSource];
	[personMsgController addTitleAndRightBarBtn];
	[personMsgController changeHeaderViewData];
	[personMsgController.listMsgView reloadData];
	[personMsgController hiddenMBProgress];
	[personMsgController release];
}
- (void)getOtherUserMsgFail:(NSError *)error
{
    [personMsgController hiddenMBProgress];
    [personMsgController showErrorView:@"加载失败"];
}

- (void)dealloc
{
    [personMsg cancelSpecifiedRequest];
    [personMsg release];
   // [self release];
    [super dealloc];
}
@end
