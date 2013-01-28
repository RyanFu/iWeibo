

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class AVAudioPlayer;

typedef enum{
	EGOOPullRefreshPulling = 0,
	EGOOPullRefreshNormal,
	EGOOPullRefreshLoading,	
} EGOPullRefreshState;

typedef enum{
	EGOHomelinelastTime = 0,
	EGOMessagelastTime,
	EGOListenlastTime,
	EGOAudiencelastTime,
	EGOBroadCastlastTime,
	EGOHotBroadCastLastTime,		// 热门广播
}EGOLastTime;

@interface EGORefreshTableHeaderView : UIView {
	
	UILabel					*_lastUpdatedLabel;
	UILabel					*_statusLabel;
	CALayer					*_arrowImage;
	UIActivityIndicatorView *_activityView;
	AVAudioPlayer			*myPlayer;
	AVAudioPlayer			*myLoadingPlayer;
	EGOPullRefreshState		_state;
	EGOLastTime				_lastState;
	BOOL					playsound;

}

@property (nonatomic, assign) EGOPullRefreshState		state;
@property (nonatomic, assign) EGOLastTime				lastState;
@property (nonatomic, retain) UILabel					*lastUpdatedLabel;
//@property (nonatomic, retain) AVAudioPlayer				*myPlayer;

//- (void)setCurrentDate;
- (void)setCurrentDate:(EGOLastTime)currentState;
// 2012-02-20 By Yi Minwen 设置间隔时间
// bDataUpdateNeeded: 是否更新EGOLastTime对应值
- (void)setCurrentDate:(EGOLastTime)currentState withDateUpdated:(BOOL)bDateUpdateNeeded;
- (void)setState:(EGOPullRefreshState)aState;
- (NSNumber *)getLasttimeState:(EGOLastTime)bState;
- (void)setTimeState:(EGOLastTime)timeState;
- (void)setLasttimeState:(EGOLastTime)bState:(NSTimeInterval)now;

@end
