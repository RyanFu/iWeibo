//
//  HomelineCellEx.h
//  iweibo
//
//  Created by Minwen Yi on 4/13/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomelineCell.h"
#import "UIImageManager.h"
#import "Canstants.h"


@interface HomelineCellEx : HomelineCell<UIImageManagerDelegate> {
	UIImageManager			*imgManager;
	IconStatus				enumHeadStatus;
	IconStatus				enumOriginImageStatus;
	IconStatus				enumOriginVideoImgStatus;
	IconStatus				enumSrcImageStatus;
	IconStatus				enumSrcVideoStatus;
}

@property (nonatomic, retain) UIImageManager			*imgManager;

// 开始下载图片资源
- (void)startIconDownload;
@end
