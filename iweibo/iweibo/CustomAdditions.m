//
//  CustomAdditions.m
//   
//
//  Created by ShiyoungLee on 10-11-16.
//  Copyright 2010. All rights reserved.
//

#import "CustomAdditions.h"

@implementation UIBarButtonItem(CustomAdditions)


+ (UIBarButtonItem *) rightBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	UIFont *_font = [UIFont systemFontOfSize:14];
	[rightBtn setBackgroundImage:[UIImage imageNamed:SKIN_EDIT_NORMAL] forState:UIControlStateNormal];
	[rightBtn setBackgroundImage:[UIImage imageNamed:SKIN_EDIT_PRESSED] forState:UIControlStateSelected];
	rightBtn.titleLabel.font = _font;
	//rightBtn.frame = CGRectMake(0.0f, 0.0f, [title sizeWithFont:_font].width + 10, 30.0f);
	rightBtn.frame = CGRectMake(0.0f, 0.0f, 47.0f, 31.0f);
	[rightBtn setTitle:title forState:UIControlStateNormal];
	[rightBtn addTarget:target action:action forControlEvents:controlEvents];
	
	UIBarButtonItem *barItem = [[[UIBarButtonItem alloc] initWithCustomView:rightBtn] autorelease];
	
	return barItem;
}


+ (UIBarButtonItem *) leftBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	
	UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	UIFont *_font = [UIFont systemFontOfSize:14];
	[leftBtn setBackgroundImage:[UIImage imageNamed:SKIN_BACK] forState:UIControlStateNormal];
	leftBtn.titleLabel.font = _font;
	//leftBtn.frame = CGRectMake(0.0f, 0.0f, [title sizeWithFont:_font].width + 10.0f, 30.0f);
	leftBtn.frame = CGRectMake(0.0f, 0.0f, 47.0f, 31.0f);
	[leftBtn setTitle:title forState:UIControlStateNormal];
	[leftBtn addTarget:target action:action forControlEvents:controlEvents];
	
	UIBarButtonItem *barItem = [[[UIBarButtonItem alloc] initWithCustomView:leftBtn] autorelease];
	
	return barItem;
}

+ (UIBarButtonItem *)editBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	UIFont *_font = [UIFont systemFontOfSize:14];
	[editBtn setBackgroundImage:[UIImage imageNamed:SKIN_EDIT_NORMAL] forState:UIControlStateNormal];
	[editBtn setBackgroundImage:[UIImage imageNamed:SKIN_EDIT_PRESSED] forState:UIControlStateSelected];
	editBtn.titleLabel.font = _font;
	//editBtn.frame = CGRectMake(0.0f, 0.0f, [title sizeWithFont:_font].width + 10.0f, 30.0f);
	editBtn.frame = CGRectMake(0.0f, 0.0f, 47.0f, 31.0f);
	[editBtn setTitle:title forState:UIControlStateNormal];
	[editBtn addTarget:target action:action forControlEvents:controlEvents];
	
	UIBarButtonItem *barItem = [[[UIBarButtonItem alloc] initWithCustomView:editBtn] autorelease];
	
	return barItem;
}



@end

//@implementation UINavigationBar(Custom)
//
//- (void)drawRect:(CGRect)rect {
//	UIImage *image = [UIImage imageNamed:SKIN_BAR_BG];
//	[image drawInRect:CGRectMake(0, 0, 320, 56)];
//}
//
//@end

@implementation UIImage(imageNamed_Hack)

+ (UIImage *)imageNamed:(NSString *)name {
    
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",
                                             [[NSBundle mainBundle] bundlePath], name ]];
}

@end




