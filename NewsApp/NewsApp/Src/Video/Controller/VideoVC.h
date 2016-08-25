//
//  VideoVC.h
//  NewsApp
//
//  Created by 杨方明 on 16/5/13.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ChannelModel.h"

#import "NewsListViewStatus.h"

#import "VideoCell.h"

@protocol VideoVCDelegate;

@interface VideoVC : UIViewController

@property (nonatomic, strong) UITableView *newsTableView;

@property (nonatomic, weak) id<VideoVCDelegate> delegate;

/*当前控制器的标记*/
@property (nonatomic, assign) NSInteger indexNumber;

- (instancetype)initWithChannelModels:(NSMutableArray<ChannelModel *> *)channelModels
                      viewStatusArray:(NSMutableArray<NewsListViewStatus *> *)viewStatus
                          indexNumber:(NSInteger)indexNumber;


@end

@protocol VideoVCDelegate <NSObject>

- (void)setCurrentIndex:(NSInteger)index;

@end

