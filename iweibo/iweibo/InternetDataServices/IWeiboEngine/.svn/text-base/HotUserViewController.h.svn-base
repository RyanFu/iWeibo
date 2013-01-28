#import <UIKit/UIKit.h>
#import "HeadDownloader.h"
#import "HotUserInfo.h"
#import "Canstants_Data.h"
#import "IWeiboAsyncApi.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

typedef enum {
	UserInfoTypeFirst = 1,
	UserInfoTypeMore = 2
}UserInfoType;

@protocol CustomHotuserCellDelegate<NSObject>

- (void)cellBtnClicked:(id)sender;

@end

extern NSString * const kThemeDidChangeNotification;

@interface HotUserViewController : UITableViewController <UIScrollViewDelegate, HeadDownloaderDelegate, CustomHotuserCellDelegate> {
	NSArray *entries;
    NSMutableDictionary *imageDownloadsInProgress;
	IWeiboAsyncApi *requestApi;
	NSIndexPath *currentIndexPath;
	
	BOOL hasNext; // 判断是否还有更多的数据
	BOOL isLoading; // 判断是否正在载入新的数据
	NSString    *lastid;
    UIButton    *backBtn;
	MBProgressHUD *hud;
	NSIndexPath *selectedIndexPath;
}

@property (nonatomic, retain) NSArray *entries;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) NSIndexPath *currentIndexPath;
@property (nonatomic, retain) UIButton    *backBtn;
- (void)appImageDidLoad:(NSIndexPath *)indexPath;
- (void)showMBProgress;

@end


@interface CustomeHotuserCell : UITableViewCell {
//	IWeiboAsyncApi *requestApi;
	id<CustomHotuserCellDelegate> delegate;
}
@property (nonatomic, assign) id<CustomHotuserCellDelegate> delegate;

- (void)refreshCellWithData:(HotUserInfo *)info atIndexPath:(NSIndexPath *)indexPath;


@end