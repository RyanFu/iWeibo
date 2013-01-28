    //
//  MyFavTopicSearchController.m
//  iweibo
//
//  Created by Minwen Yi on 1/1/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "MyFavTopicSearchController.h"
#import "MyFavTopicInfo.h"

@implementation MyFavTopicSearchController
@synthesize topicsArray;
@synthesize topicsArrayCopy;
@synthesize myFavTopicsTableList;
@synthesize myFavTopicsSearchBar;
@synthesize topicSearchDelegate;
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
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	// 临时数据
//	NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"张三",@"作者",@"1990年",@"时间",@"改革开放",@"简介",nil];
//	NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"李四",@"作者",@"2007年",@"时间",@"计算机发展了",@"简介",nil];
//	topicsArray = [[NSMutableArray alloc]initWithObjects:dic1,dic2,nil];
//	topicsArrayCopy = [[NSMutableArray alloc]initWithObjects:dic1,dic2,nil];
	// 搜索框
	myFavTopicsSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
	self.myFavTopicsSearchBar.delegate = self;
	self.myFavTopicsSearchBar.placeholder = @"搜索话题";
	self.myFavTopicsSearchBar.keyboardType = UIKeyboardTypeDefault;
	[self.myFavTopicsSearchBar becomeFirstResponder];
	[myFavTopicsSearchBar setShowsCancelButton:YES];	// 返回按钮
	myFavTopicsSearchBar.userInteractionEnabled = YES;
	[self.view addSubview:self.myFavTopicsSearchBar];	
	// 数据列表
	myFavTopicsTableList = [[UITableView alloc]initWithFrame:CGRectMake(0, 41, 320, 416)];
	[myFavTopicsTableList setDelegate:self];
	[myFavTopicsTableList setDataSource:self];
	[self.view addSubview:self.myFavTopicsTableList];
	for ( UIView * subview in myFavTopicsSearchBar.subviews ) {
		UITextField *searchField = nil;
		if([subview isKindOfClass:[UITextField class]]) { 
			searchField = (UITextField *)subview;
		}
		if(!(searchField == nil)) {
			UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15) ];
			searchImageView.image = [UIImage imageNamed:@"composeFav#.png"];
			searchField.leftView = searchImageView;
			[searchImageView release];
			break;
		}
	}
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
	[myFavTopicsTableList release];
	myFavTopicsTableList = nil;
	[myFavTopicsSearchBar release];
	myFavTopicsSearchBar = nil;
	[topicsArray removeAllObjects];
	[topicsArray release];
	topicsArray = nil;
	[topicsArrayCopy removeAllObjects];
	[topicsArrayCopy release];
	topicsArrayCopy = nil;
    [super dealloc];
}


- (void)setTopicsArray:(NSMutableArray *)topics {
	if (topicsArray) {
		[topicsArray removeAllObjects];
	}
	else {
		topicsArray = [[NSMutableArray alloc] initWithCapacity:5];
	}
	if (topicsArrayCopy) {
		[topicsArrayCopy removeAllObjects];
	}
	else {
		topicsArrayCopy = [[NSMutableArray alloc] initWithCapacity:5];
	}
	
	for (int j = 0; j< [topics count]; j++) {
		[topicsArray addObject:[topics objectAtIndex:j]];
		[topicsArrayCopy addObject:[topics objectAtIndex:j]];
	}
}

#pragma mark -
#pragma mark Delegates
#pragma mark	UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
	[topicSearchDelegate topicCancelBtnClicked];
	searchBar = nil;
	[self dismissModalViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	NSMutableArray *array2 = [NSMutableArray arrayWithArray:topicsArray];
	[topicsArray removeAllObjects];
	// 空文本框
	if ([searchText length] == 0) {
		for (int j = 0; j< [topicsArrayCopy count]; j++) {
			[topicsArray addObject:[topicsArrayCopy objectAtIndex:j]];
		}
	}
	else {
		// 有搜索数据
		// 添加首行数据
		NSMutableDictionary *dicFirstRow = [[NSMutableDictionary alloc] initWithCapacity:1];
		[dicFirstRow setObject:searchText forKey:@"text"];
		[dicFirstRow setObject:@"localID" forKey:@"id"];
		NSNumber *hasAddedBefore = [[NSNumber alloc] initWithInt:1];
		[dicFirstRow setObject:hasAddedBefore forKey:@"isaddedbefore"];
		[hasAddedBefore release];
		[topicsArray addObject:dicFirstRow];
		[dicFirstRow release];
		// 添加其他行数据
		for (int i = 0; i < [array2 count]; i ++) {
			NSString *str = [[array2 objectAtIndex:i] objectForKey:@"text"];
			NSString *idStr = [[array2 objectAtIndex:i] objectForKey:@"id"];
			// 假如之前就首行手动载入的数据，不对其进行搜索
			if (![idStr isEqualToString: @"localID"]) {
				NSRange subStr = [str rangeOfString:searchText options:NSCaseInsensitiveSearch];
				if (subStr.length > 0) {
					NSLog(@"%@",str);
					[topicsArray addObject:[array2 objectAtIndex:i]];
				}
			}
		}
	}

	[self.myFavTopicsTableList reloadData];
}

#pragma mark	TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSLog(@"点击了%d行",indexPath.row);
	NSDictionary	*curRowDict = [topicsArray objectAtIndex:indexPath.row];
	// 更新数据库中对应值
	[MyFavTopicInfo updateTopicByText:[curRowDict objectForKey:@"text"] WithStatus:YES];
	// 发送数据到主窗体
	NSString		*name = [[NSString alloc] initWithFormat:@"#%@#", [curRowDict objectForKey:@"text"]];
	[topicSearchDelegate topicItemClicked:name];
	[name release];
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark UIScrollViewDelegates
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [myFavTopicsSearchBar resignFirstResponder];
	// 激活取消按钮
	for ( UIView * subview in myFavTopicsSearchBar.subviews ) {
		UIButton *btnCancel = nil;
		if([subview isKindOfClass:[UIButton class]]) { 
			//[myFavTopicsSearchBar setShowsCancelButton:YES];	// 返回按钮
			btnCancel = (UIButton *)subview;
		}
		if(!(btnCancel == nil)) {
			[myFavTopicsSearchBar setShowsCancelButton:YES animated:YES];
			btnCancel.enabled = YES;
		}
	}
}

#pragma mark	TableViewDateSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [topicsArray count];	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
	UITableViewCell *friendCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (friendCell == nil) {
		friendCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		[friendCell setSelectionStyle:UITableViewCellSelectionStyleGray];
		
		UILabel *author = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 40)];
		author.tag = 101;
		[friendCell.contentView addSubview:author];
		[author release];
	}
	UILabel *author = (UILabel *)[friendCell.contentView viewWithTag:101];
	author.text = [NSString stringWithFormat:@"#%@#",[[topicsArray objectAtIndex:indexPath.row] objectForKey:@"text"]];
	NSNumber *isAddedBefore = [[topicsArray objectAtIndex:indexPath.row] objectForKey:@"isaddedbefore"];
	if ([isAddedBefore intValue] != 0) {
		author.textColor = [UIColor colorWithRed:0.2f green:0.4549f blue:0.5961f alpha:1.0f];//  #337498
	}
	else {
		author.textColor = [UIColor blackColor];
	}
	return friendCell;
}

#pragma mark -

@end
