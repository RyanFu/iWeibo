//
//  SearchPage.h
//  iweibo
//
//  Created by LiQiang on 11-12-27.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchPageMainView.h"
#import "HotUserViewController.h"

extern NSString * const kThemeDidChangeNotification;

@interface SearchPage : UIViewController<SearchPageMainViewDelegate> {
    SearchPageMainView			*searchPageMainView;			// 主视图
	NSMutableArray				*btnTitleArray;					// 按钮标题数组
    UIImageView                 *searchImageView;
	BOOL						fromFront;
}

@property (nonatomic, retain) SearchPageMainView			*searchPageMainView;
@property (nonatomic, retain) NSMutableArray				*btnTitleArray;
@property (nonatomic, retain) UIImageView                   *searchImageView;

- (void)touchBtn:(NSString *)string;	// 点击按钮响应

@end
