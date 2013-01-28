//
//  RefreshView.h
//  iweibo
//
//  Created by wangying on 2/9/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RefreshView : UIView {
	UIImageView		*broadCastImage;
	UIImageView		*errorCastImage;
	UIImageView		*IconCastImage;
	UILabel			*broadCastLabel;
}

- (void)setErrorState;
- (void)moveDown;
- (void)moveUp;

@end
