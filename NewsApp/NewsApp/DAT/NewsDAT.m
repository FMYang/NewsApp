//
//  ArticleDAT.m
//  UrunNews
//
//  Created by 杨方明 on 15/4/8.
//  Copyright (c) 2015年 URUN. All rights reserved.
//

#import "NewsDAT.h"

@implementation NewsDAT

-(void)createTableWithDB:(FMDatabase *)db
{
    if(![db tableExists:NewsTable])
    {
        NSString *sql = [NSString stringWithFormat:@"create table %@ (channelName_en Text, title Text, sourceName Text, picUrl Text, ctime Text, newsUrl Text, page Integer, updateTime Text)", NewsTable];
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

- (BOOL)isExistEntity:(NewsModel *)info db:(FMDatabase *)db
{
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where title=?",NewsTable];
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

- (void)insert:(NewsModel *)info
{
    NewsModel *model = (NewsModel *)info;
    
    //插入记录
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (channelName_en, title, sourceName, picUrl, ctime, newsUrl, page, updateTime) values(?,?,?,?,?,?,?,?)",NewsTable];
    //更新指定列
    NSString *upSql = [NSString stringWithFormat:@"update %@ set channelName_en=?, sourceName=?, picUrl=?, ctime=?, newsUrl=?, page=?, updateTime=? where title=?", NewsTable];
    
    //多线程中使用队列执行sql
    [[BaseDAT sharedBaseDAT].dbQueue inDatabase:^(FMDatabase *db) {
        
        if(![self isExistEntity:info db:db])
        {//不存在插入对象
            [db executeUpdate:insertSql, model.channelName_en, model.title, model.sourceName, model.picUrl, model.ctime, model.newsUrl,IntegerNumber(model.page), model.updateTime];
        }
        else
        {//存在，更新对象的值
            [db executeUpdate:upSql, model.channelName_en, model.sourceName, model.picUrl, model.ctime, model.newsUrl,IntegerNumber(model.page), model.updateTime, model.title];
        }
    }];
}

- (NSArray *)getNewsByChannelName_en:(NSString *)channelName_en
{
    __block NSMutableArray *resultArr = [NSMutableArray array];

    [[BaseDAT sharedBaseDAT].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select *from %@ where channelName_en=?", NewsTable];
        FMResultSet *s = [db executeQuery:sql, channelName_en];
        while ([s next]) {
            NewsModel *model = [[NewsModel alloc]init];
            model.channelName_en = [s stringForColumn:@"channelName_en"];
            model.title = [s stringForColumn:@"title"];
            model.picUrl = [s stringForColumn:@"picUrl"];
            model.sourceName = [s stringForColumn:@"sourceName"];
            model.newsUrl = [s stringForColumn:@"newsUrl"];
            model.updateTime = [s stringForColumn:@"updateTime"];
            model.page = [s intForColumn:@"page"];
            [resultArr addObject:model];
        }
        [s close];
    }];
    return resultArr;
}

- (void)deleteNewsByChannelName_en:(NSString *)channelName_en
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where channelName_en=?", NewsTable];
    
    [[BaseDAT sharedBaseDAT].dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql, channelName_en];
    }];
}

- (void)deleteAll
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@", NewsTable];
    
    [[BaseDAT sharedBaseDAT].dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
}

- (void)dropTableWithDB:(FMDatabase *)db
{
    NSString *sql = [NSString stringWithFormat:@"drop Table %@", NewsTable];
    
    [db executeUpdate:sql];
}

@end
