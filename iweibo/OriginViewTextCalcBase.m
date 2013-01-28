    //
//  OriginViewTextCalcBase.m
//  iweibo
//
//  Created by lichentao on 12-2-17.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "OriginViewTextCalcBase.h"


@implementation OriginViewTextCalcBase

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
//- (void)viewDidLoad {
//    [super viewDidLoad];
//}


// 获取文本距离上边框高度
//-(CGFloat)getUpVerticalSpaceBetweenSourceTextAndFrame{
//
//}
// 获取文本距离下边框高度
//-(CGFloat)getDownVerticalSpaceBetweenSourceTextAndFrame{
//
//}
// 画消息头
-(void)drawHead{

}
// 模拟画消息文本
-(void)drawMainText{
	[super drawMainText];
}
// 模拟画图片
-(void)drawPicture{

}
// 求取消息底部文字信息高度
-(void)drawTail{

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

//- (void)didReceiveMemoryWarning {
//    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
//    
//    // Release any cached data, images, etc. that aren't in use.
//}
//
//- (void)viewDidUnload {
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}


//- (void)dealloc {
//    [super dealloc];
//}


-(void)cacheUnitItem:(NSString *)strText withType:(UnitItemType)type link:(NSString *)strLink andFrame:(CGRect)rect {
}
// 将求取的数据存储到缓存字典
- (void)addItemArrayToDic {
}
@end
