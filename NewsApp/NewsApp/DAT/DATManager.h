//
//  DATManager.h
//  Urundc_IOS
//
//  Created by 杨方明 on 15/1/13.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsDAT.h"
#import "VideoNewsDAT.h"

@interface DATManager : NSObject

@property (nonatomic, strong) NewsDAT *newsDAT;

@property (nonatomic, strong) VideoNewsDAT *videoDAT;

+ (instancetype)sharedDATManager;

- (void)initDB;

- (void)clearAllTable;

- (void)updateDBIfNeed;

@end
