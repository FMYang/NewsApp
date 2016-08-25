//
//  ArticleDAT.h
//  UrunNews
//
//  Created by 杨方明 on 15/4/8.
//  Copyright (c) 2015年 URUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsModel.h"
#import "BaseDAT.h"

@interface NewsDAT : NSObject

/*插入数据*/
- (void)insert:(NewsModel *)info;

/*获取当前栏目的数据*/
- (NSArray *)getNewsByChannelName_en:(NSString *)channelName_en;

/*删除当前栏目数据*/
- (void)deleteNewsByChannelName_en:(NSString *)channelName_en;

/*删除表中的所有数据*/
- (void)deleteAll;

/*创建表*/
-(void)createTableWithDB:(FMDatabase *)db;

/*删除表*/
- (void)dropTableWithDB:(FMDatabase *)db;


@end
