//
//  BaseDAT.m
//  Urundc_IOS
//
//  Created by 杨方明 on 15/1/7.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#import "BaseDAT.h"

@implementation BaseDAT

@synthesize urunDB;
@synthesize dbQueue;

+ (instancetype)sharedBaseDAT
{
    static BaseDAT *_shareBaseDAT = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _shareBaseDAT = [[self alloc] init];
    });
    
    return _shareBaseDAT;
}

- (instancetype)init
{
    if(self = [super init])
    {
        dbQueue = [[FMDatabaseQueue alloc]initWithPath:[BaseDAT GetDataBasePath]];
    }
    return self;
}

//获取数据库的本地路径
+ (NSString *)GetDataBasePath
{
    NSString *documentPath =
    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dataBasePath = [documentPath stringByAppendingPathComponent:DBNAME];
    return dataBasePath;
}

//创建数据库
- (void)createDataBase
{
    NSString *dataBasePath = [BaseDAT GetDataBasePath];
    self.urunDB = [FMDatabase databaseWithPath:dataBasePath];
}

//打开数据库
- (FMDatabase *)openDataBase
{
    if(!self.urunDB)
    {
        [self createDataBase];
    }
    if (![self.urunDB open])
    {
        @throw @"db open error";
    }
    return self.urunDB;
}

//关闭数据库
- (void)closeDataBase
{
    if(self.urunDB)
    {
        [self.urunDB close];
    }
}


@end
