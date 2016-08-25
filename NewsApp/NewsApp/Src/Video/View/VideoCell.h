//
//  VideoCell.h
//  NewsApp
//
//  Created by 杨方明 on 16/5/12.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VideoCellLayout.h"

@protocol VideoCellDelegate;

@interface VideoCell : UITableViewCell

/*图片*/
@property (nonatomic, strong) UIImageView *videoImageView;

/*标题*/
@property (nonatomic, strong) UILabel *titleLabel;

/*标题背景*/
@property (nonatomic, strong) UIView *titleBackgroundView;

/*时长*/
@property (nonatomic, strong) UILabel *lengthLabel;

/*播放数*/
@property (nonatomic, strong) UILabel *playCountLabel;

/*回复数*/
@property (nonatomic, strong) UILabel *replyLabel;

/*底部view*/
@property (nonatomic, strong) UIView *bottomView;

/*播放按钮*/
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<VideoCellDelegate> delegate;

/*布局cell*/
- (void)layoutCellWithLayout:(VideoCellLayout *)layout;

@end

@protocol VideoCellDelegate <NSObject>

@optional
- (void)didClickPlayButtonAtIndexPath:(NSIndexPath *)indexPath;

@end
