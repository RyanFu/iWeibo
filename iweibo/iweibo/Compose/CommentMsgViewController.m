    //
//  CommentMsgViewController.m
//  iweibo
//
//  Created by Minwen Yi on 12/28/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "CommentMsgViewController.h"


@implementation CommentMsgViewController
@synthesize withBroadcast;
@synthesize homeInfo;
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

- (void)UpdateBroadcastStatus:(BOOL)broadcast {
	if(!broadcast) {
		withBroadcast=NO;
		[replyAndCommentBtn setImage:[UIImage imageNamed:@"composeForwardAndComment1.png"] forState:UIControlStateNormal];
	}
	else 
	{
		withBroadcast=YES;
		[replyAndCommentBtn setImage:[UIImage imageNamed:@"composeForwardAndComment2.png"] forState:UIControlStateNormal];
	}
}

- (void)UpdateBroadcastStatusWithDraft:(Draft *)draftSource {
	BOOL broadcast=NO;
	if (draftSource && REPLY_COMMENT_MESSAGE == draftSource.draftType) {
		broadcast = YES;
	}
	[self UpdateBroadcastStatus:broadcast];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
	[customLab setTextColor:[UIColor whiteColor]];
	[customLab setText:@"评论"];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	//self.navigationItem.title = @"评论";
		
	cutlineImage.image = [UIImage imageNamed:@"composeCommentCutline.png"];
	// 添加 "评论并转播" 
	replyAndCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	replyAndCommentBtn.frame = CGRectMake(5, 27, 20, 22);
	replyAndCommentBtn.tag = ReplyAndCommentBtnTag;
	[replyAndCommentBtn setImage:[UIImage imageNamed:@"composeForwardAndComment1.png"] forState:UIControlStateNormal];
	[replyAndCommentBtn addTarget:self action:@selector(replyAndCommentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
	[MidBaseView addSubview:replyAndCommentBtn];
	
	UIButton *forWardAndCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[forWardAndCommentButton setTitle:@"评论并转播" forState:UIControlStateNormal];
	[forWardAndCommentButton setTitleColor:[UIColor colorWithRed:160/255 green:0.4 blue:0.6 alpha:1] forState:UIControlStateNormal];
	forWardAndCommentButton.frame = CGRectMake(21, 27, 107, 22);
	forWardAndCommentButton.titleLabel.textAlignment = UITextAlignmentLeft;
	forWardAndCommentButton.titleLabel.font = [UIFont systemFontOfSize:16];
	[forWardAndCommentButton addTarget:self action:@selector(replyAndCommentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
	[MidBaseView addSubview:forWardAndCommentButton];
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
    CLog(@"取消评论微博");
    [super CancelCompose:sender];
}

// finish compse message
- (void)DoneCompose:(id) sender {
	CLog(@"完成并发送评论微博");
	[super DoneCompose:sender];
}

- (void)replyAndCommentBtnClicked {
	draftComposed.draftType = withBroadcast ? COMMENT_MESSAGE : REPLY_COMMENT_MESSAGE;	
	[self UpdateBroadcastStatus:!withBroadcast];
}

// 用草稿内容初始化界面(当前只处理文本部分)
- (CommentMsgViewController *)initWithDraft:(Draft *)draftSource {
	if (self = [super initWithDraft:draftSource]) {

	}
	return self;
}

// 更新界面数据到草稿
- (void)UpdateDraft {
	// 文本
	[super UpdateDraft];
	// 转播状态: 自动更新
}

// 根据草稿更新界面
- (void)UpdateViewWithDraft:(Draft *)draftSource {
	[super UpdateViewWithDraft:draftSource];
	// 更新按钮状态
	[self UpdateBroadcastStatusWithDraft:draftSource];
}

@end
