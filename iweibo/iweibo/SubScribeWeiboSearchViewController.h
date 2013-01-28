//
//  SubScribeWeiboSearchViewController.h
//  iweibo
//
//	新版搜索页面
//
//  Created by Minwen Yi on 6/11/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomizedSiteInfo.h"
#import "IWeiboASyncApi.h"

// 最大显示个数
#define MAX_ITEM_COUNT          50
@interface SubScribeWeiboSearchViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate> {
	UITableView		*mainTableView;			// 数据表格
	UISearchBar		*itemSearchBar;			// 搜索框
	UIView			*blackCoverView;		// 搜索时的蒙层
	NSMutableArray	*arrItems;				// 保存搜索过滤后数据集合
	NSMutableArray	*arrItemsCopy;			// 原始未分组数据
	NSMutableArray	*arrSectionItems;			// 存放以字母a_z开头的数组的数据集合(没有搜索数据情况下默认数据源)
	IWeiboAsyncApi		*request;				// 网络请求api
	NSString			*siteUrl;			// 站点完整路径
	UIImage				*imgLogo;			// 站点logo信息
	UITextField			*tfSiteName;		// 搜索栏文本输入框
	id				idParentController;
    BOOL            bIsGettingInfo;         // 是否正在检测站点信息
}

@property (nonatomic, retain) UITableView		*mainTableView;
@property (nonatomic, retain) UISearchBar		*itemSearchBar;
@property (nonatomic, retain) UIView			*blackCoverView;
@property (nonatomic, retain) NSMutableArray	*arrItems;
@property (nonatomic, retain) NSMutableArray	*arrItemsCopy;
@property (nonatomic, retain) NSMutableArray	*arrSectionItems;
@property (nonatomic, copy) NSString			*siteUrl;
@property (nonatomic, retain) UIImage			*imgLogo;
@property (nonatomic, assign) id				idParentController;

// 初始化数据
-(void)initData;
@end
