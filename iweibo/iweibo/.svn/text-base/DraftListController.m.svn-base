//
//  DraftListController.m
//  iweibo
//
//  Created by lichentao on 12-1-31.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "DraftListController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "Draft.h"
#import "Database.h"

@implementation DraftListController

@synthesize draftArray;
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

- (void)backBtnAction
{
    [self.tabBarController performSelector:@selector(showNewTabBar) withObject:nil afterDelay:0.2f];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
	[customLab setTextColor:[UIColor whiteColor]];
	[customLab setText:@"草稿箱"];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	//self.title = @"草稿箱";
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
	self.navigationItem.leftBarButtonItem = barButton;
    [barButton release];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Table View delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 130;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
     return [draftArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
		UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
		label1.tag = 101;
		label1.font = [UIFont systemFontOfSize:10];
		[cell addSubview:label1];
		[label1 release];
		
		UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 50, 30)];
		label2.tag = 102;
		label2.backgroundColor = [UIColor redColor];
		label2.font = [UIFont systemFontOfSize:10];
		[cell addSubview:label2];
		[label2 release];

		UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 50, 30)];
		label3.tag = 103;
		label3.font = [UIFont systemFontOfSize:10];
		[cell addSubview:label3];
		[label3 release];

		UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 200, 30)];
		label4.tag = 104;
		label4.font = [UIFont systemFontOfSize:10];
		[cell addSubview:label4];
		[label4 release];

		UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 100, 30)];
		label5.tag = 105;
		label5.font = [UIFont systemFontOfSize:10];
		[cell addSubview:label5];
		[label5 release];
		
		UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 100, 30)];
		label6.tag = 106;
		label6.font = [UIFont systemFontOfSize:10];
		[cell addSubview:label6];
		[label6 release];
		
		
	}
    
    // Configure the cell...
	UILabel *label1 = (UILabel *)[cell viewWithTag:101];
	label1.text = [[draftArray objectAtIndex:indexPath.row] objectForKey:@"id"];
	
	UILabel *label2 = (UILabel *)[cell viewWithTag:102];
	label2.text = [[[draftArray objectAtIndex:indexPath.row] objectForKey:@"draftType"] stringValue];

	UILabel *label3 = (UILabel *)[cell viewWithTag:103];
	label3.text = [[draftArray objectAtIndex:indexPath.row] objectForKey:@"draftText"];

	UILabel *label4 = (UILabel *)[cell viewWithTag:104];
	label4.text = [[draftArray objectAtIndex:indexPath.row] objectForKey:@"timeStamp"];

	UILabel *label5 = (UILabel *)[cell viewWithTag:105];
	label5.text = [[draftArray objectAtIndex:indexPath.row] objectForKey:@"draftForwardOrCommentName"];

	UILabel *label6 = (UILabel *)[cell viewWithTag:106];
	label6.text = [[draftArray objectAtIndex:indexPath.row] objectForKey:@"draftForwardOrCommentText"];
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
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
    [super dealloc];
}


@end

