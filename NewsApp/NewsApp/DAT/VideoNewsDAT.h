//
//  VideoNewsDAT.h
//  NewsApp
//
//  Created by 杨方明 on 16/5/12.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VideoModel.h"

@interface VideoNewsDAT : NSObject

/*插入数据*/
- (void)insert:(VideoModel *)info;

/*获取当前栏目的数据*/
- (NSArray *)getAll;

/*删除表中的所有数据*/
- (void)deleteAll;

/*创建表*/
-(void)createTableWithDB:(FMDatabase *)db;

/*删除表*/
- (void)dropTableWithDB:(FMDatabase *)db;

@end
