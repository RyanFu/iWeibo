@class HotUserInfo;
@class RootViewController;

@protocol HeadDownloaderDelegate;

@interface HeadDownloader : NSObject
{
    HotUserInfo *userRecord;
    NSIndexPath *indexPathInTableView;
    id <HeadDownloaderDelegate> delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, retain) HotUserInfo *userRecord;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <HeadDownloaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol HeadDownloaderDelegate 

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end