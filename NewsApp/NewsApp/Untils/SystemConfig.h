//
//  SystemConfig.h
//  Urundc_IOS
//
//  Created by 杨方明 on 15/1/6.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#ifndef Urundc_IOS_SystemConfig_h
#define Urundc_IOS_SystemConfig_h

#define KDefaultImageName @"icon_default_image"

#define kImgsCache @"ImgsCache"

/*计算程序执行时间的宏*/
#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])

#define kGetCurAppVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] //获取应用release版本号
#define kGetBuidVersion   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] //获取应用build版本号

#define kNewsRefreshTime 10 //分钟

#define SystemFont_10 [UIFont systemFontOfSize:10]
#define SystemFont_12 [UIFont systemFontOfSize:12]
#define SystemFont_13 [UIFont systemFontOfSize:13]
#define SystemFont_14 [UIFont systemFontOfSize:14]
#define SystemFont_16 [UIFont systemFontOfSize:16]
#define SystemFont_18 [UIFont systemFontOfSize:18]
#define SystemFont_20 [UIFont systemFontOfSize:20]
#define BoldSystemFont_12 [UIFont boldSystemFontOfSize:12]
#define BoldSystemFont_14 [UIFont boldSystemFontOfSize:14]
#define BoldSystemFont_16 [UIFont boldSystemFontOfSize:16]

#define DoubleNumber(value) [NSNumber numberWithDouble:value]
#define IntNumber(value) [NSNumber numberWithInt:value]
#define IntegerNumber(value) [NSNumber numberWithInteger:value]
#define LongNumber(value) [NSNumber numberWithLong:value]
#define BoolNumber(value) [NSNumber numberWithBool:value]
#define StringIntValue(value) [NSString stringWithFormat:@"%d", value]
#define StringIntegerValue(value) [NSString stringWithFormat:@"%ld", value]

#define kTimeFormat @"yyyy-MM-dd HH:mm:ss"

//文件缓存路径
#define CachePath ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0])

#define ScreenWith ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define KWindow [[UIApplication sharedApplication].windows lastObject]

#define CoverNull(anobject) (((anobject==nil) || [anobject isKindOfClass:[NSNull class]])?nil:anobject)
#define StringCoverNull(anobject) (((anobject==nil) || [anobject isKindOfClass:[NSNull class]])?@"":anobject)

#endif

// 日志输出
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"[行号:%d] " fmt),__LINE__ ,##__VA_ARGS__)
#define DFuctionLog() DLog(@"%s",__func__)
#else
#define DLog(...)
#define DFuctionLog(...)

#endif

