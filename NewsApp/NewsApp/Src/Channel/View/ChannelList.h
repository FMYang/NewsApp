//
//  ChannelList.h
//  NewsApp
//
//  Created by 杨方明 on 16/4/30.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChannelModel.h"

//手势操作类型
typedef NS_ENUM(NSInteger, GestureOperationType) {
    kOperationSelected, //选中操作
    kOperationDelete,   //删除操作
    kOperationAdd,      //添加操作
    kOperationMove,     //排序操作
};

@protocol ChannelListDelegate;

@interface ChannelList : UIView

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, copy) NSString *selectedChannelName;

@property (nonatomic, strong) NSMutableArray<ChannelModel *> *topChannelModels;

@property (nonatomic, strong) NSMutableArray<ChannelModel *> *bottomChannelModels;

@property (nonatomic, weak) id<ChannelListDelegate> delegate;

- (void)show;

- (void)dismiss;

@end

@protocol ChannelListDelegate <NSObject>

@optional

//选中item
- (void)didSelectedItemAtIndexPath:(NSIndexPath *)indexPath;

//item数据源有改变（增加、删除、排序）
- (void)didItemChangedTopChannelModels:(NSMutableArray<ChannelModel *> *)topChannelModels
                   bottomChannelModels:(NSMutableArray<ChannelModel *> *)bottomChannelModels
                         selectedIndex:(NSInteger)selectedIndex;

- (void)channelListViewDidShow;

- (void)channelListViewDidDissmiss;

@end


