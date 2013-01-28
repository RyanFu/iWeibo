    //
//  BroadcastMsgViewController.m
//  iweibo
//
//  Created by Minwen Yi on 12/28/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "BroadcastMsgViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+rotate.h"
#import "MessageViewUtility.h"
#import <MapKit/MapKit.h>


@implementation BroadcastMsgViewController
@synthesize imageView;
@synthesize imageCtrlView;
@synthesize imageViewClicked;
@synthesize bPicPickEnabled;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)UpdateAttachedDataWithDraft:(Draft *)draftSource {
	if (draftSource && PICTURE_DATA == draftSource.attachedDataType) {
		if (imageView) {
			[imageView removeFromSuperview];
		}
		imageView = [[AttachedPictureView alloc]initWithFrame:CGRectMake(5, -4, 43, 32)];
		imageView.myAttachedPictureViewDelegate = self;
		UIImage *imageSource = [[UIImage alloc] initWithData:draftSource.attachedData];
		[imageView setAttachedImage:imageSource];
		// lichentao 2012-03-22修改
		draftComposed.ImageRef = imageSource;
		[imageSource release];
		//	显示图片缩略图片
		//CATransition *animation = [CATransition animation];
//		animation.delegate = self;
//		animation.duration = 0.7;
//		animation.timingFunction = UIViewAnimationCurveEaseInOut;
//		animation.type = kCATransitionPush;
		[MidBaseView addSubview:imageView];
//		[[imageView layer] addAnimation:animation forKey:@"animation"];
		self.navigationItem.rightBarButtonItem.enabled = YES;	// 激活发送按钮
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	draftComposed.draftType = BROADCAST_MESSAGE;	// 广播类型
	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
	[customLab setTextColor:[UIColor whiteColor]];
	if (draftComposed.draftTitle == nil || [draftComposed.draftTitle length] == 0) {
		[customLab setText:@"广播"];
	}else {
		// 2012-02-08 直接跟某人对话需要修改标题
		[customLab setText:draftComposed.draftTitle];
	}
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	//if (draftComposed.draftTitle == nil || [draftComposed.draftTitle length] == 0) {
//		self.navigationItem.title = @"广播";
//	}else {
//		// 2012-02-08 直接跟某人对话需要修改标题
//		self.navigationItem.title = draftComposed.draftTitle;
//	}
	
	// 3.6 照相 按钮
	bPicPickEnabled = YES;
	// 检测照相机状态
	UIButton *photoFromCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[photoFromCameraBtn setImage:[UIImage imageNamed:@"composeCameraEnable.png"] forState:UIControlStateNormal];
	[photoFromCameraBtn setImage:[UIImage imageNamed:@"composeCamerahover.png"] forState:UIControlStateHighlighted];
	photoFromCameraBtn.frame = PhotoFromCameraBtnFrame;
	photoFromCameraBtn.tag = PhotoFromCameraBtnTag;
	[photoFromCameraBtn addTarget:self action:@selector(pickImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[MidBaseView addSubview:photoFromCameraBtn];
	if (! [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		photoFromCameraBtn.enabled = NO;
		[photoFromCameraBtn setImage:[UIImage imageNamed:@"composeCameraDisable.png"] forState:UIControlStateNormal];
	}
	// 3.7 照片 按钮
	UIButton *photoFromLibraryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[photoFromLibraryBtn setImage:[UIImage imageNamed:@"composePhotoEnable.png"] forState:UIControlStateNormal];
	[photoFromLibraryBtn setImage:[UIImage imageNamed:@"composePhotohover.png"] forState:UIControlStateHighlighted];
	photoFromLibraryBtn.frame = PhotoFromLibraryBtnFrame;
	photoFromLibraryBtn.tag = PhotoFromLibraryBtnTag;
	[photoFromLibraryBtn addTarget:self action:@selector(pickImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[MidBaseView addSubview:photoFromLibraryBtn];
    
    //3.8 大头针 按钮
//    UIButton * pinOfMapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [pinOfMapBtn setImage:[UIImage imageNamed:@"pin1.png"] forState:UIControlStateNormal];
//    [pinOfMapBtn setImage:[UIImage imageNamed:@"pin2.png"] forState:UIControlStateHighlighted];
//    pinOfMapBtn.frame = PinOfMapBtnFrame;
//    pinOfMapBtn.tag = PinOfMapBtnTag;
//    [pinOfMapBtn addTarget:self action:@selector(pinMapBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [MidBaseView addSubview:pinOfMapBtn];

	
	// 更新附件状态
	
	//[self performSelector:@selector(UpdateAttachedDataWithDraft:) withObject:draftComposed];
	[self UpdateAttachedDataWithDraft:draftComposed];
	
	// 从订阅话题进入消息页面，或者从草稿箱进来，draft.draftText有内容，将文本光标显示到最后lichentao 2012-03-13
	if(draftComposed.isFromHotTopic || draftComposed.isFromDraft){
		textView.text = nil;// 将之前的文本置空
		[self insertTextAtCurrentIndex:draftComposed.draftText];// 设置光标设置光标位置
	}
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.imageCtrlView = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	
    [self setModalInPopover:YES];
}


- (void)dealloc {
//    [gpsManger release];
	[imageCtrlView release];
	imageCtrlView = nil;
	[imageView release];
	imageView = nil;

    [super dealloc];
}

// 调用图片资源
- (void)pickImageBtnClick:(id)sender {
	if ([textView hasText]) {
		curSelectedRange = textView.selectedRange;
	}
	//[MessageViewUtility printAvailableMemory];
	
	[textView resignFirstResponder];
	UIButton *btn=(UIButton *)sender;
	if (btn.tag == PhotoFromCameraBtnTag) {			// 取自摄像机
//		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
			//[imageView removeFromSuperview];
		//added by wangying 20120331 修改tapd   9157624 【验收测试】写广播点击照相机时界面切换时写广播页面上面出现白条
		iweiboAppDelegate *appDelegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate; 
		appDelegate.window.backgroundColor = [UIColor blackColor];
			UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
			imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;		
			imagePicker.delegate = self;
			[[UIApplication sharedApplication] setStatusBarHidden:YES];
			[self presentModalViewController:imagePicker animated:YES];
			[imagePicker release];
//		}
//		else {		// 在viewDidLoad
//			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" 
//														   message:@"不支持摄像机功能" 
//														  delegate:self 
//												 cancelButtonTitle:@"取消" 
//												 otherButtonTitles:nil];
//			[alert show];
//			[alert release];
//		}
	}
	else {											// 取自相册
		iweiboAppDelegate *dele =(iweiboAppDelegate *) [[UIApplication sharedApplication] delegate];
		dele.draws = 0;
		//[imageView removeFromSuperview];
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;	
		imagePicker.delegate = self;
		//[[UIApplication sharedApplication] setStatusBarHidden:YES];
		[self presentModalViewController:imagePicker animated:YES];
		[imagePicker release];
	}
}

//显示地理位置
/*
-(void)pinMapBtnClick:(id)sender
{
    
    UIButton * pinBtn = (UIButton *)sender;
    if (pinBtn) {
        if (!pinOfMapClieked) {
            pinOfMapClieked = YES;
            [pinBtn setImage:[UIImage imageNamed:@"pin2.png"] forState:UIControlStateNormal];
            
            if([UITableViewControllerEx checkShowMapNetWorkStatus]){
                
                [self getCurrentLocation]; //打开gps定位，获取用户当前位置坐标
                
                [netErrorlabel removeFromSuperview];
                UILabel * btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 170, 30)];
                btnLabel.backgroundColor = [UIColor clearColor];
                btnLabel.text = @"博彦科技";
                size =  [btnLabel.text sizeWithFont:[UIFont systemFontOfSize:20] 
                                  constrainedToSize:CGSizeMake(300, 50) 
                                      lineBreakMode:UILineBreakModeCharacterWrap];
                
                UIImageView * leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 30)];
                [leftView setImage:[UIImage imageNamed:@"pin2.png"]];
                UIImageView * rightView = [[UIImageView alloc] initWithFrame:CGRectMake(185, 0, 15, 30)];
                [rightView setImage:[UIImage imageNamed:@"right.png"]];
                
                showToMapView = [[UIImageView alloc] init];
                if(imageView == nil){
                    showToMapView.frame = CGRectMake(5, 100, size.width + 20, 30);
                }else{
                    showToMapView.frame = CGRectMake(55, 100, size.width + 20, 30);
                    
                }
                showToMapView.userInteractionEnabled = YES;
                UITapGestureRecognizer * click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showat:)];
                [showToMapView addGestureRecognizer:click];
                [showToMapView setImage:[UIImage imageNamed:@"right.png"]];
                [showToMapView addSubview:btnLabel];
                [showToMapView addSubview:leftView];
                
                [click release];
                [btnLabel release];
                [leftView release]; 
                [rightView release];
                
                
                [self.view addSubview:showToMapView];
                [showToMapView release];
            }else{
                [showToMapView removeFromSuperview];
                if(imageView == nil){
                    netErrorlabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 100, 200, 30)];
                }else{
                    netErrorlabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 100, 200, 30)];}
                netErrorlabel.text = @"网络连接错误,请检查......";
                [netErrorlabel sizeToFit];
                [self.view addSubview:netErrorlabel];
                [netErrorlabel release];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:2];
                netErrorlabel.alpha = 0;
                pinOfMapClieked = NO;
                [pinBtn setImage:[UIImage imageNamed:@"pin1.png"] forState:UIControlStateNormal];
                [UIView commitAnimations];
                return;
            }
        }else{
            pinOfMapClieked = NO;
            [pinBtn setImage:[UIImage imageNamed:@"pin1.png"] forState:UIControlStateNormal];
            [showToMapView removeFromSuperview];    //关闭gps定位
//            if (gpsManger) {
//                [gpsManger stopUpdatingLocation];
//            }

        }
        
    }
}


- (void)hiddenItem{
    pinOfMapClieked = YES;
    UIButton *btn = (UIButton *)[MidBaseView viewWithTag:PinOfMapBtnTag];
    [self pinMapBtnClick:btn];
}
//显示地图界面
-(void)showat:(id)sender
{
    smvctrl = [[ShowMapViewController alloc] init];
    smvctrl.delegate = self;
    smvctrl.cancel = @selector(hiddenItem);
    [self.navigationController  pushViewController:smvctrl animated:YES];
    [smvctrl release];
    
}
//打开定位器
-(void)getCurrentLocation{
    
    if(gpsManger == nil){
        gpsManger = [[CLLocationManager alloc] init] ;
    }
    if(![CLLocationManager locationServicesEnabled]){
        NSLog(@"no GPS");
    }else{
        gpsManger.delegate = self;
        gpsManger.distanceFilter = 100.0f; 
        [gpsManger startUpdatingLocation];
        
    }
    
}
//获取坐标
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

    userLatitude = newLocation.coordinate.latitude;
    userLongitude = newLocation.coordinate.longitude;
    NSLog(@"userLatitude is %lf,userLongitude is %lf",userLatitude,userLongitude);
}
*/
#pragma mark imagePickerDelegate
/*Keys for the editing information dictionary passed to the delegate.
 
 NSString *const UIImagePickerControllerMediaType;
 NSString *const UIImagePickerControllerOriginalImage;
 NSString *const UIImagePickerControllerEditedImage;
 NSString *const UIImagePickerControllerCropRect;
 NSString *const UIImagePickerControllerMediaURL;
 NSString *const UIImagePickerControllerReferenceURL;
 NSString *const UIImagePickerControllerMediaMetadata;
*/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	assert(image != nil);
	if (nil == imageView) {
		imageView = [[AttachedPictureView alloc]initWithFrame:CGRectMake(5 - 43, -4, 43, 32)];
		imageView.myAttachedPictureViewDelegate = self;
		[MidBaseView addSubview:imageView];
//        showToMapView.frame = CGRectMake(5, 100, size.width + 20, 30);
	}
	UIImage *postImage = [image rotateImage:image.imageOrientation];
	[imageView setAttachedImage:postImage];
	imageView.backgroundColor = [UIColor clearColor];
	// 保存图片到草稿
	draftComposed.attachedDataType = PICTURE_DATA;
	// 2012-02-20 By Yi Minwen 修正一个图片资源泄露的bug
	//draftComposed.attachedData = [UIImageJPEGRepresentation(image, 0.8) retain];
	//CLog(@"origin data 1.0 length:%d", [UIImageJPEGRepresentation(image, 1.0) length]);
//	CLog(@"origin data 0.9 length:%d", [UIImageJPEGRepresentation(image, 0.9) length]);
//	CLog(@"origin data 0.8 length:%d", [UIImageJPEGRepresentation(image, 0.8) length]);
//	CLog(@"origin data 0.7 length:%d", [UIImageJPEGRepresentation(image, 0.7) length]);
//	CLog(@"origin data 0.6 length:%d", [UIImageJPEGRepresentation(image, 0.6) length]);
	draftComposed.attachedData = UIImageJPEGRepresentation(postImage, 0.8);
	draftComposed.ImageRef = postImage;
	//	显示图片缩略图片
	CATransition *animation = [CATransition animation];
	animation.delegate = self;
	animation.duration = 0.7;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = kCATransitionPush;
	//[MidBaseView addSubview:imageView];
	imageView.frame = CGRectMake(5, -4, 43, 32);
	[[imageView layer] addAnimation:animation forKey:@"animation"];
    // 图像缩略图存在，图片右移
//    showToMapView.frame = CGRectMake(55, 100, size.width + 20, 30);
        
    

	
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	//[picker dismissModalViewControllerAnimated:YES];
	self.navigationItem.rightBarButtonItem.enabled = YES;	// 激活发送按钮
	
	// 如果是系统相册中，则在返回的时候要将状态给置回1 2012／3／15 赵国辉修改
	if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
		// 如果是在相册中
		iweiboAppDelegate *dele =(iweiboAppDelegate *) [[UIApplication sharedApplication] delegate];
		dele.draws = 1;
	}
	//added by wangying 20120331 修改tapd   9157624 【验收测试】写广播点击照相机时界面切换时写广播页面上面出现白条
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[[UIApplication sharedApplication]delegate];
	delegate.window.backgroundColor = [UIColor whiteColor];
	[self dismissModalViewControllerAnimated:YES];
	//[picker release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

	// 如果是系统相册中，则在取消的时候要将状态给置回1 2012／3／15 赵国辉修改
	if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
		// 如果是在相册中
		iweiboAppDelegate *dele =(iweiboAppDelegate *) [[UIApplication sharedApplication] delegate];
		dele.draws = 1;
	}
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
    //[picker dismissModalViewControllerAnimated:YES];
	[self dismissModalViewControllerAnimated:YES];
	//[picker release];
}

#pragma mark -

#pragma mark AttachedPictureViewDelegate
- (void)AttachedPictureViewClicked {
	[self hideDownBaseSubViewExceptAttImage];
	CLog(@"AttachedPictureViewClicked");
	//return;
	self.imageViewClicked = YES;
	if (nil == imageCtrlView) {
		imageCtrlView = [[AttachedPictureCtrlView alloc] initWithFrame:CGRectMake(80, 16, 180.0f, 180.0f)];
		[imageCtrlView setMyAttachedPictureCtrlViewDelegate: self];
		[imageCtrlView attachImage:draftComposed.ImageRef];
		[DownBaseView addSubview:imageCtrlView];	
		[self setTextViewIsFirstResponser:NO];
	}
	else {
		[imageCtrlView attachImage:draftComposed.ImageRef];
		if (imageCtrlView.hidden == YES) {
			imageCtrlView.hidden = NO;	
			[self setTextViewIsFirstResponser:NO];
		}
		else {
			imageCtrlView.hidden = YES;
			[self setTextViewIsFirstResponser:YES];		// 文本输入状态
		}
	}
}

// 用草稿内容初始化界面
- (id)initWithDraft:(Draft *)draftSource {
	if (self = [super initWithDraft:draftSource]) {
	}
	return self;
}

// cancel compose message
- (void)CancelCompose:(id) sender {
    CLog(@"取消广播微博");
    [super CancelCompose:sender];
}

// finish compse message
- (void)DoneCompose:(id) sender {
	CLog(@"完成并发送广播微博");
	[super DoneCompose:sender];
}
#pragma mark AttachedPictureCtrlViewDelegate<NSObject> 
// 点击删除按钮
-(void)picCtrlViewDelBtnClicked {
	CLog(@"点击删除按钮");
	[imageCtrlView removeFromSuperview];
	[imageCtrlView release];
	imageCtrlView = nil;
	[imageView removeFromSuperview];
	[imageView release];
	imageView = nil;
    //图片删除，显示地图位置回退
//    if(showToMapView){
//        showToMapView.frame = CGRectMake(5, 100, size.width + 20, 30);
//    }

	// lichentao 2012-03-15从草稿箱进入消息页面，有图在删除图片将attacheData数据删除
	draftComposed.attachedData = nil;
	NSLog(@"draftComposed.attachedData is %@",draftComposed.attachedData);
	NSLog(@"draftComposed.attachedData length is %d",[draftComposed.attachedData length]);
	// 删除图片后如果文本框输入为空，则发送按钮不可用 lichentao
	if ([textView.text length] == 0) {
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
	[self setTextViewIsFirstResponser:YES];		// 文本输入状态
}

// 点击图片
-(void)picCtrlViewImageTouched:(UITapGestureRecognizer *)recognizer {
	CLog(@"点击图片");
}

// 中间底层背景按钮点击响应事件
- (void)btnTaped:(UITapGestureRecognizer *)recognizer {
	CGPoint point = [recognizer locationInView: [recognizer view]];
	// 点击5个图片中的哪一个
	NSInteger n = (NSInteger)(point.x) / (320 / MidViewBtnCount);
	switch (n) {
		case CameraBtnIndex:{
			// 照相
			if (bPicPickEnabled && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
				UIButton *photoFromCameraBtn = (UIButton *)[self.view viewWithTag:PhotoFromCameraBtnTag];
				[self pickImageBtnClick:photoFromCameraBtn];
			}
		}
			break;
		case PhotoBtnIndex:{
			// 照片
			if (bPicPickEnabled) {
				UIButton *photoFromLibraryBtn = (UIButton *)[self.view viewWithTag:PhotoFromLibraryBtnTag];
				[self pickImageBtnClick:photoFromLibraryBtn];
			}
		}
		default:
			[super btnTaped:recognizer];
			break;
	}
}

#pragma mark private Methods
// 更新界面数据到草稿
- (void)UpdateDraft {
	// 文本
	[super UpdateDraft];
	// 图片自动更新
}

// 根据草稿更新界面
- (void)UpdateViewWithDraft:(Draft *)draftSource {
	[super UpdateViewWithDraft:draftSource];
	// 更新附件状态
	[self performSelector:@selector(UpdateAttachedDataWithDraft:) withObject:draftSource];
	//[self UpdateAttachedDataWithDraft:draftSource];
}

- (void)hideDownBaseSubView {
	[self hideDownBaseSubViewExceptEmotion];
	[super hideDownBaseSubView];
}

// 隐藏表情之外的视图
- (void)hideDownBaseSubViewExceptEmotion {
	if (imageCtrlView && NO == imageCtrlView.hidden ) {
		imageCtrlView.hidden = YES;
		self.imageViewClicked = NO;
	}
}

// 隐藏表情之外的视图
- (void)hideDownBaseSubViewExceptAttImage {
	[super hideDownBaseSubView];
}
#pragma mark -
@end
