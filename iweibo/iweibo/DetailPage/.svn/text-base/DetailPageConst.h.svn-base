//
//  DetailPageConst.h
//  iweibo
//
//	详情页相关常量
//
//  Created by Minwen Yi on 2/10/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "Canstants.h"
#import "MessageFrameConsts.h"

// 1. 宽度
// 主消息: 框架宽度
#define DPOriginFrameWidth						320.0f
// 主消息: 文本左边空白宽度
#define DPOriginTextLeftSpaceWidth				8.0f
// 主消息: 文本右边空白宽度
#define DPOriginTextRightSpaceWidth				12.0f
// 主消息: 文本宽度
#define DPOriginTextWidth						(DPOriginFrameWidth-DPOriginTextLeftSpaceWidth-DPOriginTextRightSpaceWidth)
//主timeline消息： 时间距离右侧的屏的距离
#define DPTimeRightSpaceWidth                    11.0f
//主timeline消息： 昵称与内容之间的高度
#define VerticalSpaceBetweenNikeAndText          8.0f


// 源消息: 框架宽度(与主消息文本宽度相同)
#define DPSourceFrameWidth						DPOriginTextWidth
// 源消息: 文本左边空白宽度(与边框相对距离)
#define DPSourceTextLeftSpaceWidth				6.0f
// 源消息: 文本右边空白宽度(与边框相对距离)
#define DPSourceTextRightSpaceWidth				12.0f
// 源消息: 文本宽度
#define DPSourceTextWidth						(DPSourceFrameWidth-DPSourceTextLeftSpaceWidth-DPSourceTextRightSpaceWidth)

// 评论或者转播消息: 框架宽度(与主消息框架宽度相同)
#define DPCommentFrameWidth						DPOriginFrameWidth
// 评论或者转播消息: 文本宽度(与主消息文本宽度相同)
#define DPCommentTextWidth						DPOriginTextWidth
//下方评论或转播昵称距离上横线高度
#define DPCommentHeigntBetweenNickAndLine              12.0f
//下方评论或转播内容距离昵称高度
#define DPCommentHeightBetweenContenAndNick            10.0f
//下方评论或转播内容距离下方横线高度
#define DPCommentHeigntBetweenConteenAndBottonLine      12.0f
//下方评论或转播时间距离右侧宽度
#define DPCommentTimeLeftWidth                          11.0f

//好友列表高度
//好友列表，图像距离上方的高度
#define VerticalSpaceBetweenPicAndTop            8.0f
//好友列表，文字距离上方的高度
#define VerticalSpaceBetweenTextAndTop           VerticalSpaceBetweenPicAndTop
//好友列表，cell的高度
#define HeightofCell                             59.0f
//好友列表，昵称和地址之间的高度(上下都是文字减4)
#define VerticalSpaceBetweenNikeAndAddr          4.0f  
//好友列表，图像距离左边的宽度
#define PicLeftWidth                             9.0f
//好友列表，头像和昵称之间的宽度
#define WidthBetweenPicAndNick                   10.0f
//好友列表，昵称和性别之间的宽度
#define WidthBetweenNickAndSex                   3.0f 

// 2. 字号大小
// 主消息: 字体大小
#define DPOriginTextFontSize					16.0f
// 源消息: 字体打大小
#define DPSourceTextFontSize					14.0f
// 主消息: 底部转播次数字体大小(“原文共..转播")
#define DPCommentCntsTextFontSize				12.0f
// 评论或者转播消息: 文本字号大小
#define DPCommentTextFontSize					DPCommentTextFontSize

// 评论或者转播消息: 昵称字号大小(与文本相同)
#define DPCommentNickFontSize					DPOriginTextFontSize

// 评论或者转播消息: 发表时间标记字号大小
#define DPCommentTimeLineFontSize				DPCommentCntsTextFontSize
// 好友列表昵称字号
#define DPFansListNickFontSize                  14.0f

// 好友列表location字号
#define DPFansListLocationFontSize              12.0f

// 好友列表tweet字号
#define DPFansListTweetTextFontSize             12.0f

// 3. 图像，表情宽度

// 详情页最大图片宽度
#define MaxImageHeight							235.0f
// 详情页最大视频图片宽度
#define MaxVideoWidth							128.0f
// 详情页最大视频图片高度
#define	MaxVideoHeight							96.0f
// 文本间隔,实际并不需要人为添加间隔距离
#define VerticalSpaceBetweenText				0.0f
// 源消息距离上边框高度
#define VerticalSpaceBetweenSourceTextAndFrame				6.0f
// 源消息图片距离文本高度
#define VerticalSpaceBetweenSourceImageAndText				8.0f

// 4. 字体颜色

// 主体文字颜色 
#define OriginTextColor                           373737
// 源消息字体颜色          
#define SourceTextColor                           373737
// 消息来源字体颜色
#define FromTextColor                             808080
// 消息时间字体颜色
#define TimeTextColor                             808080
// 刷新结果黄条上的字体颜色
#define FrefreshTextColor                         a68943
// 好友列表昵称的字体颜色
#define FriendNickTextColor                       000000
// 好友列表城市的字体颜色
#define FriendAddrTextColor                       999999
//好友列表后边文字的字体颜色    
#define FriendTweetTextColor                      EBEBEB
//	更多中设置背景色
#define MoreSettingBackgroundColor				  @"ccd8e1"
//好友列表文本宽度
#define FriendTweetTextWidth					  90
//好友列表文本和箭头间距
#define FriendTweetTextArrowMargin				  16


// 相对高度: 分三部分，主消息 + 源消息 + 主消息与源消息间隔(VSpaceBetweenOriginFrameAndFrom)
// 1.  主消息: 主体文本距离上边框高度
#define VSBetweenOriginTextAndFrame							6.0f
// 2.  主消息: 视频距离文字高度
#define VSpaceBetweenVideoAndText							6.0f
// 3.  主消息: 图片距离文字或视频高度(统一用VSpaceBetweenVideoAndText)
//#define VSpaceBetweenImageAndVideo							VSpaceBetweenVideoAndText
// 4.  主消息: "来自...“距离上边文字或图片高度
#define VSpaceBetweenOriginFromAndText						6.0f
// 5.  源消息: 边框距离 "来自...“ 高度
#define VSpaceBetweenOriginFrameAndFrom						6.0f
// 6.  源消息: 主体文字距离上边框高度
#define VSBetweenSourceTextAndFrame							6.0f
// 7.  源消息: 视频距离文字高度(统一用VerticalSpaceBetweenSourceImageAndText)
// 8.  源消息: 图片距离视频或文字高度
#define VSBetweenSourceImageAndText							8.0f
// 9.  源消息: "来自...”距离主体文字或图片高度
#define VSBetweenSourceFromAndText							6.0f
// 10. 源消息: 底部边框距离"来自...”高度
#define VSBetweenSourceFrameAndFrom							6.0f
// 11. 主消息: "本文共...次转播"距离上边主体文字或者源消息高度
#define VSBetweenOriginCommentCntAndText					6.0f
// 12. 主消息:  边框距离"本文共...次转播"高度
#define VSBetweenOriginFrameAndOriginCommentCnt				6.0f

// 13. 单条消息页面 图片与视频间隔(保留，请不要随意修改)
#define VSBetweenImageAndVideo								VSpaceBetweenVideoAndText

// lichentao 2012-02-27
// 热门话题文字大小及颜色
#define HotTopicTextFontSize								36
#define HotTopicTextFontColor								@"373737"
#define HotTopicCountFontSize								27
#define HotTopicCountFontColor								@"79b9d7"


