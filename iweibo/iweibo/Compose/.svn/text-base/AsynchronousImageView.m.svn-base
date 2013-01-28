//
//  AsynchronousImageView.m
//  iweibo
//
//  Created by Minwen Yi on 1/13/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "AsynchronousImageView.h"
#import "DraftController.h"
#import "MyFriendsFansInfo.h"
#import <QuartzCore/QuartzCore.h>


@implementation AsynchronousImageView
@synthesize myAsynchronousImageViewDelegate;
@synthesize imageUrlString;
@synthesize isVip;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compseLogo.png"]];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight );
		[self addSubview:imageView];
		[imageView release];
		imageView.tag = ImageHeadTag;
		imageView.frame = CGRectMake(0, 0, 40, 40);
		isVip = NO;
		CALayer *layer = [imageView layer];
		layer.masksToBounds = YES;
		layer.cornerRadius = 8;
		
    }
    return self;
}

- (void)addVipView:(BOOL)bAdded {
	if (bAdded) {
		// 
		UIImageView* vipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip-btn.png"]];
		//vipImageView.contentMode = UIViewContentModeScaleAspectFit;
//		vipImageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight );
		[self addSubview:vipImageView];
		[vipImageView release];
		vipImageView.frame = CGRectMake(30, 30, 14, 14);
		vipImageView.tag = ImageVipPicTag;
	}
}

- (void)setIsVip:(BOOL)bIsVip {
	isVip = bIsVip;
	[self addVipView:isVip];
}

- (void)loadImageFromURL:(NSURL*)url {
    if (connection!=nil) { [connection release]; }
    if (data!=nil) { [data release]; data = nil;}
    NSURLRequest* request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self];
    //TODO error handling, what if connection is nil?
}

- (void)addImageFromData:(NSData *)imageData {
	
    UIImageView* imageView = nil;
	if (imageData) {
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
	}
	else {
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compseLogo.png"]];
	}
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
    [self addSubview:imageView];
	[imageView release];
    imageView.frame = CGRectMake(0, 0, 40, 40);
	[self addVipView:self.isVip];
	CALayer *layer = [imageView layer];
	layer.masksToBounds = YES;
	layer.cornerRadius = 8;
    [imageView setNeedsLayout];
    [self setNeedsLayout];
}

- (void)loadHeadImageFromURLString:(NSString *)urlString WithRequestType:(RequestType)reqType {
	// 好友搜索
	if (RequestFromFriendsFansSearch == reqType) {
		NSString *urlStrWithSize =  [NSString stringWithFormat:@"%@/100",urlString];
		NSURL *url = [NSURL URLWithString:urlStrWithSize];
		// 加载默认头像
		//[self addImageFromData:nil];
		// 判断是否头像url可用，不可用则用本地头像，10无具体意义，因为url后边带有size属性，长度肯定非0
		if ([urlString length] > 10) {
			// 判断本地数据库中是否有对应数据
			NSData *ImageData = [MyFriendsFansInfo myFanHeadImageDataWithUrl:urlString];
			//CLog(@"[ImageData length]=%d",[ImageData length]);
			if ([ImageData length] > 4) {
				// 本地有数据
				[self addImageFromData:ImageData];
				//[ImageData release];
				//			ImageData=nil;
			}
			else {
				// 去网络取数据
				if (self.imageUrlString) {
					self.imageUrlString = nil;
				}
                NSString *urll = [[NSString alloc] initWithString:urlString];
				self.imageUrlString = (NSMutableString *)urll;
                [urll release];
				[self loadImageFromURL:url];
			}
		}
		else {
			//CLog(@"null url");
		}

	}
	
}

- (void) connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response{
	if ([response expectedContentLength] < 0) { 
		[theConnection cancel];
		return;
	}
	[data setLength:0];
}

	// 连接返回失败
- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error{
	theConnection = nil;
}

- (void)connection:(NSURLConnection *)theConnection
    didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
        data =
        [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	
    [connection release];
    connection=nil;
	
    if ([[self subviews] count]>0) {
		for (int i = 0; i < [[self subviews] count]; i++) {
			[[[self subviews] objectAtIndex:i] removeFromSuperview];
		}
    }
	// 刷新界面
	[self addImageFromData:data];
	// 存储数据
	CLog(@"self.imageUrlString :%@", self.imageUrlString);
	[MyFriendsFansInfo updateImageData:data ForHead:self.imageUrlString];
    [data release];
    data=nil;
}


- (UIImage*) image {
    UIImageView* iv = [[self subviews] objectAtIndex:0];
    return [iv image];
}

- (void)dealloc {
    [connection cancel];
    [connection release];
    [data release];
	data = nil;
	//[self.imageUrlString release];
	self.imageUrlString = nil;
    [super dealloc];
}
@end
