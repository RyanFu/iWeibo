#import "HeadDownloader.h"
#import "HotUserInfo.h"

#define kAppIconHeight 48


@implementation HeadDownloader

@synthesize indexPathInTableView;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;
@synthesize userRecord;

#pragma mark
- (void)dealloc {
    [indexPathInTableView release];
    
    [activeDownload release];
    
    [imageConnection cancel];
    [imageConnection release];
    [userRecord release];
	
    [super dealloc];
}

- (void)startDownload {
    self.activeDownload = [NSMutableData data];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.userRecord.headURL, @"100"]]] delegate:self];
    self.imageConnection = conn;
    [conn release];
}

- (void)cancelDownload {
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.activeDownload = nil;
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    /*
    if (image.size.width != kAppIconHeight && image.size.height != kAppIconHeight) {
        CGSize itemSize = CGSizeMake(kAppIconHeight, kAppIconHeight);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.userRecord.userhead = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else {
        self.userRecord.userhead = image;
    }
	 */

    self.userRecord.userhead = image;
    self.activeDownload = nil;
    [image release];
    
    self.imageConnection = nil;
    [delegate appImageDidLoad:self.indexPathInTableView];
}

@end

