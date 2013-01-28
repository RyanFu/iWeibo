//
//  MessageUnitItemInfo.m
//  iweibo
//
//  Created by Minwen Yi on 4/18/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "MessageUnitItemInfo.h"


@implementation MessageUnitItemInfo
@synthesize itemText, itemLink, itemType, itemPos, itemRect;

-(id)initItem:(NSString *)strText withType:(UnitItemType)type link:(NSString *)strLink andPos:(CGPoint)pos {
	if (self = [super init]) {
		self.itemText = strText;
		self.itemType = type;
		self.itemLink = strLink;
		self.itemPos = pos;
        self.itemRect = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
	}
	return self;
}

// 新版，增加高度
-(id)initItem:(NSString *)strText withType:(UnitItemType)type link:(NSString *)strLink andFrame:(CGRect)rect {
    if (self = [super init]) {
		self.itemText = strText;
		self.itemType = type;
		self.itemLink = strLink;
		self.itemPos = rect.origin;
        self.itemRect = rect;
	}
	return self;
}

-(NSString *)description {
	NSString *des = [NSString stringWithFormat:@"itemText:%@, Type:%d, Link:%@, rect=%@", itemText, itemType, itemLink, NSStringFromCGRect(self.itemRect)];
	return des;
}

-(void)dealloc {
	[itemText release];
	[itemLink release];
	[super dealloc];
}
@end
