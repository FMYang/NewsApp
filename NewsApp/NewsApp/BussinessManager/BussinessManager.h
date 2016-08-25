//
//  BussinessManager.h
//  DemoProject
//
//  Created by 杨方明 on 15/1/7.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsManager.h"

@interface BussinessManager : NSObject

@property (nonatomic, strong) NewsManager *newsMannager;

+ (instancetype)sharedBussinessManager;

@end
