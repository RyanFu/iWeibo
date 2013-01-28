//
//  WebUrlViewController.h
//  iweibo
//
//	url链接打开控制页面
//
//  Created by Minwen Yi on 2/3/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DefaultURL @""

extern NSString *const kThemeDidChangeNotification;

@interface WebUrlViewController : UIViewController<UIWebViewDelegate, UIActionSheetDelegate> {
	UIWebView					*webView;			// url信息显示视图
	NSString					*webUrl;			// url串
	NSURLConnection				*connection;	//keep a reference to the connection so we can cancel download in dealloc
	NSMutableData				*receivedData;			//keep reference to the data so we can collect it as it downloads
	
    UIImageView                 *imgBG;             // 导航栏背景
	UIView						*DownBaseView;		// 底部基础视图
	UIButton					*goBackBtn;			// 后退按钮
	UIButton					*goForwardBtn;		// 前进按钮
	UIButton					*refreshBtn;		// 刷新按钮
	UIButton					*turnToBtn;			// 转到按钮
	UIActivityIndicatorView		*activityIndicator;	// 加载中状态控制视图
	UIButton					*progressBtn;		// 加载中状态控制视图底层背景框
	UIView						*errorView;			//错误提示
	UILabel						*customLab;			// 2012-05-28 标题显示标签
	UIButton					*backBtn;
    BOOL                        navHidden;
}

@property(nonatomic, retain)UIWebView				*webView;
@property(nonatomic, retain)UIImageView             *imgBG;
@property(nonatomic, retain)NSString				*webUrl;
@property(nonatomic, retain)UIView					*DownBaseView;
@property(nonatomic, retain)UIButton				*goBackBtn;			
@property(nonatomic, retain)UIButton				*goForwardBtn;		
@property(nonatomic, retain)UIButton				*refreshBtn;		
@property(nonatomic, retain)UIButton				*turnToBtn;			
@property(nonatomic, retain)UIButton				*progressBtn;			
@property(nonatomic, retain)UIActivityIndicatorView	*activityIndicator;

// 打开链接
- (void)openUrl:(NSURL*)url;
// 隐藏或取消左上角转圈按钮
- (void)performAction:(BOOL)bShowIndcator;
// 隐藏错误提示
- (void)hideError;
// 返回
- (void)back;
@end
