//
//  BaseDAT.h
//  Urundc_IOS
//
//  Created by 杨方明 on 15/1/7.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "DBConfig.h"

@interface BaseDAT : NSObject

@property (nonatomic, strong) FMDatabase *urunDB;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

+ (instancetype)sharedBaseDAT;

/*创建数据库*/
- (void)createDataBase;

/*获取数据库本地路径*/
+ (NSString *)GetDataBasePath;

/*打开数据库*/
- (FMDatabase *)openDataBase;

/*关闭数据库*/
- (void)closeDataBase;

@end
