//
//  PhotoView.m
//  iweibo
//
//  Created by ZhaoLilong on 1/31/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "PhotoView.h"
#import "Reachability.h"
#import "IWBGifImageCache.h"

@implementation PhotoView

@synthesize url;
@synthesize imageData;
@synthesize hasLoaded;

// 初始化方法
- (id)initWithFrame:(CGRect)frame withUrl:(NSString *)u{
    
    self = [super initWithFrame:frame];
	
    if (self) {
		// 设置初始化条件
		self.hasLoaded = NO;	
		
		// 获取窗口
		delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;	
		
		//设置背景色
		self.backgroundColor = [UIColor clearColor];								
		
		// 添加半透明遮罩视图
		UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		bgView.backgroundColor = [UIColor blackColor];
		bgView.alpha = 0.8;
		[self addSubview:bgView];
		[bgView release];
		
		// 添加滚动视图
		mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
		
		// 添加轻击手势
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
		[mScrollView addGestureRecognizer:tapGesture];
		[tapGesture release];
		
		//初始化放大倍数为1.0，即显示原始大小
		mScrollView.zoomScale = 1.0f;
		
		//最小放大倍数为0.5
		mScrollView.minimumZoomScale = 0.5f;
		
		//最大放大倍数未2.0
		mScrollView.maximumZoomScale = 2.0f;
		
		//设置滚动视图的大小为图片大小
		mScrollView.contentSize = CGSizeMake(mImage.size.width, mImage.size.height);
		
		//设置滚动视图的代理
		mScrollView.delegate = self;
		mScrollView.decelerationRate = 1.0f;
		mScrollView.multipleTouchEnabled = NO;
		
		// 滚动视图自适应
		mScrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
		originCenter = mScrollView.center;
		[self addSubview:mScrollView];
		
		// 初始化图片视图
		mImageView = [[IWBGifImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
		mImageView.userInteractionEnabled = YES;
		mImageView.multipleTouchEnabled = YES;
		
		// 图片视图自适应
		mImageView.contentMode = UIViewContentModeScaleAspectFit;
		mImageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
		
		// 添加图片视图
		[mScrollView addSubview:mImageView];
		
		// 添加加载动画视图
		indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 230, 20, 20)];
		[self addSubview:indicatorView];
		
		// 链接赋值
		self.url = u;	
		
		// 添加百分比标签视图
		percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 250, 60, 20)];
		percentLabel.backgroundColor = [UIColor clearColor];
		percentLabel.textColor = [UIColor whiteColor];
		[self addSubview:percentLabel];
		[percentLabel release];
		
		// 添加查看原图按钮
		zoomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[zoomBtn setLink:url];
		zoomBtn.frame = CGRectMake(130, 420, 50, 28);
		zoomBtn.userInteractionEnabled = YES;
		[zoomBtn setBackgroundImage:[UIImage imageNamed:@"magnifer.png"] forState:UIControlStateNormal];
		
		// 添加按钮响应
		[zoomBtn addTarget:self action:@selector(zoomPhoto:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:zoomBtn];
	}
	    return self;
}

// 设置图片数据
- (void)setImageData:(NSData *)dt {
	if (imageData != dt || dt == nil) {
		// 2012-03-22 zhaolilong 将首页显示的图放大为300*300
		mImageView.frame = CGRectMake(10, 90, 300, 300);			
		[imageData release];
		imageData = [dt retain];
		if (self.imageData != nil) {
			UIImage *myImage = [UIImage imageWithData:self.imageData];
			mImageView.image = myImage;
		}else {					
			mImageView.image = [UIImage imageNamed:@"btn300X300.png"];
		}
		[self loadImage];
	}
}

// 加载图片
- (void)loadImage{
	NSString *urlString = [NSString stringWithFormat:@"%@/460",self.url];
	if (conn) {
		return;
	}
	
	NSData *gifData = [[IWBGifImageCache sharedImageCache] imageFromKey:urlString fromDisk:YES];
	if (gifData) {
		[mImageView setGIFData:gifData];
		UIImage *image = [UIImage imageWithData:gifData];
		[self showImageView:image];
	}
	else {
		
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:30.0f];
		conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}
}

// 释放资源
- (void)dealloc {
	[mScrollView release];
	mScrollView = nil;
	[indicatorView release];
	indicatorView = nil;
	[mImageView release];
	mImageView = nil;
	[conn cancel];
	[imageData release];
	imageData = nil;
	[super dealloc];
}

// 触摸结束时执行
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[self removeFromSuperview];
}

// 查看原图响应
- (void)zoomPhoto:(id)sender{
	// 获取代理
	iweiboAppDelegate *del = (iweiboAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	// 导航条颜色处理
	del.draws = 0;	
	
	// 添加翻转动画
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:delegate.window cache:YES];
	[self setHidden:YES];
	[UIView setAnimationDidStopSelector:@selector(watchOriginPhoto)];
	[UIView commitAnimations];
	
	// 初始化查看原图
	zoomView = [[ZoomView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	
		//zoomView.imageUrl = self.url; //----------该处在动画未加载完提前执行网络请求代理方法，导致加载过程中崩溃
	[delegate.window addSubview:zoomView];
	[zoomView release];
	// 取消加载
	[conn cancel];
	[self removeFromSuperview];
}

// 查看原图
- (void)watchOriginPhoto{
	// 图片链接属性赋值
	zoomView.imageUrl = self.url;
	//[zoomView loadImage];
	// 刷新视图
	[zoomView setNeedsDisplay];
}

// 移除视图
-(void)removeView {
	[self removeFromSuperview];
}

// 存储gif图片
- (void)storeGifToCache:(NSData *)gifImageData{
	if ([IWBGifImageView isGifImage:gifImageData]) {
		NSString *urlString = [[NSString alloc]initWithFormat:@"%@/460",self.url];
		[[IWBGifImageCache sharedImageCache] storeImageData:gifImageData forKey:urlString toDisk:YES];
		[urlString release];
	}
}

// 轻击手势响应
- (void)tap:(UITapGestureRecognizer *)gesture{
	[self performSelectorOnMainThread:@selector(removeView) withObject:nil waitUntilDone:YES];
	
}

// 捏合手势响应
- (void) pinch:(UIPinchGestureRecognizer *)gesture{
	static CGRect initialBounds;
	
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        initialBounds = mImageView.bounds;
    }
    CGFloat factor = gesture.scale;
	CGAffineTransform zt = CGAffineTransformScale(CGAffineTransformIdentity, factor, factor);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5f];
	if (mImageView.bounds.size.width > 320 || mImageView.bounds.size.height > 480) {
		mImageView.bounds = CGRectMake(mImageView.bounds.origin.x, mImageView.bounds.origin.y, 320, 480);
	}else if (mImageView.bounds.size.width < 100||mImageView.bounds.size.height < 100) {
		mImageView.bounds = CGRectMake(mImageView.bounds.origin.x, mImageView.bounds.origin.y, originSize.width/2, originSize.height/2);
	}else {
		mImageView.bounds = CGRectApplyAffineTransform(initialBounds, zt);
	}
	[UIView commitAnimations];
}

// 手势区分
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	return ([[touch.view class] isSubclassOfClass:[UIButton class]]) ? NO : YES;
}

//按规格要求显示图片
- (void)showImageView:(UIImage *)mmImage{
	// 获取图片宽度
	CGFloat imageWidth = mmImage.size.width;
	
	// 获取图片高度
	CGFloat imageHeight = mmImage.size.height;
	
	// 图片宽高比
	CGFloat ratio = imageWidth/imageHeight;
	
	if (imageWidth > 320) {
		// 如果图片宽度大于320，则以最大宽度320对图片进行等比例缩放
		mImageView.frame = CGRectMake(0, (480 - 320/ratio)/2, 320, 320/ratio);
	}else if (imageHeight > 480) {
		// 如果图片高度大于480，则以最大高度480对图片进行等比例缩放
		mImageView.frame = CGRectMake((320 - 480*ratio)/2, 0, 480*ratio, 480);
	}
	if (imageWidth > 320 && imageHeight > 480) {
		// 如果图片的宽大于320，同时其高度也大于480，将其置为全屏
		mImageView.frame = CGRectMake(0, 0, 320, 480);
	}
	
	// 设置原始大小
	originSize = mmImage.size;
	
	// 设置图片原始中心点
	mScrollView.center = originCenter;
	
	// 刷新图片
	[mImageView setNeedsDisplay];
	
	// 将查看原图按钮置于最前
	[self bringSubviewToFront:zoomBtn];
	
	// 刷新视图
	[self setNeedsDisplay];
	
}

#pragma mark -
#pragma mark NSURLConnection Method
//返回响应
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	// 接收数据置零
	[receivedData setLength:0];
	
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	
	// 获取请求内容的总长度
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        _total = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];
    }	
}
	
//接收数据
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	// 显示加载动画
	[indicatorView startAnimating];
	
	// 累加每次返回的数据长度
	_received += [data length];
	
	// 判断接收数据是否为空
	if (receivedData == nil) {
		receivedData = [[NSMutableData alloc] initWithCapacity:2048];
	}
	
	// 将每次返回的数据添加到接收数据的末尾
	[receivedData appendData:data];
	
	// 显示百分比标签文本
	percentLabel.text = [NSString stringWithFormat:@"%.2f%%",(float)_received*100/_total];
}

//网络数据返回完毕
- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
	// 停止加载动画
	[indicatorView stopAnimating];
	
	// 更改加载状态
	self.hasLoaded = YES;
	
	// 隐藏百分比显示标签
	percentLabel.hidden = YES;
	
	// 如果返回数据不为空则显示图片
	if (receivedData != nil) {
		// 根据返回数据生成图片
		mImage = [UIImage imageWithData:receivedData];
		
		// 更改图片视图的图片属性
		mImageView.image = mImage;

		[mImageView setGIFData:receivedData];
		[self performSelectorInBackground:@selector(storeGifToCache:) withObject:receivedData];
		[self showImageView:mImage];

	}
	
	// 释放接收到的数据
	[receivedData release]; 
	receivedData=nil;
}

// 网络链接失败
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	// 停止加载动画
	[indicatorView stopAnimating];
	// 将查看原图按钮置于最前
	[self bringSubviewToFront:zoomBtn];
	// 隐藏百分比标签
	[percentLabel setHidden:YES];
}

// 图片结束缩放
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    CGFloat zs = scrollView.zoomScale;
    // 捏合最小
    zs = MAX(zs, 0.5);      
    // 捏合最大
    zs = MIN(zs, 2.0);              
	
    // 缩放动画
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];   
    mScrollView.zoomScale = zs;   
    [UIView commitAnimations];
}

// 返回scrollView上被缩放的视图
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return mImageView;
}
 
// 缩放视图方法
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
	CGFloat centerWidth = scrollView.bounds.size.width / 2;
	CGFloat centerHeight = scrollView.bounds.size.height / 2;
	if(mScrollView.zoomScale < 1.0)
	{
		[mImageView setCenter:CGPointMake(centerWidth, centerHeight)];
		[mScrollView setContentOffset:CGPointZero];
	}
}

// 缩放时视图恢复原点
- (CGRect)zoomRectForScale:(float)scale withOrigin:(CGPoint)origin {
    CGRect zoomRect;
    zoomRect.size.height = mScrollView.frame.size.height / scale;
    zoomRect.size.width  = mScrollView.frame.size.width  / scale;
    zoomRect.origin.x    = origin.x;
    zoomRect.origin.y    = origin.y;
    return zoomRect;
}
 
@end
