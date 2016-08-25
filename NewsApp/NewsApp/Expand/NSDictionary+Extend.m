//
//  NSDictionary+Extend.m
//  Urundc_IOS
//
//  Created by 杨方明 on 15/1/20.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#import "NSDictionary+Extend.h"

@implementation NSDictionary (Extend)

static NSString *toString(id object) {
    return [NSString stringWithFormat: @"%@", object];
}

// 转化为UTF8编码
static NSString *urlEncode(id object) {
    NSString *string = toString(object);
    NSString *encodedValue = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                (CFStringRef)string,
                                                                                nil,
                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                kCFStringEncodingUTF8));
    return encodedValue;
}

-(NSString*) urlEncodedString {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in self) {
        id value = [self objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];//拼装字符串
}


- (NSData *)dictionaryToJsonData:(id)theData
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil)
    {
        return jsonData;
    }
    else
    {
        return nil;
    }
}

- (NSString *)jsonString
{
    NSData *data = [self dictionaryToJsonData:self];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

/*
 *  使用 [NSDictionary dictionaryWithJsonFileName:@"data.json"]
 */
+ (NSDictionary *)dictionaryWithJsonFileName:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@""];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return jsonDic;
}

@end
