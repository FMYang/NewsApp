//
//  NSDictionary+Extend.h
//  Urundc_IOS
//
//  Created by 杨方明 on 15/1/9.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Extend)

- (void)setObjectExtra:(id)anObject forKey:(id <NSCopying>)aKey;

- (void)setObjectJsonDic:(id)anObject forKey:(id <NSCopying>)aKey;

- (NSString *)jsonString;

@end
