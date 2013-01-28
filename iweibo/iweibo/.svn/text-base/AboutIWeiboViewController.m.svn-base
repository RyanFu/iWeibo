//
//  AboutIWeiboViewController.m
//  iweibo
//
//  Created by Cui Zhibo on 12-7-17.
//  Copyright (c) 2012年 Beyondsoft. All rights reserved.
//

#import "AboutIWeiboViewController.h"

@implementation AboutIWeiboViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_bg.png"]];
    bgImgView.frame = CGRectMake(0, 44, 320, 416);
    bgImgView.tag = 100;
    [self.view addSubview:bgImgView];
    [bgImgView release];
    UIButton *guideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    guideBtn.frame = CGRectMake((320 - 123)/2, 280, 123, 32);
    [guideBtn setImage:[UIImage imageNamed:@"guide_btn.png"] forState:UIControlStateNormal];
    [guideBtn addTarget:self action:@selector(showAboutView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:guideBtn];
    
    UIImage *viewSearchImg = [UIImage imageNamed:@"subScribeTitleBg.png"];
	UIImageView	*viewSearchBG = [[UIImageView alloc] initWithImage:viewSearchImg];
    viewSearchBG.frame = CGRectMake(-5, 0, 330, topImageHeight);
	[self.view addSubview:viewSearchBG];
	viewSearchBG.userInteractionEnabled = YES;
	[viewSearchBG release];
	UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	leftButton.frame = CGRectMake(5,4, 50, 30);
	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
	leftButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    leftButton.titleLabel.shadowOffset = CGSizeMake(-1.0f, 2.0f);
    leftButton.titleLabel.shadowColor = [UIColor blackColor];
	[leftButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
	[leftButton setBackgroundImage:[UIImage imageNamed:@"subScribeNav.png"] forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(backTopage) forControlEvents:UIControlEventTouchUpInside];
    UILabel *midoleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65.0f, 11, 200, 20)];
    midoleLabel.textColor = [UIColor whiteColor];
    midoleLabel.text = @"关于";
    midoleLabel.textAlignment = UITextAlignmentCenter;
    midoleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    midoleLabel.backgroundColor = [UIColor clearColor];
    [viewSearchBG addSubview:midoleLabel];
    [midoleLabel release];
	[self.view addSubview:leftButton];
}

- (void)showAboutView{
    [[NSUserDefaults standardUserDefaults] boolForKey:@"come"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"come"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backTopage{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
