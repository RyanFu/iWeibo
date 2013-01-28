//
//  ComposeConsts.h
//  iweibo
//
//  Created by Minwen Yi on 12/28/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

// 写消息窗体类型
typedef enum {
	INVALID_MESSAGE = 0,		
	BROADCAST_MESSAGE = 1,			// 撰写新消息
	FORWORD_MESSAGE,				// 转发消息
	COMMENT_MESSAGE,				// 评论消息
	REPLY_COMMENT_MESSAGE,			// 评论并转播消息
	TALK_TO_MESSAGE,				// 对话
	SUGGESTION_FEEDBACK_MESSAGE,	// 意见反馈lichentao 2012-03-06
}ComposeMsgType;

// 附件资源类型
typedef enum {
	INVALID_DATA = 0,
	PICTURE_DATA,			// 图片资源
	MEDIA_DATA,				// 视频资源
	AUDIO_DATA,				// 音频文件
} DraftAttachedDataType;

// 定义撰写界面字符最大个数
#define MaxInputWords							140
