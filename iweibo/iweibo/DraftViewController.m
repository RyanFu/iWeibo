    //
//  DraftViewController.m
//  iweibo
//
//  Created by zhaoguohui on 12-3-6.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "DraftViewController.h"
#import "DataManager.h"
#import "Info.h"
#import "ComposeViewControllerBuilder.h"
#import "UserInfo.h"
#import "HpThemeManager.h"
#import "MessageViewUtility.h"

#define RowHeightForBroadcase 59
#define RowHeightForOtherType 112

@implementation CustomDraftCell
@synthesize typeLabel;
@synthesize textLabels;
@synthesize timeLabel;
@synthesize forwardLabel;
@synthesize picFlag;
@synthesize nameLabel;

- (id)initWithBroadcastCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)idendifier {
	self = [super initWithStyle:style reuseIdentifier:idendifier];
	
	if (nil != self) {
		UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draftBroadcastBg.png"]];
		bgView.frame = CGRectMake(0, 0, 320, 59);
		[self addSubview:bgView];
		[self sendSubviewToBack:bgView];
		[bgView release];
		
		UIImageView *lineBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separatorLine.png"]];
		lineBg.frame = CGRectMake(0, 58, 320, 1);
		[self addSubview:lineBg];
		[lineBg release];
		
		typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
		typeLabel.backgroundColor = [UIColor clearColor];
		typeLabel.text = @"";
		[self.contentView addSubview:typeLabel];
		
		textLabels = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 310, 20)];
		textLabels.backgroundColor = [UIColor clearColor];
		textLabels.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		textLabels.text = @"";
		[self.contentView addSubview:textLabels];
		
		timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 10, 48, 20)];
		timeLabel.backgroundColor = [UIColor clearColor];
		timeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		timeLabel.text = @"";
		timeLabel.font = [UIFont systemFontOfSize:12];
		timeLabel.textAlignment = UITextAlignmentRight;
		timeLabel.textColor = [UIColor grayColor];
		[self.contentView addSubview:timeLabel];
		
		picFlag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pictureFlag.png"]];
		picFlag.frame = CGRectMake(245, 12, 15, 12);
		picFlag.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		picFlag.hidden = YES;
		[self.contentView addSubview:picFlag];
	}
	
	return self;
}

- (id)initWithForwardCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)idendifier {
	self = [super initWithStyle:style reuseIdentifier:idendifier];
	
	if (nil != self) {
		UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"switchBroadBgNormal.png"]];
		bgView.frame = CGRectMake(0, 0, 320, 111);
		[self addSubview:bgView];
		[self sendSubviewToBack:bgView];
		[bgView release];
		
		UIImageView *lineBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separatorLine.png"]];
		lineBg.frame = CGRectMake(0, 111, 320, 1);
		[self addSubview:lineBg];
		[lineBg release];
		
		
		typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
		typeLabel.backgroundColor = [UIColor clearColor];
		typeLabel.text = @"";
		[self.contentView addSubview:typeLabel];
		
		textLabels = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 310, 20)];
		textLabels.backgroundColor = [UIColor clearColor];
		textLabels.text = @"";
		textLabels.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self.contentView addSubview:textLabels];
		
		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, 200, 20)];
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.text = @"";
		[self.contentView addSubview:nameLabel];
		
		forwardLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 310, 20)];
		forwardLabel.backgroundColor = [UIColor clearColor];
		forwardLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		forwardLabel.text = @"";
		[self.contentView addSubview:forwardLabel];
		
		timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 10, 48, 20)];
		timeLabel.backgroundColor = [UIColor clearColor];
		timeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		timeLabel.text = @"";
		timeLabel.font = [UIFont systemFontOfSize:12];
		timeLabel.textAlignment = UITextAlignmentRight;
		timeLabel.textColor = [UIColor grayColor];
		[self.contentView addSubview:timeLabel]; 
		
		picFlag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pictureFlag.png"]];
		picFlag.frame = CGRectMake(293, 65, 15, 12);
		picFlag.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		picFlag.hidden = YES;
		[self.contentView addSubview:picFlag];
	}
	
	return self;
}

- (void)dealloc {
	[typeLabel release];
	[textLabels release];
	[timeLabel release];
	[forwardLabel release];
	[picFlag release];
	[nameLabel release];
	
	[super dealloc];
}

@end

@implementation DraftViewController
@synthesize draftBox;

// 点击返回按钮时调用
- (void)backAction: (id)sender {
	
	[self.tabBarController performSelector:@selector(showNewTabBar)];
	
	[self.navigationController popViewControllerAnimated:YES];
}

// 点击编辑按钮的时候调用
- (void)editButtonClicked:(id)sender {
	UIButton *edit = (UIButton *)sender;
	
	NSInteger rowNum = [draftData count];
	if (rowNum == 0) {
		edit.userInteractionEnabled = NO;
	}else {
		edit.userInteractionEnabled = YES;
	}
	
	[draftBox setEditing:!draftBox.editing animated:YES];
	NSLog(@"editing:%d", draftBox.editing);
	if (draftBox.editing) {
		//edit.titleLabel.text = @"完成";
		[edit setTitle:@"完成" forState:UIControlStateNormal];
	}else {
		//edit.titleLabel.text = @"编辑";
		[edit setTitle:@"编辑" forState:UIControlStateNormal];
	}
}

- (void)updateDraft {
	//draftData = [[NSMutableArray alloc] initWithArray:[DataManager getDraftFromDatabase]];
	draftData = [[NSMutableArray alloc] initWithArray:[DataManager getDraftFromDatabase:[[UserInfo sharedUserInfo] name]]];
	NSInteger rowNum = [draftData count];
	if (rowNum == 0) {
		editBtn.userInteractionEnabled = NO;
	}else {
		editBtn.userInteractionEnabled = YES;
	}
	[draftBox reloadData];
}

- (void)updateTheme:(NSNotificationCenter *)noti{
    NSDictionary *plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
    NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    if (themePath) {
        [backBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
        [editBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"composebtn-bg.png"]] forState:UIControlStateNormal];
    }
    
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"草稿箱";
	
    NSDictionary *plistDict = nil;
    NSDictionary *pathDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"ThemePath"];
    if ([pathDic count] == 0){
        plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
        if ([plistDict count] == 0) {
            NSString *skinPath = [[NSBundle mainBundle] pathForResource:@"ThemeManager" ofType:@"plist"];
                plistDict = [[NSArray arrayWithContentsOfFile:skinPath] objectAtIndex:0];
        }
    }
    else{
        plistDict = pathDic;
    }
        
    NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateDraft)
												 name:@"UpdateDraftNotification"
											   object:nil];
	// 返回按钮
	backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 49, 30)];
	backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
	backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
	[backBtn setTitle:@"返回" forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];

	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	self.navigationItem.leftBarButtonItem = leftItem;
	[leftItem release];
	// 编辑按钮
	editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 49, 30)];
	editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
	[editBtn setTitle:@"编辑" forState:UIControlStateNormal];
	
	// 2012-03-23 By Yi Minwen 放到updateDraft里边做
	// 设置按钮的状态
//	NSArray *drafts = [DataManager getDraftFromDatabase:[[UserInfo sharedUserInfo] name]];
//	NSInteger rowNum = [drafts count];
//	if (rowNum == 0) {
//		editBtn.userInteractionEnabled = NO;
//	}else {
//		editBtn.userInteractionEnabled = YES;
//	}
//	
	
	[editBtn addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (themePath) {
        [backBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
        [editBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"composebtn-bg.png"]] forState:UIControlStateNormal];
    }

	UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
	self.navigationItem.rightBarButtonItem = editItem;
	[editItem release];
    
	draftBox = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain];
	draftBox.delegate = self;
	draftBox.dataSource = self;
	draftBox.separatorColor = [UIColor clearColor];
	[self.view addSubview:draftBox];
	[self updateDraft];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
}

#pragma mark  -
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [draftData count];
	//return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	Draft *draft = [draftData objectAtIndex:indexPath.row];
	int type = draft.draftType;
	if (type == 1 || type == 6) {
		return RowHeightForBroadcase;
	}else {
		return RowHeightForOtherType;
	}

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifierForSingleLine = @"cellIdentifierForSingleLine";
	static NSString *cellIdentifierForDoubleLine = @"cellIdentifierForDoubleLine";
	
	Draft *draft = [draftData objectAtIndex:indexPath.row];
	//NSString *type = [dict objectForKey:@"type"];
	int type = draft.draftType;
	if (type == 1 || type == 6) {// 单行的情况
		
		CustomDraftCell *cell = (CustomDraftCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierForSingleLine];
		if (nil == cell) {
			cell = [[[CustomDraftCell alloc] initWithBroadcastCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierForSingleLine] autorelease];
			
		}
		
		if ([draft.isHasPic intValue] == 0) {
			cell.picFlag.hidden = YES;
		}else {
			cell.picFlag.hidden = NO;
		}
		
		cell.typeLabel.text = draft.draftTypeContext;
		cell.textLabels.text = draft.draftText;
		cell.timeLabel.text = [Info showTime:[draft.timeStamp intValue]];
		
		return cell;
		
	}else {// 双行的情况
		CustomDraftCell *cell = (CustomDraftCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierForDoubleLine];
		if (nil == cell) {
			cell = [[[CustomDraftCell alloc] initWithForwardCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierForDoubleLine] autorelease];
			
		}
		
		if ([draft.isHasPic intValue] == 0) {
			cell.picFlag.hidden = YES;
		}else {
			cell.picFlag.hidden = NO;
		}
		
		if (draft.draftType == 5) {
			cell.typeLabel.text = [NSString stringWithFormat:@"对 %@ 说", draft.draftTitle];
		}else {
			cell.typeLabel.text = draft.draftTypeContext;
		}
		cell.textLabels.text = draft.draftText;
		cell.nameLabel.text = draft.draftTitle;
		cell.forwardLabel.text = draft.draftForwardOrCommentText;
		cell.timeLabel.text = [Info showTime:[draft.timeStamp intValue]];
		
		return cell;
	}
	
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[MessageViewUtility printAvailableMemory];
	Draft *draft = [draftData objectAtIndex:indexPath.row];
	draft.draftTitle = draft.draftTypeContext;
	draft.isFromDraft = [NSNumber numberWithInt:1];					// lichentao12-03-09判断是从草稿箱进入时候isFromDraft的值是1,其他路径没有值
	draft.fromDraftIndex = [NSNumber numberWithInt:indexPath.row];	// lichentao 12-03-09从草稿箱的哪一条进入到消息页面
	draft.fromDraftString = draft.draftText;						// lichentao 12-03-09从草稿箱进入消息页面的文本信息textView
	// 2012-03-23 By Yi Minwen 获取图片数据
	draft.attachedData = [DataManager getDraftAttachedData:draft.timeStamp userName:[UserInfo sharedUserInfo].name];
	draft.fromDraftAttachData = draft.attachedData;
	NSLog(@"draft si = %@", draft.draftText);
	ComposeBaseViewController	*composeViewController =  [ComposeViewControllerBuilder createWithDraft:draft];
	//[draft release];
	UINavigationController		*composeNavController = [[[UINavigationController alloc] initWithRootViewController:composeViewController] autorelease];
    [self presentModalViewController:composeNavController animated:YES];
	// composeViewController无需手动释放
	//[ComposeViewControllerBuilder desposeViewController:composeViewController];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	Draft *draft = [draftData objectAtIndex:indexPath.row];
	//BOOL flag = [DataManager removeDraft:draft.timeStamp];
	BOOL flag = [DataManager removeDraft:draft.timeStamp userName:[UserInfo sharedUserInfo].name];
	if (flag) {
		[draftData removeObjectAtIndex:indexPath.row];
		[draftBox deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
	}
	//[draftBox reloadData];
	
	
}

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateDraftNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
	[draftBox release];
	[editBtn release];
    [backBtn release];
    [super dealloc];
}


@end
