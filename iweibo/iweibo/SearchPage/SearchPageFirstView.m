//
//  SearchPageFirstView.m
//  iweibo
//
//  Created by Minwen Yi on 2/23/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "SearchPageFirstView.h"
#import "HpThemeManager.h"

@implementation SearchPageFirstView
@synthesize firstTopicBtn, secondTopicBtn, thirdTopicBtn, fourthTopicBtn, fifthTopicBtn, moreTopicBtn;
@synthesize hotTopicBtn, hotUserBtn, hotBroadcastMsgBtn;		
@synthesize mySearchPageFirstViewDelegate;
@synthesize btnTitleArray;
@synthesize hotTopicLabel,hotBroadcastLabel,hotUserLabel;

// 生成按钮
-(UIButton *)buttonWithTag:(NSUInteger)btnTag andImage:(UIImage *)imgName {
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.tag = btnTag;
	btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	btn.backgroundColor = [UIColor clearColor];
    if ([[sepatorArray objectAtIndex:0] isEqualToString:@"FirstSkin"]) {
        btn.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 22.0f, 0.0f, 0.0f);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else{
        btn.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 38.0f, 0.0f, 0.0f);
        [btn setTitleColor:[UIColor colorWithRed:0.2157 green:0.2157 blue:0.2157 alpha:1.0] forState:UIControlStateNormal];
    }
	btn.titleLabel.numberOfLines = 1;
	btn.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	[btn setBackgroundImage:imgName forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
	return btn;
}

- (void)setSearchFirstSkinSize{
    self.firstTopicBtn.frame = CGRectMake(26, 25, 111, 39);	
    firstTopicBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 22.0f, 0.0f, 0.0f);
    [firstTopicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.secondTopicBtn.frame = CGRectMake(159, 25, 124, 39);
    secondTopicBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 22.0f, 0.0f, 0.0f);
    [secondTopicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.thirdTopicBtn.frame = CGRectMake(26, 84, 127, 39);	
    thirdTopicBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 22.0f, 0.0f, 0.0f);
    [thirdTopicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.fourthTopicBtn.frame = CGRectMake(173, 84, 110, 39);
    fourthTopicBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 22.0f, 0.0f, 0.0f);
    [fourthTopicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.fifthTopicBtn.frame = CGRectMake(26, 143, 101, 39);
    fifthTopicBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 22.0f, 0.0f, 0.0f);
    [fifthTopicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.moreTopicBtn.frame = CGRectMake(149, 143, 134, 39);
    moreTopicBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 22.0f, 0.0f, 0.0f);
    [moreTopicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setSearchSecondSkinSize{
    self.firstTopicBtn.frame = CGRectMake(30, 21, 111, 39);	// 81-20(toolbar)-40(searchbar)
    firstTopicBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 38.0f, 0.0f, 0.0f);
    [firstTopicBtn setTitleColor:[UIColor colorWithRed:0.2157 green:0.2157 blue:0.2157 alpha:1.0] forState:UIControlStateNormal];
    self.secondTopicBtn.frame = CGRectMake(159, 21, 124, 39);	// 320-37(右边距)-124 
    secondTopicBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 38.0f, 0.0f, 0.0f);
    [secondTopicBtn setTitleColor:[UIColor colorWithRed:0.2157 green:0.2157 blue:0.2157 alpha:1.0] forState:UIControlStateNormal];
    self.thirdTopicBtn.frame = CGRectMake(30, 74, 127, 39);		//  21+39+14
    thirdTopicBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 38.0f, 0.0f, 0.0f);
    [thirdTopicBtn setTitleColor:[UIColor colorWithRed:0.2157 green:0.2157 blue:0.2157 alpha:1.0] forState:UIControlStateNormal];
    self.fourthTopicBtn.frame = CGRectMake(173, 74, 110, 39);	// 320-37(右边距)-110 
    fourthTopicBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 38.0f, 0.0f, 0.0f);
    [fourthTopicBtn setTitleColor:[UIColor colorWithRed:0.2157 green:0.2157 blue:0.2157 alpha:1.0] forState:UIControlStateNormal];
    self.fifthTopicBtn.frame = CGRectMake(30, 127, 101, 39);	// 74+39+14
    fifthTopicBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 38.0f, 0.0f, 0.0f);
    [fifthTopicBtn setTitleColor:[UIColor colorWithRed:0.2157 green:0.2157 blue:0.2157 alpha:1.0] forState:UIControlStateNormal];
    self.moreTopicBtn.frame = CGRectMake(149, 127, 134, 39);	// 320-37(右边距)-134
    moreTopicBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 38.0f, 0.0f, 0.0f);
    [moreTopicBtn setTitleColor:[UIColor colorWithRed:0.2157 green:0.2157 blue:0.2157 alpha:1.0] forState:UIControlStateNormal];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        NSDictionary *dic = nil;
		self.backgroundColor = [UIColor clearColor];
		changedArray = [[NSArray alloc] initWithObjects:@"热门话题",@"最新广播",@"热门用户",nil];
        changedCellImage = [[NSArray alloc] initWithObjects:@"SearchHotTopic.png",@"SearchHotBroadcast.png",@"SearchHotUser.png",nil];
      
        NSDictionary *pathDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"ThemePath"];
        if ([pathDic count] == 0){
            NSString *skinPath = [[NSBundle mainBundle] pathForResource:@"ThemeManager" ofType:@"plist"];
            dic = [[NSArray arrayWithContentsOfFile:skinPath] objectAtIndex:0];

        }
        else{
            dic = pathDic;
        }
		
        NSString *themePathTmp = [dic objectForKey:@"SearchPageFirstImage"];
        sepatorArray = [themePathTmp componentsSeparatedByString:@"/"];
        themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
        bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchBg.png"]]];
        [self addSubview:bgImageView];
//        bgImageView.center = CGPointMake(bgImageView.center.x, bgImageView.center.y + 1);
        // bgImageView的坐标以前是（0，1，320，368），这样导致不能覆盖整个视图，所以上边出现一个像素，下边出现两个像素的空白，现在改坐标如下 2012-7-19
        bgImageView.frame = CGRectMake(0, 0, 320, 371);
    
		// 第一个热门话题按钮
		firstTopicBtn = [self buttonWithTag:SPVFirstTopicBtnTag andImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchTopicLeft1.png"]]];
		[self addSubview:self.firstTopicBtn];
		// 第二个热门话题按钮
		secondTopicBtn = [self buttonWithTag:SPVSecondTopicBtnTag andImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchTopicRight1.png"]]];
		[self addSubview:self.secondTopicBtn];
		// 第三个热门话题按钮
		thirdTopicBtn = [self buttonWithTag:SPVThirdTopicBtnTag andImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchTopicLeft2.png"]]];
		[self addSubview:self.thirdTopicBtn];
		// 第四个热门话题按钮
		fourthTopicBtn = [self buttonWithTag:SPVFourthTopicBtnTag andImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchTopicRight2.png"]]];
		[self addSubview:self.fourthTopicBtn];
		// 第五个热门话题按钮
		fifthTopicBtn = [self buttonWithTag:SPVFifthTopicBtnTag andImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchTopicLeft3.png"]]];
		[self addSubview:self.fifthTopicBtn];
		// "更多"话题按钮
		moreTopicBtn = [self buttonWithTag:SPVMoreTopicBtnTag andImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchTopicRight3.png"]]];
		[self addSubview:self.moreTopicBtn];
        
        if ([[sepatorArray objectAtIndex:0] isEqualToString:@"FirstSkin"]) {
            [self setSearchFirstSkinSize];
            // 热门话题　按钮
            hotTopicBtn = [self buttonWithTag:SPVHotTopicBtnTag andImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchHotTopic.png"]]];
            self.hotTopicBtn.frame = CGRectMake(28, 247, 66, 67);		// 307 - 20 - 40 + (380 - 376) 166-129
            [self addSubview:self.hotTopicBtn];
            hotTopicLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 323, 66, 14)];	// 33 + 67 + 7
            hotTopicLabel.backgroundColor = [UIColor clearColor];
            hotTopicLabel.font = [UIFont systemFontOfSize:12];
            hotTopicLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
            hotTopicLabel.text = @"热门话题";
            hotTopicLabel.textAlignment = UITextAlignmentCenter;
            [self addSubview:hotTopicLabel];
            // 热门广播　按钮
            hotBroadcastMsgBtn = [self buttonWithTag:SPVHotBroadcastMsgBtnTag  andImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchHotBroadcast.png"]]];
            self.hotBroadcastMsgBtn.frame = CGRectMake(124, 247, 66, 67);		// 28 + 66 + 30
            [self addSubview:self.hotBroadcastMsgBtn];
            hotBroadcastLabel = [[UILabel alloc] initWithFrame:CGRectMake(124, 323, 66, 14)];	// 33 + 67 + 7
            hotBroadcastLabel.backgroundColor = [UIColor clearColor];
            hotBroadcastLabel.font = [UIFont systemFontOfSize:12];
            hotBroadcastLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
            hotBroadcastLabel.text = @"最新广播";
            hotBroadcastLabel.textAlignment = UITextAlignmentCenter;
            [self addSubview:hotBroadcastLabel];
            // 热门用户　按钮
            hotUserBtn = [self buttonWithTag:SPVHotUserBtnTag andImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchHotUser.png"]]];
            self.hotUserBtn.frame = CGRectMake(220, 247, 66, 67);				// 124 + 66 + 30
            [self addSubview:self.hotUserBtn];
            hotUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 323, 66, 14)];	// 33 + 67 + 7
            hotUserLabel.backgroundColor = [UIColor clearColor];
            hotUserLabel.font = [UIFont systemFontOfSize:12];
            hotUserLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
            hotUserLabel.text = @"热门用户";
            hotUserLabel.textAlignment = UITextAlignmentCenter;
            [self addSubview:hotUserLabel];
        }
        else{
            [self  setSearchSecondSkinSize];
            hotTopicBtn = [self buttonWithTag:SPVHotTopicBtnTag andImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchHotTopic.png"]]];
            self.hotTopicBtn.frame = CGRectMake(14.5, 204, 291, 49);		// 307 - 20 - 40 + (380 - 376) 166-129
            [self addSubview:self.hotTopicBtn];
            
            hotBroadcastMsgBtn = [self buttonWithTag:SPVHotBroadcastMsgBtnTag  andImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchHotBroadcast.png"]]];
            self.hotBroadcastMsgBtn.frame = CGRectMake(14.5, 253, 291, 49);		// 28 + 66 + 30
            [self addSubview:self.hotBroadcastMsgBtn];
            
            hotUserBtn = [self buttonWithTag:SPVHotUserBtnTag andImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchHotUser.png"]]];
            self.hotUserBtn.frame = CGRectMake(14.5, 302, 291, 49);				// 124 + 66 + 30
            [self addSubview:self.hotUserBtn];
        }

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

- (void)updateTheme:(NSNotificationCenter *)not{
	NSDictionary *dic = [[HpThemeManager sharedThemeManager] themeDictionary];
	NSString *themePathTmp = [dic objectForKey:@"SearchPageFirstImage"];
    NSArray *sepArray = [themePathTmp componentsSeparatedByString:@"/"];
	themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
	if(themePath){
        bgImageView.image = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchBg.png"]];
		[firstTopicBtn setBackgroundImage: [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchTopicLeft1.png"]] forState:UIControlStateNormal];
		[secondTopicBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchTopicRight1.png"]] forState:UIControlStateNormal];
		[thirdTopicBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchTopicLeft2.png"]] forState:UIControlStateNormal];
		[fourthTopicBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchTopicRight2.png"]] forState:UIControlStateNormal];
		[fifthTopicBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchTopicLeft3.png"]] forState:UIControlStateNormal];
		[moreTopicBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchTopicRight3.png"]] forState:UIControlStateNormal];
        if ([[sepArray objectAtIndex:0]isEqualToString:@"FirstSkin"]) {
            [self setSearchFirstSkinSize];
            hotTopicBtn.frame = CGRectMake(28, 247, 66, 67);
            [hotTopicBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchHotTopic.png"]] forState:UIControlStateNormal];
            // 启动程序默认为黑色背景时，在更换皮肤后，hotTopicLabel并未在init函数中生成，是空的，所以要加以下判断
            if (hotTopicLabel == nil) {
                hotTopicLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 323, 66, 14)];	// 33 + 67 + 7
                hotTopicLabel.backgroundColor = [UIColor clearColor];
                hotTopicLabel.font = [UIFont systemFontOfSize:12];
                hotTopicLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
                hotTopicLabel.text = @"热门话题";
                hotTopicLabel.textAlignment = UITextAlignmentCenter;
                [self addSubview:hotTopicLabel];
            }
            [self.hotTopicLabel  setHidden:NO];
            
            hotBroadcastMsgBtn.frame = CGRectMake(124, 247, 66, 67);
            [hotBroadcastMsgBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchHotBroadcast.png"]] forState:UIControlStateNormal];
            if (hotBroadcastLabel == nil) {
                hotBroadcastLabel = [[UILabel alloc] initWithFrame:CGRectMake(124, 323, 66, 14)];	// 33 + 67 + 7
                hotBroadcastLabel.backgroundColor = [UIColor clearColor];
                hotBroadcastLabel.font = [UIFont systemFontOfSize:12];
                hotBroadcastLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
                hotBroadcastLabel.text = @"最新广播";
                hotBroadcastLabel.textAlignment = UITextAlignmentCenter;
                [self addSubview:hotBroadcastLabel];
            }

            [self.hotBroadcastLabel setHidden:NO];
            
            hotUserBtn.frame = CGRectMake(220, 247, 66, 67);
            [hotUserBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchHotUser.png"]] forState:UIControlStateNormal];
            if (hotUserLabel == nil) {
                hotUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 323, 66, 14)];	// 33 + 67 + 7
                hotUserLabel.backgroundColor = [UIColor clearColor];
                hotUserLabel.font = [UIFont systemFontOfSize:12];
                hotUserLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
                hotUserLabel.text = @"热门用户";
                hotUserLabel.textAlignment = UITextAlignmentCenter;
                [self addSubview:hotUserLabel];
            }
            [self.hotUserLabel setHidden:NO];
        }
        else{
            [self setSearchSecondSkinSize];
            hotTopicBtn.frame = CGRectMake(14.5, 204, 291, 49);
            [hotTopicBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchHotTopic.png"]] forState:UIControlStateNormal];
            [self.hotTopicLabel setHidden:YES];
            
            hotBroadcastMsgBtn.frame = CGRectMake(14.5, 253, 291, 49);
            [hotBroadcastMsgBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchHotBroadcast.png"]] forState:UIControlStateNormal];
            [self.hotBroadcastLabel setHidden:YES];
            
            hotUserBtn.frame = CGRectMake(14.5, 302, 291, 48);
            [hotUserBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchHotUser.png"]] forState:UIControlStateNormal];
            [self.hotUserLabel setHidden:YES];

        }
        
	}
}

- (void)setBtnTitleArray:(NSMutableArray *)array{
	if (btnTitleArray != array) {
		[btnTitleArray release];
		btnTitleArray = [array retain];
	}
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	//[super drawRect:rect];
	[self setBtnTitleToWhite];
	switch ([self.btnTitleArray count]) {
		case 6:
			[self.moreTopicBtn setTitle:[self.btnTitleArray objectAtIndex:5] forState:UIControlStateNormal];
		case 5:
			[self.fifthTopicBtn setTitle:[self.btnTitleArray objectAtIndex:4] forState:UIControlStateNormal];
		case 4:
			[self.fourthTopicBtn setTitle:[self.btnTitleArray objectAtIndex:3] forState:UIControlStateNormal];
		case 3:
			[self.thirdTopicBtn setTitle:[self.btnTitleArray objectAtIndex:2] forState:UIControlStateNormal];
		case 2:
			[self.secondTopicBtn setTitle:[self.btnTitleArray objectAtIndex:1] forState:UIControlStateNormal];
		case 1:
			[self.firstTopicBtn	 setTitle:[self.btnTitleArray objectAtIndex:0] forState:UIControlStateNormal];
			break;
		default:
			break;
	}		
}

- (void)setBtnTitleToWhite{
	[self.moreTopicBtn setTitle:@"" forState:UIControlStateNormal];
	[self.fifthTopicBtn setTitle:@"" forState:UIControlStateNormal];
	[self.fourthTopicBtn setTitle:@"" forState:UIControlStateNormal];
	[self.thirdTopicBtn setTitle:@"" forState:UIControlStateNormal];
	[self.secondTopicBtn setTitle:@"" forState:UIControlStateNormal];
	[self.firstTopicBtn	 setTitle:@"" forState:UIControlStateNormal];
} 

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [hotUserLabel release];
    [hotBroadcastLabel release];
    [hotTopicLabel release];
    [bgImageView release];
    [changedArray release];
	[btnTitleArray release];
	btnTitleArray = nil;
    [super dealloc];
}

-(void)btnClicked:(id)idButton {
	if ([self.mySearchPageFirstViewDelegate respondsToSelector:@selector(SearchPageFirstViewBtnClicked:withInfo:)]) {
		[self.mySearchPageFirstViewDelegate SearchPageFirstViewBtnClicked:idButton withInfo:nil];
	}
}

@end
