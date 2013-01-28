//
//  SearchPageFirstView.h
//  iweibo
//
//	搜索页面第一个基础页面视图
//
//  Created by Minwen Yi on 2/23/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const kThemeDidChangeNotification;

// 控件tag标记
// 背景视图
#define SPVBgViewTag						1000
// 话题按钮
#define SPVFirstTopicBtnTag					(SPVBgViewTag + 1)
#define SPVSecondTopicBtnTag				(SPVBgViewTag + 2)
#define SPVThirdTopicBtnTag					(SPVBgViewTag + 3)
#define SPVFourthTopicBtnTag				(SPVBgViewTag + 4)
#define SPVFifthTopicBtnTag					(SPVBgViewTag + 5)
#define SPVMoreTopicBtnTag					(SPVBgViewTag + 6)

// 各热门按钮
#define SPVHotTopicBtnTag					(SPVBgViewTag + 7)
#define SPVHotUserBtnTag					(SPVBgViewTag + 8)
#define SPVHotBroadcastMsgBtnTag			(SPVBgViewTag + 9)

// 协议
@protocol SearchPageFirstViewDelegate<NSObject>
@optional
// 按钮点击事件
// infoBtn:相应参数信息
-(void)SearchPageFirstViewBtnClicked:(UIButton *)btnClicked withInfo:(id)infoBtn;

@end

@interface SearchPageFirstView : UIView<UITableViewDelegate,UITableViewDataSource> {

	UIButton				*firstTopicBtn;				// 第一个热门话题按钮
	UIButton				*secondTopicBtn;			// 第二个热门话题按钮
	UIButton				*thirdTopicBtn;				// 第三个热门话题按钮
	UIButton				*fourthTopicBtn;			// 第四个热门话题按钮
	UIButton				*fifthTopicBtn;				// 第五个热门话题按钮
	UIButton				*moreTopicBtn;				// "更多"话题按钮
	UIButton				*hotTopicBtn;				// 热门话题　按钮
	UIButton				*hotUserBtn;				// 热门用户　按钮
	UIButton				*hotBroadcastMsgBtn;		// 热门广播　按钮
    UILabel                 *hotTopicLabel;
    UILabel                 *hotBroadcastLabel;
    UILabel                 *hotUserLabel;
			
    NSString            *themePath;
	NSMutableArray		*btnTitleArray;			// 按钮标题数组
    UIImageView         *bgImageView;
	UITableView         *changedTable;
    NSArray             *changedArray;
    NSArray             *changedCellImage;
    NSArray             *sepatorArray;
	id<SearchPageFirstViewDelegate>	mySearchPageFirstViewDelegate;
}

@property(nonatomic, retain) UIButton				*firstTopicBtn;				// 第一个热门话题按钮
@property(nonatomic, retain) UIButton				*secondTopicBtn;			// 第二个热门话题按钮
@property(nonatomic, retain) UIButton				*thirdTopicBtn;				// 第三个热门话题按钮
@property(nonatomic, retain) UIButton				*fourthTopicBtn;			// 第四个热门话题按钮
@property(nonatomic, retain) UIButton				*fifthTopicBtn;				// 第五个热门话题按钮
@property(nonatomic, retain) UIButton				*moreTopicBtn;				// "更多"话题按钮
@property(nonatomic, retain) UIButton				*hotTopicBtn;				// 热门话题　按钮
@property(nonatomic, retain) UIButton				*hotUserBtn;				// 热门用户　按钮
@property(nonatomic, retain) UIButton				*hotBroadcastMsgBtn;		// 热门广播　按钮
@property(nonatomic, retain) UILabel                *hotBroadcastLabel;
@property(nonatomic, retain) UILabel                *hotTopicLabel;
@property(nonatomic, retain) UILabel                *hotUserLabel;
@property(nonatomic, retain) NSMutableArray         *btnTitleArray;		
@property(nonatomic, assign) id<SearchPageFirstViewDelegate>	mySearchPageFirstViewDelegate;

- (void)setBtnTitleToWhite;

@end
