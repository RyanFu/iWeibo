//
//  AppXMLParser.m
//  iweibo
//
//  Created by Yi Minwen on 6/27/12.
//  Copyright (c) 2012 Beyondsoft. All rights reserved.
//

#import "AppXMLParser.h"

@implementation AppXMLParser

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    [arrApps release];
    arrApps = nil;
    [item release];
    item = nil;
    arrApps = [[NSMutableArray alloc] initWithCapacity:100];
    item = [[CustomizedSiteInfo alloc] init];
    SiteDescriptionInfo *desInfo = [[SiteDescriptionInfo alloc] init];
    item.descriptionInfo = desInfo;
    [desInfo release];
}
// sent when the parser begins parsing of the document.
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [arrApps addObject:item];
    [item release];
    item = nil;
}
- (void)parser:(NSXMLParser *)parser  
didStartElement:(NSString *)elementName  
  namespaceURI:(NSString *)namespaceURI  
 qualifiedName:(NSString *)qualifiedName  
    attributes:(NSDictionary *)attributeDict {  
    if ([item.descriptionInfo.svrName length] > 0 && [item.descriptionInfo.svrUrl length] > 0) {
        [arrApps addObject:item];
        [item release];
        item =  [[CustomizedSiteInfo alloc] init];
        SiteDescriptionInfo *desInfo = [[SiteDescriptionInfo alloc] init];
        item.descriptionInfo = desInfo;
        [desInfo release];
    }
    keyName = elementName;
}   
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet] ] length] > 0) { 
        if ([keyName isEqualToString:@"name"]) {
            item.descriptionInfo.svrName = string;
        }
        if ([keyName isEqualToString:@"url"]) {
            item.descriptionInfo.svrUrl = string;
        }
    }
}    

-(NSMutableArray *)doParser {
    NSString *srcXmlPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"iweibo_app.xml"];
    //    NSMutableArray *arrCopy = [[NSMutableArray alloc] initWithContentsOfFile:srcXmlPath];
    NSData *fileData = [NSData dataWithContentsOfFile:srcXmlPath]; 
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:fileData];    
    [xmlParser setDelegate:self];    
    BOOL result = [xmlParser parse];
    CLog(@"result:%d", result);
    return arrApps;
}

-(void)dealloc {
    [arrApps release];
    arrApps = nil;
    [super dealloc];
}
@end
