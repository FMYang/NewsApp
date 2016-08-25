//
//  BaseService.m
//  DemoProject
//
//  Created by 杨方明 on 15/1/7.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#import "BaseService.h"
#import "URRequest.h"
#import "NSDictionary+Extend.h"
#import "AppDelegate.h"

@implementation BaseService
@synthesize manager;

+ (instancetype)sharedBaseService {
    static BaseService *_shareBaseService = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _shareBaseService = [[self alloc] init];
    });
    
    return _shareBaseService;
}

-(void)getRequestDataFromServiceWithUrl:(NSString *)url
                              params:(NSDictionary *)params
                             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    //转成utf8编码
    NSString *paramsStr = [params urlEncodedString];
    NSString *urlStr;
    if([NSString isEmptyString:paramsStr])
    {
        urlStr = url;
    }
    else
    {
        urlStr = [NSString stringWithFormat:@"%@&%@",url,paramsStr];
    }
    
    DLog(@"urlPath = %@", urlStr);

    manager = [URRequest sharedURRequest];
    manager.requestSerializer.timeoutInterval = 60;
    
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    
    [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *jsonDic = (NSDictionary *)responseObject;
        
        DLog(@"%@",jsonDic);
        
        success(task, jsonDic);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"请求头============:%@",manager.requestSerializer.HTTPRequestHeaders);
        DLog(@"状态码：%ld",task.error.code);
        DLog(@"Error: %@", error);
        
        if(task.error.code == NSURLErrorCancelled)
        {//如果请求是手动取消的
            
        }
        
        if(task.error.code == NSURLErrorTimedOut)
        {//请求超时处理
            
        }
        
        failure(task, error);

    }];
}

- (void)postRequestDataFromServiceWithUrl:(NSString *)url
                                   params:(NSDictionary *)params
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
{
    manager = [URRequest sharedURRequest];
    manager.requestSerializer.timeoutInterval = 60;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonDic = (NSDictionary *)responseObject;
        DLog(@"%@",jsonDic);
        
        success(task, jsonDic);
                
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError *error) {
        DLog(@"请求头============:%@",manager.requestSerializer.HTTPRequestHeaders);
        DLog(@"状态码：%ld",task.error.code);
        DLog(@"Error: %@", error);
        
        failure(task, error);
    }];
}

@end
