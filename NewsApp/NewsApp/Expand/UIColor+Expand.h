//
//  UIColor+Expand.h
//  Urundc_IOS
//
//  Created by 杨方明 on 15/1/6.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Expand)

//根据十六进制字符串生成Color
+ (UIColor *)colorWithHexColorString:(NSString *)hexColor;

//根据十六进制字符串生成Color
+ (UIColor *)colorWithHexColorString:(NSString *)hexColor alpha:(CGFloat)alpha;

//根据十六进制字符串生成Color
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

//根据十六进制字符串生成Color
+ (UIColor*)colorWithHex:(NSInteger)hexValue;

@end
