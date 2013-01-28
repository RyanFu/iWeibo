//
//  OriginViewEx.h
//  iweibo
//
//  Created by Minwen Yi on 4/13/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OriginView.h"
#import "IWBGifImageView.h"
#import <MapKit/MapKit.h>

//声明代理
@protocol OriginViewMapDelegate;


@interface OriginViewEx : OriginView<MKMapViewDelegate,MKAnnotation> {
	IWBGifImageView		*imageViewEx;		// 图片
	IWBGifImageView		*videoViewEx;		// 视频图片
    id<OriginViewMapDelegate> myOriginViewMapDelegate;
}

@property(nonatomic, retain) IWBGifImageView		*imageViewEx;
@property(nonatomic, retain) IWBGifImageView		*videoViewEx;	
@property(nonatomic, assign) id<OriginViewMapDelegate> myOriginViewMapDelegate;

@end

//地图缩略图点击事件
@protocol OriginViewMapDelegate <NSObject>

-(void)OrignViewMapClicked:(CLLocationCoordinate2D)center;

@end
