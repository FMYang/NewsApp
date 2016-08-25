//
//  UIImageView+Extend.h
//  Kitchen
//
//  Created by 杨方明 on 15/3/27.
//  Copyright (c) 2015年 rurn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extend)

+ (float)getHeightByNewWidth:(float)newWidth image:(UIImage *)image;

+ (float)getWidthByNewHeight:(float)newHeight image:(UIImage *)image;

- (UIImage *)cutImageFromImage:(UIImage *)aImage cutFrame:(CGSize)curRect;

@end

