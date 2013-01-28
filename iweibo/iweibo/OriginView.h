//
//  OriginView.h
//  iweibo
//
//  Created by ZhaoLilong on 1/9/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextExtract.h"
#import "Info.h"
//#import "HomePage.h"
#import "Asyncimageview.h"
#import "videoUrl.h"
#import "Canstants.h"
#import "CustomLink.h"
#import "ColorUtil.h"
#import "MessageViewBase.h"



// 声明代理
@protocol OriginViewUrlDelegate;
@protocol OriginViewVideoDelegate;
@protocol OriginViewDelegate;


// 显示类型
typedef enum {
	HomeShowSytle = 0,			// 主页显示
	BroadShowSytle = 1,			// 详细页显示
	MsgShowSytle,				// 消息页显示
	HotBroadcastShowStyle,		// 热门广播
}OriginShowSytle;

@interface OriginView : MessageViewBase<AsyncImageViewDelegate> {
	int					controllerType;	// 控制器标示
	Info					*info;			// 原创信息
	OriginShowSytle		showStyle;		// 显示类型
	AsyncImageView		*imageView;		// 图片
	AsyncImageView		*videoView;		// 视频图片
	
	// 2012-02-08 By Yi Minwen 增加视频，url点击相应委托方法
	id<OriginViewUrlDelegate>	myOriginUrlDelegate;
	id<OriginViewVideoDelegate>	myOriginVideoDelegate;
	
	id<OriginViewDelegate>		myOriginViewDelegate;	// 图片和视频加载完毕代理
	
	// 2012-02-15 lichentao 是否进行复制
	BOOL						isLongPress;				// 长按标识
	// 2012-04-16 By Yi Minwen: 时间标签做成成员
	UILabel					*timeLabel;
}

@property (nonatomic, assign) int							controllerType;
@property (nonatomic, retain)  Info							*info;	
@property (nonatomic, assign) BOOL						isLongPress;
@property (nonatomic, retain)  AsyncImageView				*imageView;
@property (nonatomic, retain)  AsyncImageView				*videoView;
@property (nonatomic, assign) OriginShowSytle				showStyle;
@property (nonatomic, assign) id<OriginViewDelegate>		myOriginViewDelegate;
@property (nonatomic, assign) id<OriginViewUrlDelegate>	myOriginUrlDelegate;
@property (nonatomic, assign) id<OriginViewVideoDelegate>	myOriginVideoDelegate;


// 添加子视图方法
-(void)addSubViews;

+(NSMutableDictionary *)originViewUnitItemDic;
// 原创高度
+(NSMutableDictionary *) orgingHeight;
// 添加链接
- (void)addLink:(CGPoint)mPosition withTmpString:(NSString *)tempString withString:(NSString *)string withType:(NSUInteger)type;
// 添加链接
- (void)addLinkAt:(CGRect)rect withTmpString:(NSString *)tempString withString:(NSString *)string withType:(NSUInteger)type;
// 点击url响应
- (void)touchUrl:(id)sender;
// 点击图片
- (void)tapPhoto:(UITapGestureRecognizer *)gesture;
// 点击视频
- (void)tapVideo:(UITapGestureRecognizer *)gesture;
-(void)addMainText;
-(void)addSubViews;
-(void)addVideoPlayImageWithRul:(NSString *)url;
@end

// 2012-02-08 By Yi Minwen 
// 图片点击委托事件
@protocol OriginViewUrlDelegate<NSObject>
- (void)OriginViewUrlClicked:(NSString *)urlSource;
@end

// 视频点击事件
@protocol OriginViewVideoDelegate<NSObject>
- (void)OriginViewVideoClicked:(NSString *)urlVideo;
@end

@protocol OriginViewDelegate<NSObject>
@optional
// 图片和视频加载完毕委托方法
-(void)OriginViewHasLoadedImage;
@end
