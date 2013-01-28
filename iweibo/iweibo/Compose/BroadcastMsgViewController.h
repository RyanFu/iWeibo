//
//  BroadcastMsgViewController.h
//  iweibo
//
//	广播消息, 或者直接跟某人对话
//
//  Created by Minwen Yi on 12/28/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeBaseViewController.h"
#import "AttachedPictureView.h"
#import "AttachedPictureCtrlView.h"
#import "ShowMapViewController.h"
#import "UITableViewControllerEx.h"



#define PhotoFromCameraBtnFrame					CGRectMake(BtnLeftSpace, 27.0f, 23.0f, 22.0f)
#define PhotoFromLibraryBtnFrame				CGRectMake(AverageBtnWidth+BtnLeftSpace, 27.0f, 23.0f, 22.0f)
#define PinOfMapBtnFrame                        CGRectMake(2 *AverageBtnWidth+BtnLeftSpace, 27.0f, 23.0f, 22.0f)


#define PhotoFromCameraBtnTag					(MidBaseViewTag + 11)				// 照相 按钮
#define PhotoFromLibraryBtnTag					(MidBaseViewTag + 12)				// 相册 按钮
#define PinOfMapBtnTag                          (MidBaseViewTag + 999)               // 大头针 按钮


@interface BroadcastMsgViewController : ComposeBaseViewController< AttachedPictureViewDelegate, AttachedPictureCtrlViewDelegate,CLLocationManagerDelegate> {
	
	AttachedPictureView			*imageView;			// 拍照图像
	AttachedPictureCtrlView		*imageCtrlView;		// 点击附件时显示的图像
	BOOL						imageViewClicked;	// 是否点击了拍照图像
	BOOL						bPicPickEnabled;	// 是否启动照相和相片功能
//    BOOL                        pinOfMapClieked;    // 是否开启地图

//    ShowMapViewController       *   smvctrl;
//    UIImageView                 *   showToMapView;   // 点击到地图界面
//    CGSize                          size;            // label中内容长度
//    UILabel                     *   netErrorlabel;   // 存放网络状态
//    id                              _delegate;
//    SEL                             _getMap;
//    CLLocationManager           * gpsManger;         // 位置管理器
//    CGFloat                     userLatitude;        // 当前经度
//    CGFloat                     userLongitude;    // 当前纬度    


}

@property (nonatomic, retain) AttachedPictureView			*imageView;
@property (nonatomic, retain) AttachedPictureCtrlView		*imageCtrlView;		
@property (nonatomic, assign) BOOL							imageViewClicked;
@property (nonatomic, assign) BOOL							bPicPickEnabled;

// 用草稿内容初始化界面
- (id)initWithDraft:(Draft *)draftSource;
// 从界面更新草稿内容
- (void)UpdateDraft;
// 根据草稿更新界面
- (void)UpdateViewWithDraft:(Draft *)draftSource;
- (void)CancelCompose:(id) sender;
- (void)DoneCompose:(id) sender;
// 隐藏表情视图
- (void)hideDownBaseSubView;
// 隐藏表情之外的视图
- (void)hideDownBaseSubViewExceptEmotion;
// 隐藏表情之外的视图
- (void)hideDownBaseSubViewExceptAttImage;
//得到用户当前位置坐标
//-(void)getCurrentLocation;

@end
