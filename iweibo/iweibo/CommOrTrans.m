//
//  commOrTrans.m
//  iweibo
//
//  Created by wangying on 1/30/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "CommOrTrans.h"
#import <QuartzCore/QuartzCore.h>
#import "Info.h"
#import "CalculateUtil.h"
#import "DetailPageConst.h"

@implementation CommOrTrans
@synthesize uid,nick,time,text,isvip,type,localAuth;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		UIFont *font = [UIFont systemFontOfSize:16];
		
		UILabel *coName = [[UILabel alloc] init];
		coName.tag = 001;
		coName.textColor = [UIColor colorWithRed:0.2 green:0.455 blue:0.596 alpha:1];
		coName.font = font;
		[self.contentView addSubview:coName];
		[coName release];
		
		UIButton *coComment = [[UIButton alloc] init];
		coComment.tag = 002;
		coComment.titleLabel.font = [UIFont systemFontOfSize:10];
		coComment.backgroundColor = [UIColor lightGrayColor];
		coComment.layer.cornerRadius = 3.0f;
		[coComment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[coComment setTitle:@"评论" forState:UIControlStateNormal];
		[self.contentView addSubview:coComment];
		[coComment release];
		
		UIImageView *coIsVip = [[UIImageView alloc] init];
		coIsVip.tag = 003;
		[self.contentView addSubview:coIsVip];
		[coIsVip release];
		
		UILabel *coTime = [[UILabel alloc] init];
		coTime.tag = 004;
		coTime.textColor = [UIColor lightGrayColor];
		coTime.font = [UIFont systemFontOfSize:12];
		[self.contentView addSubview:coTime];
		[coTime release];
		
		CommentView *commentView = [[CommentView alloc] init];
		commentView.tag = 005;
		[self addSubview:commentView];
		[commentView release];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void)setMsg{
	UILabel *myCoName = (UILabel *)[self viewWithTag:001];
	UIButton *myComment = (UIButton *)[self viewWithTag:002];
	UIImageView *myVip = (UIImageView *)[self viewWithTag:003];
	UILabel *myCoTime = (UILabel *)[self viewWithTag:004];
	CommentView *myCommentView = (CommentView *)[self viewWithTag:005];
	
	CGSize nameSize = [self.nick sizeWithFont:[UIFont systemFontOfSize:16]];
	myCoName.text = self.nick;
	myCoName.frame = CGRectMake(5, DPCommentHeigntBetweenNickAndLine - 3, nameSize.width, nameSize.height);
 
	myVip.frame = CGRectMake(nameSize.width + 5, DPCommentHeigntBetweenNickAndLine - 2, VipImageWidth, VipImageWidth);

	if (![self.isvip isEqualToString:@"0"]) {						//  如果是vip用户
		myVip.image = [UIImage imageNamed:@"vip-btn.png"];
	}else if(![self.localAuth isEqualToString:@"0"]){				// 如果是本地认证用户
		myVip.image = [UIImage imageNamed:@"localVip.png"];
	}else {
		myVip.hidden = YES;
	}
	
	if (![self.type isEqualToString:@"2"]&&(![self.isvip isEqualToString:@"0"]||![self.localAuth isEqualToString:@"0"])) {
		myComment.frame = CGRectMake(nameSize.width + 5 + VipImageWidth, DPCommentHeigntBetweenNickAndLine, 23, 12);
	}else if (![self.type isEqualToString:@"2"]) {
		myComment.frame = CGRectMake(nameSize.width + 5, DPCommentHeigntBetweenNickAndLine, 23, 12);
	}else {
		myComment.hidden = YES;
	}

	NSString *timeString = [Info intervalSinceNow:[self.time doubleValue]];
	CGSize timeSize = [timeString sizeWithFont:[UIFont systemFontOfSize:12]];
	myCoTime.text = timeString;
	myCoTime.frame = CGRectMake(DPCommentFrameWidth - timeSize.width - 11, DPCommentHeigntBetweenNickAndLine-3, timeSize.width, timeSize.height);
	
	CalculateUtil *calculate = [[CalculateUtil alloc] init];
	CGFloat height = [calculate calculateHeight:self.text fontSize:16 andWidth:DPCommentTextWidth];
	myCommentView.frame = CGRectMake(5, nameSize.height + DPCommentHeigntBetweenNickAndLine + DPCommentHeightBetweenContenAndNick - 10, DPCommentTextWidth, height);	
	myCommentView.kWidth = DPCommentTextWidth;
	myCommentView.comment = self.text;
	
	[calculate release];
}

- (void)dealloc {
    [super dealloc];
}


@end
