
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "EGORefreshTableHeaderView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define BORDER_COLOR [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f
#define EGOREFRESHHOMELINE	@"EGORefreshTableView_LastRefresh"
#define EGOREFRESHMESSAGELINE	@"EGOMesRefreshTableView_LastRefresh"
#define EGOREFRESHLISTEN	@"EGOListenRefresh_LastRefresh"
#define EGOREFRESHAUDIENCE  @"EGOAudienceRefresh_LastRefresh"
#define EGOREFRESHBROADCAST @"EGOBroadCastRefresh_lastRefresh"
#define EGOREFRESHHOTBROADCAST @"EGOHotBroadCastRefresh_lastRefresh"

@implementation EGORefreshTableHeaderView

@synthesize state=_state;
@synthesize lastUpdatedLabel = _lastUpdatedLabel, lastState = _lastState;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 2.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		CALayer *layer = [[CALayer alloc] init];
		layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		[layer release];
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		
		NSString *pathPulling = [[NSBundle mainBundle] pathForResource:@"refresh_pulling" ofType:@"wav"];
		NSURL *urlPulling = [[NSURL alloc] initFileURLWithPath:pathPulling];
		myPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:urlPulling error:NULL];
		myPlayer.numberOfLoops = 0;
		myPlayer.volume = 2.0f;
		[urlPulling release];
		
		NSString *pathLoading = [[NSBundle mainBundle] pathForResource:@"refresh_loading" ofType:@"wav"];
		NSURL *url = [[NSURL alloc] initFileURLWithPath:pathLoading];
		myLoadingPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
		myLoadingPlayer.numberOfLoops = 0;
		myLoadingPlayer.volume = 2.0f;
		[url release];
		
		[self setState:EGOOPullRefreshNormal];
		
    }
    return self;
}


// 2012-02-20 By Yi Minwen 设置间隔时间
// bDataUpdateNeeded: 是否更新EGOLastTime对应值
- (void)setCurrentDate:(EGOLastTime)currentState withDateUpdated:(BOOL)bDateUpdateNeeded {
	NSString *timeString=@"";
	
	NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
	
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
	NSNumber *lastM = [self getLasttimeState:currentState];
	NSTimeInterval cha = now-[lastM doubleValue];
	if (!lastM) {
		cha = 0.0f;
	}
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
		if ([timeString compare:@"1"]==NSOrderedAscending) {
			_lastUpdatedLabel.text = @"上次更新: 刚刚";
		}
		else {
			_lastUpdatedLabel.text = [NSString stringWithFormat:@"上次更新: %@分钟前", timeString];
		}
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        _lastUpdatedLabel.text=[NSString stringWithFormat:@"上次更新: %@小时前", timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        _lastUpdatedLabel.text=[NSString stringWithFormat:@"上次更新: %@天前", timeString];
    }
	if (bDateUpdateNeeded) {
		[self setLasttimeState:currentState:now];
	}
}

- (void)setCurrentDate:(EGOLastTime)currentState{

//	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//	[formatter setAMSymbol:@"AM"];
//	[formatter setPMSymbol:@"PM"];
//	[formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
//  _lastUpdatedLabel.text = [NSString stringWithFormat:@"上次更新: %@", [formatter stringFromDate:[NSDate date]]];

	[self setCurrentDate:currentState withDateUpdated:YES];
//	[formatter release];
}

- (NSNumber *)getLasttimeState:(EGOLastTime)bState{
	NSNumber *last= nil;
	switch (bState) {
		case EGOHomelinelastTime:
			last = [[NSUserDefaults standardUserDefaults] objectForKey:EGOREFRESHHOMELINE];
			break;
		case EGOMessagelastTime:
			last = [[NSUserDefaults standardUserDefaults] objectForKey:EGOREFRESHMESSAGELINE];
			break;
		case EGOListenlastTime:
			last = [[NSUserDefaults standardUserDefaults] objectForKey:EGOREFRESHLISTEN];
			break;
		case EGOAudiencelastTime:
			last = [[NSUserDefaults standardUserDefaults] objectForKey:EGOREFRESHAUDIENCE];
			break;
		case EGOBroadCastlastTime:
			last = [[NSUserDefaults standardUserDefaults] objectForKey:EGOREFRESHBROADCAST];
			break;
		case EGOHotBroadCastLastTime:
			last = [[NSUserDefaults standardUserDefaults] objectForKey:EGOREFRESHHOTBROADCAST];
			break;

		default:
			break;
	}
	return last;
}
	 
- (void)setLasttimeState:(EGOLastTime)bState:(NSTimeInterval)now{
	switch (bState) {
		case EGOHomelinelastTime:
			[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:now] forKey:EGOREFRESHHOMELINE];
			[[NSUserDefaults standardUserDefaults] synchronize];
			break;
		case EGOMessagelastTime:
			[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:now] forKey:EGOREFRESHMESSAGELINE];
			[[NSUserDefaults standardUserDefaults] synchronize];
			break;
		case EGOListenlastTime:
			[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:now] forKey:EGOREFRESHLISTEN];
			[[NSUserDefaults standardUserDefaults] synchronize];
			break;
		case EGOAudiencelastTime:
			[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:now] forKey:EGOREFRESHAUDIENCE];
			[[NSUserDefaults standardUserDefaults] synchronize];
			break;
		case EGOBroadCastlastTime:
			[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:now] forKey:EGOREFRESHBROADCAST];
			[[NSUserDefaults standardUserDefaults] synchronize];
			break;
		case EGOHotBroadCastLastTime:
			[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:now] forKey:EGOREFRESHHOTBROADCAST];
			[[NSUserDefaults standardUserDefaults] synchronize];
			break;

		default:
			break;
	}
}
	
- (void)setTimeState:(EGOLastTime)timeState{
	[myPlayer stop];
	[myLoadingPlayer stop];
	[self setCurrentDate:timeState];
	return;
	if (timeState == EGOHomelinelastTime) {
		if ([[NSUserDefaults standardUserDefaults] objectForKey:EGOREFRESHHOMELINE]) {
		} else {
			_lastUpdatedLabel.text = [NSString stringWithFormat:@"上次更新: 刚刚"];
		}
	}
	if (timeState == EGOMessagelastTime) {
		if ([[NSUserDefaults standardUserDefaults] objectForKey:EGOREFRESHMESSAGELINE]) {
		//	[self setCurrentDate:timeState];
		} else {
			_lastUpdatedLabel.text = [NSString stringWithFormat:@"上次更新: 刚刚"];
		}
	}
	if (timeState == EGOListenlastTime) {
		if ([[NSUserDefaults standardUserDefaults] objectForKey:EGOREFRESHLISTEN]) {
		//	[self setCurrentDate:timeState];
		} else {
			_lastUpdatedLabel.text = [NSString stringWithFormat:@"上次更新: 刚刚"];
		}
	}
	if (timeState == EGOAudiencelastTime) {
		if ([[NSUserDefaults standardUserDefaults] objectForKey:EGOREFRESHAUDIENCE]) {
		//	[self setCurrentDate:timeState];
		} else {
			_lastUpdatedLabel.text = [NSString stringWithFormat:@"上次更新: 刚刚"];
		}
	}
	if (timeState == EGOBroadCastlastTime) {
		if ([[NSUserDefaults standardUserDefaults] objectForKey:EGOREFRESHBROADCAST]) {
			[self setCurrentDate:timeState];
		}else {
			_lastUpdatedLabel.text = [NSString stringWithFormat:@"上次更新:刚刚"];
		}
	}
}
	
- (void)setState:(EGOPullRefreshState)aState{
	playsound = [[[NSUserDefaults standardUserDefaults]objectForKey:KEYPLAYSOURND] boolValue];
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			_statusLabel.text = NSLocalizedString(@"释放立即刷新...", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedString(@"下拉刷新...", @"Pull down to refresh status");
			if (playsound) {
				[myLoadingPlayer stop];
				[myPlayer play];
			}
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshLoading:
			
			_statusLabel.text = NSLocalizedString(@"正在刷新...", @"Loading Status");
			if (playsound) {
				[myPlayer stop];
				[myLoadingPlayer play];
			}
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}

- (void)dealloc {
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
	[myPlayer release];
	[myLoadingPlayer release];
    [super dealloc];
}


@end
