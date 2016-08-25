//
//  NSDictionary+Extend.m
//  Urundc_IOS
//
//  Created by 杨方明 on 15/1/9.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#import "NSMutableDictionary+Extend.h"

@implementation NSMutableDictionary (Extend)

//插入的值为nil或者key为nil时不做操作
- (void)setObjectExtra:(id)anObject forKey:(id <NSCopying>)aKey
{
    
    if(anObject && ![anObject isKindOfClass:[NSNull class]] && aKey)
    {
        [self setObject:anObject forKey:aKey];
    }
}

- (void)setObjectJsonDic:(id)anObject forKey:(id <NSCopying>)aKey
{
    if(anObject && ![anObject isKindOfClass:[NSNull class]])
    {
        [self setObject:anObject forKey:aKey];
    }
    else
    {
        [self setObject:@"" forKey:aKey];
    }
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

@end

@implementation NSMutableArray (Extend)

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

@end
