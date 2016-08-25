//
//  UIColor+Helper.h
//  UrunNews
//
//  Created by 杨方明 on 16/3/18.
//  Copyright © 2016年 URUN. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIColor+Expand.h"

@interface UIColor (Helper)

/*导航栏红*/
+ (UIColor *)navRedColor;

/*导航栏白*/
+ (UIColor *)navWhiteColor;

/*浅灰色 背景*/
+ (UIColor *)backgoundLightGrayColor;

/*蓝色 文字 来源、评论用户名等*/
+ (UIColor *)textBlueColor;

/*红色 文字 相关新闻等*/
+ (UIColor *)textRedColor;

//浅黑色 文字 新闻详情、评论等
+ (UIColor *)textLightBlackColor;

/*侧边栏的背景色 */
+ (UIColor *)leftSlideBgColor;

@end
