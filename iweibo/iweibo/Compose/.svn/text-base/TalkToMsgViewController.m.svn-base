    //
//  TalkToMsgViewController.m
//  iweibo
//
//  Created by Minwen Yi on 2/2/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "TalkToMsgViewController.h"


@implementation TalkToMsgViewController

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
	assert(draftComposed.draftTitle != nil);
	NSString *strTitle = [[NSString alloc] initWithFormat:@"对 %@ 说",draftComposed.draftTitle];
	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
	[customLab setTextColor:[UIColor whiteColor]];
	[customLab setText:strTitle];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	//self.navigationItem.title = strTitle;
	[strTitle release];
	draftComposed.draftType = TALK_TO_MESSAGE;	// 转播类型
    
    NSString *trimmedString = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; 
	if ([trimmedString length] > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
	}
    else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
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
}


- (void)dealloc {
    [super dealloc];
}


@end
