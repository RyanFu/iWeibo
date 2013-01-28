//
//  AsynchronousImageView.h
//  iweibo
//
//	图像加载(改编自AsyncImageView)
// 
//  Created by Minwen Yi on 1/13/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
	TypeInvalid = 0,
	TypeHead,
} MediaImageType;

typedef enum {
	RequestFromFriendsFansSearch = 1,	// 
} RequestType;

#define ImageHeadTag				500
#define ImageVipPicTag				(ImageHeadTag + 1)

@protocol AsynchronousImageViewDelegate
@optional
// 图像加载完成
-(void)AsynchronousImageViewDidFinishLoading:(UIView *)view;
@end

@interface AsynchronousImageView : UIView {
	NSURLConnection				*connection; //keep a reference to the connection so we can cancel download in dealloc
	NSMutableData				*data; //keep reference to the data so we can collect it as it downloads
	//but where is the UIImage reference? We keep it in self.subviews - no need to re-code what we have in the parent class
	NSMutableString				*imageUrlString;
	MediaImageType				requestType;
	BOOL						isVip;			// requestType为TypeHead下,标记头像是否为vip类型头像
	
	id<AsynchronousImageViewDelegate>	myAsynchronousImageViewDelegate;
}

@property (nonatomic, retain) NSMutableString					*imageUrlString;
@property (nonatomic, assign) id<AsynchronousImageViewDelegate>	myAsynchronousImageViewDelegate;
@property (nonatomic, assign) BOOL								isVip;

- (void)loadImageFromURL:(NSURL*)url;
- (UIImage*) image;

- (void)loadHeadImageFromURLString:(NSString *)urlString WithRequestType:(RequestType)requestType;
@end
