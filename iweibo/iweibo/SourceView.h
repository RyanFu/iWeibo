//
//  SourceView.h
//  iweibo
//
//  Created by ZhaoLilong on 1/9/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextExtract.h"
#import "Asyncimageview.h"
#import "TransInfo.h"
#import "DataManager.h"
#import "videoUrl.h"
#import "Canstants.h"
#import "MessageViewBase.h"

// 转发消息显示类型
typedef enum {
	HomeSourceSytle = 0,		// 主页
	BroadSourceSytle = 1,		// 详细页
	MsgSourceSytle,				// 消息页
	HotBroadcastSourceStyle,	// 热门广播
}SourceShowSytle;

// 声明代理
@protocol SourceViewUrlDelegate;
@protocol SourceViewVideoDelegate;
@protocol SourceViewImageDelegate;

@interface SourceView : MessageViewBase<AsyncImageViewDelegate> {
	int					controllerType;
	TransInfo			*transInfo;				// 转发内容
	AsyncImageView		*imageView;				// 转发图片
	AsyncImageView		*videoImage;				// 转发视频缩略图
	SourceShowSytle		sourceStyle;				// 转发类型

	// 2012-02-08 By Yi Minwen 增加视频，url点击相应委托方法(未完成)
	id<SourceViewUrlDelegate>	  mySrcUrlDelegate;				// 转发Url代理
	id<SourceViewVideoDelegate>	  mySrcVideoDelegate;			// 转发视频代理
	id<SourceViewImageDelegate> mySourceViewImageDelegate;	// 转发图片代理
	// 2012-02-15 lichentao 是否进行复制
	BOOL						isLongPress;		     // 长按标识
	// 2012-04-16 By Yi Minwen
	UILabel						*colonLabel;		// 昵称后边":"标签
	UILabel						*broadSourceFrom;	// ”来自..."
	UILabel						*broadSourceTime;	// 后边跟的时间戳
}

@property (nonatomic, assign) int				 controllerType;
@property (nonatomic, assign) BOOL			 isLongPress;
@property (nonatomic, retain) TransInfo		 *transInfo;
@property (nonatomic, retain) AsyncImageView	 *imageView;
@property (nonatomic, retain) AsyncImageView	 *videoImage;
@property (nonatomic, assign) SourceShowSytle sourceStyle;
@property (nonatomic, assign) id<SourceViewUrlDelegate>		mySrcUrlDelegate;
@property (nonatomic, assign) id<SourceViewVideoDelegate>	mySrcVideoDelegate;
@property (nonatomic, assign) id<SourceViewImageDelegate>	mySourceViewImageDelegate;

// 添加子视图方法
-(void)addSubViews;

// 获取转发内容高度
+(NSMutableDictionary *) sourceHeight;

+(NSMutableDictionary *)srcViewUnitItemDic;
// 点击图片
- (void)tapPhoto:(UITapGestureRecognizer *)gesture;

// 添加链接
- (void)addLink:(CGPoint)mPosition withTmpString:(NSString *)tempString withString:(NSString *)string withType:(NSUInteger)type;
// 添加链接
- (void)addLinkAt:(CGRect)rect withTmpString:(NSString *)tempString withString:(NSString *)string withType:(NSUInteger)type;
// 点击URL
- (void)touchUrl:(id)sender;

// 点击视频
- (void)tapVideo:(UITapGestureRecognizer *)gesture;

-(void)addMainText;
- (void)addSubViews;
-(void)addVideoPlayImageWithRul:(NSString *)url;
@end

// 2012-02-08 By Yi Minwen 
// 图片点击委托事件
@protocol SourceViewUrlDelegate<NSObject>
- (void)SourceViewUrlClicked:(NSString *)urlSource;
@end

// 视频点击事件
@protocol SourceViewVideoDelegate<NSObject>
- (void)SourceViewVideoClicked:(NSString *)urlVideo;
@end

// 图片和图片加载完毕委托方法
@protocol SourceViewImageDelegate<NSObject>
@optional
-(void)SourceViewHasLoadedImage;

@end

