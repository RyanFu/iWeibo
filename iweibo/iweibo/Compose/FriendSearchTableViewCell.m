//
//  FriendSearchTableViewCell.m
//  iweibo
//
//  Created by Yi Minwen on 7/2/12.
//  Copyright (c) 2012 Beyondsoft. All rights reserved.
//

#import "FriendSearchTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "MyFriendsFansInfo.h"
#import "DataManager.h"

@implementation FriendSearchTableViewCell
@synthesize headImageDownloader, bgView, headImageViewBg, headImageView, strUrlHead, lbNick, lbName, lbIndexLast;
@synthesize lbIndexFirst, vipImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
        IconDownloader *manager = [[IconDownloader alloc] init];
        manager.delegate = self;
        self.headImageDownloader = manager;
        [manager release];
        UIImageView *bgCell = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draftBroadcastBg.png"]];
        bgCell.frame = CGRectMake(0, 0, 320, 54);
        bgCell.alpha = 0.2;
        [self.contentView addSubview:bgCell];
        [self.contentView sendSubviewToBack:bgCell];
        [bgCell release];
        
        UIImageView *lineBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separatorLine.png"]];
        lineBg.frame = CGRectMake(0, 54, 320, 1);
        lineBg.alpha = 0.6;
        [self.contentView addSubview:lineBg];
        [lineBg release];
        
        bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"outline.png"]];
        bgView.tag = 112;
        CALayer *bgLayer = [bgView layer];
        bgLayer.masksToBounds = YES;
        bgLayer.cornerRadius = 8;
        bgView.frame = CGRectMake(5, 6, 42, 42);
        [self.contentView addSubview:bgView];
        
        // 头像图片
        headImageViewBg = [[UIView alloc] initWithFrame:CGRectMake(6, 7, 40, 40)];
        [self.contentView addSubview:headImageViewBg];
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        headImageView.image = [UIImage imageNamed:@"compseLogo.png"];
        headImageView.tag = 100;
		CALayer *layer = [headImageView layer];
		layer.masksToBounds = YES;
		layer.cornerRadius = 8;
        [headImageViewBg addSubview:headImageView];
        
        vipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip-btn.png"]];
		vipImageView.frame = CGRectMake(30, 30, 14, 14);
        [headImageViewBg addSubview:vipImageView];
        //	昵称标签
        lbNick = [[UILabel alloc] initWithFrame:CGRectMake(60, 4, 180, 30)];
        lbNick.tag = 101;
        lbNick.backgroundColor = [UIColor clearColor];
        lbNick.font = [UIFont systemFontOfSize:16];
        lbNick.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        [self.contentView addSubview:lbNick];
//        
        // 搜索输入第一行
        lbIndexFirst = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, 320, 50)];
        lbIndexFirst.tag = 110;
        lbIndexFirst.backgroundColor = [UIColor clearColor];
        lbIndexFirst.font = [UIFont systemFontOfSize:22];
        lbIndexFirst.textColor = [UIColor blueColor];
        [self.contentView addSubview:lbIndexFirst];
//        
        // 去网络搜索
        lbIndexLast = [[UILabel alloc] initWithFrame:CGRectMake(105, 4, 220, 50)];
        lbIndexLast.tag = 111;
        lbIndexLast.backgroundColor = [UIColor clearColor];
        lbIndexLast.font = [UIFont systemFontOfSize:20];
        lbIndexLast.textColor = [UIColor grayColor];
        [self.contentView addSubview:lbIndexLast];
        // 用户名标签
        lbName = [[UILabel alloc] initWithFrame:CGRectMake(60, 31, 180, 20)];
        lbName.tag = 102;
        lbName.backgroundColor = [UIColor clearColor];
        lbName.font = [UIFont systemFontOfSize:12];
        lbName.textColor = [UIColor colorWithRed:99/255 green:99/255 blue:99/255 alpha:0.6];
        [self.contentView addSubview:lbName];
    }
    return self;
}


-(void)dealloc {
    [self.headImageDownloader cancelDownload];
    self.headImageDownloader.delegate = nil;
    [headImageDownloader release];
    headImageDownloader = nil;
    self.vipImageView = nil;
    self.lbIndexFirst = nil;
    self.lbIndexLast = nil;
    self.lbName = nil;
    self.headImageView = nil;
    self.lbNick = nil;
    self.strUrlHead = nil;
    [super dealloc];
}

-(void)setStrUrlHead:(NSString *)urlHead {
    [self.headImageDownloader cancelDownload];
    enumHeadStatus = IconDefault;
    if (urlHead != strUrlHead) {
        [strUrlHead release];
        strUrlHead = [urlHead copy];
        NSString *urlStrWithSize =  [NSString stringWithFormat:@"%@/100",strUrlHead];
        // 加载默认头像
		if ([urlStrWithSize length] > 10) {
			// 判断本地数据库中是否有对应数据
			NSData *ImageData = [DataManager getCachedImageFromDB:strUrlHead withType:ICON_HEAD];
			if ([ImageData length] > 4) {
				// 本地有数据
				UIImage *imgHead = [UIImage imageWithData:ImageData];
                self.headImageView.image = imgHead;
                [self.headImageView setNeedsLayout];
                enumHeadStatus = IconDoneDownloading;
			}
            else
                self.headImageView.image = [UIImage imageNamed:@"compseLogo.png"];
            [self.headImageView setNeedsLayout];
		}
		else {
            self.headImageView.image = [UIImage imageNamed:@"compseLogo.png"];
            [self.headImageView setNeedsLayout];
		}
    }
}

// 开始下载图片资源
- (void)startIconDownload {
    if ([strUrlHead length] == 0) {
        self.headImageView.image = [UIImage imageNamed:@"compseLogo.png"];
        [self.headImageView setNeedsLayout];
        return;
    }
//    [self.headImageDownloader cancelDownload];
//    enumHeadStatus = IconDefault;
	if (IconDoneDownloading != enumHeadStatus) {
		enumHeadStatus = IconInDownloading;
        // 查找本地
        NSString *urlStrWithSize =  [NSString stringWithFormat:@"%@/100",strUrlHead];
        // 加载默认头像
		if ([urlStrWithSize length] > 10) {
			// 判断本地数据库中是否有对应数据
			NSData *ImageData = [DataManager getCachedImageFromDB:strUrlHead withType:ICON_HEAD];
			if ([ImageData length] > 4) {
				// 本地有数据
				UIImage *imgHead = [UIImage imageWithData:ImageData];
                self.headImageView.image = imgHead;
                [self.headImageView setNeedsLayout];
                enumHeadStatus = IconDoneDownloading;
			}
			else {
                self.headImageView.image = [UIImage imageNamed:@"compseLogo.png"];
                [self.headImageView setNeedsLayout];
                NSNumber *unType = [[NSNumber alloc] initWithInt:ICON_HEAD];
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:urlStrWithSize, KEYURL, unType, KEYTYPE, nil];
                [unType release];
                [headImageDownloader startDownloadWithParam:dic];
                [dic release];
			}
		}
		else {
			//CLog(@"null url");
            self.headImageView.image = [UIImage imageNamed:@"compseLogo.png"];
            [self.headImageView setNeedsLayout];
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
    self.headImageView.image = imgHead;
    [self.headImageView setNeedsLayout];
}

- (void)setIsVip:(BOOL)bIsVip {
	if (bIsVip) {
        self.vipImageView.hidden = NO;
        [headImageViewBg bringSubviewToFront:self.vipImageView];
    }
    else {
        self.vipImageView.hidden = YES;
    }
}
@end
