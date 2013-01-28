//
//  NoWebView.h
//  iweibo
//
//  Created by wangying on 2/9/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
	broadCastType = 0,
	listenType,
	audienceType,
	messageType,
	catalogSearchType,
	noTextType
}sourceType;

@interface NoWebView : UIView {
	UIImageView *imageView;
	UILabel  *label;
}

- (void)setState:(sourceType)type;

@end
