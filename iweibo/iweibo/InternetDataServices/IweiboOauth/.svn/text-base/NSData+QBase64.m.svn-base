//
//  NSData+QBase64.m
//  iweibo
//
//  Created by zhaoguohui on 11-12-26.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "NSData+QBase64.h"


@implementation NSData (QBase64)

#define CHAR64(c) (index_64[(unsigned char)(c)])

// 获取bytes数组中的一个字符，若没有找到，则返回一个EOF，作为错误标志
#define BASE64_GETC (length > 0 ? (length--, bytes++, (unsigned int)(bytes[-1])) : (unsigned int)EOF)

// 将一个字符添c添加到buffer的后面
#define BASE64_PUTC(c) [buffer appendBytes: &c length: 1]

static char basis_64[] =
"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

// 将指定c1，c2, c3 3个字节的数据用base64编码转换为4个字节的数据
static inline void output64Chunk( int c1, int c2, int c3, int pads, NSMutableData * buffer )
{
	char pad = '=';
	BASE64_PUTC(basis_64[c1 >> 2]);
	BASE64_PUTC(basis_64[((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4)]);
	
	switch ( pads )
	{
		case 2:
			BASE64_PUTC(pad);
			BASE64_PUTC(pad);
			break;
			
		case 1:
			BASE64_PUTC(basis_64[((c2 & 0xF) << 2) | ((c3 & 0xC0) >> 6)]);
			BASE64_PUTC(pad);
			break;
			
		default:
		case 0:
			BASE64_PUTC(basis_64[((c2 & 0xF) << 2) | ((c3 & 0xC0) >> 6)]);
			BASE64_PUTC(basis_64[c3 & 0x3F]);
			break;
	}
}

// 将一个NSData对象经过base64编码之后，以字符串的形式返回
- (NSString *) base64EncodedString
{
	// 创建一个缓冲区
	NSMutableData * buffer = [NSMutableData data];
	const unsigned char * bytes; // 指向指定的字节数据
	NSUInteger length; // 标记数据的长度
	unsigned int c1, c2, c3;
	
	bytes = [self bytes];// 获取要进行加密的数据
	length = [self length]; // 获取加密数据的长度
	
	// EOF是文件结束标记
	while ( (c1 = BASE64_GETC) != (unsigned int)EOF )
	{
		c2 = BASE64_GETC;
		if ( c2 == (unsigned int)EOF )
		{
			output64Chunk( c1, 0, 0, 2, buffer );
		}
		else
		{
			c3 = BASE64_GETC;
			if ( c3 == (unsigned int)EOF )
				output64Chunk( c1, c2, 0, 1, buffer );
			else
				output64Chunk( c1, c2, c3, 0, buffer );
		}
	}
	
	return ( [[[NSString allocWithZone: [self zone]] initWithData: buffer encoding: NSASCIIStringEncoding] autorelease] );
}

@end
