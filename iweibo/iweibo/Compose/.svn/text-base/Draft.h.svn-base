//
//  Draft.h
//  iweibo
//
//	草稿
//
//  Created by Minwen Yi on 12/28/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComposeConsts.h"

@interface Draft : NSObject {
	
	NSString						*draftTitle;				// 标题
	UIImage							*ImageRef;					
	NSString						*fromDraftString;			// 从草稿箱进入到消息页面的文本信息
	NSNumber						*isFromDraft;				// 判断是否从草稿箱进入消息页面lichentao 12-03-09
	NSNumber						*fromDraftIndex;			// 判断是从草稿箱中第几个进去到消息页面
	NSData							*fromDraftAttachData;		// 从草稿箱进入消息页面图片资源
	NSString						*realUserName;				// 保存用户名
	NSString						*site;						// 站点信息
	BOOL							isFromHotTopic;			// 从热门话题进入消息页面
	// 草稿数据库保存的数据基本类型
	NSString						*uid;						// 微博的唯一id
	ComposeMsgType					draftType;					// 草稿类型// 代表发送的类型用数字表示1，广播，2，转播，3，评论，4，转播并评论，5，对话，6，意见反馈
	NSString						*draftText;					// 正文
	NSString						*timeStamp;					// 保存时间
	// 转播&&评论&&对话
	NSString						*draftForwardOrCommentName;	// 保存转播或者评论的名字
	NSString						*draftForwardOrCommentText;	// 保存转播或者评论的内容
	// 广播
	DraftAttachedDataType			attachedDataType;			// 附件类型
	NSData							*attachedData;				// 贴图二进制数据
	NSString						*location;					// 定位信息			
	NSNumber						*isHasPic;					// 是否有广播图片 || 转播/评论originView有图片
	NSString						*draftTypeContext;			// 类型对应的类型内容	
	NSString						*talkToUserName;			// 2012-02-01 By Yi Minwen:　假如为对话模式时，对话时用户名称
	BOOL							bWithGeocoding;				// 是否带经纬度
}

@property (nonatomic, assign) ComposeMsgType			draftType;
@property (nonatomic, retain) NSString					*draftTitle;
@property (nonatomic, retain) NSString					*draftText;
@property (nonatomic, assign) DraftAttachedDataType		attachedDataType;
@property (nonatomic, retain) NSData					*attachedData;
@property (nonatomic, retain) NSString					*uid;					
@property (nonatomic, retain) NSString					*timeStamp;				
@property (nonatomic, retain) UIImage					*ImageRef;	
@property (nonatomic, retain) NSString					*draftForwardOrCommentName;	
@property (nonatomic, retain) NSString					*draftForwardOrCommentText;	// 保存转播或者评论的内容
@property (nonatomic, retain) NSString					*location;
@property (nonatomic, retain) NSString					*talkToUserName;
@property (nonatomic, retain) NSNumber					*isHasPic;
@property (nonatomic, retain) NSString					*draftTypeContext;
@property (nonatomic, retain) NSNumber					*isFromDraft;
@property (nonatomic, retain) NSNumber					*fromDraftIndex;
@property (nonatomic, retain) NSString					*fromDraftString;
@property (nonatomic, retain) NSData					*fromDraftAttachData;
@property (nonatomic, retain) NSString					*realUserName;
@property (nonatomic, retain) NSString					*site;
@property (nonatomic, assign) BOOL						isFromHotTopic;

// 是否有数据
-(BOOL)hasData;
@end
