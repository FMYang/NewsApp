//
//  NSString+Expand.h
//  Urundc_IOS
//
//  Created by 杨方明 on 15/1/8.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"

@interface NSString (Expand)

+ (NSString *)base64StringFromText:(NSString *)text withKey:(NSString*)key;

+ (NSData *) DESEncrypt:(NSData *)data key:(NSString *)key;

+ (BOOL)isEmptyString:(NSString *)string;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (NSString*)getVisitVerify:(NSString *)string;

+ (NSString *)GetMd5:(NSString *)string;

+ (NSString *)getPhoneSN;

+ (NSString *) md5:(NSString *)str lenth:(int)lenth;

+ (NSString *)replaceNullByStr:(NSObject *)source string:(NSString *)str;

+ (NSString *)getCurrentDateWithFormat:(NSString *)format;

//date转string
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;

//string转date
- (NSDate *)dateValueWithFormatString:(NSString *)formatString;

//string转date
- (NSDate *)dateValue;

//获取字符串高度通过宽度
- (int)getHeightByWidth:(float)aWidth font:(UIFont *)aFont;

//获取字符串宽度通过高度
- (int)getWidthByHeight:(float)aHeight font:(UIFont *)aFont;

//获取字符串size
+ (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font maxWidth:(CGFloat)maxW;

//string转NSMutableAttributedString
-(NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font
                                                withLineSpacing:(CGFloat)lineSpacing;

//获取时间间隔，根据间隔返回对应的描述
+ (NSString *)getTimeInterval:(NSString *)getPushTime currentTime:(NSString *)currentTime;

//获取评论内容的时间描述
+ (NSString *)getCommentTimeInterval:(NSString *)getPushTime currentTime:(NSString *)currentTime;

//获取时间间隔秒数
+ (long)getTimeIntervalSecond:(NSString *)getPushTime currentTime:(NSString *)currentTime;

//时间戳转时间(特定格式Date(/xxxx))
+ (NSString *)timeStampToString:(NSString *)dateStr format:(NSString *)formatStr;

//时间戳转时间 (时间戳微秒格式)
+ (NSString *)timeStampFromString:(NSString *)timeStamp format:(NSString *)formatStr;

//时间戳转时间 (时间戳微秒格式)
+ (NSString *)timeStampFormatToString:(long)timeStamp format:(NSString *)formatStr;

//时间戳转时间 (时间戳秒格式)
+ (NSString *)timeStampTwoFromString:(NSString *)timeStamp format:(NSString *)formatStr;

- (BOOL)isContainsString:(NSString*)other;

+ (NSString *)mergeSpaceString:(NSString *)str;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
