//
//  PersonalMsgHeaderViewController.m
//  iweibo
//
//  Created by LiQiang on 12-1-29.
//  Copyright 2012年 Beyondsoft. All rights reserved.
//

#import "PersonalMsgHeaderView.h"
#import "PersonalMsgViewController.h"
@implementation PersonalMsgHeaderView
@synthesize headPortrait,parentController,nicknameLabel,accountLabel,talkBtn;
@synthesize data;
@synthesize urlString;
@synthesize urlconnection;
@synthesize isDownloading;
@synthesize accountName;

- (id)constructFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *headbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerBg.png"]];
		headbg.frame = CGRectMake(0, 0, 320, 100);
		[self addSubview:headbg];
        [headbg release];
        
		headPortrait = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headDefault.png"]];//头像图片
		headPortrait.frame = CGRectMake(5, 5, 90, 90);
		[self addSubview:headPortrait];
        
        talkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [talkBtn setBackgroundImage:[UIImage imageNamed:@"talk.png"] forState:UIControlStateNormal];
        talkBtn.frame = CGRectMake(273, 43, 32, 26);
        [talkBtn addTarget:self action:@selector(talkAction) forControlEvents:UIControlEventTouchUpInside];
        talkBtn.enabled = NO;
	[self addSubview:talkBtn];

        UILabel *talkLabel = [[[UILabel alloc] initWithFrame:CGRectMake(277, 68, 30, 20)] autorelease];
		talkLabel.backgroundColor = [UIColor clearColor];
		talkLabel.text = @"对话";
        talkLabel.font = [UIFont systemFontOfSize:12];
        talkLabel.textColor = [UIColor whiteColor];
		[self addSubview:talkLabel];
		
//		NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"userInfo.plist"];
//		NSDictionary *userInfo = [NSDictionary dictionaryWithContentsOfFile:path];
//		CLog(@"当前用户账户：==%@",userInfo);
        NSString *loginUserName = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite.loginUserName;
		if ([self.accountName isEqualToString:loginUserName]) {
			talkBtn.hidden = YES;
			talkLabel.hidden = YES;
		}
		
		
         }
    return self;
}

// 新添加一个方法
- (id)constructForMorePageFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *headbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerBg.png"]];
		headbg.frame = CGRectMake(0, 0, 320, 100);
		[self addSubview:headbg];
        [headbg release];
        
		headPortrait = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headDefault.png"]];//头像图片
		headPortrait.frame = CGRectMake(5, 5, 90, 90);
		[self addSubview:headPortrait];
	}
    return self;
}

- (void)talkAction{
	if ([parentController respondsToSelector:@selector(talkBtnClickedAction)]) {
		[parentController performSelector:@selector(talkBtnClickedAction)];
	}	 
}

- (void)getData
{
	self.isDownloading = NO;
    self.talkBtn.enabled =YES;
	NSURL *url = [NSURL URLWithString:self.urlString];
	if (!url)
	{
		CLog(@"Could not create URL from string %@", self.urlString);
		return;
	}
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	if (!theRequest)
	{
		  CLog(@"Could not create URL request from string %@", self.urlString);
		return;
	}
	
    NSURLConnection *urlConn = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	self.urlconnection = urlConn;
    [urlConn release];
	if (!self.urlconnection)
	{
		 CLog(@"URL connection failed for string %@", self.urlString);
		return;
	}
	
	self.isDownloading = YES;
	// Create the new data object
	self.data = [NSMutableData data];
	[self.urlconnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) cleanup
{
	self.data = nil;
	self.urlconnection = nil;
	self.urlString = nil;
	self.isDownloading = NO;
}


- (void)setMyPortraitToDefaultImage {
	self.headPortrait.image = [UIImage imageNamed:@"headDefault.png"];
	self.headPortrait.layer.masksToBounds = YES;
	self.headPortrait.layer.cornerRadius = 6.0;
	self.headPortrait.layer.borderWidth = 1.0;
	self.headPortrait.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
	// append the new data and update the delegate
	[self.data appendData:theData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.isDownloading) {
        self.headPortrait.image = [UIImage imageWithData:self.data];
        self.headPortrait.layer.masksToBounds = YES;
        self.headPortrait.layer.cornerRadius = 6.0;
        self.headPortrait.layer.borderWidth = 1.0;
        self.headPortrait.layer.borderColor = [[UIColor grayColor] CGColor];
        [self.urlconnection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [self cleanup];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	self.isDownloading = NO;
	NSLog(@"Error: Failed connection, %@", [error localizedDescription]);
	[self cleanup];
}


- (void)dealloc {
	[headPortrait release];
    [self.urlconnection cancel];
    [self cleanup];
    [super dealloc];
}


@end
