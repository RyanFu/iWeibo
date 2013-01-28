//
//  IWeiboSyncApi.h
//  iweibo
//
//  Created by zhaoguohui on 11-12-27.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "IWeiboSyncHttpRequest.h"
#import "Canstants.h"
#import "ASIHTTPRequest.h"


@interface IWeiboSyncApi : NSObject {

}

/*
 @function: 通过用户名和密码实现iweibo的登录功能
 
 @param:error  如果网络请求出现错误，比如没有网络，则通过该参数返回给调用者，以做相应的处理
	若没有错误，则返回nil。若传入nil，表示不关心错误结果。
 @param:name   用户名
 @param:pwd	   密码
 
 @return:将登录返回信息组织成为一个字典返回，可以通过键值获取相应的值，如下：
	ret  :0  登录成功
		 :1	本地帐号不存在	
		 :2	密码不正确
		 :3	未绑定腾讯帐号
		 :4	系统错误
		 errorcode:备用（如果以后需细化错误，可用）
		 msg:提示信息，对应ret
		 data(oauth_token):用户登录成功后返回对应的access_token,登录失败返回空值
 
 */
- (NSDictionary *)iweiboLoginWithUserName:(NSString *)name password:(NSString *)pwd error:(NSError **)error;
@end
