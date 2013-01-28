//
//  SelectWeiboPage.h
//  iweibo
//
//  Created by Cui Zhibo on 12-5-14.
//  Copyright (c) 2012年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomizedSiteInfo.h"
#import "IWBSvrSettingsManager.h"
#import "WeiboDetailsPage.h"
#import "MyWBIconView.h"
#import "MySubView.h"
#import "MyScrollView.h"

#define NavbgHight  46

@interface SelectWeiboPage : UIViewController<UIScrollViewDelegate>{
    UIPageControl       *pageControl;              // 站点页页数控制器
    MyScrollView        *scrollview;               // 放置站点icon的滚动视图
    NSMutableArray      *allDelateBtn;             // 存放可删除的按钮
    NSMutableArray      *allDelateImg;             // 存放可删除的按钮图片
    int                 selectTag;
    
    int                 btnTag;
    BOOL				isDownloadingTheme;
    IWeiboAsyncApi      *iWeiboAsyncApi;
    NSDictionary		*dicThemeResult;            // 保存主题缓存信息
    CustomizedSiteInfo  *cusinfo;
    id                  idParentController;
    
    BOOL				isCancelledFromBackground;	// 是否切换到后台并且取消图片下载
    UIView              *bigViewForIcon;            // 点击Icon时出现的蒙层
    UIView              *bigView;                   // 遮挡视图
    UIView              *navCoverView;              // 遮挡导航条视图
    UIPageControl       *pageForFirstView;          // 程序第一次启动时页数控制器
    
}

@property (nonatomic, retain) NSDictionary          *dicThemeResult;
// 从本地获得数据 
- (void) achieveInfoFromLocal;
// 完成
-(void)doneServerPreparation;
// 获取主题信息
-(void)getThemeInfo;
// 程序第一次启动时添加介绍页面视图
- (void) theAppFirstStartView;
// 重新展示视图
- (void)showViewAgain;
@end
