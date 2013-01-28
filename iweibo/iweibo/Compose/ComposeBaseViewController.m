    //
//  ComposeBaseViewController.m
//  iweibo
//
//  Created by Minwen Yi on 12/28/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "ComposeBaseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "EmotionView.h"
#import "SCAppUtils.h"
#import "FriendSearchController.h"
#import "MyFavTopicSearchController.h"
#import "CustomNavigationbar.h"
#import "UserInfo.h"
#import "HpThemeManager.h"

static float		g_keyboardFrameHeightLastTime = 216;		// 默认初始键盘高度

@implementation ComposeBaseViewController
@synthesize UpBaseView;		
@synthesize MidBaseView;		
@synthesize DownBaseView;
@synthesize textView;
@synthesize curSelectedRange;
@synthesize draftComposed;
@synthesize emotionView;
@synthesize wordsLeftView;
@synthesize emotionBtnClickded;
@synthesize draftFavTopicsArray;
@synthesize friendsSearchBtnClicked;
@synthesize cutlineImage;
@synthesize typeString;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	friendsSearchBtnClicked = NO;
	curSelectedRange.location = 0;
	if (nil == draftComposed) {
		draftComposed = [[Draft alloc] init];
		[draftComposed setDraftType:INVALID_MESSAGE];
		draftComposed.draftText = nil;
		draftComposed.draftTitle = nil;
	}else {
		// 2012-03-10 By Yi Minwen不为空时，光标在最前边
		//curSelectedRange.location = [draftComposed.draftText length]; //  2012-03-06 zhaolilong 当文本不为空时，将光标置于文本最后
	}

	// 设置消息回调
	[[DraftController sharedInstance] setMyDraftControllerFansListDelegate:self];
    // 1. 导航栏
	self.navigationItem.title = @"撰写";
    NSDictionary *plistDict = nil;
    NSDictionary *pathDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"ThemePath"];
    if ([pathDic count] == 0){
        plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
        if ([plistDict count] == 0) {
            NSString *skinPath = [[NSBundle mainBundle] pathForResource:@"ThemeManager" ofType:@"plist"];
            plistDict = [[NSArray arrayWithContentsOfFile:skinPath] objectAtIndex:0];
        }
    }
    else{
        plistDict = pathDic;
    }
	NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    UIImage *imageNav = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]];
    [SCAppUtils navigationController:self.navigationController setImage:imageNav];
//	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_bg.png"]];// zhaolilong 2012-03-10 改变导航条背景色
	// lichentao 2012-03-05更改关闭和发送按钮的背景图片
	// 关闭按钮
	leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 50, 30)];
	[leftButton setTitle:@"关闭" forState:UIControlStateNormal];
	leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"composebtn-bg.png"]] forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(CancelCompose:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
	self.navigationItem.leftBarButtonItem = leftBar;
	[leftBar release];
	// 发送按钮
	UIButton *sendWeiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	sendWeiboBtn.frame = CGRectMake(260, 5, 50, 30);
	[sendWeiboBtn setTitle:@"发送" forState:UIControlStateNormal];
	sendWeiboBtn.titleLabel.font = [UIFont systemFontOfSize:14];
	[sendWeiboBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"composebtn-bg.png"]] forState:UIControlStateNormal];
    [sendWeiboBtn addTarget:self action:@selector(DoneCompose:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *writeWeiboBarbBtn = [[UIBarButtonItem alloc] initWithCustomView:sendWeiboBtn];
    self.navigationItem.rightBarButtonItem = writeWeiboBarbBtn;
    [writeWeiboBarbBtn release];
	
	self.navigationItem.rightBarButtonItem.enabled = NO;	// 默认不允许发送空消息
	[self.view setBackgroundColor:[UIColor whiteColor]];
	self.view.frame = CGRectMake(0, 64, 320, 416);		// 480减掉toolbar(20), navigationbar(44)高度
	
	// 3. 中间底层背景(放到文本更新之前以保证修改字数时wordsLeftView非空)
	MidBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 141, self.view.frame.size.width, 59)];	// 键盘上方剩余高度，默认59
	[self.view addSubview:MidBaseView];
	// 3.2 字数统计　
	wordsLeftView = [[WordsLeftView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 17)];
	[MidBaseView addSubview:wordsLeftView];
	wordsLeftView.wordsLeftCounts = MaxInputWords;
	wordsLeftView.myWordsLeftViewDelegate = self;
	
	// 2. 顶部底层背景
	UpBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 141)];	// 文本输入框默认高度141
	[self.view addSubview:UpBaseView];
	// 2.1 文本编辑框: 下移两个像素
	textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 137)];
	textView.font = [UIFont systemFontOfSize:18];
	textView.tag = TextViewTag;
	textView.delegate = self;
	// 2.2 更新文本
	if (nil != draftComposed.draftText) {
		textView.text = draftComposed.draftText;
		[self textViewDidChange:textView];
	}
	[UpBaseView addSubview: textView];
	[textView becomeFirstResponder];	
	[textView release];
	
	// 3.3 底层分割线
	cutlineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 26, self.view.frame.size.width, 24)];
	cutlineImage.image = [UIImage imageNamed:@"composeCutline.png"];
	cutlineImage.tag = CutlineImageViewTag;
	[MidBaseView addSubview:cutlineImage];
	cutlineImage.userInteractionEnabled = YES;
	[cutlineImage release];
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnTaped:)];
	[cutlineImage addGestureRecognizer:tapGesture];
	[tapGesture release];
	
	// 3.4 好友搜索按钮
	UIButton *friendsSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[friendsSearchBtn setImage:[UIImage imageNamed:@"composeAt.png"] forState:UIControlStateNormal];
	[friendsSearchBtn setImage:[UIImage imageNamed:@"composeAthover.png"] forState:UIControlStateHighlighted];
	friendsSearchBtn.frame = FriendsearchBtnFrame;			// 23*22
	friendsSearchBtn.tag = FriendSearchBtnTag;
	[friendsSearchBtn addTarget:self action:@selector(friendSearchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
	[MidBaseView addSubview:friendsSearchBtn];
	// 3.5 话题搜索按钮
	UIButton *topicSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[topicSearchBtn setImage:[UIImage imageNamed:@"compose#.png"] forState:UIControlStateNormal];
	[topicSearchBtn setImage:[UIImage imageNamed:@"compose#hover.png"] forState:UIControlStateHighlighted];
	topicSearchBtn.frame = TopicSearchBtnFrame;
	topicSearchBtn.tag = TopicSearchBtnTag;
	[topicSearchBtn addTarget:self action:@selector(topicSearchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
	[MidBaseView addSubview:topicSearchBtn];
	// 3.6 表情选择按钮
	UIButton *emotionSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[emotionSelectBtn setImage:[UIImage imageNamed:@"composeEmotion.png"] forState:UIControlStateNormal];
	[emotionSelectBtn setImage:[UIImage imageNamed:@"composeEmotionhover.png"] forState:UIControlStateHighlighted];
	emotionSelectBtn.frame = EmotionSelectBtnFrame;
	emotionSelectBtn.tag = EmotionSelectBtnTag;
	[emotionSelectBtn addTarget:self action:@selector(emotionSelectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
	[MidBaseView addSubview:emotionSelectBtn];
	emotionBtnClickded = NO;
	// 4. 底部底层背景
	// 正常应该高度位置为200
	DownBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 216)];		// 默认键盘高度216
	[self.view addSubview:DownBaseView];
	[emotionView release];
	UIImageView	*bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
	bgImage.image = [UIImage imageNamed:@"composeEmotionBg.png"];
	[DownBaseView addSubview:bgImage];
	[bgImage release];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[self setTextViewIsFirstResponser:YES];		// 文本输入状态
	friendsSearchBtnClicked = NO;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
	[[DraftController sharedInstance] setMyDraftControllerFansListDelegate:nil];
    // 2012-06-20 By Yi Minwen 修正bug 305 发送失败存草稿后，图片未保存的问题
//	draftComposed.attachedData = nil;
//	draftComposed.fromDraftAttachData = nil;
//	draftComposed.ImageRef = nil;
	[draftComposed release];
	draftComposed = nil;
    [leftButton release];
//	[wordsLeftView release];
//	wordsLeftView = nil;
	[UpBaseView release];
	UpBaseView = nil;
	[MidBaseView release];
	MidBaseView = nil;
	[emotionView release];
	emotionView = nil;
	[DownBaseView release];
	DownBaseView = nil;
	self.typeString = nil;
	//[draftFavTopicsArray release];
	g_keyboardFrameHeightLastTime = 216;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendFailerSaveDraft" object:nil];
    [super dealloc];
}

- (void)hideDownBaseSubView {
	if (YES == emotionBtnClickded) {
		UIButton *emotionSelectBtn = (UIButton *)[self.view viewWithTag:EmotionSelectBtnTag];
		emotionBtnClickded = NO;	
		[emotionSelectBtn setImage:[UIImage imageNamed:@"composeEmotion.png"] forState:UIControlStateNormal];
	}
	if (emotionView && NO == emotionView.hidden ) {
		emotionView.hidden = YES;
	}
}

// 隐藏表情之外的视图
- (void)hideDownBaseSubViewExceptEmotion {
	return;
}

- (void)friendSearchBtnClicked {
	[self setTextViewIsFirstResponser:NO];
    
	FriendSearchController *friendSearch = [[FriendSearchController alloc] init];
	[friendSearch setMyFriendSearchControllerDelegate:self];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:friendSearch];
	[self presentModalViewController:nav animated:YES];
    [nav release];
	[friendSearch release];	
    
//	if (!friendsSearchBtnClicked) {
//		friendsSearchBtnClicked = YES;
//		[[DraftController sharedInstance] getFriendsFansList];
//	}
	CLog(@"friendSearchBtnClicked");
}

- (void)topicSearchBtnClicked {
	[self setTextViewIsFirstResponser:NO];
	CLog(@"topicSearchBtnClicked");
	
	// 检测网络状态
	if (YES) {
		// 异步消息，等待回调完成
		[[DraftController sharedInstance] getMyFavTopicsList];
	}
	else {
		// 读取数据库数据？
	}

}

- (void)emotionSelectBtnClicked {
	[self hideDownBaseSubViewExceptEmotion];
	// 更换图片
	UIButton *emotionSelectBtn = (UIButton *)[self.view viewWithTag:EmotionSelectBtnTag];
	if (emotionBtnClickded) {
		emotionBtnClickded = NO;	
		[emotionSelectBtn setImage:[UIImage imageNamed:@"composeEmotion.png"] forState:UIControlStateNormal];
	}
	else {
		[emotionSelectBtn setImage:[UIImage imageNamed:@"composeEmotionhover.png"] forState:UIControlStateNormal];
		emotionBtnClickded = YES;
	}

	// 2. 当键盘高度不等于216时, 强制滑动文本框，按钮到200位置
	NSNumber *height = [[NSNumber alloc] initWithFloat: 216 - g_keyboardFrameHeightLastTime];
	g_keyboardFrameHeightLastTime = 216;
	if ([height intValue] != 0) {
		[self performSelectorOnMainThread:@selector(scrollIfNeeded:) withObject:height waitUntilDone:NO];
	}
	[height release];
	// 3. 生成键盘
	if (nil == emotionView) {
		emotionView = [[EmotionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
		emotionView.myEmotionViewDelegate = self;
		[DownBaseView addSubview:emotionView];	
		[self setTextViewIsFirstResponser:NO];
	}
	else {
		if (emotionView.hidden == YES) {
			emotionView.hidden = NO;	
			[self setTextViewIsFirstResponser:NO];
		}
		else {
			emotionView.hidden = YES;
			[self setTextViewIsFirstResponser:YES];		// 文本输入状态
		}
	}

}

#pragma mark WordsLeftViewDelegate 

-(void)WordsLeftBtnClicked {
	UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle: nil
													  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"清空文字" otherButtonTitles:nil];
	menu.tag = CleanWordsActionSheetTag;
	menu.actionSheetStyle = UIActionSheetStyleDefault;
	[menu showFromBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES];
	[menu release];	
	//textView.text = nil;
}

#pragma mark -

- (void)insertTextAtCurrentIndex:(NSString *)contextStr {
	if ([textView hasText]) {
		// 获得光标所在的位置
		int location = curSelectedRange.location;
		// 将UITextView中的内容进行调整（主要是在光标所在的位置进行字符串截取，再拼接你需要插入的文字即可）
		NSString *content = textView.text;
		// 2012-06-13 By Yi Minwen Bug 297: 修正中文输入法一些特殊字符输入后，在文本框失去焦点后，字符宽度变小(比如 ~ _ ~ 变成~_~)导致越界的问题
		if (location > [content length]) {
			location = [content length];
		}
		NSString *result = [NSString stringWithFormat:@"%@%@%@",[content substringToIndex:location], contextStr, [content substringFromIndex:location]];
		// 将调整后的字符串添加到UITextView上面
		textView.text = result;
		// 设置光标位置
		curSelectedRange.location = location + contextStr.length;
		textView.selectedRange = curSelectedRange;
	}
	else {
		textView.text = contextStr;
		 //设置光标位置
		curSelectedRange.location = contextStr.length;
		textView.selectedRange = curSelectedRange;
	}

}
// 设置文本框为输入状态
- (void)setTextViewIsFirstResponser:(BOOL)isFirstResponser {
	if (isFirstResponser) {
		// 1. 恢复文本输入状态
		[textView becomeFirstResponder];
		if ([textView hasText]) {
			textView.selectedRange = curSelectedRange;
		}
	}
	else {
		// 2. 文本框失去聚焦状态
		if ([textView isFirstResponder] && [textView hasText]) {
			curSelectedRange = textView.selectedRange;
		}
		[textView resignFirstResponder];
	}

}

- (void)btnTaped:(UITapGestureRecognizer *)recognizer {
	CGPoint point = [recognizer locationInView: [recognizer view]];
	// 点击5个图片中的哪一个
	NSInteger n = (NSInteger)(point.x) / (320 / MidViewBtnCount);
	switch (n) {
		case FriendSearchBtnIndex:{
			// 好友
			[self friendSearchBtnClicked];
		}
			break;
		case TopicSearchBtnIndex:{
			// 话题
			[self topicSearchBtnClicked];
		}
			break;
		case EmotionSelectBtnIndex:{
			// 表情
			[self emotionSelectBtnClicked];
		}
			break;
		default:
			break;
	}
}

#pragma mark EmotionViewDelegate
- (void)toucheAtPage:(NSInteger)pageIndex EmotionIndex:(NSInteger)emotionIndex 
	 WithDescription:(NSString *)emotionDescription {
	// 1. 恢复文本输入状态
	[self setTextViewIsFirstResponser:YES];
	// 2. 隐藏表情
	emotionView.hidden = YES;
	// 3. 添加文本
	[self insertTextAtCurrentIndex:emotionDescription];
}
#pragma mark -

#pragma mark 字数统计相关

// 先匹配替换规则，然后进行字数统计
+ (int)calcStrWordCount:(NSString *)str {
	int nResult = 0;
	NSString *strSourceCpy = [str copy];
	NSMutableString *strCopy =[[NSMutableString alloc] initWithString: strSourceCpy];
	NSArray *array = [strCopy componentsMatchedByRegex:@"((news|telnet|nttp|file|http|ftp|https)://){1}(([-A-Za-z0-9]+(\\.[-A-Za-z0-9]+)*(\\.[-A-Za-z]{2,5}))|([0-9]{1,3}(\\.[0-9]{1,3}){3}))(:[0-9]*)?(/[-A-Za-z0-9_\\$\\.\\+\\!\\*\\(\\),;:@&=\\?/~\\#\\%]*)*"];
	CLog(@"calcStrWordCount:%@", array);
	if ([array count] > 0) {
		for (NSString *itemInfo in array) {
			NSRange searchRange = {0};
			searchRange.location = 0;
			searchRange.length = [strCopy length];
			[strCopy replaceOccurrencesOfString:itemInfo withString:@"aaaaaaaaaaaaaaaaaaaaaa" options:NSCaseInsensitiveSearch range:searchRange];
		}
	}
	//char *pchSource = (char *)[dt bytes];
	char *pchSource = (char *)[str cStringUsingEncoding:NSUTF8StringEncoding];
	int sourcelen = strlen(pchSource);
	
	int nCurNum = 0;		// 当前已经统计的字数
	for (int n = 0; n < sourcelen; ) {
		if( *pchSource & 0x80 ) {
			pchSource += 3;		// NSUTF8StringEncoding编码汉字占３字节
			n += 3;
			nCurNum += 2;
		}
		else {
			pchSource++;
			n += 1;
			nCurNum += 1;
		}
	}
	// 字数统计规则，不足一个字(比如一个英文字符)，按一个字算
	nResult = nCurNum / 2 + nCurNum % 2;	 
	
	[strSourceCpy release];
	[strCopy release];
	CLog(@"sourcelen:%d, calcStrWordCount length:%d ",
		 sourcelen, nResult);
	return nResult;
}


// 从字符串中获取字数个数为N的字符串，单字节字符占半个字数，双字节占一个字数
+ (NSString *)getSubString:(NSString *)strSource WithCharCounts:(NSInteger)number {
	// 一个字符以内，不处理
	if (strSource == nil || [strSource length] <= 1) {
		return strSource;
	}
	char *pchSource = (char *)[strSource cStringUsingEncoding:NSUTF8StringEncoding];
	int sourcelen = strlen(pchSource);
	int nCharIndex = 0;		// 字符串中字符个数,取值范围[0, [strSource length]]
	int nCurNum = 0;		// 当前已经统计的字数
	for (int n = 0; n < sourcelen; ) {
		if( *pchSource & 0x80 ) {
			if ((nCurNum + 2) > number * 2) {
				break;
			}
			pchSource += 3;		// NSUTF8StringEncoding编码汉字占３字节
			n += 3;
			nCurNum += 2;
		}
		else {
			if ((nCurNum + 1) > number * 2) {
				break;
			}
			pchSource++;
			n += 1;
			nCurNum += 1;
		}
		nCharIndex++;
	}
	assert(nCharIndex > 0);
	return [strSource substringToIndex:nCharIndex];
}
#pragma mark -

#pragma mark TextVeiwDelegate
- (void)textViewDidChange:(UITextView *)tView {
	if (tView.tag == TextViewTag) {
		// 求取字符个数

		//RegexKitLite
		// 此处计算字符数有点问题，先不用计算值，有问题再改
		// 2012-02-13 By Yi Minwen 已解决
		int textUTF8StrLength = [ComposeBaseViewController calcStrWordCount:textView.text];
		if (textUTF8StrLength > MaxInputWords + 200) {
			tView.text = [tView.text substringToIndex:MaxInputWords + 200];
		} 
		NSInteger charLeft = MaxInputWords - textUTF8StrLength;
		// 更新发送按钮状态
//		if (charLeft == MaxInputWords && draftComposed.attachedDataType != PICTURE_DATA) {
//			self.navigationItem.rightBarButtonItem.enabled = NO;
//			// 一个单字节字符的情况
//			if (tView.text.length > 0) {
//				self.navigationItem.rightBarButtonItem.enabled = YES;
//			}
//		}
//		else {
//			if (NO == self.navigationItem.rightBarButtonItem.enabled) {
//				self.navigationItem.rightBarButtonItem.enabled = YES;
//			}
//		}
		// textView中内容为空或者输入空格，转播发送按钮可用，广播及评论不可用
		NSString *trimmedString = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; 
		if ([trimmedString length] == 0) {
			if (self.draftComposed.draftType == FORWORD_MESSAGE) {
				self.navigationItem.rightBarButtonItem.enabled = YES;
			}else {
				// 广播或者意见反馈 有图片，文本为空的时候发送按钮可用，否则不可用lichentao 2012-03-26修改
				if ([self.draftComposed.attachedData length] > 0) {
					self.navigationItem.rightBarButtonItem.enabled = YES;
				}else {
					self.navigationItem.rightBarButtonItem.enabled = NO;
				}
			}
		}else {
				self.navigationItem.rightBarButtonItem.enabled = YES;
		}
		// 修正字个数
		[wordsLeftView setWordsLeftCounts:charLeft];
	}
}
#pragma mark -

#pragma mark UIKeyboardWillShowNotification

- (void)keyboardWillHide:(NSNotification *)notification {
	if (emotionBtnClickded) {
		return;
	}
	NSDictionary	*userInfo = [notification userInfo];
	CGRect			bounds;
	[(NSValue *)[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&bounds];
	NSNumber *height = nil; 
	//CLog(@"g_keyboardFrameHeightLastTime = %f, bounds.size.height = %f", g_keyboardFrameHeightLastTime, bounds.size.height);
	height = [[NSNumber alloc] initWithFloat:bounds.size.height - g_keyboardFrameHeightLastTime];
	g_keyboardFrameHeightLastTime = bounds.size.height;		// 保存上一次键盘高度
	if ([height intValue] != 0) {
		[self performSelectorOnMainThread:@selector(scrollIfNeeded:) withObject:height waitUntilDone:NO];
	}
	[height release];
}

// prepare to resize for keyboard.
- (void)keyboardWillShow:(NSNotification *)notification {
	[self hideDownBaseSubView];
	[self keyboardWillHide:notification];
}

- (void)scrollIfNeeded:(NSNumber *)boundsHeight {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	UpBaseView.frame = CGRectMake(UpBaseView.frame.origin.x, UpBaseView.frame.origin.y  ,
								  UpBaseView.frame.size.width, UpBaseView.frame.size.height - [boundsHeight floatValue]);
	textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y  ,
								  textView.frame.size.width, textView.frame.size.height - [boundsHeight floatValue]);
	MidBaseView.frame = CGRectMake(MidBaseView.frame.origin.x, MidBaseView.frame.origin.y - [boundsHeight floatValue] ,
								   MidBaseView.frame.size.width, MidBaseView.frame.size.height );
//	DownBaseView.frame = CGRectMake(DownBaseView.frame.origin.x, DownBaseView.frame.origin.y - [boundsHeight floatValue] ,
//									DownBaseView.frame.size.width, DownBaseView.frame.size.height );
	[UIView commitAnimations];
}
#pragma mark -
// 从草稿箱发送一条数据，或者更改数据，先将以前的数据删掉，保存新的数据,如果是发送失败是先删除在保存
-(void)deleteDraftByTimeStamp:(NSString *)strTimeStamp {
	if ([strTimeStamp isKindOfClass:[NSString class]] && [strTimeStamp length] > 0 && [draftComposed.isFromDraft intValue] == 1) {
		[DataManager removeDraft:strTimeStamp userName:[UserInfo sharedUserInfo].name];
	}
}
#pragma mark barButtonItem click
// cancel composing message
- (void)CancelCompose:(id) sender {
	[self hideDownBaseSubView];
	// 1. 更新草稿数据draftText和DraftAttachData
	[self UpdateDraft];
	// 2. 判断是否有相应内容，假如有则弹出保存提示框/ 从草稿箱进入消息页面进行逻辑判断lichentao 2012-03-11
	//NSString *trimmedString = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; // 去掉两边空格
	if ([draftComposed hasData]) { // 有数据
		if ([draftComposed.draftText isEqualToString:draftComposed.fromDraftString]) {// 判断进入消息页面文本是否发生变化
			if (draftComposed.draftType == BROADCAST_MESSAGE || draftComposed.draftType == SUGGESTION_FEEDBACK_MESSAGE) {// 判断是否是广播或者意见反馈
				if ([draftComposed.isHasPic intValue] == 1) {// 是否有图片
					if ([draftComposed.isFromDraft intValue] == 1) {// 是否从草稿箱进入消息页面 
						if ([draftComposed.attachedData isEqualToData:draftComposed.fromDraftAttachData]) {// 如果图片内容相等不提示保存
							[self dismissModalViewControllerAnimated:YES];
						}else {
							[self showUIActionMenu];// 图片内容不相等，则提示保存
						}

					}else {// 不是从草稿箱进入消息页，只要有图片资源就提示保存
						[self showUIActionMenu];
					}

				}else {
					if ([draftComposed.attachedData length] > 0) {// 从草稿箱进入时候没有图片资源，后来又加载图片，则提示是否保存，否则直接退出
						[self showUIActionMenu];
					}else {										
						[self dismissModalViewControllerAnimated:YES];
					}
				}

			}else {// 转播。评论，对话，文本无变化，退出不提示保存
				[self dismissModalViewControllerAnimated:YES];
			}

		}else {// 文本如果有变化，提示是否保存
			[self showUIActionMenu];
		}

	}
	else {	// 没有文本数据，直接退出,如果是从草稿箱进来的并且是转播可以保存
		if ([draftComposed.isFromDraft intValue] == 1) {// 有文本进入消息页面时候逻辑判断
			if ([draftComposed.fromDraftString length] > 0) {
				if (draftComposed.draftType == FORWORD_MESSAGE) {
					[self showUIActionMenu];
				}else {// 如果文本为空，则直接将该条记录删除
					[self deleteDraftByTimeStamp:draftComposed.timeStamp];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDraftNotification" object:nil];
					[self dismissModalViewControllerAnimated:YES];
				}
			}else {// 没有文本进入消息页面，并且是广播或者意见反馈
				if (draftComposed.draftType == BROADCAST_MESSAGE || draftComposed.draftType == SUGGESTION_FEEDBACK_MESSAGE) {
					[self deleteDraftByTimeStamp:draftComposed.timeStamp];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDraftNotification" object:nil];
					[self dismissModalViewControllerAnimated:YES];					
				}else {
					[self dismissModalViewControllerAnimated:YES];
				}

			}
		}else {
			[self dismissModalViewControllerAnimated:YES];
		}
		
	}
}

- (void)showUIActionMenu{
	UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle: @"您是否要保存到草稿箱？"
													  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
	menu.actionSheetStyle = UIActionSheetStyleDefault;
	menu.tag = CancelComposeActionSheetTag;
	//[menu showFromBarButtonItem:sender animated:YES];
	// lichentao 2012 -03-05
	[menu showInView:self.view];
	[menu release];
}

// UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	CLog(@"ActionSheet clickedButtonAtIndex: %d", buttonIndex);
	if (CancelComposeActionSheetTag == actionSheet.tag) {
		switch (buttonIndex) {
			case 0:	{	// "不保存"
				// 返回主界面
				[self dismissModalViewControllerAnimated:YES];
			}
				break;
			case 1:	{	// “保存"
				// 1. 更新草稿(未完成)
				// 2. 根据需要保存数据到草稿箱,如果是从草稿箱进来的则有更新变动先删除旧的草稿，然后保存新的草稿
				[self deleteDraftByTimeStamp:draftComposed.timeStamp];
				[self setDraft];		// lichenao 2012-03-12设置草稿
				[DataManager insertDraftToDatabase:draftComposed];// lichentao 2012-03-12保存到数据库
				// 如果从草稿箱进入的消息页面，如果保存发送通知草稿箱列表即使更新数据显示
				if ([draftComposed.isFromDraft intValue] == 1) {
					[[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDraftNotification" object:nil];
				}
				[self dismissModalViewControllerAnimated:YES];
			}
				break;
			default: {	// ”取消“
				[self setTextViewIsFirstResponser:YES];
			}
				break;
		}
	}
	else if (CleanWordsActionSheetTag == actionSheet.tag) {
		switch (buttonIndex) {
			case 0:	{	// "清空文字"
				textView.text = nil;
				[self setTextViewIsFirstResponser:YES];
			}
				break;
			default: {	// ”取消“
				[self setTextViewIsFirstResponser:YES];
			}
				break;
		}
	}
	else if (DoneComposeActionSheetTag == actionSheet.tag) {
		switch (buttonIndex) {
			case 0:	{	// "清除超出文字"
				// 去掉尾部多余文字
				textView.text = [ComposeBaseViewController getSubString:textView.text WithCharCounts:MaxInputWords];
				// 设置光标位置
				curSelectedRange.location = textView.text.length;
				curSelectedRange.length = 0;
				// 设置聚焦状态
				[self setTextViewIsFirstResponser:YES];
			}
				break;
			case 1:	{	// "清空文字"
				textView.text = nil;
				[self setTextViewIsFirstResponser:YES];
			}
				break;
			default: {	// ”取消“
				[self setTextViewIsFirstResponser:YES];
			}
				break;
		}
	}
}

// 设置草稿内容
- (void)setDraft{
	// 保存用户名
	draftComposed.realUserName = [UserInfo sharedUserInfo].name;
	// 获得当前的时间戳
	NSTimeInterval time = [[NSDate date] timeIntervalSince1970]; 
	NSNumber *timeDouble = [[NSNumber alloc] initWithLong:time];
	NSString *timeStamp = [[NSString alloc] initWithFormat:@"%@",timeDouble];//时间
	draftComposed.timeStamp = timeStamp;
	[timeDouble release];
	[timeStamp release];
	// 确定保存的类型
	switch (draftComposed.draftType) {
		case BROADCAST_MESSAGE:
			draftComposed.draftTypeContext = @"广播";
			break;
		case FORWORD_MESSAGE:
			draftComposed.draftTypeContext = @"转播";
			break;
		case COMMENT_MESSAGE:
			draftComposed.draftTypeContext = @"评论";
			break;
		case REPLY_COMMENT_MESSAGE:
			draftComposed.draftTypeContext = @"评论并转播";
			break;
		case SUGGESTION_FEEDBACK_MESSAGE:
			draftComposed.draftTypeContext = @"意见反馈";
			break;
		case TALK_TO_MESSAGE:
			draftComposed.draftTypeContext= draftComposed.draftTitle;
			break;

		default:
			break;
	}
	// 如果是广播或者意见反馈，在保存的时候先判断是否有图片，如果有，将保留有图片标记。
	if (draftComposed.draftType == BROADCAST_MESSAGE || draftComposed.draftType == SUGGESTION_FEEDBACK_MESSAGE) {
		if ([draftComposed.attachedData length] > 0) {
			NSNumber *hasPic = [[NSNumber alloc] initWithInt:1];
			draftComposed.isHasPic = hasPic; 
			draftComposed.attachedDataType = PICTURE_DATA;
			[hasPic release];
		}else {
			NSNumber *hasPic = [[NSNumber alloc] initWithInt:0];
			draftComposed.isHasPic = hasPic; 
			draftComposed.attachedDataType = INVALID_DATA;
			[hasPic release];
		}
	}
}

// send compsed message
- (void)DoneCompose:(id) sender {
	[self hideDownBaseSubView];
	// 1. 更新草稿
	[self UpdateDraft];
	// 2. 判断是否文本超出最大值
	// 此处计算字符数有点问题，先不用计算值，有问题再改
	// 2012-02-13 By Yi Minwen 已解决
	int textUTF8StrLength = [ComposeBaseViewController calcStrWordCount:textView.text];
	if (textUTF8StrLength > MaxInputWords) {
		// 3.1 判断是否有相应内容，假如有则弹出保存提示框
		UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle: @"抱歉, 每条广播字数上限为140字!"
														  delegate:self cancelButtonTitle:@"取消" 
											destructiveButtonTitle:@"清除超出文字" otherButtonTitles:@"清空文字", nil];
		menu.actionSheetStyle = UIActionSheetStyleDefault;
		menu.destructiveButtonIndex = 1;
		menu.tag = DoneComposeActionSheetTag;
		//[menu showFromBarButtonItem:sender animated:YES];
		// lichentao 2012 -03-05
		[menu showInView:self.view];
		[menu release];
	}
	else {	// 没数据，直接退出
		// 更新数据库，草稿箱进入消息页面点击发送将其从草稿箱中删除lichentao 2012-03-12
		[self deleteDraftByTimeStamp:draftComposed.timeStamp];
		[self setDraft];
		// 3.2 发送数据(目前都为异步消息)
		// 注: 若要监听异步数据发送状态，可在窗体销毁之前监听DraftControllerDelegate回调方法DraftSendOnSuccessCallBack和DraftSendOnFailureCallBack
		// 发送通知到主窗体，提示监听消息回调刷新发送状态
		iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
		[delegate performSelector:@selector(showDraftStatus)];
		//[[NSNotificationCenter defaultCenter] postNotificationName:@"showStatus" object:nil];
		// 发送数据，如果是评论，发送内容不许为空
		[[DraftController sharedInstance] PostDraftToServer:self.draftComposed];
		// 退出窗体
		[self dismissModalViewControllerAnimated:YES];
	}
}

#pragma mark -

#pragma mark DraftControllerDelegate
// 获取好友列表回调方法
-(void)getFriendsFansListOnSuccess:(NSArray *)info {
	// 测试 CLog(@"info count: %d, getFriendsFansListOnSuccess %@",[info count], info);
	NSMutableArray *infoArray = [NSMutableArray arrayWithArray:info];
	// 好友列表
	FriendSearchController *friendSearch = [[FriendSearchController alloc] init];
	friendSearch.friendArray = infoArray;
	[friendSearch setMyFriendSearchControllerDelegate:self];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:friendSearch];
	[self presentModalViewController:nav animated:YES];
    [nav release];
	[friendSearch release];	
}

-(void)getFriendsFansListOnFailure:(NSError *)error {
	CLog(@"error:%@", error);
	[self setTextViewIsFirstResponser:YES];
}

// 获取话题列表回调方法
-(void)getMyFavTopicsOnSuccess:(NSArray *)info {
	//CLog(@"info count: %d, getFriendsFansListOnSuccess %@",[info count], info);
	NSMutableArray *infoArray = [info copy];
	MyFavTopicSearchController *topicSearchCtrl = [[MyFavTopicSearchController alloc] init];
	[topicSearchCtrl setTopicsArray:infoArray];
	[topicSearchCtrl setTopicSearchDelegate:self];
	[self presentModalViewController:topicSearchCtrl animated:YES];
	[topicSearchCtrl release];
	[infoArray release];
}

-(void)getMyFavTopicsOnFailure:(NSError *)error {
	CLog(@"error:%@", error);
	[self setTextViewIsFirstResponser:YES];
}

//-(void)DraftSendOnSuccessCallBack:(NSDictionary *)dict {
//	CLog(@"on successcallback:%@", dict);
//}
//
//-(void)DraftSendOnFailureCallBack:(NSError *)error {
//	CLog(@"error:%@", error);
//}
#pragma mark -

#pragma mark FriendSearchControllerDelegate 
- (void)FriendsFansItemClicked:(NSString *)ItemName {
	CLog(@"FriendsFansItemClicked: %@", ItemName);
	// 1. 恢复文本输入状态
	[self setTextViewIsFirstResponser:YES];
	// 2. 添加文本
	[self insertTextAtCurrentIndex:ItemName];
	[self textViewDidChange:self.textView]; 
}

- (void)FriendsFansCancelBtnClicked {
	CLog(@"FriendsFansCancelBtnClicked");
	self.view.userInteractionEnabled = YES;
	// 1. 恢复文本输入状态
	[self setTextViewIsFirstResponser:YES];
}

#pragma mark MyFavTopicSearchControllerDelegate 
- (void)topicItemClicked:(NSString *)topicItemName {
	CLog(@"topicItemClicked: %@", topicItemName);
	// 1. 恢复文本输入状态
	[self setTextViewIsFirstResponser:YES];
	// 2. 添加文本
	[self insertTextAtCurrentIndex:topicItemName];
	[self textViewDidChange:self.textView];
}

- (void)topicCancelBtnClicked {
	CLog(@"topicCancelBtnClicked");
	// 1. 恢复文本输入状态
	[self setTextViewIsFirstResponser:YES];
}

#pragma mark -

#pragma mark private Methods

// 用草稿内容初始化界面(当前只处理文本部分)
- (id)initWithDraft:(Draft *)draftSource {
	// 填充文本到文本编辑框
	if (self = [super init]) {
		if (draftComposed) {
			[draftComposed release];
		}
		draftComposed = draftSource;
		[draftComposed retain];
		//NSLog(@"draftComposed retainCnt:%d is %@ %@ %@ %d", [draftComposed retainCount],draftComposed.uid,draftComposed.draftText,draftComposed.timeStamp,draftComposed.draftType);
	}
	return self;
}

// 更新草稿
- (void)UpdateDraft {
	// 文本
	if ([textView hasText]) {
		draftComposed.draftText = textView.text;	// 测试文本
	}else {// lichentao 2012 -03- 13文本内容为空草稿保存空字符串
		draftComposed.draftText = @"";
	}

}

// 根据草稿更新界面
- (void)UpdateViewWithDraft:(Draft *)draftSource {
	if (draftSource) {
		if (nil != draftSource.draftText) {
			textView.text = draftSource.draftText;
		}
	}
}

#pragma mark -

@end

