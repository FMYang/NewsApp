//
//  BaseService.h
//  DemoProject
//
//  Created by 杨方明 on 15/1/7.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "NSMutableDictionary+Extend.h"

@interface BaseService : NSObject

@property (nonatomic, strong, readonly) AFHTTPSessionManager *manager;

+ (instancetype)sharedBaseService;

/**
 *  基类网络请求接口(GET)
 *
 *  @param url    接口的服务器地址
 *  @param params 接口参数
 */
- (void)getRequestDataFromServiceWithUrl:(NSString *)url
                                 params:(NSDictionary *)params
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  基类网络请求接口(POST)
 *
 *  @param url         接口的服务器地址
 *  @param params      接口参数
 *  @param success     请求成功块
 *  @param failure     请求失败块
 */
- (void)postRequestDataFromServiceWithUrl:(NSString *)url
                                  params:(NSDictionary *)params
                                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                 failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
