//
//  TableCellBuilder.m
//  iweibo
//
//  Created by Minwen Yi on 2/24/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "TableCellBuilder.h"
#import "HotBroadcastTableCell.h"

@implementation TableCellBuilder

// 生成单元行
+(UITableViewCellEx *)getCellwithStyle:(UITableViewCellStyle)cellStyle 
					 reuseIdentifier:(NSString *)identifier 
							 section:(NSInteger)sect
							 AndType:(TableCellType)cellType {
	UITableViewCellEx *tableCell = nil;
	switch (cellType) {
		case HotBroadcastCellType: {
			tableCell = [[HotBroadcastTableCell alloc] initWithStyle:cellStyle reuseIdentifier:identifier];
		}
			break;
		default:
			NSParameterAssert(NO);
			break;
	}
	return [tableCell autorelease];
}
@end
