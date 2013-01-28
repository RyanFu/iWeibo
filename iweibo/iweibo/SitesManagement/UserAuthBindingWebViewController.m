//
//  UserAuthBindingWebViewController.m
//  iweibo
//
//  Created by Minwen Yi on 6/15/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "UserAuthBindingWebViewController.h"
#define AuthorizationSucceedMark	@"private/result?ret=0"


@implementation UserAuthBindingWebViewController
@synthesize parentViewControllerId, graParentViewControllerId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // 去掉底部按钮
    imgBG.image = [UIImage imageNamed:@"subScribeTitleBg.png"];
	customLab.font = [UIFont fontWithName:@"Verdana" size:18];
    [DownBaseView removeFromSuperview];
	[backBtn setBackgroundImage:[UIImage imageNamed:@"subScribeNav.png"] forState:UIControlStateNormal];
	webView.frame = CGRectMake(0, 44, 320, 416);
    [progressBtn setBackgroundImage:[UIImage imageNamed:@"authActivateIndicatorBG.png"] forState:UIControlStateNormal];
}
- (void)webViewDidFinishLoad:(UIWebView *)wView {
	[super webViewDidFinishLoad:wView];
	NSURL *requestURL = [ [self.webView request] URL ];
	NSRange rang = [[requestURL relativeString] rangeOfString:AuthorizationSucceedMark options:NSCaseInsensitiveSearch];
	if (rang.location != NSNotFound) {
		[customLab setText:@"已授权"];
//		[backBtn setTitle:@"完成" forState:UIControlStateNormal];
        enumAuthStatus = SUCCEED_AUTH;
	}
    else {
        enumAuthStatus = FAILED_AUTH;
    }
}

- (void)back{
	CLog(@"%s,%@", __FUNCTION__, [ [self.webView request] URL ]);
//    if (bSucceedAuth) {
    if ([parentViewControllerId respondsToSelector:@selector(updateAuthStatus:)]) {
        [parentViewControllerId updateAuthStatus:enumAuthStatus];
    }
    [webView stopLoading];
    [webView loadHTMLString:@"" baseURL:[NSURL URLWithString:@""]]; 
    if (graParentViewControllerId != nil) {
        [self.navigationController popToViewController:(UIViewController *)graParentViewControllerId animated:YES]; 
    }
    else {
        [self.navigationController popToViewController:(UIViewController *)parentViewControllerId animated:YES];    
    }
}

@end
