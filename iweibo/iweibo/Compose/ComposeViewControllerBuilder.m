//
//  ComposeViewControllerBuilder.m
//  iweibo
//
//  Created by Minwen Yi on 12/28/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "ComposeViewControllerBuilder.h"
#import "BroadcastMsgViewController.h"
#import "CommentMsgViewController.h"
#import "ForwardMsgViewController.h"
#import "TalkToMsgViewController.h"
#import "SuggestionFeedController.h"

@implementation ComposeViewControllerBuilder

+ (ComposeBaseViewController *)createWithComposeMsgType:(ComposeMsgType) enumType {
	ComposeBaseViewController *viewController = nil;
	switch (enumType) {
		case BROADCAST_MESSAGE: {
			viewController = [[BroadcastMsgViewController alloc] init];
		}
			break;
		case FORWORD_MESSAGE: {
			viewController = [[ForwardMsgViewController alloc] init];
		}
			break;
		case COMMENT_MESSAGE: {
			viewController = [[CommentMsgViewController alloc] init];
		}
			break;
		case REPLY_COMMENT_MESSAGE: {
			assert(NO);
		}
			break;
		case TALK_TO_MESSAGE: {
			viewController = [[TalkToMsgViewController alloc] init];
		}
			break;

		default:
			assert(NO);
			break;
	}
	assert(viewController != nil);
	return [viewController autorelease];
}

+ (ComposeBaseViewController *)createWithDraft:(Draft *)draft {
	ComposeBaseViewController *viewController = nil;
	switch (draft.draftType) {
		case BROADCAST_MESSAGE: {
			viewController = [[BroadcastMsgViewController alloc] initWithDraft:draft];
		}
			break;
		case FORWORD_MESSAGE: {
			viewController = [[ForwardMsgViewController alloc] initWithDraft:draft];
		}
			break;
		case COMMENT_MESSAGE: {
			viewController = [[CommentMsgViewController alloc] initWithDraft:draft];
		}
			break;
		case REPLY_COMMENT_MESSAGE: {
			assert(NO);
		}
			break;
		case TALK_TO_MESSAGE: {
			viewController = [[TalkToMsgViewController alloc] initWithDraft:draft];
		}
			break;
		case SUGGESTION_FEEDBACK_MESSAGE:{// lichentao 2012-03-06意见反馈
			viewController = [[SuggestionFeedController alloc] initWithDraft:draft];
		}
			break;	
		default:
			assert(NO);
			break;
	}
	assert(viewController != nil);
	return [viewController autorelease];
}

+ (void)desposeViewController:(ComposeBaseViewController *)viewController {
	[viewController release];
}
@end
