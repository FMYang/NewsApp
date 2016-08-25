//
//  NewsModel.h
//  NewsApp
//
//  Created by 杨方明 on 16/4/21.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 ctime = "2016-05-05 17:47";
 description = "网易国内";
 picUrl = "http://s.cimg.163.com/cnews/2016/5/5/2016050517471867d5d_550.jpg.119x83.jpg";
 title = "北京军区总医院更名陆军总医院 将严打科室外包";
 url = "http://news.163.com/16/0505/17/BMAPE9AG0001124J.html#f=dlist";
  */

@interface NewsModel : NSObject

/*标题*/
@property (nonatomic, copy) NSString *title;

/*来源*/
@property (nonatomic, copy) NSString *sourceName;

/*列表图片url*/
@property (nonatomic, copy) NSString *picUrl;

/*创建时间*/
@property (nonatomic, copy) NSString *ctime;

/*所属栏目*/
@property (nonatomic, copy) NSString *channelName_en;

/*新闻内容url（详情页面html）*/
@property (nonatomic, copy) NSString *newsUrl;

/*当前栏目的第几页*/
@property (nonatomic, assign) NSInteger page;

/*入库时间（本地数据库）*/
@property (nonatomic, copy) NSString *updateTime;

@end
