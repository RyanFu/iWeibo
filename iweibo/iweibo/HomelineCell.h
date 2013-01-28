//
//  HomelineCell.h
//  iweibo
//
//  Created by wangying on 1/20/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OriginView.h"
#import "SourceView.h"

@class AsyncImageView;
@class Info;
@class TransInfo;
@class IWeiboAsyncApi;
@class PersonalMsgViewController;

@protocol HomelineCellVideoDelegate;

@interface HomelineCell : UITableViewCell<OriginViewVideoDelegate, SourceViewVideoDelegate> {
	SourceView		 *sourceView;             // 转发内容视图
	OriginView		 *originView;               // 原创内容视图
	AsyncImageView  *iconView;			// 头像视图
	UILabel			 *fromLabel;			// 来自标签
	UILabel			 *commentNumLabel;// 评论数标签
	UIImageView        *commentView ;        // 评论视图
	Info		             	 *homeInfo;			// 原创内容
	TransInfo		 *sourceInfo;			// 转发内容
	CGFloat			 originHeight;		// 原创内容高度
	CGFloat			 sourceHeight;		// 转发内容高度
	CGFloat			 leftMargin;			// 左空白
	CGFloat			 rightMargin;			// 右侧空白
	NSMutableDictionary *heightDic;		// 存储高度字典
	NSString			*remRow;		// 行数
	NSString		*userName;			// 用户名
	BOOL			hasHead;			// 头像标识
	CGFloat			labelYPos;			// 标签纵向高度
	OriginShowSytle originStyle;			// 原创文本类型
	UIView			*aView;
	// 2012-02-08 By Yi Minwen 增加视频，url点击相应委托方法
	id<HomelineCellVideoDelegate>	myHomelineCellVideoDelegate;
    int rootContrlType;
	BOOL			hasFaultageAction;		// 是否有断层提示
	UIView			*viewFaultage;
}

//@property (nonatomic, retain) UILabel			*timeLabel;
@property (nonatomic, retain) UILabel			*fromLabel;
@property (nonatomic, retain) UILabel			*commentNumLabel;
@property (nonatomic, retain) Info				*homeInfo;
@property (nonatomic, retain) TransInfo		*sourceInfo;
@property (nonatomic, retain) AsyncImageView *iconView;
@property (nonatomic, retain) UIImageView		*commentView;
@property (nonatomic, retain) NSMutableDictionary *heightDic;
@property (nonatomic, copy) NSString			*remRow;
@property (nonatomic, assign) OriginShowSytle originStyle;
@property (nonatomic, assign) id<HomelineCellVideoDelegate>		myHomelineCellVideoDelegate;
@property (nonatomic, assign) BOOL			hasHead;
@property (nonatomic, assign) int				rootContrlType;
@property (nonatomic, assign) CGFloat		labelYPos;
@property (nonatomic, assign) BOOL			hasFaultageAction;

// Cell初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier showStyle:(OriginShowSytle)showStyle sourceStyle:(SourceShowSytle)sourceStyle containHead:(BOOL)contain;
// 移除转发内容
- (void)remove;
// 设置标签
- (void)setLabelInfo:(Info *)info;
// 添加点击头像手势
- (void)tapHead:(UITapGestureRecognizer *)gesture;

- (void)startIconDownload;

@end

// 视频点击事件
@protocol HomelineCellVideoDelegate<NSObject>
@optional
- (void)HomelineCellVideoClicked:(NSString *)urlVideo;
-(void)HomelineCellFaultageViewClick;
@end

