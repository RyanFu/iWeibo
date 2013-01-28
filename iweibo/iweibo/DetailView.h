//
//  DetailView.h
//  iweibo
//
//  Created by wangying on 12/29/11.
//  Copyright 2011 bysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "UIImageManager.h"

@class DetailsPage;
@class Info;

@interface DetailView : UIView<UIImageManagerDelegate> {
	UIImageView		*headPortrait;
	UILabel			*headLabel;
	UILabel			*fromLabel;
	UILabel			*timeLabel;
	UIImageView		*vipImage;
    
    UIButton        *transmitCast;
    UIButton        *comment;
    UIButton        *more;
	DetailsPage		*parentController;
	Info			*baseInfo;
	int				rootContrlType;
	UIImageManager			*imgManager;
}

@property (nonatomic, retain) UIImageManager			*imgManager;
@property (nonatomic, assign) DetailsPage				*parentController;
@property (nonatomic, retain) Info						*baseInfo;
@property (nonatomic, retain) UIImageView				*headPortrait;
@property (nonatomic, assign) int						rootContrlType;

- (void)tapHead:(UITapGestureRecognizer *)gesture;

@end
