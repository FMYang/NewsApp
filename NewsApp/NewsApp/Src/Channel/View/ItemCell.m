//
//  ItemCell.m
//  NewsApp
//
//  Created by 杨方明 on 16/4/30.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        _itemLabel = [[UILabel alloc]init];
        _itemLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _itemLabel.backgroundColor = [UIColor whiteColor];
        _itemLabel.textAlignment = NSTextAlignmentCenter;
        _itemLabel.font = [UIFont systemFontOfSize:14];
        _itemLabel.textColor = [UIColor blackColor];
        _itemLabel.adjustsFontSizeToFitWidth = YES; //根据宽度自适应字体大小
        [self addSubview:_itemLabel];
        
        _deleteImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
        _deleteImgView.image = [UIImage imageNamed:@"icon_channel_delete"];
        _deleteImgView.centerX = _itemLabel.x+_itemLabel.width-4;
        _deleteImgView.centerY = _itemLabel.y+4;
        _deleteImgView.hidden = YES;
        [self addSubview:_deleteImgView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
