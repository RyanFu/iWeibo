//
//  VideoLinkUrl.m
//  iweibo
//
//  Created by ZhaoLilong on 2/12/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "VideoLinkUrl.h"


@implementation AsyncImageView(AddVaribles)

static const char *linkKey = "linkKey";

	// get方法
- (NSString *)link {
    return (NSString *)objc_getAssociatedObject(self, linkKey);
}
	// set方法
- (void)setLink:(NSString *)newLinkKey {
    objc_setAssociatedObject(self, linkKey, newLinkKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
