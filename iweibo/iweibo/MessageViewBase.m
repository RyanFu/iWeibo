//
//  MessageViewBase.m
//  iweibo
//
//  Created by Minwen Yi on 4/16/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "MessageViewBase.h"
#import "TextExtract.h"
#import "HomePage.h"			// 因为涉及表情字典


@implementation MessageViewBase
@synthesize hasPortrait;
@synthesize hasImage, hasVideo, hasLoadedImage, hasLoadedVideo;
@synthesize frameWidth, labelLocation;
@synthesize headFont;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		arrButtonsFree = [[NSMutableArray alloc] initWithCapacity:10];
		arrButtonsInUse = [[NSMutableArray alloc] initWithCapacity:10];
		for (int i = 0; i <3; i++) {
			UIButton *btn = [[UIButton alloc] init];
			btn.frame = CGRectMake(0.0f, 0.0f, 320.0f, 18.0f);
			[btn addTarget:self action:@selector(touchUrl:) forControlEvents:UIControlEventTouchUpInside];
			[btn setTitleColor:[UIColor colorWithRed:0.2 green:0.455 blue:0.596 alpha:1] forState:UIControlStateNormal];
			[btn setTitleColor:[UIColor colorWithRed:0.2 green:0.455 blue:0.596 alpha:1] forState:UIControlStateHighlighted];			
			[arrButtonsFree addObject:btn];
			btn.hidden = YES;
			btn.tag = LinkButtonTag;
			//[self.layer addSublayer:btn.layer];
			[self addSubview:btn];
			[btn release];
		}
		
		arrLablesFree = [[NSMutableArray alloc] initWithCapacity:10];
		arrLablesInUse = [[NSMutableArray alloc] initWithCapacity:10];
		for (int i = 0; i < 5; i++) {
			UILabel *lb = [[UILabel alloc] init];
			lb.frame = CGRectMake(0.0f, 0.0f, 320.0f, 18.0f);
			[arrLablesFree addObject:lb];
			lb.hidden = YES;
			lb.text = @"";
			lb.tag = TextLabelTag;
			[self addSubview:lb];
			//[self.layer addSublayer:lb.layer];
			[lb release];
		}
		arrImagesFree = [[NSMutableArray alloc] initWithCapacity:5];
		arrImagesInUse = [[NSMutableArray alloc] initWithCapacity:5];
		for (int i = 0; i < 1; i++) {
			UIImageView *imgView = [[UIImageView alloc] init];
			imgView.frame = CGRectMake(0.0f, 0.0f, EmotionImageWidth, EmotionImageWidth);
			[arrImagesFree addObject:imgView];
			imgView.hidden = YES;
			imgView.tag = EmotionViewTag;
			[self addSubview:imgView];
			[imgView release];
		}
		// 昵称
		nickBtn = [[UIButton alloc] init];
        [nickBtn addTarget:self action:@selector(touchUrl:) forControlEvents:UIControlEventTouchUpInside];
        [nickBtn setType:TypeNickName];
//		[nickBtn addTarget:self action:@selector(touchNick) forControlEvents:UIControlEventTouchUpInside];

		nickBtn.titleLabel.font = [UIFont systemFontOfSize:SourceTextFontSize];
		nickBtn.backgroundColor = [UIColor clearColor];
		[nickBtn setTitleColor: [UIColor colorWithRed:0.2 green:0.455 blue:0.596 alpha:1] forState:UIControlStateNormal];
		nickBtn.frame = CGRectMake(0.0f, 0.0f, 15.0f, 18.0f);
		[self addSubview:nickBtn];
		
		// 添加vip图片
		vipImage = [[UIImageView alloc] initWithImage:nil];
		vipImage.tag = VIPImageTag;
		[self addSubview:vipImage];
		// 派生类中自己处理字体类型
		//headFont = [UIFont systemFontOfSize:14];
		//tailFont = [UIFont systemFontOfSize:14];
		// may be deleted later.
		// 表情字典
		emoDic = [HomePage emotionDictionary];
		if (![emoDic isKindOfClass:[NSDictionary class]]) {
			TextExtract *textExtract = [[TextExtract alloc] init];
			emoDic = [textExtract getEmoDictionary];//获取表情字典
			[textExtract release];
		}
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[arrButtonsFree removeAllObjects];
	[arrButtonsFree release];
	[arrButtonsInUse removeAllObjects];
	[arrButtonsInUse release];
	
	[arrLablesFree removeAllObjects];
	[arrLablesFree release];
	[arrLablesInUse removeAllObjects];
	[arrLablesInUse release];
	[arrImagesFree removeAllObjects];
	[arrImagesFree release];
	[arrImagesInUse removeAllObjects];
	[arrImagesInUse release];
	[nickBtn release];
	nickBtn = nil;
	[vipImage release];
	vipImage = nil;
    [super dealloc];
}

// 回收资源
-(void)recycleSubViews {
	for (UIButton *btn in arrButtonsInUse) {
		btn.hidden = YES;
		//[btn setTitle:@"" forState:UIControlStateNormal];
		[arrButtonsFree addObject:btn];
	}
	[arrButtonsInUse removeAllObjects];
	for (UILabel *lb in arrLablesInUse) {
		lb.hidden = YES;
		[arrLablesFree addObject:lb];
	}
	[arrLablesInUse removeAllObjects];
	for (UIImageView *imgView in arrImagesInUse) {
		imgView.hidden = YES;
		imgView.image = nil;
		[arrImagesFree addObject:imgView];
	}
	[arrImagesInUse removeAllObjects];
//	//
//	NSInteger i = 0;
//	for (; i < [arrButtonsFree count]; i++) {
//		UIButton *btn = [[arrButtonsFree objectAtIndex:i] retain];
//		 
//		btn.hidden = NO;
//		[btn setTitle:@"安娜娜娜南安男女" forState:UIControlStateNormal];
//		
//		btn.frame = CGRectMake(0.0f, i*18.0f, 320.0f, 18.0f);
//		[arrButtonsInUse addObject:btn];
//		[btn release];
//	}
//	[arrButtonsFree removeAllObjects];
//	for (NSInteger j = 0; j < [arrLablesFree count]; j++) {
//		UILabel *lb = [arrLablesFree objectAtIndex:j];
//		lb.hidden = NO;
//		lb.text = @"南欧好嗷嗷哦奥嗷嗷哦";
//		lb.frame = CGRectMake(0.0f, j*18.0f, 320.0f, 18.0f);
//		[arrLablesInUse addObject:lb];
//	}
//	[arrLablesFree removeAllObjects];
}

- (void) touchUrl:(id)sender{
}
- (void)touchNick {
}
@end
