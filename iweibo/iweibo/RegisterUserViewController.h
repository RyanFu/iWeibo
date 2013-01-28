//
//  RegisterUserViewController.h
//  iweibo
//
//  注册页面
//
//  Created by Yi Minwen on 6/21/12.
//  Copyright (c) 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWeiboAsyncApi.h"
#import "LoginPage.h"

// 图像
#define HEAD_TAG                800
// 输入框
#define TEXTFIELD_TAG           (HEAD_TAG + 1)

// 用户名背景tag
#define NAME_BG_TAG             1000
// email背景
#define EMAIL_BG_TAG            (NAME_BG_TAG + 1)
// 密码背景
#define PWD_BG_TAG              (EMAIL_BG_TAG + 1)
// 重复密码背景
#define PWD_RETRY_BG_TAG        (PWD_BG_TAG + 1)
// 错误提示图
#define ERROR_BG_TAG            (PWD_RETRY_BG_TAG + 1)



@interface RegisterUserViewController : UIViewController<UITextFieldDelegate> {
    UIImageView         *bgView;                // 背景视图
    UIImageView         *nameBg;                
    UITextField         *usrTextField;          // 用户名
    UIImageView         *emailBg;
    UITextField         *emailTextField;        // 邮箱
    UIImageView         *pwdBg;
    UITextField         *pwdTextField;          // 密码
    UIImageView         *pwdRetryBg;
    UITextField         *pwdRetryTextField;     // 重复密码
    UIButton            *btnRegister;
    NSInteger           markedTextFieldIndex;
    IWeiboAsyncApi      *api;
    ENUMAUTHSTATUS      enumAuthStatus;              // 是否完成授权
    LoginPage                  *parentViewControllerId;
}

@property (nonatomic, assign) ENUMAUTHSTATUS                enumAuthStatus;
@property (nonatomic, assign) LoginPage                     *parentViewControllerId;
// 创建TextField
-(UITextField *)createTextFieldWithRect:(CGRect)rect placeHolder:(NSString *)strHolder;
// 更新授权状态
-(void)updateAuthStatus:(ENUMAUTHSTATUS)status;
@end
