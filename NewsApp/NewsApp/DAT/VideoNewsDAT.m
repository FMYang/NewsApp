//
//  VideoNewsDAT.m
//  NewsApp
//
//  Created by 杨方明 on 16/5/12.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import "VideoNewsDAT.h"

@implementation VideoNewsDAT

- (void)createTableWithDB:(FMDatabase *)db
{
    if(![db tableExists:VideoTable])
    {
        NSString *sql = [NSString stringWithFormat:@"create table %@ (title Text, mp4_url Text, picUrl Text, playCount Integer, replyCount Integer, length Integer, page Integer, updateTime Text)", VideoTable];
        BOOL success = [db executeUpdate:sql];
        if(success)
        {
            DLog(@"创建%@成功",NewsTable);
        }
        else
        {
            DLog(@"创建%@失败",NewsTable);
        }
    }
}

- (BOOL)isExistEntity:(VideoModel *)info db:(FMDatabase *)db
{
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where title=?",VideoTable];
    int count = [db intForQuery:sql,info.title];
    if(count > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)insert:(VideoModel *)info
{
    VideoModel *model = (VideoModel *)info;
    
    //插入记录
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (title, mp4_url, picUrl, playCount, replyCount, length, page, updateTime) values(?,?,?,?,?,?,?,?)",VideoTable];
    //更新指定列
    NSString *upSql = [NSString stringWithFormat:@"update %@ set mp4_url=?, picUrl=?, playCount=?, replyCount=?, length=?, page=?, updateTime=? where title=?", VideoTable];
    
    //多线程中使用队列执行sql
    [[BaseDAT sharedBaseDAT].dbQueue inDatabase:^(FMDatabase *db) {
        
        if(![self isExistEntity:info db:db])
        {//不存在插入对象
            [db executeUpdate:insertSql, model.title, model.mp4_url, model.picUrl, IntegerNumber(model.playCount), IntegerNumber(model.replyCount), IntegerNumber(model.length), IntegerNumber(model.page), model.updateTime];
        }
        else
        {//存在，更新对象的值
            [db executeUpdate:upSql, model.mp4_url, model.picUrl, IntegerNumber(model.playCount), IntegerNumber(model.replyCount), IntegerNumber(model.length), IntegerNumber(model.page), model.updateTime, model.title];
        }
    }];
}

- (NSArray *)getAll
{
    __block NSMutableArray *resultArr = [NSMutableArray array];
    
    [[BaseDAT sharedBaseDAT].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select *from %@", VideoTable];
        FMResultSet *s = [db executeQuery:sql];
        while ([s next]) {
            VideoModel *model = [[VideoModel alloc]init];
            model.title = [s stringForColumn:@"title"];
            model.mp4_url = [s stringForColumn:@"mp4_url"];
            model.picUrl = [s stringForColumn:@"picUrl"];
            model.playCount = [s intForColumn:@"playCount"];
            model.replyCount = [s intForColumn:@"replyCount"];
            model.length = [s intForColumn:@"length"];
            model.updateTime = [s stringForColumn:@"updateTime"];
            model.page = [s intForColumn:@"page"];
            [resultArr addObject:model];
        }
        [s close];
    }];
    return resultArr;
}

- (void)deleteAll
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@", VideoTable];
    
    [[BaseDAT sharedBaseDAT].dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
}

- (void)dropTableWithDB:(FMDatabase *)db
{
    NSString *sql = [NSString stringWithFormat:@"drop Table %@", VideoTable];
    
    [db executeUpdate:sql];
}

@end
