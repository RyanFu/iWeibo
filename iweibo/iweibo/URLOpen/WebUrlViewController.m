    //
//  WebUrlViewController.m
//  iweibo
//
//  Created by Minwen Yi on 2/3/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "WebUrlViewController.h"
#import <iconv.h>
#import "HpThemeManager.h"
#import <QuartzCore/QuartzCore.h>
#import "SCAppUtils.h"

@implementation WebUrlViewController
@synthesize webView, webUrl;
@synthesize goBackBtn, goForwardBtn, refreshBtn, turnToBtn, DownBaseView, progressBtn;
@synthesize activityIndicator;
@synthesize imgBG;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

//- (void)updateTheme:(NSNotification *)noti{
//    NSDictionary  *plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
//    NSString *themePathTmp = [plistDict objectForKey:@"Common"];
//	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
//    [backBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
//}

-(void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:navHidden animated:YES];
    [super viewWillDisappear:animated];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	navHidden = self.navigationController.navigationBar.hidden;
	[self.navigationController setNavigationBarHidden:YES animated:YES];
    //self.navigationItem.title = @"页面载入中";
    NSDictionary *plistDict = nil;
    NSDictionary *pathDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"ThemePath"];
    //    if ([pathDic count] == 0){
    if (YES) {
        NSString *skinPath = [[NSBundle mainBundle] pathForResource:@"ThemeManager" ofType:@"plist"];
        // 蓝色皮肤
        plistDict = [[NSArray arrayWithContentsOfFile:skinPath] objectAtIndex:1];
    }
    else{
        plistDict = pathDic;
    }
	NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    UIImage *imageWriteNav = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]];
    imgBG = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    imgBG.image = imageWriteNav;
    imgBG.userInteractionEnabled = YES;
    //    [imgBG addSubview:viewSearchBG];
	[self.view addSubview:imgBG];
    [self.view bringSubviewToFront:imgBG];
	backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn.frame = CGRectMake(4, 5, 50, 30);
	[backBtn setTitle:@"返回" forState:UIControlStateNormal];
	backBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    backBtn.titleLabel.shadowOffset = CGSizeMake(-1.0f, 2.0f);
	[backBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 12, 5, 5)];
	[backBtn setBackgroundImage:[UIImage imageNamed:[themePathTmp stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	[imgBG addSubview:backBtn];

	// 1. 导航栏
   
	customLab = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 11, 220, 20)];
	[customLab setTextColor:[UIColor whiteColor]];
	[customLab setText:@"页面载入中"];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [imgBG addSubview:customLab];
	
	
	progressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [progressBtn setBackgroundImage:[UIImage imageNamed:@"webUrlbg1.png"] forState:UIControlStateNormal];
    [progressBtn setBackgroundImage:[UIImage imageNamed:@"webUrlbg2.png"] forState:UIControlStateHighlighted];
    //[progressBtn addTarget:self action:@selector(writeWeibo) forControlEvents:UIControlEventTouchUpInside];
    progressBtn.frame = CGRectMake(280, 5, 32, 32);
    [imgBG addSubview:progressBtn];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
	[activityIndicator setCenter:CGPointMake(16.0f,16.0f)];
	[activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
	[progressBtn addSubview:activityIndicator];
	[self performAction:YES];
	
	
	[self.view setBackgroundColor:[UIColor whiteColor]];
//	self.view.frame = CGRectMake(0, 20, 320, 460);		// 480减掉toolbar(20), navigationbar(44)高度, 导航控制按钮(44)
	// web显示页
	 UIWebView *wbView = [[UIWebView alloc] init];
    self.webView = wbView;
	webView.frame = CGRectMake(0, 44, 320, 372);
	webView.scalesPageToFit = YES;
	webView.delegate = self;
	[self.view addSubview:self.webView];
    [wbView release];
	
	// 底层控件视图
	DownBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 416, self.view.frame.size.width, 44)];		// 默认键盘高度216
	[self.view addSubview:DownBaseView];
	// 底层分割线
	UIImageView *cutlineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
	cutlineImage.image = [UIImage imageNamed:@"webUrlDownBG.png"];
	cutlineImage.tag = 501;
	cutlineImage.userInteractionEnabled = YES;
	[DownBaseView addSubview:cutlineImage];
	[cutlineImage release];
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabtaped:)];
	[cutlineImage addGestureRecognizer:tapGesture];
	[tapGesture release];
	
	// 转到按钮
	turnToBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[turnToBtn setImage:[UIImage imageNamed:@"webUrlTurnTo.png"] forState:UIControlStateNormal];
	[turnToBtn setImage:[UIImage imageNamed:@"webUrlTurnToHover.png"] forState:UIControlStateHighlighted];
	turnToBtn.frame = CGRectMake(28, 15, 23, 17);
	[turnToBtn addTarget:self action:@selector(turnToBtnClicked) forControlEvents:UIControlEventTouchUpInside];
	[DownBaseView addSubview:turnToBtn];
	// 后退按钮
	goBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[goBackBtn setImage:[UIImage imageNamed:@"webUrlGoBack.png"] forState:UIControlStateNormal];
	[goBackBtn setImage:[UIImage imageNamed:@"webUrlGoBackHover.png"] forState:UIControlStateHighlighted];
	goBackBtn.frame = CGRectMake(115, 16, 10, 15);
	[goBackBtn addTarget:self action:@selector(goBackBtnClicked) forControlEvents:UIControlEventTouchUpInside];
	[DownBaseView addSubview:goBackBtn];
	// 前进按钮
	goForwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[goForwardBtn setImage:[UIImage imageNamed:@"webUrlGoForward.png"] forState:UIControlStateNormal];
	[goForwardBtn setImage:[UIImage imageNamed:@"webUrlGoForwardHover.png"] forState:UIControlStateHighlighted];
	goForwardBtn.frame = CGRectMake(195, 16, 10, 15);
	[goForwardBtn addTarget:self action:@selector(goForwardBtnClicked) forControlEvents:UIControlEventTouchUpInside];
	[DownBaseView addSubview:goForwardBtn];
	// 刷新按钮
	refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[refreshBtn setImage:[UIImage imageNamed:@"webUrlReload.png"] forState:UIControlStateNormal];
	[refreshBtn setImage:[UIImage imageNamed:@"webUrlReloadHover.png"] forState:UIControlStateHighlighted];
	refreshBtn.frame = CGRectMake(265, 10, 29, 28);
	[refreshBtn addTarget:self action:@selector(refreshBtnClicked) forControlEvents:UIControlEventTouchUpInside];
	[DownBaseView addSubview:refreshBtn];
	
	// 错误提示按钮
	errorView = [[UIView alloc] initWithFrame:CGRectMake(60, 100, 200, 150)];
	errorView.layer.masksToBounds = YES;
	errorView.layer.cornerRadius = 10.0f;
	errorView.backgroundColor = [UIColor blackColor];
	errorView.alpha = 0.6;
	errorView.tag = 400;
	UIImageView *errorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
	errorImage.frame = CGRectMake(71, 15, 58, 58);
	[errorView addSubview:errorImage];
	[errorImage release];
	UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 73, 170, 60)];
	errorLabel.textAlignment = UITextAlignmentCenter;
	errorLabel.backgroundColor = [UIColor clearColor];
	errorLabel.numberOfLines = 0;
	errorLabel.lineBreakMode = UILineBreakModeWordWrap;
	errorLabel.textColor = [UIColor whiteColor];
	errorLabel.text = @"网络链接错误，请检查网络";
	[errorView addSubview:errorLabel];
	[errorLabel release];
	[webView addSubview:errorView];
	errorView.hidden = YES;
	// 加载数据
	assert(webUrl != nil);
	NSURL *url = [NSURL URLWithString:webUrl];
	[self openUrl:url];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
}

// 后退
- (void)goBackBtnClicked {
	CLog(@"goBackBtnClicked");
	//if ([webView canGoBack]) {
		[webView goBack];
	//}
}

// 前进
- (void)goForwardBtnClicked {
	CLog(@"goForwardBtnClicked");
	if ([webView canGoForward]) {
		[webView goForward];
	}
}

// 刷新
- (void)refreshBtnClicked {
	[webView stopLoading];
	CLog(@"refreshBtnClicked");
	[webView reload];
}

// 转到
- (void)turnToBtnClicked {
	CLog(@"turnToBtnClicked");
	// 弹出提示按钮
	UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle: nil
													  delegate:self cancelButtonTitle:@"取消" 
										destructiveButtonTitle:@"在Safari中打开" otherButtonTitles:nil];
	menu.actionSheetStyle = UIActionSheetStyleDefault;
	menu.destructiveButtonIndex = 2;		// 隐藏掉
	//menu.tag = DoneComposeActionSheetTag;
	[menu showInView:self.view];
	[menu release];
	
}

- (void)tabtaped:(UITapGestureRecognizer *)recognizer {
	CGPoint point = [recognizer locationInView: [recognizer view]];
	// 点击5个图片中的哪一个
	NSInteger n = (NSInteger)(point.x) / (320 / 4);
	switch (n) {
		case 0:{
			// 表情
			[self turnToBtnClicked];
		}
			break;
		case 1:{
			// 后退
			[self goBackBtnClicked];
		}
			break;
		case 2:{
			// 前进
			[self goForwardBtnClicked];
		}
			break;
		case 3:{
			// 刷新
			[self refreshBtnClicked];
		}
			break;
		default:
			break;
	}
}

#pragma mark -
#pragma mark UIActionSheetDelegate <NSObject> 转到　按钮点击事件相关委托方法
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:	{	// "在Safari中打开"
			if ([webUrl hasPrefix:@"http"] || [webUrl hasPrefix:@"https"] || [webUrl hasPrefix:@"mailto"] ) {
				NSURL *url = [NSURL URLWithString:webUrl];
				[ [ UIApplication sharedApplication ] openURL: url ];
			}
		}
			break;
		default: {	
			// ”取消“
		}
			break;
	}
}
#pragma mark -


// 异步加载数据
- (void)openUrl:(NSURL*)url {
	if (connection!=nil) { [connection release]; } 
	if (receivedData!=nil) { [receivedData release]; }
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	// 格式化请求，只取utf８数据
	[request setValue:@"AppleWebKit/533.18.1 (KHTML, like Gecko) Version/5.0.2 Safari/533.18.5" forHTTPHeaderField:@"User-Agent"];
	// 法1 先加载所有数据到本地，然后填充到webView
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; //notice how delegate set to self object
	if (!connection) {
		[webView loadHTMLString:@"Unable to make connection!" baseURL:[NSURL URLWithString:DefaultURL]] ;
	}
	
	// 法2 直接通过webView加载(好像要慢一些)
	//[webView loadRequest:request];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	CLog(@"%s,%@", __FUNCTION__, webUrl);
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
	[customLab release];
	customLab = nil;
    [imgBG release];
    imgBG = nil;
	[errorView release];
	errorView = nil;
	[activityIndicator release];
	activityIndicator = nil;
	[receivedData release];
	receivedData = nil;
	[connection cancel]; //in case the URL is still downloading
	[connection release];
	connection = nil;
	// 2012-02-13 By Yi Minwen 修正返回时程序崩溃的问题
	[webView stopLoading];
	webView.delegate = nil;		
	[webView release];
	webView = nil;
	[DownBaseView release];
	DownBaseView = nil;
	
    [super dealloc];
	CLog(@"%s---------------", __FUNCTION__);
}

#pragma mark -
#pragma mark NSURLConnection Callbacks 异步加载数据相关委托方法
- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response {
	[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data { 
	if (receivedData==nil) { 
		receivedData = [[NSMutableData alloc] initWithCapacity:2048]; 
	} 
	[receivedData appendData:data];
}

- (void)ShowError:(NSError *)error {
	errorView.hidden = NO;
	//errorView bringsubviewtoFront:
	[self.view bringSubviewToFront:errorView];
}

- (void)performAction:(BOOL)bShowIndcator {
	if (!bShowIndcator) {
		[activityIndicator stopAnimating];
		progressBtn.hidden = YES;
	}
	else {
		if (![activityIndicator isAnimating]) {
			[activityIndicator startAnimating];
			progressBtn.hidden = NO;
		}
	}
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error {
	[connection release];
	connection = nil;
	receivedData = nil;
	/*
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:
																			  @"Connection failed! Error - %@ (URL: %@)", [error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]]
												   delegate:self cancelButtonTitle:@"Bummer" otherButtonTitles:nil];
	[alert show]; 
	[alert release];
	 */
	[self performAction:NO];
	[self ShowError:error];
	[self performSelector:@selector(hideError) withObject:nil afterDelay:2.0f];
} 

- (NSData *)cleanUTF8:(NSData *)data {
	iconv_t cd = iconv_open("UTF-8", "UTF-8"); // convert to UTF-8 from UTF-8
	int one = 1;
	iconvctl(cd, ICONV_SET_DISCARD_ILSEQ, &one); // discard invalid characters
	
	size_t inbytesleft, outbytesleft;
	inbytesleft = outbytesleft = data.length;
	char *inbuf  = (char *)data.bytes;
	char *outbuf = malloc(sizeof(char) * data.length);
	char *outptr = outbuf;
	if (iconv(cd, &inbuf, &inbytesleft, &outptr, &outbytesleft)
		== (size_t)-1) {
		NSLog(@"this should not happen, seriously");
		return nil;
	}
	NSData *result = [NSData dataWithBytes:outbuf length:data.length - outbytesleft];
	iconv_close(cd);
	free(outbuf);
	return result;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
	webView.hidden = NO; 
	[self performAction:NO];
	//NSData *result = [self cleanUTF8:receivedData];
	NSString *payloadAsString = [[NSString alloc] initWithData: receivedData
														encoding:NSUTF8StringEncoding]; 
	// 处理GB2312编码格式数据，用超集18030处理
	if (!payloadAsString) {
		payloadAsString = [[NSString alloc] initWithData:receivedData
												encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
	}
	[webView loadHTMLString:payloadAsString baseURL:[NSURL URLWithString:webUrl]]; 
	//self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	[payloadAsString release];
	[connection release]; 
	connection = nil;
	[receivedData release];
	receivedData = nil;
}

#pragma mark -
#pragma mark UIWebViewDelegate <NSObject>　页面加载时相关事件


- (void)webViewDidStartLoad:(UIWebView *)wView {
	// 加载标题
//	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
//	[customLab setTextColor:[UIColor whiteColor]];
	[customLab setText:@"页面载入中"];
	CLog(@"request:%@", [[wView request] URL]);
//	[customLab setTextAlignment:UITextAlignmentCenter];
//	customLab.backgroundColor = [UIColor clearColor];
//	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
//	self.navigationItem.titleView = customLab;
//	[customLab release];
	//self.navigationItem.title = @"页面载入中";
	// 导航栏按钮状态变更
	[self performAction:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)wView {
	CLog(@"++++++++++++++%s", __FUNCTION__);
	// 加载标题
//	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
//	[customLab setTextColor:[UIColor whiteColor]];
	[customLab setText:[NSString stringWithFormat:@"　%@", [wView stringByEvaluatingJavaScriptFromString:@"document.title"]]];
//	[customLab setTextAlignment:UITextAlignmentCenter];
//	customLab.backgroundColor = [UIColor clearColor];
//	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
//	self.navigationItem.titleView = customLab;
//	[customLab release];
	//self.navigationItem.title =[NSString stringWithFormat:@"　%@", [wView stringByEvaluatingJavaScriptFromString:@"document.title"]];
	// 保存当前url地址
//    for (UIView *sub in [webView subviews]) {
//        CLog(@"sub class:%@, frame: %@", [sub class], NSStringFromCGRect(sub.frame));
//        if ([sub isKindOfClass:[UIScrollView class]]) {
//            NSArray *arr = [sub subviews];
//            UIView *lastWebBrowserView = [arr objectAtIndex:[arr count] - 1];
//            CLog(@"lastWebBrowserView:%@, frame: %@", [lastWebBrowserView class], NSStringFromCGRect(lastWebBrowserView.frame));
////            if (lastWebBrowserView.frame.size.height < self.view.bounds.size.height) {
//                CLog(@"lastWebBrowserView.center: %@", NSStringFromCGPoint(lastWebBrowserView.center));
//                lastWebBrowserView.center = CGPointMake(lastWebBrowserView.center.x, lastWebBrowserView.center.y + 100);
////            }
//        }
//    }
	NSURL *requestURL = [ [self.webView request] URL ];
	webUrl = [requestURL relativeString];
	// 导航栏按钮状态变更
	[self performAction:NO];
	CLog(@"%s,%@", __FUNCTION__, webUrl);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	CLog(@"++++++++++++++%s", __FUNCTION__);
	CLog(@"%s,%@", __FUNCTION__, webUrl);
	if ([error code] != -999) {
		[self performAction:NO];
		[self ShowError:error];
		[self performSelector:@selector(hideError) withObject:nil afterDelay:2.0f];
	}
} 

- (void)hideError{
	[errorView setHidden:YES];
}

- (void)back{
	CLog(@"%s,%@", __FUNCTION__, [ [self.webView request] URL ]);
	[webView stopLoading];
	[webView loadHTMLString:@"" baseURL:[NSURL URLWithString:@""]]; 
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
@end
