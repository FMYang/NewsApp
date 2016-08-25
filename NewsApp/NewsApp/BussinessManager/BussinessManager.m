//
//  BussinessManager.m
//  DemoProject
//
//  Created by 杨方明 on 15/1/7.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#import "BussinessManager.h"

@implementation BussinessManager

+ (instancetype)sharedBussinessManager
{
    static BussinessManager *_shareBussinessManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _shareBussinessManager = [[self alloc] init];
    });
    
    return _shareBussinessManager;
}

-(instancetype)init
{
    if(self = [super init])
    {
        _newsMannager = [[NewsManager alloc]init];
    }
    return self;
}

@end
