//
//  NewsManager.m
//  NewsApp
//
//  Created by 杨方明 on 16/4/20.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import "NewsManager.h"

#import "BaseService.h"

#import "NSString+Expand.h"

@implementation NewsManager

- (void)getSouhuNewsList:(NSMutableDictionary *)params
            success:(void (^)(NSMutableArray<ArticleCellLayout *> *))success
               fail:(void (^)(NSMutableDictionary *))fail{
    
    NSString *content = params[@"content"];
    NSNumber *page = params[@"page"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.huceo.com/%@/other/?key=c32da470996b3fdd742fabe9a2948adb&num=20",content];
    
    NSMutableDictionary *requestParams = [NSMutableDictionary dictionary];
    [requestParams setObject:page forKey:@"page"];
    
    [[BaseService sharedBaseService] getRequestDataFromServiceWithUrl:urlString params:requestParams success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = responseObject;
        
        NSArray *newsDic = dic[@"newslist"];
        
        [NewsModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"sourceName" : @"description",
                     @"newsUrl" : @"url",
                     };
        }];
        
        NSMutableArray<NewsModel *> *models = [NewsModel mj_objectArrayWithKeyValuesArray:newsDic];
        
        NSMutableArray *layouts = [NSMutableArray array];
        
        [models enumerateObjectsUsingBlock:^(NewsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NewsModel *model = obj;
            
            model.channelName_en = content;
            
            model.page = [page integerValue];
            
            model.updateTime = [NSString stringFromDate:[NSDate date] format:kTimeFormat];
            
            ArticleCellLayout *layout = [ArticleCellLayout getLayoutByModel:obj];
            
            [layouts addObject:layout];

        }];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            if([page integerValue] == 1)
            {
                [[DATManager sharedDATManager].newsDAT deleteNewsByChannelName_en:content];
            }

            [models enumerateObjectsUsingBlock:^(NewsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [[DATManager sharedDATManager].newsDAT insert:obj];
            }];
        });

        success(layouts);
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        fail(nil);
    }];
}


- (void)getVideoNewsList:(NSMutableDictionary *)params
                 success:(void (^)(NSMutableArray<VideoCellLayout *> *))success
                    fail:(void (^)(NSMutableDictionary *))fail
{
    NSNumber *page = params[@"page"];
    NSString *urlstr = [NSString stringWithFormat:@"http://c.3g.163.com/nc/video/list/VAP4BFE3U/y/%d-10.html",10*([page intValue]-1)];
    
    [[BaseService sharedBaseService] getRequestDataFromServiceWithUrl:urlstr params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *resultArr = responseObject[@"VAP4BFE3U"];
        
        [VideoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"picUrl" : @"cover",
                     };
        }];
        
        NSArray<VideoModel *> *models = [VideoModel mj_objectArrayWithKeyValuesArray:resultArr];
        
        NSMutableArray *layouts = [NSMutableArray array];
        [models enumerateObjectsUsingBlock:^(VideoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            VideoModel *model = obj;
            
            model.page = [page integerValue];
            
            model.updateTime = [NSString stringFromDate:[NSDate date] format:kTimeFormat];

            VideoCellLayout *layout = [[VideoCellLayout alloc]initWithModel:obj];
            [layouts addObject:layout];
            
        }];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if([page integerValue] == 1)
            {
                [[DATManager sharedDATManager].videoDAT deleteAll];
            }
            
            [models enumerateObjectsUsingBlock:^(VideoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [[DATManager sharedDATManager].videoDAT insert:obj];
            }];
        });
        
        success(layouts);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        fail(nil);
    }];
}

@end
