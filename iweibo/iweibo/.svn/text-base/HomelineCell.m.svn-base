//
//  HomelineCell.m
//  iweibo
//
//  Created by wangying on 1/20/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "HomelineCell.h"
#import "SourceView.h"
#import "OriginView.h"
#import "Asyncimageview.h"
#import "iweiboAppDelegate.h"
#import "PushAndRequest.h"
#import "MessageViewUtility.h"
#import "TimelinePageConst.h"
#import "DetailPageConst.h"

@implementation HomelineCell

@synthesize homeInfo,sourceInfo;
@synthesize fromLabel,iconView,commentNumLabel,commentView;
@synthesize heightDic,remRow,rootContrlType;
@synthesize originStyle;
@synthesize myHomelineCellVideoDelegate;
@synthesize hasHead;
@synthesize labelYPos;
@synthesize hasFaultageAction;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier showStyle:(OriginShowSytle)style1 sourceStyle:(SourceShowSytle)style2 containHead:(BOOL)contain{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.hasHead = contain;					// 头像标示
		self.backgroundColor = [UIColor clearColor];// 设置背景色
		
		aView = [[UIView alloc] initWithFrame:self.contentView.frame];
		aView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:0.933];
		self.selectedBackgroundView = aView; 
		
		originView = [[OriginView alloc] init];		// 原创视图初始化
		if (!self.hasHead) {
			originView.hasPortrait = NO;			// 原创头像标识
		}
		originView.showStyle = style1;				// 原创类型
		originView.myOriginVideoDelegate = self;    // 原创视频代理
		[self.contentView addSubview:originView];   // 添加原创视图
		
		sourceView = [[SourceView alloc] init];		// 转发视图初始化
		if (!self.hasHead) {
			sourceView.hasPortrait = NO;			// 转发头像标识
		}
		sourceView.sourceStyle = style2;			// 转发类型
		sourceView.mySrcVideoDelegate = self;       // 转发视频代理
		[self.contentView addSubview:sourceView];  // 添加转发视图
		
		iconView = [[AsyncImageView alloc] init];     // 头像初始化

		if (self.hasHead) {// 如果有头像
			// 添加头像边框
			UIImageView *bgView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"outline.png"]];
			bgView.frame = CGRectMake(4, 6.5, 32, 32);
			[self.contentView addSubview:bgView];
			[bgView release];
			
			// 添加点击手势及圆角处理
			UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHead:)];
			iconView.layer.masksToBounds = YES;
			iconView.layer.cornerRadius = 3.0f;
			iconView.userInteractionEnabled = YES;
			iconView.tag = 001;
			iconView.frame = CGRectMake(5, 7.5, ICON_WIDTH, ICON_HEIGHT);
			[iconView addGestureRecognizer:tapGesture];
			[tapGesture release];
			[self.contentView addSubview:iconView];	
			//[iconView release];
		}
		
		// 添加来自标签
		fromLabel = [[UILabel alloc] init];
		fromLabel.tag = 005;
		fromLabel.backgroundColor = [UIColor clearColor];
		fromLabel.textColor = [UIColor colorWithRed:0.502f green:0.502f blue:0.502f alpha:1];
		fromLabel.font = [UIFont systemFontOfSize:12];
		[self.contentView addSubview:fromLabel];
		//[fromLabel release];

		// 添加评论图片
		commentView = [[UIImageView alloc] init];
		commentView.tag = 006;
		commentView.image = [UIImage imageNamed:@"对话.png"];
		[self.contentView addSubview:commentView];
//		[commentView release];
		
		// 添加评论数标签
		commentNumLabel = [[UILabel alloc] init];
		commentNumLabel.tag = 007;
		commentNumLabel.backgroundColor = [UIColor clearColor];
		commentNumLabel.textColor = [UIColor colorWithRed:0.502f green:0.502f blue:0.502f alpha:1];
		commentNumLabel.font = [UIFont systemFontOfSize:12];
		[self.contentView addSubview:commentNumLabel];
//		[commentNumLabel release];
		viewFaultage = [[UIView alloc] init];
		viewFaultage.backgroundColor = [UIColor redColor];
		viewFaultage.userInteractionEnabled = YES;
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faultageAction)];
		[viewFaultage addGestureRecognizer:tapGesture];
		[tapGesture release];
		[self addSubview:viewFaultage];
    }
    return self;
}

-(void)faultageAction {
	if ([self.myHomelineCellVideoDelegate respondsToSelector:@selector(HomelineCellFaultageViewClick)]) {
		[self.myHomelineCellVideoDelegate HomelineCellFaultageViewClick];
	}
	
}

-(void)setHomeInfo:(Info *)info{
	
	//if (homeInfo) {
//		[homeInfo release];
//	}
//		homeInfo = [info retain];
	homeInfo = info;
	// 读取视图高度
	NSMutableDictionary *dic = [heightDic objectForKey:remRow];
	originHeight = [[dic objectForKey:@"origHeight"] floatValue];
	sourceHeight = [[dic objectForKey:@"sourceHeight"] floatValue];
	
	if (self.hasHead) {
		leftMargin = ICON_LEFT_MARGIN + ICON_RIGHT_MARGIN + ICON_WIDTH;
		originView.frame = CGRectMake(leftMargin, 0, TLOriginTextWidth,originHeight);
	}else {
		leftMargin = 10.0f;
		originView.frame = CGRectMake(leftMargin, 0, DPOriginTextWidth,originHeight);
	}
	
	[iconView removeFromSuperview];
	[iconView release];
	iconView = nil;
	if (self.hasHead) {
		iconView = [[AsyncImageView alloc] init];     // 头像初始化
		// 添加点击手势及圆角处理
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHead:)];
		iconView.layer.masksToBounds = YES;
		iconView.layer.cornerRadius = 3.0f;
		iconView.tag = 001;
		iconView.frame = CGRectMake(5, 7.5, ICON_WIDTH, ICON_HEIGHT);
		[iconView addGestureRecognizer:tapGesture];
		[tapGesture release];
		[self.contentView addSubview:iconView];	
		
		//如果数据库没有，从网络请求
		NSData *data = nil;
		data = [Info myHeadImageDataWithUrl:info.head];
		if ([data length]>4) {
			[iconView addHeadImageFromData:nil];
			[iconView addHeadImageFromData:data];
		}
		else {
			[iconView addHeadImageFromData:nil];
			if (sourceView.sourceStyle == MsgSourceSytle) {
				[iconView loadImageFromURL:[NSString stringWithFormat:@"%@/100",info.head] withType:multiMediaTypeMsgHead userId:info.uid];
			}else {
				[iconView loadImageFromURL:[NSString stringWithFormat:@"%@/100",info.head] withType:multiMediaTypeHead userId:info.uid];
			}
		}		
	}
	[iconView setNeedsDisplay];
	originView.info = info;
	originView.controllerType = self.rootContrlType;
	
	
	
	userName = info.name;
	[commentView removeFromSuperview];
	[commentNumLabel removeFromSuperview];
}	

-(void)setLabelInfo:(Info *)info{
	if ([info.from isEqualToString:@""]||info.from == nil) {// 如果from字段为空，则硬编码为腾讯微博
		fromLabel.text = @"腾讯微博";
	}else {
		fromLabel.text = [NSString stringWithFormat:@"来自:%@",info.from];
	}

	// 为来自标签定位
	CGSize fromSize = [fromLabel.text sizeWithFont:[UIFont systemFontOfSize:12]];
	self.labelYPos = 0.0f;
	if (sourceHeight >0.1f) {
		self.labelYPos += sourceHeight + VSBetweenOriginFrameAndOriginCommentCnt;
	}
	fromLabel.frame = CGRectMake(leftMargin, originHeight + self.labelYPos,  fromSize.width + 2, fromSize.height);
	//CLog(@"setLabelInfo: info.nick:%@, originHeight:%f, sourceHeight:%f", info.nick, originHeight, sourceHeight);
	
	[commentView removeFromSuperview];
 	[commentNumLabel removeFromSuperview];
	if ([info.count intValue] + [info.mscount intValue]!=0) {
		NSString *commentString = [NSString stringWithFormat:@"%d",[info.count intValue] + [info.mscount intValue]];
		CGFloat commentWidth = [commentString sizeWithFont:[UIFont systemFontOfSize:12]].width;
		rightMargin = 320.0f - (commentWidth + 15.0f);
		
		commentView.hidden = NO;
		commentNumLabel.hidden = NO;
		commentView.frame = CGRectMake(rightMargin - 15.0f, originHeight + self.labelYPos + 2, 10, 10);
		commentNumLabel.text = [NSString stringWithFormat:@"%d",[info.count intValue] + [info.mscount intValue]];
		commentNumLabel.frame = CGRectMake(rightMargin, originHeight + self.labelYPos, 100, 15);
		[self.contentView addSubview:commentView];
 		[self.contentView addSubview:commentNumLabel];
	}else {
		commentView.hidden = YES;
		commentNumLabel.hidden = YES;
	}
	if (hasFaultageAction) {
		// 添加断层刷新按钮
		viewFaultage.frame = CGRectMake(0.0f, fromLabel.frame.origin.y + fromSize.height + VSpaceBetweenOriginFromAndText, 320.0f, 40.0f);
		viewFaultage.hidden = NO;
	}
	else {
		viewFaultage.hidden = YES;
	}
}

-(void)setSourceInfo:(TransInfo *)transInfo{
	sourceInfo = transInfo;
	sourceView.hidden = NO;
	//NSLog(@"transNick:%@\ttransCount:%@",transInfo.transNick,transInfo.transCommitcount);
	// 添加转发及评论数
	// 2012-03-15 By Yi Minwen setLabelInfo的重复步骤，注掉
	[commentView removeFromSuperview];
 	[commentNumLabel removeFromSuperview];
	if ([transInfo.transCount intValue] + [transInfo.transCommitcount intValue]!=0) {
		NSString *commentString = [NSString stringWithFormat:@"%d",[transInfo.transCount intValue] + [transInfo.transCommitcount intValue]];
		CGFloat commentWidth = [commentString sizeWithFont:[UIFont systemFontOfSize:12]].width;
		rightMargin = 320.0f - (commentWidth + 15.0f);
		
		commentView.hidden = NO;
		commentNumLabel.hidden = NO;
		commentView.frame = CGRectMake(rightMargin - 15.0f, originHeight + self.labelYPos + 2, 10, 10);
		commentNumLabel.text = [NSString stringWithFormat:@"%d",[transInfo.transCount intValue] + [transInfo.transCommitcount intValue]];
		commentNumLabel.frame = CGRectMake(rightMargin, originHeight + self.labelYPos, 100, 15);
		[self.contentView addSubview:commentView];
 		[self.contentView addSubview:commentNumLabel];
	}else {
		commentView.hidden = YES;
		commentNumLabel.hidden = YES;
	}
	
	// 根据头像标识定位转发视图高度
	if (self.hasHead) {
		//sourceHeight = [MessageViewUtility getTimelineSourceViewHeight:transInfo];
		sourceView.frame = CGRectMake(leftMargin, originHeight, TLOriginTextWidth, sourceHeight);
	}else {
		//sourceHeight = [MessageViewUtility getBroadcastSource:transInfo];
		sourceView.frame = CGRectMake(leftMargin, originHeight, DPSourceFrameWidth, sourceHeight);
	}
	sourceView.transInfo = transInfo;
	sourceView.controllerType = self.rootContrlType;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
}

// 移除转发视图
-(void)remove{
	sourceView.hidden = YES;
}

- (void)dealloc {
	// 释放资源
	//[homeInfo release];
	originView.myOriginVideoDelegate = nil;
	[iconView release];
	[aView release];
	[sourceView release];
	[originView release];
	[fromLabel release];
	[commentView release];
	[commentNumLabel release];
	[viewFaultage release];
	[super dealloc];
}

- (void)tapHead:(UITapGestureRecognizer *)gesture{
	//NSLog(@"dianjitouxiang:%@",userName);
	[[PushAndRequest shareInstance] pushControllerType:self.rootContrlType withName:userName];
	if (self.rootContrlType == 3) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"changeValue" object:nil];
	}
}

- (void)startIconDownload {
}

#pragma mark -
#pragma mark protocol OriginViewVideoDelegate<NSObject> 视频点击事件
- (void)OriginViewVideoClicked:(NSString *)urlVideo {
	if ([self.myHomelineCellVideoDelegate respondsToSelector:@selector(HomelineCellVideoClicked:)]) {
		[self.myHomelineCellVideoDelegate HomelineCellVideoClicked:urlVideo];
	}
}

#pragma mark -
#pragma mark protocol SourceViewVideoDelegate<NSObject> 视频点击事件
- (void)SourceViewVideoClicked:(NSString *)urlVideo {
	if ([self.myHomelineCellVideoDelegate respondsToSelector:@selector(HomelineCellVideoClicked:)]) {
		[self.myHomelineCellVideoDelegate HomelineCellVideoClicked:urlVideo];
	}
}

@end
