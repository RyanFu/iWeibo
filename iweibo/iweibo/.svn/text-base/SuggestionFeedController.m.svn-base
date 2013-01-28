    //
//  SuggestionFeedController.m
//  iweibo
//
//  Created by lichentao on 12-3-6.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "SuggestionFeedController.h"


@implementation SuggestionFeedController

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
	[customLab setText:@"意见反馈"];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	//self.navigationItem.title = @"意见反馈";
	draftComposed.draftType = SUGGESTION_FEEDBACK_MESSAGE;	// 广播类型
	textView.text = nil;// 将之前的文本置空
	[self insertTextAtCurrentIndex:draftComposed.draftText];// 设置光标设置光标位置
}

// cancel compose message
//- (void)CancelCompose:(id) sender {
//    CLog(@"取消意见反馈微博");
//    [super CancelCompose:sender];
//}
//
// finish compse message
//- (void)DoneCompose:(id) sender {
//	CLog(@"完成并发送意见反馈微博");
//	[super DoneCompose:sender];
//}

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


@end
