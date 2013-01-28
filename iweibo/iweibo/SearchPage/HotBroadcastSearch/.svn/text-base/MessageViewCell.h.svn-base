//
//  MessageViewCell.h
//  iweibo
//
//	消息行基本视图
//
//  Created by Minwen Yi on 3/1/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCellEx.h"
#import "SourceView.h"
#import "OriginView.h"
#import "IconDownloader.h"

@interface MessageViewCell : UITableViewCellEx<IconDownloaderDelegate, OriginViewUrlDelegate, OriginViewVideoDelegate, SourceViewVideoDelegate> {
	SourceView			*sourceView;			// 源消息视图
	OriginView			*originView;			// 广播消息视图
	UIImageView		*iconView;				// 头像视图
	UILabel				*fromLabel;				// 来自标签
	UILabel				*commentNumLabel;		// 评论数标签
	UIImageView			*commentView ;			// 评论视图
	
//	NSString			*remRow;				// 行数
	NSString		*userName;					// 用户名
//	BOOL			hasHead;					// 头像标识
//	OriginShowSytle originStyle;				// 原创文本类型
	
    NSInteger			rootContrlType;			// 根tab页类型
	IconDownloader		*headImageDownloader;
}

@property (nonatomic, retain) SourceView			*sourceView;
@property (nonatomic, retain) OriginView			*originView;
@property (nonatomic, retain) UIImageView		*iconView;
@property (nonatomic, retain) UILabel				*fromLabel;
@property (nonatomic, retain) UILabel				*commentNumLabel;
@property (nonatomic, retain) UIImageView			*commentView ;
@property (nonatomic, retain) NSString				*userName;	
@property (nonatomic, assign) NSInteger				rootContrlType;
@property (nonatomic, retain) IconDownloader		*headImageDownloader;
// 设置cell内容
- (void)configCell;
// 设置默认头像
- (void)initHead;
// 更新头像
- (void)updateHead;
@end
