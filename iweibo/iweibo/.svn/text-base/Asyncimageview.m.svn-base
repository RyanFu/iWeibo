//
//  Asyncimageview.m
//  iweibo
//
//  Created by ZhaoLilong on 12/30/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "AsyncImageView.h"
#import "Database.h"
#import "FMDatabase.h"
#import "Info.h"
#import "TransInfo.h"
#import "MessageFrameConsts.h"
#import "ColorUtil.h"
#import "HotBroadcastInfo.h"

@implementation AsyncImageView
@synthesize keyUrl;
@synthesize requestType;
@synthesize requestId;
@synthesize mImage;
@synthesize refresh;
@synthesize activityIndicator;
@synthesize myAsyncImageViewDelegate;
@synthesize videoLink;
@synthesize myTapHeadDelegate;
@synthesize connection;

- (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size    
{    
    UIGraphicsBeginImageContext(size);										// 创建一个bitmap的context，并把它设置成为当前正在使用的context
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];				// 绘制改变大小的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();	// 从当前context中创建一个改变大小后的图片    
    UIGraphicsEndImageContext();											// 使当前的context出堆栈    
    return scaledImage;													// 返回新的改变大小后的图片
} 

-(UIImage *)smallImage:(UIImage *)bigImg
{
	CGSize imgsize = bigImg.size;													 // 获取图片尺寸
	NSInteger w = imgsize.width>imgsize.height?imgsize.height:imgsize.width;			 // 获取宽和高中的最大值
	CGRect rect;											
	if(imgsize.width>imgsize.height)												 // 定位图片
	{
		rect = CGRectMake((imgsize.width-imgsize.height)/2, 0, w, w);
	}
	else {
		rect = CGRectMake(0, (imgsize.height-imgsize.width)/2, w, w);
	}
	CGImageRef imageRef = CGImageCreateWithImageInRect([bigImg CGImage], rect);// 创建指定尺寸的图片
	UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];				  // 生成图片
	CGImageRelease(imageRef);													  // 释放资源
	return croppedImage;
}

- (id)init {
	self = [super init];
	if (self != nil) {
		self.requestType = 0;
		self.requestId = nil;
		self.keyUrl = nil;
	}
	return self;
}

- (void)dealloc {
	[connection cancel]; // 如果url正在下载，先取消链接
	[connection release];
	connection = nil;
	[data release]; 
	[keyUrl release];
	[requestId release];
	[super dealloc];
}

- (void)addHeadImageFromData:(NSData *)imageData {
	
	UIImageView* imageView = [[UIImageView alloc] init];
	if (imageData) {
		UIImage *image = [UIImage imageWithData:imageData];
		if (image) {
			imageView.image = image;			 // 如果有图则显示图像
		}
		else {
			imageView.image = [UIImage imageNamed:@"compseLogo.png"];	 // 如果没图显示默认图片
		}
		
	}
	else {
		imageView.image = [UIImage imageNamed:@"compseLogo.png"];	 // 如果没图显示默认图片
	}
	for (UIView *_view in self.subviews) {
		[_view removeFromSuperview];
	}
	imageView.contentMode = UIViewContentModeScaleAspectFit;									    // 图片自适应
	imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight ); // 图片宽高自适应
	[self addSubview:imageView];
	[imageView release];
	imageView.frame = self.bounds;																    // 将图片的大小设置成自身大小
	[imageView setNeedsLayout];																	    // 刷新图片
	//[self setNeedsLayout];																		    // 刷新本身
	imageView = nil;
}

- (void)addVideoFromData:(NSData *)mediaData{
	UIImageView* imageView = [[UIImageView alloc] init];
	if (mediaData) {
		//UIImage *image = [self originImage:[UIImage imageWithData:mediaData] scaleToSize:CGSizeMake(75, 75)]
		UIImage *image = [self smallImage:[UIImage imageWithData:mediaData]];
		if (image != nil) {
			imageView.image = image;
			//imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:mediaData]];
		}
		else {
			imageView.image = [UIImage imageNamed:@"视频默认图片.png"];
		}

	}
	else {
		imageView.image = [UIImage imageNamed:@"视频默认图片.png"];
	}
	// 2012-03-20 By Yi Minwen 清除之前视图
	for (UIView *_view in self.subviews) {
		[_view removeFromSuperview];
	}
	imageView.contentMode = UIViewContentModeScaleAspectFit; 
	imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight );
	[self addSubview:imageView];
	[imageView release];
	imageView.frame = self.bounds;
	[imageView setNeedsLayout];
	imageView = nil;
	//[self setNeedsLayout];	
}

- (void)addImageFromData:(NSData *)imageData viewLocation:(NSUInteger)location{
	UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
	if (imageData) {
		//UIImage *image = [self originImage:[UIImage imageWithData:imageData] scaleToSize:CGSizeMake(75, 75)];
		UIImage *image = [UIImage imageWithData:imageData];
		if (image != nil) {
			CGImageRef myImage;
			if (location == 0) {
				if (image.size.height > image.size.width) {
					myImage = CGImageCreateWithImageInRect([image CGImage],CGRectMake(0, 0, image.size.width, image.size.width));
					imageView.image = [UIImage imageWithCGImage:myImage];
				}else{
					myImage = CGImageCreateWithImageInRect([image CGImage],CGRectMake(0, 0, image.size.height, image.size.height));
					imageView.image = [UIImage imageWithCGImage:myImage];
				}
			}else {
				myImage = CGImageCreateWithImageInRect([image CGImage],CGRectMake(0, 0, image.size.width, image.size.height));
				imageView.image = [UIImage imageWithCGImage:myImage];
			}
			CGImageRelease(myImage);
		}
		else {
			imageView.image = [UIImage imageNamed:@"imageDefault.png"];
		}
	}
	else {
		imageView.image = [UIImage imageNamed:@"imageDefault.png"];
	}
	// 2012-03-20 By Yi Minwen 清除之前视图
	for (UIView *_view in self.subviews) {
		[_view removeFromSuperview];
	}
	//imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight );
	[self addSubview:imageView];
	[imageView release];
	//NSLog(@"imageViewRetainCount:%d",[imageView retainCount]);
	imageView.frame = self.bounds;
	[imageView setNeedsLayout];
	//[self setNeedsLayout];	
	imageView = nil;
	//NSLog(@"imageViewRetainCountx:%d",[imageView retainCount]);
}
// 根据不同页面位置添加图片
// bFrame:是否加边框
- (void)addImageFromData:(NSData *)imageData viewLocation:(NSUInteger)location withFrame:(BOOL)bFrame {
	UIImageView* imageView = nil;
	if (imageData) {
		//UIImage *image = [self originImage:[UIImage imageWithData:imageData] scaleToSize:CGSizeMake(75, 75)];
		UIImage *image = [UIImage imageWithData:imageData];
		if (image != nil) {
			imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
			CGImageRef myImage;
			if (location == 0) {
				if (image.size.height > image.size.width) {
					myImage = CGImageCreateWithImageInRect([image CGImage],CGRectMake(0, 0, image.size.width, image.size.width));
					imageView.image = [UIImage imageWithCGImage:myImage];
				}else{
					myImage = CGImageCreateWithImageInRect([image CGImage],CGRectMake(0, 0, image.size.height, image.size.height));
					imageView.image = [UIImage imageWithCGImage:myImage];
				}
			}else {
				myImage = CGImageCreateWithImageInRect([image CGImage],CGRectMake(0, 0, image.size.width, image.size.height));
				imageView.image = [UIImage imageWithCGImage:myImage];
			}
			CGImageRelease(myImage);
		}
		else {
			imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imageDefault.png"]];
		}
	}
	else {
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imageDefault.png"]];
	}
	// 2012-03-20 By Yi Minwen 清除之前视图
	for (UIView *_view in self.subviews) {
		[_view removeFromSuperview];
	}
	//imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight );
	[self addSubview:imageView];
	// 有边框
	if (bFrame) {
		// 加边框
//		线框：2px，颜色：c1c1c1。
//		图片到线框的距离为：4px
		//self.backgroundColor = [UIColor colorStringToRGB:@"c1c1c1"];
		self.backgroundColor = [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
		UIImageView* imageViewBack = [[UIImageView alloc]initWithFrame:CGRectMake(ImageFrameWidth / 2.0f, ImageFrameWidth / 2.0f, 
																 self.bounds.size.width - ImageFrameWidth, self.bounds.size.height - ImageFrameWidth)];
		[self addSubview:imageViewBack];
		[imageViewBack release];
		imageViewBack.backgroundColor = [UIColor whiteColor];
		[imageViewBack addSubview:imageView];
		imageView.frame = CGRectMake(ImageFrameWidth / 2.0f, ImageFrameWidth / 2.0f, imageViewBack.frame.size.width - ImageFrameWidth, imageViewBack.frame.size.height - ImageFrameWidth);
	}
	else {
		[self addSubview:imageView];
		imageView.frame = self.bounds;
	}
	[imageView release];
	[imageView setNeedsLayout];
	[self setNeedsLayout];	
}

//处理多媒体音频，视频，头像信息
- (void)handleMediaData:(NSString *)url{
	NSURL *urlSourceImage = [NSURL URLWithString:url];
	if ([url length]>10) {
		[self addImageFromData:nil viewLocation:0];
		if (self.keyUrl) {
			[keyUrl release];
			self.keyUrl = nil;
		}
		[self loadImageFromURL:urlSourceImage withType:self.requestType];
	}
}

- (void)handleVideoData:(NSString *)url{
	NSURL *urlSourceImage = [NSURL URLWithString:url];
	if ([url length]>10) {
		[self addVideoFromData:nil];
		if (self.keyUrl) {
			[keyUrl release];
			self.keyUrl = nil;
		}
		[self loadImageFromURL:urlSourceImage withType:self.requestType];
	}
}

// 根据传入的参数请求相应的数据
- (void)loadImageFromURL:(NSString*)url withType:(MultiMediaType)type userId:(NSString *)userId {
	//if (connection!=nil) { 
//		// 2012-02-28 By Yi Minwen 假如上一次未执行完，则不做处理
//		//CLog(@"%s, url:%@", __FUNCTION__, url);
//		return; 
//	} 
    self.requestType = type;
	self.requestId = userId;
	[self handleMediaData:url];
}

- (void)loadVideoImageFromURL:(NSString*)url withType:(MultiMediaType)type userId:(NSString *)userId {
    self.requestType = type;
	self.requestId = userId;
	[self handleVideoData:url];
}

- (void)loadImageFromURL:(NSURL*)url withType:(MultiMediaType)type {
	if (connection!=nil) { [connection cancel]; [connection release]; } 
	if (data!=nil) { [data release]; data = nil;}

	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; 
}

- (void)loadImageFromURL:(NSURL*)url withType:(MultiMediaType)type userId:(NSString *)userId refresh:(BOOL)r{
	//if (connection!=nil) { 
//		// 2012-02-28 By Yi Minwen 假如上一次未执行完，则不做处理
//		//CLog(@"%s, url:%@", __FUNCTION__, url);
//		return; 
//	} 
		// 先加载一个默认图片
	// 2012-03-30 
	//if ([[self subviews] count]>0) {
//		[[[self subviews] objectAtIndex:0] removeFromSuperview]; 
//	}
	// 2012-03-20 By Yi Minwen 清除之前视图
	for (UIView *_view in self.subviews) {
		[_view removeFromSuperview];
	}
	self.requestType = type;
	self.requestId = userId;
	UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imageDefault.png"]];
	activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(27.0f, 27.0f, 25.0f, 25.0f)];
	[activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
	[imageView addSubview:activityIndicator];
	[self.activityIndicator startAnimating];
	[self addSubview:imageView];
	[imageView release];
	refresh = YES;
	
	if (connection!=nil) { [connection cancel]; [connection release]; } //如果有第二张图片在下载，则释放当前连接
	if (data!=nil) { [data release]; data = nil;}
	//self.keyUrl = url;
	//self.keyUrl = [url 
	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; 
}

// 接收返回的数据
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (data==nil) { data = [[NSMutableData alloc] initWithCapacity:2048]; } 
	[data appendData:incrementalData];
}

// 连接返回失败
- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error{
//	[self.connection cancel];
//	[self.connection release];
	self.connection = nil;
}

-(void)updateImageDataToDB:(NSDictionary *)dic {
	NSData *dt = [dic objectForKey:@"DATA"];
	UIImage *img = [UIImage imageWithData:dt];
	NSString *strType = [dic objectForKey:@"TYPE"];
	NSString *strID = [dic objectForKey:@"ID"];
	//	BOOL bNeedFrame = NO;
	switch ([strType intValue]) {
		case multimediatypeNone:
		{
			// 不处理这些值
		}
			break;
		case multiMediaTypeHead:
			if (img) {
				[Info updateHeadData:dt withUrl:strID];
			}
			break;
		case multiMediaTypeImage:
			if (img) {
				[Info updateImageData:dt withUrl:strID];
			}
			break;
		case multiMediaTypeVideo:
			if (img) {
				[Info updateVideoData:dt withUrl:strID];
			}
			break;
		case multiMediaTypeSourceImage:
			if (img) {
				[TransInfo updateSourceImageData:dt withUrl:strID];
			}
			break;
		case multiMediaTypeSourceVideo:
			if (img) {
				[TransInfo updateSourceVideoData:dt withUrl:strID];
			}
			break;
		case multiMediaTypeMsgHead:
			if (img) {
				[Info updateMsgHeadData:dt withUrl:strID];
			}
			break;
		case multiMediaTypeMsgImage:
			if (img) {
				[Info updateMsgImageData:dt withUrl:strID];
			}
			break;
		case multiMediaTypeMsgVideo:
			if (img) {
				[Info updateMsgVideoData:dt withUrl:strID];
			}
			break;
		case multiMediaTypeMsgSourceImage:
			if (img) {
				[TransInfo updateMsgSourceImageData:dt withUrl:strID];
			}
			break;
		case multiMediaTypeMsgSourceVideo:
			if (img) {
				[TransInfo updateMsgSourceVideoData:dt withUrl:strID];
			}
			break;
		case multiMediaTypeHotBroadcastVideo:
			if (img) {
				[HotBroadcastInfo updateHotBroadCastVideoData:dt withUrl:strID];
			}
			break;
		case multiMediaTypeHotBroadcastImage:
			if (img) {
				[HotBroadcastInfo updateHotBroadCastImageData:dt withUrl:strID];
			}
			break;
		case multiMediaTypeHotBroadcastHead:
			if (img) {
				[HotBroadcastInfo updateHotBroadCastHeadData:dt withUrl:strID];
			}
			break;
		case multiMediaTypeHotBroadcastSrcVideo:
			if (img) {
				[HotBroadcastInfo updateSourceVideoData:dt withUrl:strID];
			}
			break;
		case multiMediaTypeHotBroadcastSrcImage:
			if (img) {
				[HotBroadcastInfo updateSourceImageData:dt withUrl:strID];
			}
			break;
			
		default:
			break;
	}
}

// 所有数据返回完毕
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	//so self data now has the complete image 
	BOOL bNeedPlay = NO;
	BOOL bIsHead = NO;
	self.mImage = [UIImage imageWithData:data];
	NSString *strType = [NSString stringWithFormat:@"%d", self.requestType];
	
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 strType, @"TYPE", 
						 [[data copy] autorelease], @"DATA", 
						 [[self.requestId copy] autorelease], @"ID", nil];
	[self performSelector:@selector(updateImageDataToDB:) withObject:dic afterDelay:0.01f];
//	BOOL bNeedFrame = NO;
	switch (self.requestType) {
		case multimediatypeNone:
		{
			// 不处理这些值
		}
			break;
		case multiMediaTypeHead:
			//if (self.mImage) {
//				[Info updateHeadData:data withUrl:self.requestId];
//			}
			bIsHead = YES;
			break;
		case multiMediaTypeImage:
			//if (self.mImage) {
//				[Info updateImageData:data withUrl:self.requestId];
//			}
			break;
		case multiMediaTypeVideo:
			//if (self.mImage) {
//				[Info updateVideoData:data withUrl:self.requestId];
//			}
			bNeedPlay = YES;
			break;
		case multiMediaTypeSourceImage:
			//if (self.mImage) {
//				[TransInfo updateSourceImageData:data withUrl:self.requestId];
//			}
			break;
		case multiMediaTypeSourceVideo:
			//if (self.mImage) {
//				[TransInfo updateSourceVideoData:data withUrl:self.requestId];
//			}
			bNeedPlay = YES;
			break;
		case multiMediaTypeMsgHead:
			//if (self.mImage) {
//				[Info updateMsgHeadData:data withUrl:self.requestId];
//			}
			bIsHead = YES;
			break;
		case multiMediaTypeMsgImage:
			//if (self.mImage) {
//				[Info updateMsgImageData:data withUrl:self.requestId];
//			}
			break;
		case multiMediaTypeMsgVideo:
			//if (self.mImage) {
//				[Info updateMsgVideoData:data withUrl:self.requestId];
//			}
			bNeedPlay = YES;
			break;
		case multiMediaTypeMsgSourceImage:
			//if (self.mImage) {
//				[TransInfo updateMsgSourceImageData:data withUrl:self.requestId];
//			}
			break;
		case multiMediaTypeMsgSourceVideo:
			//if (self.mImage) {
//				[TransInfo updateMsgSourceVideoData:data withUrl:self.requestId];
//			}
			bNeedPlay = YES;
			break;
		case multiMediaTypeHotBroadcastVideo:
			//if (self.mImage) {
//				[HotBroadcastInfo updateHotBroadCastVideoData:data withUrl:self.requestId];
//			}
			bNeedPlay = YES;
			break;
		case multiMediaTypeHotBroadcastImage:
			//if (self.mImage) {
//				[HotBroadcastInfo updateHotBroadCastImageData:data withUrl:self.requestId];
//			}
			break;
		case multiMediaTypeHotBroadcastHead:
			bIsHead = YES;
			//if (self.mImage) {
//				[HotBroadcastInfo updateHotBroadCastHeadData:data withUrl:self.requestId];
//			}
			break;
		case multiMediaTypeHotBroadcastSrcVideo:
			//if (self.mImage) {
//				[HotBroadcastInfo updateSourceVideoData:data withUrl:self.requestId];
//			}
			bNeedPlay = YES;
			break;
		case multiMediaTypeHotBroadcastSrcImage:
			//if (self.mImage) {
//				[HotBroadcastInfo updateSourceImageData:data withUrl:self.requestId];
//			}
			break;

		default:
			break;
	}
	 
	[connection release];
	connection=nil;
	//发送刷新通知
		if (self.refresh) {
			[self.activityIndicator stopAnimating];
		//	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeight" object:data];
		// 发送
			if (bNeedPlay) {
				if ([self.myAsyncImageViewDelegate respondsToSelector:@selector(AsyncImageViewHasLoadedVideo:)]) {
					[self.myAsyncImageViewDelegate AsyncImageViewHasLoadedVideo:data];
				}
			}
			else {
				if ([self.myAsyncImageViewDelegate respondsToSelector:@selector(AsyncImageViewHasLoadedImage:)]) {
					[self.myAsyncImageViewDelegate AsyncImageViewHasLoadedImage:data];
				}
			}

			
		}
	else {
		for (UIView *_view in self.subviews) {
			[_view removeFromSuperview];
		}
		//NSLog(@"self.mImagae:%f",self.mImage.size.height);
		UIImage *im = [UIImage imageWithData:data];
		if (!im) {
			// 假如生成失败
			if (bIsHead) {
				im = [UIImage imageNamed:@"compseLogo.png"];
			}
			else if (bNeedPlay){
				im = [UIImage imageNamed:@"视频默认图片.png"];
			}
			else {
				im = [UIImage imageNamed:@"imageDefault.png"];
			}
		}
		UIImageView* imageView = [[UIImageView alloc] initWithImage:im];
		//make sizing choices based on your needs, experiment with these. maybe not all the calls below are needed.
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
		[self addSubview:imageView];
		[imageView release];
		imageView.frame = self.bounds;
		// 带刷新功能的，自动附带播放按钮
		if (!self.refresh && bNeedPlay) {
			UIImageView *playImage = [[UIImageView alloc] init];
			playImage.frame = CGRectMake((imageView.frame.size.width - DefaultPlayBtnWidth) / 2.0f, 
										 (imageView.frame.size.height - DefaultPlayBtnHeight) / 2.0f, 
										 DefaultPlayBtnWidth, 
										 DefaultPlayBtnHeight);
			playImage.image = [UIImage imageNamed:@"未标题-2.png"];
			[imageView addSubview:playImage];
			[playImage release];
		}
		//CLog(@"imageView.frame.size.height:%f",imageView.frame.size.height);
		[imageView setNeedsLayout];
		[self setNeedsLayout];	
		
	}
		//	}
	self.mImage = nil;
	[data release]; 
	data=nil;
}
//直接得到图片
- (UIImage*) image {
	UIImageView* iv = [[self subviews] objectAtIndex:0];
	return [iv image];
}

@end
