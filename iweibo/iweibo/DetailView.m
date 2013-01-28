//
//  DetailView.m
//  iweibo
//
//  Created by wangying on 12/29/11.
//  Copyright 2011 bysoft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Canstants.h"
#import "DetailView.h"
#import "DetailsPage.h"
#import "HpThemeManager.h"
#import "Info.h"
#import "PushAndRequest.h"

@implementation DetailView
@synthesize parentController,baseInfo;
@synthesize headPortrait;
@synthesize rootContrlType;
@synthesize imgManager;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		int imageOriginX = 9;
		int imageOriginY = 6;
		int labelOriginX = 67;
		int ButtonOriginY = 26;
		int HeadWidth = 50;
		int HeadHeight = 50;
		int VIPOFFSET = 10;
		
		CGRect rc = CGRectMake(imageOriginX, imageOriginY, HeadWidth, HeadHeight);
		
		UIImageView *bgView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"outline.png"]];
		bgView.frame = CGRectMake(imageOriginX - 0.5, imageOriginY - 0.5, HeadWidth + 1, HeadHeight + 1);
		[self addSubview:bgView];
		[bgView release];
		
        NSDictionary *plistDic = nil;
        NSDictionary *pathDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"ThemePath"];
        if ([pathDic count] == 0){
            NSString *skinPath = [[NSBundle mainBundle] pathForResource:@"ThemeManager" ofType:@"plist"];
            plistDic = [[NSArray arrayWithContentsOfFile:skinPath] objectAtIndex:0];
        }
        else{
            plistDic = pathDic;
        }
        
        NSString *themePathTmpSingleMessage = [plistDic objectForKey:@"SingleMessageImage"];
        NSString *themePathSingle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmpSingleMessage];
        
		headPortrait = [[UIImageView alloc] init];
		headPortrait.userInteractionEnabled = YES;
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHead:)];
		[headPortrait addGestureRecognizer:tapGesture];
		[tapGesture release];
		headPortrait.layer.masksToBounds = YES;
		headPortrait.layer.cornerRadius = 3.0f;
		headPortrait.frame = rc;
		[self addSubview:headPortrait];
		
		rc = CGRectMake(labelOriginX, imageOriginY, 150, 20);
		headLabel = [[UILabel alloc] initWithFrame:rc];
		headLabel.backgroundColor = [UIColor clearColor];
		headLabel.font = [UIFont systemFontOfSize:16];
		headLabel.textColor = [UIColor colorWithRed:0.2 green:0.455 blue:0.596 alpha:1];
		[self addSubview:headLabel];
		
		rc = CGRectMake(HeadWidth+imageOriginX-VIPOFFSET, HeadHeight+imageOriginY-VIPOFFSET, 16, 16);
		NSLog(@"rc:%@",[NSValue valueWithCGRect:rc]);
		vipImage = [[UIImageView alloc]initWithImage:nil];
		vipImage.frame = rc;
		[self addSubview:vipImage];
		[vipImage release];
		
		rc = CGRectMake(labelOriginX, ButtonOriginY, 75, 30);
		transmitCast = [[UIButton alloc] initWithFrame:rc];
		transmitCast.frame = rc;
		[transmitCast setBackgroundImage:[UIImage imageWithContentsOfFile:[themePathSingle stringByAppendingPathComponent:@"trans.png"]] forState:UIControlStateNormal];
		[transmitCast addTarget:self action:@selector(transmitAction) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:transmitCast];
		
		rc = CGRectMake(labelOriginX + 83, ButtonOriginY, 75, 30);
		comment = [[UIButton alloc]initWithFrame:rc];
		comment.frame = rc;
		[comment setBackgroundImage:[UIImage imageWithContentsOfFile:[themePathSingle stringByAppendingPathComponent:@"comments.png"]] forState:UIControlStateNormal];
		[comment addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:comment];
		
		rc = CGRectMake(labelOriginX + 166, ButtonOriginY, 75, 30);
		more = [[UIButton alloc] initWithFrame:rc];
		more.frame = rc;
		[more setBackgroundImage:[UIImage imageWithContentsOfFile:[themePathSingle stringByAppendingPathComponent:@"more.png"]] forState:UIControlStateNormal];
		[more addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:more];
		imgManager = [[UIImageManager alloc] initWithDelegate:self];

    }
    return self;
}

-(void)moreAction{
	if ([parentController respondsToSelector:@selector(moreMsgBtnAction)]){
		[parentController performSelector:@selector(moreMsgBtnAction)];
	}
}

-(void)commentAction{
	if ([parentController respondsToSelector:@selector(commentBtnAction)]){
		[parentController performSelector:@selector(commentBtnAction)];
	}
}

-(void)transmitAction{		 
	if ([parentController respondsToSelector:@selector(transmitBtnAction)]) {
		[parentController performSelector:@selector(transmitBtnAction)];
	}	 
}
		 
-(void)setBaseInfo:(Info *)base{
	if (base != baseInfo) {
		[base retain];
		[baseInfo release];
		baseInfo = base;
	}
	headLabel.text = baseInfo.nick;
	UIImage *img = [UIImageManager cachedImage:ICON_HEAD forUrl:baseInfo.head];
	if (nil == img) {
		// 先加载默认图片
		headPortrait.image = [UIImageManager defaultImage:ICON_HEAD forUrl:baseInfo.head];
		[imgManager startGettingImageWithUrl:baseInfo.head requestID:baseInfo.uid andType:ICON_HEAD];
	}
	else {
		//有缓存直接用缓存数据
		headPortrait.image = img;
	}

	if ([baseInfo.isvip boolValue]) {
		vipImage.hidden = NO;
		vipImage.image = [UIImage imageNamed:@"vip-btn.png"];
	}else if ([baseInfo.localAuth boolValue]) {
		vipImage.hidden = NO;
		vipImage.image = [UIImage imageNamed:@"localVip.png"];
	}
	else {
		vipImage.hidden = YES;
	}
}

- (void)dealloc {
	[headPortrait release];
	[headLabel release];
	[timeLabel release];
	[fromLabel release];
    [transmitCast release];
    [comment release];
    [more release];
	[imgManager cancelAllIconDownloading];
	[imgManager release];
    [super dealloc];
}

- (void)tapHead:(UITapGestureRecognizer *)gesture{
	NSLog(@"tapHeadxxx%@",self.baseInfo.name);
	[[PushAndRequest shareInstance] pushControllerType:self.rootContrlType withName:self.baseInfo.name];
}

#pragma mark protocol UIImageManagerDelegate<NSObject>
// 加载图片完毕
-(void)UIImageManagerDoneLoading:(UIImage *)imgSrc WithType:(IconType)iType {
	UIImage *img = imgSrc;
	if (nil == imgSrc) {
		img = [UIImageManager defaultImage:iType];	 // 如果没图显示默认图片
		CGFloat iwidth = ICON_WIDTH; 
		CGFloat iheight = ICON_HEIGHT;
		if (img.size.width != iwidth && img.size.height != iheight)
		{
			CGSize itemSize = CGSizeMake(iwidth, iheight);
			UIGraphicsBeginImageContext(itemSize);
			CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
			[img drawInRect:imageRect];
			headPortrait.image = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
		}
		else
		{
			headPortrait.image = img;
		}
	}
    else
        headPortrait.image = imgSrc;
}
@end
