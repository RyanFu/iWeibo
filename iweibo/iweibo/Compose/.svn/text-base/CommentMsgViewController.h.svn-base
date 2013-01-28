//
//  CommentMsgViewController.h
//  iweibo
//
//	评论消息
//
//  Created by Minwen Yi on 12/28/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeBaseViewController.h"


#define ReplyAndCommentBtnTag					(MidBaseViewTag + 10)				// 评论并转播 按钮

@interface CommentMsgViewController : ComposeBaseViewController {
	UIButton *replyAndCommentBtn;			// 转播并评论 按钮
	BOOL		withBroadcast;				// 是否转播
	Info		*homeInfo;					// 由homePage封装的数据
}

@property (nonatomic, assign) BOOL		withBroadcast;
@property (nonatomic, retain) Info		*homeInfo;
// 用草稿内容初始化界面(当前只处理文本部分)
- (id)initWithDraft:(Draft *)draftSource;
// 从界面更新草稿内容
- (void)UpdateDraft;
// 根据草稿更新界面
- (void)UpdateViewWithDraft:(Draft *)draftSource;
- (void)CancelCompose:(id) sender;
- (void)DoneCompose:(id) sender;
@end
