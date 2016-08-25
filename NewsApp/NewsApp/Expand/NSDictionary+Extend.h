//
//  NSDictionary+Extend.h
//  Urundc_IOS
//
//  Created by 杨方明 on 15/1/20.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extend)

//编码成http页面能够接受得参数
-(NSString*) urlEncodedString;

- (NSString *)jsonString;

//获取本地json字典
+ (NSDictionary *)dictionaryWithJsonFileName:(NSString *)fileName;

@end
