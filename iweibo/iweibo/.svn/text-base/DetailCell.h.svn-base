//
//  detailCell.h
//  iweibo
//
//  Created by wangying on 1/29/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OriginView.h"
#import "SourceView.h"
#import "OriginViewEx.h"
#import "SourceViewEx.h"
#import "DPUIImageManager.h"
#import "Canstants.h"
#import "DetailSrcView.h"
#import "DetailOriginView.h"

// lichentao 2012-02-21 判断长按源消息或者主消息
typedef enum{
	originViewCopy = 0,
	sourceViewCopy = 1,
}LongPressCopyString;

@class Info;
@class TransInfo;

@protocol DetailCellDelegate;

@interface DetailCell : UITableViewCell<DetailSrcViewDelegate, DetailOriginViewDelegate, UIImageManagerDelegate>  {
	DetailSrcView      *sourceView;
	DetailOriginView		*originView;
	Info			*homeInfo;
	TransInfo		*sourceInfo;
	CGFloat			leftMargin;
	CGFloat			sourceHeight;
	CGFloat			originHeight;
	CGFloat			rightMargin;
	NSMutableDictionary *heightDic;
	NSString			*remRow;
	CGFloat			firstRowHeight;
	UILabel			*broadFromLabel;
	UILabel			*broadTimeLabel;
	UILabel			*commentLabel;
	BOOL			hasComment;			// 是否有被评论
	// 2012-02-08 By Yi Minwen 增加视频，url点击相应委托方法
	id<DetailCellDelegate>	myDetailCellDelegate;
	// 2012-02-21 lichentao 源消息图片加载成功BOOL判断
	BOOL					sourceViewPicFinished;
	LongPressCopyString		longPressCopy; // 判断复制区域属于哪个view
	NSInteger				picNotificationCount;	// 通知类型计数器,多个cell重用通知导致多次执行
    int  rContrlType;
	DPUIImageManager			*imgManager;
	IconStatus				enumHeadStatus;
	IconStatus				enumOriginImageStatus;
	IconStatus				enumOriginVideoImgStatus;
	IconStatus				enumSrcImageStatus;
	IconStatus				enumSrcVideoStatus;
}


@property (nonatomic, retain) NSMutableDictionary *heightDic;
@property (nonatomic, retain) DetailSrcView *sourceView;
@property (nonatomic, retain) DetailOriginView *originView;
@property (nonatomic, retain) Info       *homeInfo;
@property (nonatomic, retain) TransInfo  *sourceInfo;
@property (nonatomic, retain) NSString	 *remRow;
@property (nonatomic, assign) CGFloat firstRowHeight;
@property (nonatomic, assign) CGFloat sourceHeight;
@property (nonatomic, assign) CGFloat originHeight;
@property (nonatomic, assign) id<DetailCellDelegate>		myDetailCellDelegate;
@property (nonatomic, assign) BOOL			hasComment;
@property (nonatomic, assign) BOOL			sourceViewPicFinished;
@property (nonatomic, assign) LongPressCopyString		longPressCopy;
@property (nonatomic, assign) NSInteger picNotificationCount;	// 通知类型计数器,多个cell重用通知导致多次执行
@property (nonatomic, assign) int  rContrlType;
@property (nonatomic, retain) DPUIImageManager			*imgManager;

// 开始下载图片资源
- (void)startIconDownload;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier showStyle:(OriginShowSytle)showStyle;
// 显示粘贴板复制按钮 lichentao 2012-02-15
- (void)showCopyMenu:(UIView *)touchView;
- (void)sourceViewNeedDisplay;
- (void)originViewNeedDisplay;
@end

// 2012-02-08 By Yi Minwen 
@protocol DetailCellDelegate<NSObject>
@optional
// 图片点击委托事件
- (void)DetailCellUrlClicked:(NSString *)urlSource;
// 图片加载完毕事件
- (void)DetailCellImageHasLoadedImage;
// 视频点击事件
- (void)DetailCellVideoClicked:(NSString *)urlVideo;
// 地图缩略图点击委托事件
-(void)DetailCellMapClicked:(CLLocationCoordinate2D)center;
@end


