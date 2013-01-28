//
//  WordsLeftView.h
//  iweibo
//
//	剩余字数视图控制
// 
//  Created by Minwen Yi on 12/31/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeConsts.h"


// 控件标记
#define WordsLeftBtnTag				500
#define	DeleteBtnTag				(WordsLeftBtnTag + 1)
// 标签字体大小
#define LabelFontSize				14.0f
// 按钮离右边间距
#define SpatiumBetweenRightEdge		5.0f

@protocol WordsLeftViewDelegate;

@interface WordsLeftView : UIView {
	UIButton					*wordsLeftButton;		// 字数显示按钮
	UIButton					*deleteButton;			// 删除按钮
	NSInteger					wordsLeftCounts;		// 剩余字数
	id<WordsLeftViewDelegate>	myWordsLeftViewDelegate;	
	
	BOOL						showDeleteBtn;			// 是否显示删除暗暗
}

@property (nonatomic, retain) UIButton					*wordsLeftButton;
@property (nonatomic, retain) UIButton					*deleteButton;	
@property (nonatomic, assign) NSInteger					wordsLeftCounts;
@property (nonatomic, assign) BOOL						showDeleteBtn;
@property (nonatomic, assign) id<WordsLeftViewDelegate>	myWordsLeftViewDelegate;
@end

@protocol WordsLeftViewDelegate <NSObject>
- (void)WordsLeftBtnClicked;		
@end