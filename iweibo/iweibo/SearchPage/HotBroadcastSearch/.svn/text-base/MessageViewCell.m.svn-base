//
//  MessageViewCell.m
//  iweibo
//
//  Created by Minwen Yi on 3/1/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MessageViewCell.h"
#import "MessageViewCellInfo.h"
#import "TimelinePageConst.h"
#import "DetailPageConst.h"
#import "PushAndRequest.h"

@implementation MessageViewCell
@synthesize sourceView, originView, iconView, fromLabel, commentNumLabel, commentView, userName;
@synthesize rootContrlType;
@synthesize headImageDownloader;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		self.backgroundColor = [UIColor greenColor];// 设置背景色
		
		originView = [[OriginView alloc] init];		// 原创视图初始化
		originView.myOriginVideoDelegate = self;    // 原创视频代理
		originView.showStyle = HomeShowSytle;
		[self.contentView addSubview:originView];   // 添加原创视图
		
		sourceView = [[SourceView alloc] init];		// 转发视图初始化
		sourceView.mySrcVideoDelegate = self;       // 转发视频代理
		sourceView.sourceStyle = HomeSourceSytle;
		[self.contentView addSubview:sourceView];  // 添加转发视图
		
		iconView = [[UIImageView alloc] init];     // 头像初始化
		// 添加头像边框
		UIImageView *bgView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"outline.png"]];
		bgView.frame = CGRectMake(4.3, 6.8, 31, 31);
		[self.contentView addSubview:bgView];
		[bgView release];
		
		// 添加点击手势及圆角处理
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHead:)];
		iconView.layer.masksToBounds = YES;
		iconView.layer.cornerRadius = 3.0f;
		iconView.tag = 001;
		iconView.frame = CGRectMake(5, 7.5, ICON_WIDTH, ICON_HEIGHT);
		[iconView addGestureRecognizer:tapGesture];
		[tapGesture release];
		[self.contentView addSubview:iconView];
		
		
		// 添加来自标签
		fromLabel = [[UILabel alloc] init];
		fromLabel.tag = 005;
		fromLabel.backgroundColor = [UIColor clearColor];
		fromLabel.textColor = [UIColor colorWithRed:0.502f green:0.502f blue:0.502f alpha:1];
		fromLabel.font = [UIFont systemFontOfSize:12];
		[self.contentView addSubview:fromLabel];
		[fromLabel release];
		// 添加评论图片
		commentView = [[UIImageView alloc] init];
		commentView.tag = 006;
		commentView.image = [UIImage imageNamed:@"对话.png"];
		[self.contentView addSubview:commentView];
		
		// 添加评论数标签
		commentNumLabel = [[UILabel alloc] init];
		commentNumLabel.tag = 007;
		commentNumLabel.backgroundColor = [UIColor clearColor];
		commentNumLabel.textColor = [UIColor colorWithRed:0.502f green:0.502f blue:0.502f alpha:1];
		commentNumLabel.font = [UIFont systemFontOfSize:12];
		[self.contentView addSubview:commentNumLabel];	
		
		headImageDownloader = [[IconDownloader alloc] init];
		headImageDownloader.delegate = self;
    }
    return self;
}


- (void)tapHead:(UITapGestureRecognizer *)gesture{
	//NSLog(@"dianjitouxiang:%@",userName);
    [[PushAndRequest shareInstance] pushControllerType:self.rootContrlType withName:userName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void)dealloc {
	[originView release];
	originView = nil;
	[sourceView release];
	sourceView = nil;
	self.userName = nil;
	[commentNumLabel release];
	commentNumLabel = nil;
	[commentView release];
	commentView = nil;
	[iconView release];
	iconView = nil;
	[headImageDownloader cancelDownload];
	headImageDownloader.delegate = nil;
	[headImageDownloader release];
	headImageDownloader = nil;
    [super dealloc];
}

// set方法重载
//目前只适用热门广播，因为头像是从热门广播加载的，除非以后区分sourceStyle
- (void)setCellInfo:(id)info {
	cellInfo = info;
	MessageViewCellInfo *messageViewCellInfo = (MessageViewCellInfo *)info;
	Info *infoItem = messageViewCellInfo.originInfo;
	// 读取视图高度
	CGFloat leftMargin = 10.0f;
	//if (self.hasHead) {
	if (YES) {
		leftMargin = ICON_LEFT_MARGIN + ICON_RIGHT_MARGIN + ICON_WIDTH;
	}
	originView.frame = CGRectMake(leftMargin, 0, TLOriginTextWidth, messageViewCellInfo.originViewHeight);
	originView.info = infoItem;
//	
	//if (self.hasHead) {
	[self initHead];
	
	self.userName = infoItem.name;
	//CLog(@"%s, userName:%@", __FUNCTION__, userName);
	if (infoItem.from == nil || [infoItem.from length] == 0 || [infoItem.from isEqualToString:@""]) {// 如果from字段为空，则硬编码为腾讯微博
		fromLabel.text = @"腾讯微博";
	}else {
		fromLabel.text = [NSString stringWithFormat:@"来自:%@", infoItem.from];
	}
	
	// 为来自标签定位
	CGSize fromSize = [fromLabel.text sizeWithFont:[UIFont systemFontOfSize:12]];
	CGFloat labelYPos = 0.0f;
	if (messageViewCellInfo.sourceViewHeight >0.1f) {
		labelYPos += messageViewCellInfo.sourceViewHeight + VSBetweenOriginFrameAndOriginCommentCnt;
	}
	fromLabel.frame = CGRectMake(leftMargin, messageViewCellInfo.originViewHeight + labelYPos,  fromSize.width + 2, fromSize.height);
	
	// 设置sourceView
	TransInfo* transInfo = messageViewCellInfo.sourceInfo;
	if (transInfo == nil) {
		sourceView.hidden = YES;
		[commentView removeFromSuperview];
		[commentNumLabel removeFromSuperview];
		return;
	}
	sourceView.hidden = NO;
	// 添加转发及评论数
	[commentView removeFromSuperview];
 	[commentNumLabel removeFromSuperview];
	if ([transInfo.transCount intValue] + [transInfo.transCommitcount intValue]!=0) {
		NSString *commentString = [NSString stringWithFormat:@"%d",[transInfo.transCount intValue] + [transInfo.transCommitcount intValue]];
		CGFloat commentWidth = [commentString sizeWithFont:[UIFont systemFontOfSize:12]].width;
		CGFloat rightMargin = 320.0f - (commentWidth + 15.0f);
		
		commentView.hidden = NO;
		commentNumLabel.hidden = NO;
		commentView.frame = CGRectMake(rightMargin - 15.0f, messageViewCellInfo.originViewHeight + labelYPos + 2, 10, 10);
		commentNumLabel.text = [NSString stringWithFormat:@"%d",[transInfo.transCount intValue] + [transInfo.transCommitcount intValue]];
		commentNumLabel.frame = CGRectMake(rightMargin, messageViewCellInfo.originViewHeight + labelYPos, 100, 15);
		[self.contentView addSubview:commentView];
 		[self.contentView addSubview:commentNumLabel];
	}else {
		commentView.hidden = YES;
		commentNumLabel.hidden = YES;
	}
	
	// 根据头像标识定位转发视图高度
//	if (self.hasHead) {
		sourceView.frame = CGRectMake(leftMargin, messageViewCellInfo.originViewHeight, TLOriginTextWidth, messageViewCellInfo.sourceViewHeight);
//	}else {
//		sourceHeight = [MessageViewUtility getBroadcastSource:transInfo];
//		sourceView.frame = CGRectMake(leftMargin, originHeight, DPSourceFrameWidth, sourceHeight);
//	}
	sourceView.transInfo = transInfo;
    sourceView.controllerType = self.rootContrlType;
}

// 设置cell内容
- (void)configCell {
	
}

// 开始加载图片数据
- (void)startIconDownload {
}

#pragma mark protocol IconDownloaderDelegate 

- (void)appImageDidLoadWithData:(NSData *)imgData andType:(IconType)iType {
	// do nothing
}

#pragma mark -
// 设置默认头像
- (void)initHead {
}

- (void)updateHead {
}

#pragma mark protocol OriginViewUrlDelegate<NSObject> // 图片点击委托事件
- (void)OriginViewUrlClicked:(NSString *)urlSource {
	
}

#pragma mark protocol OriginViewVideoDelegate<NSObject> // 视频点击事件
- (void)OriginViewVideoClicked:(NSString *)urlVideo {
	
}

#pragma mark protocol SourceViewVideoDelegate<NSObject> 视频点击事件
- (void)SourceViewVideoClicked:(NSString *)urlVideo {
}

@end
