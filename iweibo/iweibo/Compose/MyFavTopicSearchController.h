//
//  MyFavTopicSearchController.h
//  iweibo
//
//  Created by Minwen Yi on 1/1/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HeadBtnTag			400

@protocol MyFavTopicSearchControllerDelegate <NSObject>
- (void)topicItemClicked:(NSString *)topicItemName;
- (void)topicCancelBtnClicked;
@end


@interface MyFavTopicSearchController : UIViewController<UIScrollViewDelegate, UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
	NSMutableArray							*topicsArray;
	NSMutableArray							*topicsArrayCopy; 
	UITableView								*myFavTopicsTableList;		// 话题列表
	UISearchBar								*myFavTopicsSearchBar;		// 搜索框
	id<MyFavTopicSearchControllerDelegate>	topicSearchDelegate;
}

@property (nonatomic, retain) NSMutableArray		*topicsArray;
@property (nonatomic, retain) NSMutableArray		*topicsArrayCopy;
@property (nonatomic, retain) UITableView			*myFavTopicsTableList;
@property (nonatomic, retain) UISearchBar			*myFavTopicsSearchBar;
@property (nonatomic, assign) id<MyFavTopicSearchControllerDelegate>	topicSearchDelegate;
@end
