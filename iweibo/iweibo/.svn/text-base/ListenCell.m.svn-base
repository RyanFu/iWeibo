//
//  ListenCell.m
//  iweibo
//
//  Created by ZhaoLilong on 2/1/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "ListenCell.h"
#import "ColorUtil.h"
#import "DataManager.h"
#import "DetailPageConst.h"
#import "UIImageManager.h"

@implementation ListenCell

@synthesize headView,vipView;
@synthesize listenIdolList;
@synthesize headImageDownloader;

// 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		// 设置背景
		self.backgroundColor = [UIColor clearColor];
			
		// 添加头像边框
		UIImageView *bgView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"outline.png"]];
		bgView.frame = CGRectMake(8.5, 9.5, 41, 41);
		[self.contentView addSubview:bgView];
		[bgView release];
		
		// 添加用户昵称
		UILabel *nameLabel = [[UILabel alloc] init];
		nameLabel.tag = 003;
		nameLabel.textColor = [UIColor colorStringToRGB:@"000000"];
		nameLabel.font = [UIFont boldSystemFontOfSize:16];
		[self.contentView addSubview:nameLabel];
		[nameLabel release];
		// 添加位置
		UILabel *locationLabel = [[UILabel alloc] init];
		locationLabel.tag = 004;
		locationLabel.textColor = [UIColor colorStringToRGB:@"999999"];
		locationLabel.font = [UIFont systemFontOfSize:DPFansListLocationFontSize];
		[self.contentView addSubview:locationLabel];
		[locationLabel release];
		
		// 添加性别
		UIImageView *sexView = [[UIImageView alloc] init];
		sexView.tag = 005;
		[self.contentView addSubview:sexView];
		[sexView release];
		
		// 添加评论
		CommentView *commentView = [[CommentView alloc] init];
		commentView.tag = 006;
		commentView.backgroundColor = [UIColor colorStringToRGB:@"EBEBEB"];
		commentView.layer.masksToBounds = YES;
		commentView.layer.cornerRadius = 3.0f;
		[self.contentView addSubview:commentView];
		[commentView release];
        IconDownloader *manager = [[IconDownloader alloc] init];
        manager.delegate = self;
        self.headImageDownloader = manager;
        [manager release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
}

// 添加视图
- (void)addSubviews{
	UILabel *myNameLabel = (UILabel *)[self viewWithTag:003];
	UILabel *myLocationLabel = (UILabel *)[self viewWithTag:004];
	UIImageView *mySexView = (UIImageView *)[self viewWithTag:005];
	CommentView *myCommentView = (CommentView *)[self viewWithTag:006];
	// 添加头像
	if (headView != nil) {
		[headView removeFromSuperview];
		[headView release];
		headView = nil;	
	}
	headView = [[UIImageView alloc] init];
	headView.layer.masksToBounds = YES;
	headView.layer.cornerRadius = 3.0f;
	headView.frame = CGRectMake(9, 10, 40, 40);
	[self.contentView addSubview:headView];
    
    
    NSString *urlStrWithSize = [NSString stringWithFormat:@"%@/100",self.listenIdolList.head];
    // 加载默认头像
    if ([urlStrWithSize length] > 10) {
        // 判断本地数据库中是否有对应数据
        NSData *ImageData = [DataManager getCachedImageFromDB:self.listenIdolList.head withType:ICON_HEAD];
        if ([ImageData length] > 4) {
            // 本地有数据
            UIImage *imgHead = [UIImage imageWithData:ImageData];
            self.headView.image = imgHead;
            enumHeadStatus = IconDoneDownloading;
        }
        else
            headView.image = [UIImage imageNamed:@"compseLogo.png"];
    }
    else {
        headView.image = [UIImage imageNamed:@"compseLogo.png"];
    }
    [headView setNeedsLayout];
//	NSURL *headImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/100",self.listenIdolList.head]];
//	[headView addHeadImageFromData:nil];
//	[headView loadImageFromURL:headImageUrl withType:multiMediaTypeHead];
//	[headView setNeedsDisplay];
	
	// 添加vip视图
	if (vipView != nil) {
		[vipView removeFromSuperview];
		[vipView release];
		vipView = nil;		
	}
	vipView = [[UIImageView alloc] initWithFrame:CGRectMake(41, 42, 16, 16)];
	[self.contentView addSubview:vipView];
	if ([self.listenIdolList.isvip boolValue]) {
		vipView.image = [UIImage imageNamed:@"vip-btn.png"];
	}else if ([self.listenIdolList.localAuth boolValue]) {
		vipView.image = [UIImage imageNamed:@"localVip.png"];
	}else {
		vipView.hidden = YES;
	}

	// 添加用户名
	CGSize nameSize = CGSizeZero;
	nameSize = [self.listenIdolList.nick sizeWithFont:[UIFont boldSystemFontOfSize:16]];
	NSString *nameStr = nil;
	if (nameSize.width > 110) {
		nameStr = [[self.listenIdolList.nick substringToIndex:6] stringByAppendingString:@"..."];
	}else {
		nameStr = self.listenIdolList.nick;
	}
	nameSize = [nameStr sizeWithFont:[UIFont boldSystemFontOfSize:16]];
	[myNameLabel setFrame:CGRectMake(59, 10, nameSize.width, 32)]; 
	myNameLabel.text = nameStr;
	
	// 添加位置
	CGSize locationSize = CGSizeZero;
	if (![self.listenIdolList.location isEqualToString:@"未知"]&&[self.listenIdolList.location length] != 0) {
		myLocationLabel.text = [NSString stringWithFormat:@"%@",self.listenIdolList.location];
		locationSize = [myLocationLabel.text sizeWithFont:[UIFont systemFontOfSize:DPFansListLocationFontSize]];
		[myLocationLabel setFrame:CGRectMake(59, nameSize.height + 15, locationSize.width, locationSize.height)];
	} 
	else {
		myLocationLabel.text = @"";
	}

	
	// 取得昵称和位置长度的最大值
	CGFloat max = [self getMaxWidth:nameSize andLocationSize:locationSize];
	
	// 添加性别图片
	[mySexView setFrame:CGRectMake(59 + max + 5, 18, 13, 15)];
	if ([self.listenIdolList.sex intValue] == 1) {
		mySexView.image = [UIImage imageNamed:@"male.png"];
	}else if ([self.listenIdolList.sex intValue]==2) {
		mySexView.image = [UIImage imageNamed:@"female.png"]	;
	}else {
		mySexView.image = [UIImage imageNamed:@"morenSex.png"];
	}
	
	// 添加tweet
	myCommentView.fontSize = DPFansListTweetTextFontSize;
	NSString *tmpString = nil;
	if ([self.listenIdolList.text length] >= 14) {
		tmpString = [self.listenIdolList.text substringWithRange:NSMakeRange(0, 14)];
	}else {	
		tmpString = self.listenIdolList.text;
	}
	if (nil != self.listenIdolList.text&&![self.listenIdolList.text isEqualToString:@""]) {
		CGSize textSize = [self.listenIdolList.text sizeWithFont:[UIFont systemFontOfSize:DPFansListTweetTextFontSize]];
		if (textSize.width < FriendTweetTextWidth) {
			[myCommentView setFrame:CGRectMake(300 - FriendTweetTextWidth - FriendTweetTextArrowMargin, SINGLELINEVERTICALPOS, FriendTweetTextWidth, 21)];
		}else {
			[myCommentView setFrame:CGRectMake(300 - FriendTweetTextWidth - FriendTweetTextArrowMargin,DOUBLELINEVERTICALPOS,FriendTweetTextWidth,40)];
		}
	}else {
		myCommentView.hidden = YES;
	}

	myCommentView.kWidth = FriendTweetTextWidth;
	myCommentView.emoSize = 14.0f;
	myCommentView.comment = tmpString;
}

// 获取长度最大值	
- (CGFloat)getMaxWidth:(CGSize)nameSize andLocationSize:(CGSize)locationSize{
	CGFloat nameWidth = nameSize.width;
	CGFloat locationWidth = locationSize.width;
	return nameWidth > locationWidth?nameWidth:locationWidth;
}

// 用户信息赋值
- (void)setListenIdolList:(ListenIdolList *)listen{
    [self.headImageDownloader cancelDownload];
    enumHeadStatus = IconDefault;
	if (listenIdolList != listen) {
		[listen retain];
		[listenIdolList release];
		listenIdolList = listen;
	}
	[self addSubviews];
	[self setNeedsDisplay];
}

- (void)dealloc {
    [self.headImageDownloader cancelDownload];
    self.headImageDownloader.delegate = nil;
    [headImageDownloader release];
    headImageDownloader = nil;
	[headView release];
    headView = nil;
	[vipView release];
	[super dealloc];
}

// 开始下载图片资源
- (void)startIconDownload {
    if (self.listenIdolList.head == nil || [self.listenIdolList.head length] == 0)
        return;
	if (IconDoneDownloading != enumHeadStatus) {
		enumHeadStatus = IconInDownloading;
        // 查找本地
        NSString *urlStrWithSize =  [NSString stringWithFormat:@"%@/100",self.listenIdolList.head];
        // 加载默认头像
		if ([urlStrWithSize length] > 10) {
			// 判断本地数据库中是否有对应数据
			NSData *ImageData = [DataManager getCachedImageFromDB:self.listenIdolList.head withType:ICON_HEAD];
            if ([ImageData length] > 4) {
				// 本地有数据
				UIImage *imgHead = [UIImage imageWithData:ImageData];
                headView.image = imgHead;
                enumHeadStatus = IconDoneDownloading;
                [headView setNeedsLayout];
			}
			else {
                headView.image = [UIImage imageNamed:@"compseLogo.png"];
                [headView setNeedsLayout];
                NSNumber *unType = [[NSNumber alloc] initWithInt:ICON_HEAD];
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:urlStrWithSize, KEYURL, unType, KEYTYPE, nil];
                [unType release];
                [headImageDownloader startDownloadWithParam:dic];
                [dic release];
			}
		}
		else {
            headView.image = [UIImage imageNamed:@"compseLogo.png"];
            [headView setNeedsLayout];
		}
	}
}

- (void)appImageDidLoadWithData:(NSData *)imgData andBaseInfo:(NSDictionary *)param {
	// 发送到接收对象
	UIImage *imgHead = [UIImage imageWithData:imgData];
	if (nil == imgHead || param == nil) {
		// 2012-5-02 取消下载时，图片数据会有问题，直接返回
		return;
	}
	// 缓存数据到数据库
	enumHeadStatus = IconDoneDownloading; 
    NSString *StrWithSize = [param objectForKey:KEYURL];
    NSRange rg = {0};
    rg.location = [StrWithSize length] - 4;  //   '/100'
    rg.length = 4;
    NSString *strUrl = [StrWithSize stringByReplacingCharactersInRange:rg withString:@""];
    [DataManager insertCachedImageToDB:strUrl withData:imgData andType:IMAGE_SMALL];
    headView.image = imgHead;
    [headView setNeedsLayout];
}

 
@end
