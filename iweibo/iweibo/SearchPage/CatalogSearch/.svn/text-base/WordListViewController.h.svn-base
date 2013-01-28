//
//  WordListViewController.h
//  iweibo
//
//  Created by ZhaoLilong on 2/26/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

// 传值代理
@protocol PassValueDelegate

- (void)passValue:(NSString *)value;

@end

// 隐藏键盘代理
@protocol HideKeyBoardDelegate

- (void)hide;

@end
 
@interface WordListViewController : UITableViewController <UIScrollViewDelegate>{
	UILabel						*label;							// 该label作为tableview的footerview，能够去除cell剩下的横线
	NSString					*searchText;						// 搜索文本
	NSString					*selectedText;					// 选中的文本
	NSMutableArray				*resultList;						// 结果列表
	id <PassValueDelegate>		passValueDelegate;				// 传值代理
	id <HideKeyBoardDelegate>	hideKeyBoardDelegate;			// 隐藏键盘代理
}

@property (nonatomic, copy) NSString *searchText;

@property (nonatomic, copy) NSString *selectedText;

@property (nonatomic, retain) NSMutableArray *resultList;

@property (nonatomic, assign) id <PassValueDelegate> passValueDelegate;

@property (nonatomic, assign) id <HideKeyBoardDelegate> hideKeyBoardDelegate;

// 刷新补全列表
- (void)updateData;

@end
