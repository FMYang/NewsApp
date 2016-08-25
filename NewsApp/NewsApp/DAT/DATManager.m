//
//  DATManager.m
//  Urundc_IOS
//
//  Created by 杨方明 on 15/1/13.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#import "DATManager.h"

@implementation DATManager

+ (instancetype)sharedDATManager
{
    static DATManager *_shareDATManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _shareDATManager = [[self alloc] init];
    });
    
    return _shareDATManager;
}

- (instancetype)init
{
    if(self = [super init])
    {
        //创建数据库
        [[BaseDAT sharedBaseDAT] createDataBase];
    }
    return self;
}

- (void)initDB
{
    _newsDAT = [[NewsDAT alloc]init];
    
    _videoDAT = [[VideoNewsDAT alloc]init];
    
    [[BaseDAT sharedBaseDAT].dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {

        [_newsDAT createTableWithDB:db];
        [_videoDAT createTableWithDB:db];
        
    }];
}

- (void)clearAllTable
{
    [[BaseDAT sharedBaseDAT].dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
       
        [_newsDAT dropTableWithDB:db];
        [_videoDAT dropTableWithDB:db];
       
    }];
}

- (void)updateDBIfNeed
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    float dbVersion = [[userDefaults objectForKey:kAPPDBVersion] floatValue];
    DLog(@"数据库版本号：%f",dbVersion);
    if(dbVersion < kDBVersion)
    {
        [self clearAllTable];
        [self initDB];
        
        [userDefaults setObject:[NSNumber numberWithFloat:kDBVersion] forKey:kAPPDBVersion];
        [userDefaults synchronize];
    }
}

@end
