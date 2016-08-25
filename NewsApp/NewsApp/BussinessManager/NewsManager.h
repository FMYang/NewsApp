//
//  NewsManager.h
//  NewsApp
//
//  Created by 杨方明 on 16/4/20.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ArticleCellLayout.h"

#import "VideoCellLayout.h"

@interface NewsManager : NSObject

- (void)getSouhuNewsList:(NSMutableDictionary *)params
            success:(void(^)(NSMutableArray<ArticleCellLayout *> *))success
               fail:(void(^)(NSMutableDictionary *failDic))fail;


- (void)getVideoNewsList:(NSMutableDictionary *)params
                 success:(void(^)(NSMutableArray<VideoCellLayout *> *))success
                    fail:(void(^)(NSMutableDictionary *failDic))fail;

@end
