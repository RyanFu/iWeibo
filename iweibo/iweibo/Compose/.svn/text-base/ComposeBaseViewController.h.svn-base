//
//  ComposeBaseViewController.h
//  iweibo
//
//  Created by Minwen Yi on 12/28/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeConsts.h"
#import "Draft.h"
#import "EmotionView.h"
#import "DraftController.h"
#import "WordsLeftView.h"
#import "MyFavTopicSearchController.h"
#import "FriendSearchController.h"

// 定义中间按钮个数
#define MidViewBtnCount							5
// 按钮类型
enum {
	CameraBtnIndex = 0,
	PhotoBtnIndex = 1,
	FriendSearchBtnIndex = 2,
	TopicSearchBtnIndex = 3,
	EmotionSelectBtnIndex = 4,
};
// 按钮边框位置
#define AverageBtnWidth							(320.0f/MidViewBtnCount)
#define BtnLeftSpace							((AverageBtnWidth-23.0f)/2.0f)
#define FriendsearchBtnFrame					CGRectMake(AverageBtnWidth*(MidViewBtnCount-3)+BtnLeftSpace, 27.0f, 23.0f, 22.0f)
#define TopicSearchBtnFrame						CGRectMake(AverageBtnWidth*(MidViewBtnCount-2)+BtnLeftSpace, 27.0f, 23.0f, 22.0f)
#define	EmotionSelectBtnFrame					CGRectMake(AverageBtnWidth*(MidViewBtnCount-1)+BtnLeftSpace, 27.0f, 23.0f, 22.0f)

// 定义控件tag起始值
#define ComposeMainBaseViewTag					500
#define UpBaseViewTag							(ComposeMainBaseViewTag + 1)		// 基本区域: 顶部文本区
#define TextViewTag								(UpBaseViewTag + 1)					// 文本输入框

#define MidBaseViewTag							(ComposeMainBaseViewTag + 10)		// 基本区域: 中部文本区
#define AttachedImageViewTag					(MidBaseViewTag + 1)				// 附件贴图
#define AvalibleCharactersLeftImageViewTag		(MidBaseViewTag + 2)				// 剩余字数
//#define ReplyAndCommentBtnTag					(MidBaseViewTag + 10)				// 评论并转播 按钮
//#define PhotoFromCameraBtnTag					(MidBaseViewTag + 11)				// 照相 按钮
//#define PhotoFromLibraryBtnTag					(MidBaseViewTag + 12)				// 相册 按钮
#define FriendSearchBtnTag						(MidBaseViewTag + 13)				// 好友 按钮
#define TopicSearchBtnTag						(MidBaseViewTag + 14)				// 话题搜索 按钮
#define EmotionSelectBtnTag						(MidBaseViewTag + 15)				// 表情 按钮
#define CutlineImageViewTag						(MidBaseViewTag + 16)				// 分割线 
#define CleanWordsActionSheetTag				(MidBaseViewTag + 17)				// 清空文字提示框标记
#define CancelComposeActionSheetTag				(MidBaseViewTag + 18)				// 取消操作时提示框标记
#define DoneComposeActionSheetTag				(MidBaseViewTag + 19)				// 完成操作时提示框标记

#define DownBaseViewTag							(ComposeMainBaseViewTag + 30)		// 基本区域: 底部文本区

extern NSString *const kThemeDidChangeNotification;

@interface ComposeBaseViewController : UIViewController<UINavigationControllerDelegate,EmotionViewDelegate, UIImagePickerControllerDelegate,UITextViewDelegate
,DraftCtrllerGetSearchListDelegate, UIActionSheetDelegate, WordsLeftViewDelegate, FriendSearchControllerDelegate, MyFavTopicSearchControllerDelegate> {
	Draft				*draftComposed;		// 草稿
	
	UIView				*UpBaseView;		// 顶部(文本输入框部分)基础视图
	UIView				*MidBaseView;		// 中间部分基础视图
	UIView				*DownBaseView;		// 底部基础视图
	UIImageView			*cutlineImage;		// 底层分割线
	UITextView			*textView;			// 文本输入框
	NSRange				curSelectedRange;	// 光标位置
	EmotionView			*emotionView;		// 表情视图
	WordsLeftView		*wordsLeftView;		// 剩余字数视图
	BOOL				emotionBtnClickded;	// 表情按钮是否已选定
	BOOL				friendsSearchBtnClicked;
	NSMutableArray		*draftFavTopicsArray;	// 草稿中已涉及的收藏话题列表
	NSString			*typeString;		// 发送消息的类型lichentao存到数据库中
    UIButton            *leftButton;
}

@property (nonatomic, retain) UIView			*UpBaseView;		
@property (nonatomic, retain) UIView			*MidBaseView;		
@property (nonatomic, retain) UIView			*DownBaseView;		
@property (nonatomic, retain) UITextView		*textView;
@property (nonatomic, assign) NSRange			curSelectedRange;
@property (nonatomic, retain) Draft				*draftComposed;
@property (nonatomic, retain) EmotionView		*emotionView;
@property (nonatomic, retain) WordsLeftView		*wordsLeftView;
@property (nonatomic, assign) BOOL				emotionBtnClickded;
@property (nonatomic, assign) BOOL				friendsSearchBtnClicked;
@property (nonatomic, retain) NSMutableArray	*draftFavTopicsArray;
@property (nonatomic, retain) UIImageView		*cutlineImage;
@property (nonatomic, retain) NSString			*typeString;

// 用草稿内容初始化界面(当前只处理文本部分)
- (id)initWithDraft:(Draft *)draftSource;
// 从界面更新草稿内容
- (void)UpdateDraft;
// 根据草稿更新界面
- (void)UpdateViewWithDraft:(Draft *)draftSource;
// 取消撰写消息
- (void)CancelCompose:(id) sender;
// 完成并发送消息
- (void)DoneCompose:(id) sender;
// 隐藏表情视图
- (void)hideDownBaseSubView;
// 隐藏表情之外的视图
- (void)hideDownBaseSubViewExceptEmotion;
// 文本框相关
// 插入字符串到光标位置
- (void)insertTextAtCurrentIndex:(NSString *)contextStr;
// 设置文本框为输入状态
- (void)setTextViewIsFirstResponser:(BOOL)isFirstResponser;
// 草稿已字典形式保存导数据库lichetnao 2012-03-06
- (void)setDraft;
// 显示UIActionSheet
- (void)showUIActionMenu;
// 中间底层背景按钮点击响应事件
- (void)btnTaped:(UITapGestureRecognizer *)recognizer;

+ (int)calcStrWordCount:(NSString *)str;
+ (NSString *)getSubString:(NSString *)strSource WithCharCounts:(NSInteger)number;
@end
