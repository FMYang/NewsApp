//
//  VideoCellLayout.h
//  NewsApp
//
//  Created by 杨方明 on 16/5/12.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VideoModel.h"

@interface VideoCellLayout : NSObject

/*model*/
@property (nonatomic, strong) VideoModel *model;

/*title height*/
@property (nonatomic, assign) float titleHeight;

/*image width*/
@property (nonatomic, assign) float videoImageWidth;

/*image height*/
@property (nonatomic, assign) float videoImageHeight;

/*bottom view height*/
@property (nonatomic, assign) float bottomToolHeight;

/*cell height*/
@property (nonatomic, assign) float cellHeight;

- (instancetype)initWithModel:(VideoModel *)model;

@end

