//
//  WordListViewController.m
//  iweibo
//
//  Created by ZhaoLilong on 2/26/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "WordListViewController.h"
#import "DataManager.h"

@implementation WordListViewController
@synthesize searchText;
@synthesize selectedText;
@synthesize resultList;
@synthesize passValueDelegate, hideKeyBoardDelegate;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (NSString *)dataFilePath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	return [documentDirectory stringByAppendingPathComponent:@"wordlist.plist"];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.searchText = nil;
	resultList = [[NSMutableArray alloc] initWithCapacity:20];
	
	label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
	label.backgroundColor = [UIColor clearColor];
	[self.tableView.tableFooterView addSubview:label];
}

#pragma mark -
#pragma mark Table view data source
// 返回section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 返回section对应的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([resultList count] == 0) {
		return 1;
	}else {
		return [resultList count];
	}
}

// 自定义tableView显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// 获取行
	NSUInteger row = [indexPath row];
	
	// 此处不重用的原因是由于文本颜色在下一屏中的第一行也会呈现蓝色
	NSString *CellIdentifier = [NSString stringWithFormat:@"%d",row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		UIView *selectedView = [[UIView alloc] initWithFrame:cell.contentView.frame];
		selectedView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:0.933];
		cell.selectedBackgroundView = selectedView; 
		[selectedView release];	
	}
	if ([resultList count] != 0) {
		cell.textLabel.text = [resultList objectAtIndex:row];
	}
	if (row == 0) {
		cell.textLabel.textColor = [UIColor blueColor];
	}
	return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	CGFloat height = 0.0f;
	if ([self.resultList count]*44 < 380) {
		height = 380- [self.resultList count]*44;
	}
	return height;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	return label;
}
 
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	selectedText = [resultList objectAtIndex:[indexPath row]];
	[passValueDelegate passValue:selectedText];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[resultList release];
	[label release];
	[super dealloc];
}

// 滑动列表
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	[hideKeyBoardDelegate hide];
}

// 刷新补全列表
- (void)updateData{
	if ([self.resultList count] != 0) {
		[self.resultList removeAllObjects];
	}
	NSMutableArray *matchList = [DataManager getHotSearchFromDatabase];// 读取数据库的字符串数组
	// 遍历寻找匹配的字符串
	for (int i = 0; i < [matchList count]; i++) {
		NSString *str = [matchList objectAtIndex:i];
		if ([str rangeOfString:self.searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
			if ([str isEqualToString:self.searchText]) {
				[self.resultList insertObject:str atIndex:0];
			}else {
				[self.resultList addObject:str];
			}
		}
	}
	if (![self.resultList containsObject:self.searchText]) {
		[self.resultList insertObject:self.searchText atIndex:0];
	}
	// 刷新列表
	[self.tableView reloadData];
}

@end

