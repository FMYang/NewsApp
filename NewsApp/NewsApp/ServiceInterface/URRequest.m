//
//  URRequest.m
//  Urundc_IOS
//
//  Created by 杨方明 on 15/1/7.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#import "URRequest.h"

@implementation URRequest

+ (instancetype)sharedURRequest {
    static URRequest *_shareURRequest = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _shareURRequest = [[self alloc] init];
    });
    
    return _shareURRequest;
}

//获取当前task
- (NSURLSessionDataTask *)getCurrentOperationWithTag:(NSString *)path
{
    NSURLSessionDataTask *currentTask = nil;
    for(NSURLSessionDataTask *task in self.tasks)
    {
        NSLog(@"%@",task.currentRequest.URL);
        NSString *curRequestUrl = task.currentRequest.URL.absoluteString;
        
        if([curRequestUrl isContainsString:path])
        {
            currentTask = task;
        }
    }
    
    return currentTask;
}

//通过接口path取消task任务
- (void)cancelRequestByPath:(NSString *)path
{
    NSURLSessionDataTask *currentTask = [self getCurrentOperationWithTag:path];
    
    if(currentTask.state != NSURLSessionTaskStateCanceling)
    {
        [currentTask cancel];
    }
}

@end
