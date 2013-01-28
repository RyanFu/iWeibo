//
//  LoginPage.h
//  iweibo
//
//  Created by LiQiang on 11-12-22.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "IWeiboASyncApi.h"
#define     KTEXTFIELD   @"textField"
#define     KUSRMSG      @"usr"
#define     PLACEUSRNAME @"请输入用户名"
#define     PLACEPWD     @"请输入密码"

@interface LoginPage : UIViewController<UITextFieldDelegate> {
    UITextField     *usrTextField;
    UITextField     *pwdTextField;
	UIImageView     *loginBg;

    MBProgressHUD   *MBprogress;
    IWeiboAsyncApi  *api;
	NSDictionary	*dicDetailInfoCopy;
    UIImageView     *loginState;       // 秘密选择状态
    BOOL            isSelect;       // 是否记住秘密
    ENUMAUTHSTATUS      enumAuthStatus;              // 是否完成授权
    BOOL            bBtnLoginClicked;           // 是否点击登陆按钮
}

@property (nonatomic, retain) UITextField       *usrTextField;
@property (nonatomic, retain) UITextField       *pwdTextField;
@property (nonatomic, copy) NSDictionary		*dicDetailInfoCopy;
@property (nonatomic, retain) UIImageView		*loginBg;
@property (nonatomic, retain) MBProgressHUD		*MBprogress;

- (UITextField *)getTextFieldNormal:(NSString *)placeMsg;
- (UITextField *)getTextFieldSecure:(NSString *)placeMsg;
- (void)onSuccess:(NSDictionary *)result;
- (void)onFailure:(NSError *)error;
// 更新授权状态
-(void)updateAuthStatus:(ENUMAUTHSTATUS)status;

+ (void)signOut;
@end
