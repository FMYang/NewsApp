//
//  VideoModel.h
//  NewsApp
//
//  Created by 杨方明 on 16/5/12.
//  Copyright © 2016年 杨方明. All rights reserved.
//

/*
 {
 "topicImg": "http://vimg1.ws.126.net/image/snapshot/2016/2/U/L/VBG7H0SUL.jpg",
 "replyCount": 0,
 "videosource": "新媒体",
 "mp4Hd_url": null,
 "topicDesc": "不说不笑不热闹",
 "topicSid": "VBFGARMFR",
 "cover": "http://vimg2.ws.126.net/image/snapshot/2016/5/E/O/VBLULPOEO.jpg",
 "title": "小姐你的伤口好深呀 回家帮你打两针就没有事了",
 "playCount": 3148,
 "replyBoard": "video_bbs",
 "videoTopic": {
 "alias": "不说不笑不热闹",
 "tname": "搞笑一箩筐",
 "ename": "T1460515708679",
 "tid": "T1460515708679"
 },
 "sectiontitle": "",
 "description": "小咖秀合作",
 "replyid": "BLULAUM5008535RB",
 "mp4_url": "http://flv2.bn.netease.com/tvmrepo/2016/5/R/L/EBLULAPRL/SD/EBLULAPRL-mobile.mp4",
 "length": 0,
 "playersize": 0,
 "m3u8Hd_url": null,
 "vid": "VBLULAUM5",
 "m3u8_url": "http://flv2.bn.netease.com/tvmrepo/2016/5/R/L/EBLULAPRL/SD/movie_index.m3u8",
 "ptime": "2016-05-12 14:31:47",
 "topicName": "搞笑一箩筐"
 }
 */

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

/*标题*/
@property (nonatomic, copy) NSString *title;

/*播放地址*/
@property (nonatomic, copy) NSString *mp4_url;

/*图片*/
@property (nonatomic, copy) NSString *picUrl;

/*播放数*/
@property (nonatomic, assign) NSInteger playCount;

/*回复数*/
@property (nonatomic, assign) NSInteger replyCount;

/*时长*/
@property (nonatomic, assign) NSInteger length;

/*当前栏目的第几页*/
@property (nonatomic, assign) NSInteger page;

/*入库时间（本地数据库）*/
@property (nonatomic, copy) NSString *updateTime;

@end
