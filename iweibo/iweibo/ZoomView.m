//
//  ZoomView.m
//  iweibo
//
//  Created by ZhaoLilong on 1/31/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "ZoomView.h"
#import "iweiboAppDelegate.h"
#import "IWBGifImageCache.h"
#import "Reachability.h"

@implementation ZoomView
@synthesize progressView;
@synthesize imageUrl;
@synthesize mImage;
@synthesize mImageView;
@synthesize hasLoaded;

// 初始化方法
- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
		// 设置背景颜色
		self.backgroundColor = [UIColor blackColor];
		
		 // 设置初始化条件
		self.hasLoaded = NO;						
		
		// 添加滚动视图
		mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
		mScrollView.zoomScale = 1.0f;
		mScrollView.minimumZoomScale = 1.0f;
		mScrollView.maximumZoomScale = 2.0f;
		mScrollView.contentSize = CGSizeMake(mImage.size.width, mImage.size.height);
		mScrollView.delegate = self;
		mScrollView.decelerationRate = 1.0f;
		mScrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
		
		// 添加导航条
		navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
		navigationBar.barStyle = UIBarStyleBlackTranslucent;
//		2012-03-19 modified by wangying 解决翻转时，原图查看导航条错位的bug
//		self.mImageView = [[UIImageView alloc] initWithFrame:mScrollView.bounds];
		// 初始化图片视图
		mImageView = [[IWBGifImageView alloc] initWithFrame:CGRectMake(0, 20, mScrollView.bounds.size.width, mScrollView.bounds.size.height)];
		self.mImageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
		self.mImageView.userInteractionEnabled = YES;
		self.mImageView.multipleTouchEnabled = YES;
		
		// 添加手势
		UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
		UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
		
		[doubleTapGesture setNumberOfTapsRequired:2];
		[singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
		
		[self.mImageView addGestureRecognizer:singleTapGesture];
		[self.mImageView addGestureRecognizer:doubleTapGesture];
 
		[singleTapGesture release];
		[doubleTapGesture release];
		
		// 添加加载时的图片
		picView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic.png"]];
		picView.frame = CGRectMake(80, 112, 157, 113);
		[self addSubview:picView];
		[picView release];
		
		// 添加进度条视图
		progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
		progressView.frame = CGRectMake(75, 300, 172, 10);
		[self addSubview:progressView];

		// 添加百分比标签视图
		percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 270, 200, 30)];
		percentLabel.backgroundColor = [UIColor clearColor];
		percentLabel.textColor = [UIColor colorStringToRGB:@"ffffff"];
		percentLabel.font = [UIFont fontWithName:@"Arial" size:16];
		[self addSubview:percentLabel];
		[percentLabel release];
		[mScrollView addSubview:self.mImageView];
		[self addSubview:mScrollView];
		[mScrollView release];
		
		// 添加导航条项目
		NSString *title = @"原图查看";
		CGSize fontSize = [title sizeWithFont:[UIFont systemFontOfSize:22]];
		UILabel *navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fontSize.width, fontSize.height)];
		navTitleLabel.font = [UIFont systemFontOfSize:20];
		navTitleLabel.text = title;
		navTitleLabel.backgroundColor = [UIColor clearColor];
		navTitleLabel.textColor = [UIColor whiteColor];
		navigationItem = [[UINavigationItem alloc]init];
		navigationItem.titleView = navTitleLabel;
		[navTitleLabel release];
		
		[navigationBar pushNavigationItem:navigationItem animated:YES];
		// 添加导航栏按钮
		UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
		//UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
		navigationItem.leftBarButtonItem = leftBarButtonItem;
		//navigationItem.rightBarButtonItem = rightBarButtonItem;
		[leftBarButtonItem release];
		//[rightBarButtonItem release];
		[self addSubview:navigationBar];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.	
	[super drawRect:rect];
	if (!self.hasLoaded) {
		//[self loadImage];
	}
	//[self setNeedsDisplay];
}


- (void)dealloc {
	[progressView release];
	progressView = nil;
	[mImage release];
	mImage = nil;
	[mImageView release];
	mImageView = nil;
	[navigationItem release];
	[navigationBar release];
	[conn cancel];
	[conn release];
	[receivedData release];
	receivedData = nil;
	self.imageUrl = nil;
    [super dealloc];
}

	//返回
- (void) back:(id)sender{
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	delegate.draws = 1;
	delegate.window.backgroundColor = [UIColor blackColor];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:delegate.window cache:YES];
	[navigationBar popNavigationItemAnimated:YES];
	[conn cancel];
	[self removeFromSuperview];
	[UIView commitAnimations];	
}

// 保存图片
- (void) save:(id)sender{
	// 保存图片到相册中 
	if (!hasSaved&&enableSave) {
		UIImageWriteToSavedPhotosAlbum(self.mImageView.image, self, @selector (image:didFinishSavingWithError:contextInfo:) , nil ) ; 
		hasSaved = YES;
	}
	navigationItem.rightBarButtonItem = nil;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{ 
	progressHUD = [[MBProgressHUD alloc] initWithView:self];
	[self addSubview:progressHUD];
	[progressHUD release];
		//有错误
    if (error != NULL) 
		
    { 
		// 显示错误信息
		progressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] autorelease];
		progressHUD.mode = MBProgressHUDModeCustomView;
		progressHUD.labelText = @"保存失败";		
    } else 
    { 
		// 设置自定义提示信息
		progressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] autorelease];
		progressHUD.mode = MBProgressHUDModeCustomView;
		progressHUD.labelText = @"已保存到手机相册";
	} 
	
	//显示提示信息
	[progressHUD show:YES];
	
	// 延迟执行提示消息消失
	[self performSelector:@selector(hideDelayed) withObject:[NSNumber numberWithBool:YES] afterDelay:2];
} 

//延迟隐藏
- (void)hideDelayed{
	[progressHUD hide:YES];
}

-(void)setImageUrl:(NSString *)url {
	if (imageUrl != url) {
		[imageUrl release];
		imageUrl = [url copy];
	}
	if (url) {
		[self loadImage];
	}
}

// 缩放响应
- (void)zoomImage:(UIPinchGestureRecognizer *)gesture{
	CGFloat imageWidth = m_imageWidth;
	CGFloat imageHeight = m_imageHeight;
	imageWidth = imageWidth*gesture.scale;
	imageHeight = imageHeight*gesture.scale;
	if (imageWidth > 320) {
		imageWidth = 320;
	}
	if (imageHeight >416) {
		imageHeight = 416;
	}
	if (imageWidth < 100) {
		imageWidth = 100;
	}
	if (imageHeight < 100) {
		imageHeight = 100;
	}
	self.mImageView.frame = CGRectMake((320 - imageWidth)/2, (480 - imageHeight)/2, imageWidth, imageHeight);
}

// 轻击图片
- (void)tapImage:(UITapGestureRecognizer *)gesture{
	CGFloat imageWidth = m_imageWidth;
	CGFloat imageHeight = m_imageHeight;
	if (self.mImageView.frame.size.width<320||self.mImageView.frame.size.height<416) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5f];
		self.mImageView.frame = CGRectMake(0, 44, 320, 416);
		[UIView commitAnimations];
	}else {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5f];
		self.mImageView.frame = CGRectMake((320 - imageWidth)/2, (480 - imageHeight)/2, imageWidth, imageHeight);
		[UIView commitAnimations];
	}
}

// 加载图片
- (void)loadImage{
	if (self.imageUrl == nil) {
		return;
	}
	NSString *urlString = [NSString stringWithFormat:@"%@/2000",self.imageUrl];
	if (receivedData) {
		[receivedData release];
	}
	NSData *gifData = [[IWBGifImageCache sharedImageCache] imageFromKey:urlString fromDisk:YES];
	if (gifData) {
		picView.hidden = YES;
		self.mImageView.contentMode = UIViewContentModeScaleAspectFit;
		self.mImageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
		[mImageView setGIFData:gifData];
		if ([IWBGifImageView isGifImage:gifData]) {
			navigationItem.rightBarButtonItem = nil;
		}
		else {
			UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
			navigationItem.rightBarButtonItem = rightBarButtonItem;
			[rightBarButtonItem release];
		}

	}
	else {
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0f];
		conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		[request release];		
		if(conn){
		}else{
			NSLog(@"sorry");
		}
	}	
}

// 存储gif图片
- (void)storeGifToCache:(NSData *)gifImageData{
	if ([IWBGifImageView isGifImage:gifImageData]) {
		NSString *urlString = [[NSString alloc]initWithFormat:@"%@/2000",self.imageUrl];
		[[IWBGifImageCache sharedImageCache] storeImageData:gifImageData forKey:urlString toDisk:YES];
		[urlString release];
	}
}

#pragma mark -
#pragma mark URLConnection Method
// 网络请求响应
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	[receivedData setLength:0];
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        _total = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];		
    }	
}

// 网络请求返回数据
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	_received += [data length];
	if (receivedData == nil) {
		receivedData = [[NSMutableData alloc] initWithCapacity:2048];
	}
	[receivedData appendData:data];
	progressView.progress = (float)_received/_total;
	percentLabel.text = [NSString stringWithFormat:@"%dk/%lldk",_received/1024,_total/1024];
}

// 网络请求加载完成
- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
	enableSave = YES;
	progressView.hidden = YES;
	percentLabel.hidden = YES;
	picView.hidden = YES;
	self.mImage = [UIImage imageWithData:receivedData];
	self.mImageView.contentMode = UIViewContentModeScaleAspectFit;
	self.mImageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );

	self.mImageView.image = self.mImage;
	[self.mImageView setGIFData:receivedData];
	if ([IWBGifImageView isGifImage:receivedData]) {
		navigationItem.rightBarButtonItem = nil;
	}
	else {
		UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
		navigationItem.rightBarButtonItem = rightBarButtonItem;
		[rightBarButtonItem release];
	}
	[self performSelectorInBackground:@selector(storeGifToCache:) withObject:receivedData];
	self.hasLoaded = YES;
	[self setNeedsDisplay];
}

// 网络返回失败
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
		&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		[self.mImageView setHidden:YES];
		progressView.hidden = YES; 
        
		percentLabel.hidden = YES;
		[picView setHidden:YES];
		
		UIImageView *errorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic-w.png"]];
		errorView.frame = CGRectMake(80.5, 100, 159, 114);
		[self addSubview:errorView];
		[errorView release];
		
		NSString *errorString = @"无法获取图片，稍后请重试";
		CGSize errorSize = [errorString sizeWithFont:[UIFont systemFontOfSize:16]];
		UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake((320 - errorSize.width)/2,297,errorSize.width,errorSize.height)];
		errorLabel.backgroundColor = [UIColor clearColor];
		errorLabel.font = [UIFont systemFontOfSize:16];
		errorLabel.textColor = [UIColor whiteColor];
		errorLabel.text = errorString;
		[self addSubview:errorLabel];
		[errorLabel release];
	}
}

#pragma mark -
#pragma mark Gesture Method
// 单击手势响应
- (void)singleTap:(UITapGestureRecognizer *)gesture{
	NSLog(@"singleGesture:%@",gesture);
	if (isHidden) {
		navigationBar.hidden = NO;
		isHidden = NO;
	}else {
		navigationBar.hidden = YES;
		isHidden = YES;
	}

}

// 双击手势响应
- (void)doubleTap:(UITapGestureRecognizer *)gesture{
	NSLog(@"doubleGesture:%@",gesture);

	/*
	if (!isFirst) {
		isFirst = YES;
		NSLog(@"第一次双击");
		[self zoomView:mScrollView toScale:1.0f];
	}else {
		if (!isScaled) {
			NSLog(@"2倍");
			isScaled = YES;
			[self zoomView:mScrollView toScale:1.0f];
		}else {
			NSLog(@"2.5倍");
			isScaled = NO;
			[self zoomView:mScrollView toScale:2.0f];
		}
	}
*/
	CGFloat zs = mScrollView.zoomScale;
    // 双击倍数
    zs = (zs == 1.0) ? 2.0 : 1.0;             
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];           
    mScrollView.zoomScale = zs;   
    [UIView commitAnimations];
}

// 视图结束缩放时调用
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    // 滚动视图放大倍数
    CGFloat zs = scrollView.zoomScale;
    // 捏合最小
    zs = MAX(zs, 1.0);   
    // 捏合最大
    zs = MIN(zs, 2.0);                
    // 缩放过程动画
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];   
    mScrollView.zoomScale = zs;   
    [UIView commitAnimations];
}
 
// 滚动视图返回的被缩放的视图
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return self.mImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
	if(mScrollView.zoomScale < 1.0)
    {
			//[mScrollView setContentOffset:CGPointMake(mScrollView.frame.origin.x/2, mScrollView.frame.origin.y/2) animated:NO];	
			//[mScrollView setContentOffset:CGPointZero];
	}
}
@end
