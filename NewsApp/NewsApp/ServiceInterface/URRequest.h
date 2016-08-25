//
//  URRequest.h
//  Urundc_IOS
//
//  Created by 杨方明 on 15/1/7.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>

@interface URRequest : AFHTTPSessionManager

+ (instancetype)sharedURRequest;

/**
 *  获取当前task
 *
 *  @param path 接口地址
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)getCurrentOperationWithTag:(NSString *)path;

/**
 *  取消指定请求
 *
 *  @param path 接口地址
 */
- (void)cancelRequestByPath:(NSString *)path;

@end
