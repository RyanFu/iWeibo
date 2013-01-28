//
//  RumexCustomTabBar.m
//  
//
//  Created by Oliver Farago on 19/06/2010.
//  Copyright 2010 Rumex IT All rights reserved.
//

#import "RXCustomTabBar.h"
#import "HpThemeManager.h"
#import "iweiboAppDelegate.h"

@implementation RXCustomTabBar

@synthesize btn1, btn2, btn3, btn4;
@synthesize tabBarView;

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(updateTheme:) 
												 name:kThemeDidChangeNotification 
											   object:nil];
    [self addCustomElements];
}

-(void)updateTheme:(NSNotification*)notif{
	NSDictionary *dic = [[HpThemeManager sharedThemeManager] themeDictionary];
	NSString *themePathTmp = [dic objectForKey:@"TimelineImage"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
	if(themePath){
		UIButton *tabBarButton = nil;
		UIImage *img0 = nil;
		UIImage *img1 = nil;
//		tabbarBg.image = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"tabBarBg.png"]];
		NSArray *tabView = self.view.subviews;
		for (int i = 0; i<[tabView count]; i++) {
			UIView *firstView = [tabView objectAtIndex:i];
			for (UIView *secondView in firstView.subviews) {
				for (UIView *view in secondView.subviews) {
					if ([view isKindOfClass:[UIButton class]]) {
						switch (view.tag) {
							case 0:
								tabBarButton = (UIButton *) [view viewWithTag:view.tag];
								img0 = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"TabBar_01.png"]];
								img1 = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"TabBar_01_s.png"]];
								break;
							case 1:
								tabBarButton = (UIButton *) [view viewWithTag:view.tag];
								img0 = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"TabBar_02.png"]];
								img1 = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"TabBar_02_s.png"]];
								break;
							case 2:
								tabBarButton = (UIButton *) [view viewWithTag:view.tag];
								img0 = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"TabBar_03.png"]];
								img1 = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"TabBar_03_s.png"]];
								break;
							case 3:
								tabBarButton = (UIButton *) [view viewWithTag:view.tag];
								img0 = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"TabBar_04.png"]];
								img1 = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"TabBar_04_s.png"]];
							default:
								break;
						}
						[tabBarButton setBackgroundImage:img0 forState:UIControlStateNormal];
						[tabBarButton setBackgroundImage:img1 forState:UIControlStateSelected];
					}
				}
			}
		}
	}
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self hideTabBar];
}

- (void)hideTabBar {
   if (self.tabBar.hidden == YES) {
		return;
	}
	UIView *contentView;
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.view.subviews objectAtIndex:1];
    else
        contentView = [self.view.subviews objectAtIndex:0];
	contentView.frame = CGRectMake(contentView.bounds.origin.x, 
								   contentView.bounds.origin.y, 
								   contentView.bounds.size.width, 
								   contentView.bounds.size.height + self.tabBar.frame.size.height);        
	self.tabBar.hidden = YES;
}

- (void)hideNewTabBar 
{
      CLog(@"隐藏tabbar");
    self.tabBarView.hidden = 1;
}

- (void)showNewTabBar 
{
      CLog(@"显示tabbar");
    self.tabBarView.hidden = 0;
}

//做了修改 设置tab bar
-(void)addCustomElements
{
	int btn_x = 0;
	int btn_y = 0;
	int btn_with = 80;
	int btn_height = 48+1;
	
	int label_y = 30;
	int label_height = 12;
	
	int bview_x = 0;
	int bview_y = 0;
	int bview_width= self.view.frame.size.width/4;
	int bview_height= 48+1;
	
    NSDictionary *dic = nil;
	self.tabBarView = [[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, bview_height)] autorelease];
    
    NSDictionary *pathDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"ThemePath"];
    if ([pathDic count] == 0){
        dic = [[HpThemeManager sharedThemeManager]themeDictionary];
        if ([dic count] == 0) {
            NSString *skinPath = [[NSBundle mainBundle] pathForResource:@"ThemeManager" ofType:@"plist"];
            dic = [[NSArray arrayWithContentsOfFile:skinPath] objectAtIndex:0];
        }
    }
    else{
        dic = pathDic;
    }
	NSString *themePathTmp = [dic objectForKey:@"TimelineImage"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
	
//	tabbarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1, 320, 50)];
//	tabbarBg.image = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"tabBarBg.png"]];
//	[self.tabBarView addSubview:tabbarBg];
	[self.view addSubview:self.tabBarView];

    //set tabbar button 一个循环就够了不用写那么多
    for (int i=0; i<4; i++) {
        UIView *tabbgView = [[UIView alloc] initWithFrame:CGRectMake(i*bview_width, bview_y, bview_width, bview_height)];
        tabbgView.backgroundColor = [UIColor clearColor];
        [self.tabBarView addSubview:tabbgView];
        
        UIButton *tabBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tabBarButton.frame = CGRectMake(btn_x, btn_y, btn_with, btn_height);
		UIImage *tabNormalImage = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:[NSString stringWithFormat:@"TabBar_0%d.png",i+1]]];
		[tabBarButton setBackgroundImage:tabNormalImage forState:UIControlStateNormal];
		UIImage *tabSelectedImage = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:[NSString stringWithFormat:@"TabBar_0%d_s.png",i+1]]];
		[tabBarButton setBackgroundImage:tabSelectedImage forState:UIControlStateSelected];
        [tabBarButton setTag:i]; 
        [tabBarButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tabbgView addSubview:tabBarButton];
        [tabbgView release];
        //设置标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(bview_x, label_y, btn_with, label_height)];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [tabBarButton addSubview:titleLabel];
        tabBarButton.showsTouchWhenHighlighted = YES;
        titleLabel.font = [UIFont boldSystemFontOfSize:9.0];
        if (tabBarButton.tag==0) {
            self.btn1 = tabBarButton;
            bubbleBg = [[UIImageView alloc] initWithFrame:CGRectMake(43, 4, 14, 15)];
            bubbleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 13)];
            bubbleLabel.textAlignment = UITextAlignmentCenter;
            bubbleLabel.adjustsFontSizeToFitWidth = YES;
            bubbleLabel.font = [UIFont systemFontOfSize:10];
            bubbleLabel.textColor = [UIColor whiteColor];
            bubbleLabel.backgroundColor = [UIColor clearColor];
            [bubbleBg addSubview:bubbleLabel];
            [self.btn1 addSubview:bubbleBg];
            bubbleBg.hidden = YES;
            [tabBarButton setSelected:true];
            //titleLabel.text = @"主页"; 
        }
        if (tabBarButton.tag==1) {
            self.btn2 = tabBarButton;
            //titleLabel.text = @"消息"; 
        }
        if (tabBarButton.tag==2) {
            self.btn3 = tabBarButton;
            //titleLabel.text = @"探索";
        }
        if (tabBarButton.tag==3) {
            self.btn4 = tabBarButton;
            //titleLabel.text = @"更多"; 
        }
        [titleLabel release];
    }

}

- (void)showNewMsgBubble:(NSString *)numMsg
{
    if ([numMsg isEqualToString:@"0"]) {
        [self hideNewMsgBubble];
        return;
    }
    int numNewMsg = [numMsg intValue];
    CLog(@"消息个数：%d",numNewMsg);
    if(numNewMsg>0 && numNewMsg<10)
    {
        CLog(@"一个字符");
        bubbleBg.image = [UIImage imageNamed:@"bubble.png"];
        bubbleBg.frame = CGRectMake(43, 4, 14, 15);
        bubbleLabel.frame = CGRectMake(0, 0, 14, 13);
        bubbleLabel.text = numMsg;
    }
    else if(numNewMsg>9 && numNewMsg<100)
    {
        CLog(@"两个字符");
        bubbleBg.image = [UIImage imageNamed:@"twoChar.png"];
        bubbleBg.frame = CGRectMake(43, 4, 19, 15);
        bubbleLabel.frame = CGRectMake(0, 0, 19, 13);
        bubbleLabel.text = numMsg;
    }
    else
    {
        CLog(@"三个字符");
        bubbleBg.image = [UIImage imageNamed:@"threeChar.png"];
        bubbleBg.frame = CGRectMake(43, 4, 23, 15);
        bubbleLabel.frame = CGRectMake(0, 0, 23, 13);
        bubbleLabel.text = @"99+";
    }
    bubbleBg.hidden = NO;
    CLog(@"显示bubble");
}
- (void)hideNewMsgBubble
{
    bubbleBg.hidden = YES;
    CLog(@"隐藏bubble");
}
- (void)buttonClicked:(id)sender
{
    int i = [(UIButton *)sender tag];
	switch(i)
	{
		case 0:
            if (btn1.selected) {
                CLog(@"刷新首页");
                iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.homeTab refresh];
            }
			[btn1 setSelected:true];
			[btn2 setSelected:false];
			[btn3 setSelected:false];
			[btn4 setSelected:false];
			break;
		case 1:
			[btn1 setSelected:false];
			[btn2 setSelected:true];
			[btn3 setSelected:false];
			[btn4 setSelected:false];
			break;
		case 2:
			[btn1 setSelected:false];
			[btn2 setSelected:false];
			[btn3 setSelected:true];
			[btn4 setSelected:false];
			break;
		case 3:
			//if (!btn4.selected) {
//				iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
//                [delegate.moreTab reloadPersonalInfo];
//			}
			[btn1 setSelected:false];
			[btn2 setSelected:false];
			[btn3 setSelected:false];
			[btn4 setSelected:true];
			break;
	}	
	
	self.selectedIndex = [(UIButton *)sender tag];
	
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [bubbleLabel release];
	[tabbarBg release];
    [bubbleBg release];
	[btn1 release];
	[btn2 release];
	[btn3 release];
	[btn4 release];
    [tabBarView release];
    [super dealloc];
}

@end
