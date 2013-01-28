//
//  CustomLink.m
//  iweibo
//
//  Created by ZhaoLilong on 1/30/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "CustomLink.h"

static const char *linkKey = "linkKey";

static const char *typeKey = "typeKey";

@implementation UIButton(AddVaribles)

	// get方法
- (NSString *)link {
    return (NSString *)objc_getAssociatedObject(self, linkKey);
}
	// set方法
- (void)setLink:(NSString *)newLinkKey {
    objc_setAssociatedObject(self, linkKey, newLinkKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)type{
	return (NSString *)objc_getAssociatedObject(self, typeKey);
}

- (void)setType:(NSString *)newTypeKey{
	objc_setAssociatedObject(self, typeKey, newTypeKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
