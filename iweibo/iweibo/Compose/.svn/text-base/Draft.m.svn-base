//
//  Draft.m
//  iweibo
//
//  Created by Minwen Yi on 12/28/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "Draft.h"


@implementation Draft

@synthesize draftTitle;
@synthesize draftType;
@synthesize draftText;
@synthesize attachedDataType;
@synthesize attachedData;
@synthesize ImageRef;
@synthesize uid;
@synthesize timeStamp;
@synthesize draftForwardOrCommentName;
@synthesize draftForwardOrCommentText;
@synthesize location;
@synthesize talkToUserName,site;
@synthesize isHasPic,draftTypeContext,isFromDraft,fromDraftIndex,fromDraftString,fromDraftAttachData,realUserName;
@synthesize isFromHotTopic;

- (Draft *)init {
	if (self = [super init]) {
		// 额外初始化操作
		self.draftType = INVALID_MESSAGE;
		draftText = nil;
		self.attachedDataType = INVALID_DATA;
		attachedData = nil;
	}
	return self;
}

- (void)dealloc
{
	self.draftTitle					= nil;
	self.ImageRef					= nil;
	self.fromDraftString			= nil;
	self.isFromDraft				= nil;
	self.fromDraftIndex				= nil;
	self.fromDraftAttachData		= nil;
	self.realUserName				= nil;
	self.uid						= nil;
	self.draftText					= nil;
	self.timeStamp					= nil;
	self.draftForwardOrCommentName	= nil;
	self.draftForwardOrCommentText	= nil;
	self.attachedData				= nil;
	self.location					= nil;
	self.isHasPic					= nil;
	self.draftTypeContext			= nil;
	self.talkToUserName				= nil;
	self.site						= nil;
    [super dealloc];
}

// 重载set方法
- (void)setDraftText:(NSString *)text {
	if (draftText != text) {
		[draftText release];
		draftText = [text retain];
	}
}

// 重载set方法
- (void)setAttachedData:(NSData *)data {
	if (attachedData != data) {
		[attachedData release];
		attachedData = [data retain];
	}
}

-(BOOL)hasData {
	BOOL bResult = NO;
	switch (draftType) {
		case BROADCAST_MESSAGE:
		case SUGGESTION_FEEDBACK_MESSAGE:	// lichentao 意见反馈
		{			// 广播消息
			bResult = ([draftText length] > 0 || [attachedData length] > 0) ? YES:NO;
		}
			break;
		case TALK_TO_MESSAGE:
		case FORWORD_MESSAGE: 
		case COMMENT_MESSAGE:
		case REPLY_COMMENT_MESSAGE:
		{			
			bResult = [draftText length] > 0 ? YES:NO;
		}
			break;
		default:
			break;
	}
	return bResult;
}

@end
