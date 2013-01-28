//
//  FriendSearchImageManager.m
//  iweibo
//
//  Created by Yi Minwen on 7/2/12.
//  Copyright (c) 2012 Beyondsoft. All rights reserved.
//

#import "FriendSearchImageManager.h"

@implementation FriendSearchImageManager
- (id)initWithDelegate:(id)delegate {
	if (self = [super init]) {
        // 清除掉除头像以外其它下载对象
        [imageDownloader release];
        imageDownloader = nil;
        [videoImageDownloader release];
        videoImageDownloader = nil;
        [sourceImageDownloader release];
        sourceImageDownloader = nil;
        [sourceVideoImageDownloader release];
        sourceVideoImageDownloader = nil;
	}
	return self;
}

@end
