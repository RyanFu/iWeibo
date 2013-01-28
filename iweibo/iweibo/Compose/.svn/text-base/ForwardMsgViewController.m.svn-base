    //
//  ForwardMsgViewController.m
//  iweibo
//
//  Created by Minwen Yi on 12/28/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "ForwardMsgViewController.h"
#import "Canstants_Data.h"


@implementation ForwardMsgViewController

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
	[customLab setTextColor:[UIColor whiteColor]];
	[customLab setText:@"转播"];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	//self.navigationItem.title = @"转播";
	// 转播发送按钮可用
	self.navigationItem.rightBarButtonItem.enabled = YES;
	draftComposed.draftType = FORWORD_MESSAGE;	// 转播类型
	// 禁掉取照片功能
	UIButton *photoFromCameraBtn = (UIButton *)[self.view viewWithTag:PhotoFromCameraBtnTag];
	photoFromCameraBtn.enabled = NO;
	[photoFromCameraBtn setImage:[UIImage imageNamed:@"composeCameraDisable.png"] forState:UIControlStateNormal];
	UIButton *photoFromLibraryBtn = (UIButton *)[self.view viewWithTag:PhotoFromLibraryBtnTag];
	photoFromLibraryBtn.enabled = NO;
	[photoFromLibraryBtn setImage:[UIImage imageNamed:@"composePhotoDisable.png"] forState:UIControlStateNormal];
	self.bPicPickEnabled = NO;
}

- (ForwardMsgViewController *)initWithDraft:(Draft *)draftSource {
	if (self = [super initWithDraft:draftSource]) {
		
	}
	return self;
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
}

- (void)dealloc {
    [super dealloc];
}

// cancel compose message
- (void)CancelCompose:(id) sender {
    CLog(@"取消转播微博");
    [super CancelCompose:sender];
}

// finish compse message
- (void)DoneCompose:(id) sender {
	CLog(@"完成并发送转播微博");
	[super DoneCompose:sender];
	
}
@end
