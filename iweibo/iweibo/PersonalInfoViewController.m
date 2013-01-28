    //
//  PersonalInfoViewController.m
//  iweibo
//
//  Created by zhaoguohui on 12-3-5.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ComposeBaseViewController.h"
#import "WordsLeftView.h"
#import "DetailPageConst.h"
#import "IWeiboAsyncApi.h"
#import "UserInfo.h"
#import "HpThemeManager.h"

@implementation PersonalInfoViewController
@synthesize head;
@synthesize wordsLeftView;
@synthesize personalInfo;

// 点击返回按钮时调用
- (void)backAction: (id)sender {
	[self.tabBarController performSelector:@selector(showNewTabBar)];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)updateTheme:(NSNotification *)noti{
    NSDictionary  *plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
    NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    [backBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
	[customLab setTextColor:[UIColor whiteColor]];
	[customLab setText:@"个人资料"];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	//self.title = @"个人资料";
	backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 49, 30)];
	backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
	[backBtn setTitle:@"返回" forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];	
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	self.navigationItem.leftBarButtonItem = leftItem;
	[leftItem release];
	personInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped];
	personInfoTable.delegate = self;
	personInfoTable.dataSource = self;
	personInfoTable.backgroundColor = [UIColor colorStringToRGB:MoreSettingBackgroundColor];
	[self.view addSubview:personInfoTable];
	
	// 显示图像的部分
	UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 97)];
	header.backgroundColor = [UIColor clearColor];
	
	// 显示图像
	UIImageView *headerImg = [[UIImageView alloc] initWithImage:self.head];
	headerImg.frame = CGRectMake(17, 8, 86, 86);
	headerImg.layer.cornerRadius = 6.0f;
	headerImg.clipsToBounds = YES;
	[header addSubview:headerImg];
	[headerImg release];
	
	// 显示别针
	UIImageView *headerBg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 2, 93, 95)];
	headerBg.image = [UIImage imageNamed:@"personHeaderBg.png"];
	[header addSubview:headerBg];
	[headerBg release];
	
	personInfoTable.tableHeaderView = header;
	[header release];
	
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateTheme:) 
                                                 name:kThemeDidChangeNotification
                                               object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHidden)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}

// 键盘出现的时候调用
- (void)keyboardWillShow {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3f];
	personInfoTable.contentOffset = CGPointMake(0, 100);
	[UIView commitAnimations];
	personInfoTable.scrollEnabled = NO;
}

// 键盘将要隐藏的时候调用
- (void)keyboardWillHidden {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3f];
	personInfoTable.contentOffset = CGPointMake(0, 0);
	[UIView commitAnimations];
	personInfoTable.scrollEnabled = YES;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"cellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (nil == cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 14, 42, 17)];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont systemFontOfSize:14];
	titleLabel.text = @"简介:";
	[cell.contentView addSubview:titleLabel];
	[titleLabel release];
	
	textView = [[UITextView alloc] initWithFrame:CGRectMake(53, 5, 220, 83)];
	textView.font = [UIFont systemFontOfSize:14];
	textView.delegate = self;
	textView.text = self.personalInfo;
	textView.returnKeyType = UIReturnKeyDone;
	[cell.contentView addSubview:textView];
	
	wordsLeftView = [[WordsLeftView alloc] initWithFrame:CGRectMake(0, 88, 280, 17)];
	wordsLeftView.backgroundColor = [UIColor clearColor];
	wordsLeftView.showDeleteBtn = NO;
	[cell.contentView addSubview:wordsLeftView];
	wordsLeftView.wordsLeftCounts = MaxInputWords;
	
	[self checkWordNumOfPersonalInfo:textView];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 109;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
	return 21;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UILabel *header = nil;
	header = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 21)] autorelease];
	header.backgroundColor = [UIColor clearColor];
	
	return header;
}


// 显示加载框
- (void)showMBProgressWithText:(NSString *)text{
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (hud == nil) {
        hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(30, 80, 260, 200)];  
    }
	
	hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] autorelease];
	hud.mode = MBProgressHUDModeCustomView;
	
	
	[delegate.window addSubview:hud];  
	[delegate.window bringSubviewToFront:hud]; 
	hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];  
}

// 隐藏加载框
- (void) hiddenMBProgress{
    [hud hide:YES];
}


// 更新个人简介信息
- (void)updatePersonalIntroduction {
	
	if (leftWordNum < 0) {
		UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle: @"抱歉, 每条广播字数上限为140字!"
														  delegate:self cancelButtonTitle:@"取消" 
											destructiveButtonTitle:@"清除超出文字" otherButtonTitles:@"清空文字", nil];
		menu.actionSheetStyle = UIActionSheetStyleDefault;
		menu.destructiveButtonIndex = 1;
		menu.tag = DoneComposeActionSheetTag;
		[menu showFromBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES];
		[menu release];
	}else {
		[textView resignFirstResponder];    
		
		NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithCapacity:3];
		[paramters setValue:@"json" forKey:@"format"];
		NSString *myText = textView.text;
		NSLog(@"myText = %@", myText);
		[paramters setValue:textView.text forKey:@"introduction"];
		[paramters setValue:URL_UPDATE_INTRODUCTION forKey:@"request_api"];
		
		IWeiboAsyncApi *api = [[IWeiboAsyncApi alloc] init];
		NSDictionary *dict = [api updatePersonalIntroductionWithParamters:paramters];
		NSLog(@"dict = %@", dict);
		[api release];
		
		if (nil == dict || ![dict isKindOfClass:[NSDictionary class]]) {
			return;
		}
		id ret = [dict objectForKey:@"ret"];
		if (nil == ret || [ret isKindOfClass:[NSNull class]]) {
			return;
		}
		if (0 == [ret intValue]) {
			[self showMBProgressWithText:@"保存成功"];
			[UserInfo sharedUserInfo].introduction = textView.text;
		}else {
			[self showMBProgressWithText:@"保存失败"];
		}
		[self performSelector:@selector(hiddenMBProgress) withObject:nil afterDelay:1.0f];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:	{	// "清除超出文字"
			textView.text = [ComposeBaseViewController getSubString:textView.text WithCharCounts:MaxInputWords];
			[textView becomeFirstResponder];
		}
			break;
		case 1:	{	// "清空文字"
			textView.text = nil;
			[textView becomeFirstResponder];
		}
			break;
		default: {	// ”取消“
			[textView becomeFirstResponder];

		}
			break;
	}
}

// 检查个人信息介绍中文字的个数，并且正确的显示出来，标记状态
- (void)checkWordNumOfPersonalInfo:(UITextView *)tView {
	int textUTF8StrLength = [textView.text length];
	if (textUTF8StrLength > MaxInputWords + 200) {
		tView.text = [tView.text substringToIndex:MaxInputWords + 200];
	} 
	NSInteger charLeft = MaxInputWords - textUTF8StrLength;
	leftWordNum = charLeft;
	// 修正字个数
	[wordsLeftView setWordsLeftCounts:charLeft];
}

#pragma mark -
#pragma mark UITextViewDelegate Methods
-(BOOL)textView:(UITextView *)textView1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {    
    if ([text isEqualToString:@"\n"]) {    
		[self updatePersonalIntroduction];
        return NO;    
    }
    return YES;    
}

- (void)textViewDidChange:(UITextView *)tView {

	[self checkWordNumOfPersonalInfo:tView];
}


- (void)dealloc {
	[backBtn release];
	[personInfoTable release];
	[head release];
	[textView release];
	[wordsLeftView release];
	[personalInfo release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	
    [super dealloc];
}


@end
