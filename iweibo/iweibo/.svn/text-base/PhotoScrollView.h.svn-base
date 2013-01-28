//
//  PhotoScrollView.h
//  iweibo
//
//  Created by ZhaoLilong on 2/1/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotoScrollView : UIScrollView<UIScrollViewDelegate> {
	UIImageView *imageView;
}

@property (nonatomic, retain)UIImageView *imageView;

- (void)displayImage:(UIImage *)image;
- (void)setMaxMinZoomScalesForCurrentBounds;

- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;

@end
