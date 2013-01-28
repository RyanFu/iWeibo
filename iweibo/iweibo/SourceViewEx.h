//
//  SourceViewEx.h
//  iweibo
//
//  Created by Minwen Yi on 4/13/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SourceView.h"
#import "IWBGifImageView.h"

@interface SourceViewEx : SourceView {
	IWBGifImageView		*imageViewEx;				// 转发图片
	IWBGifImageView		*videoImageEx;				// 转发视频缩略图

}

@property (nonatomic, retain) IWBGifImageView		*imageViewEx;
@property (nonatomic, retain) IWBGifImageView		*videoImageEx;
@end
