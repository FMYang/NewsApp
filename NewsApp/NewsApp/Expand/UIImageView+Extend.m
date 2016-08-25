//
//  UIImageView+Extend.m
//  Kitchen
//
//  Created by 杨方明 on 15/3/27.
//  Copyright (c) 2015年 rurn. All rights reserved.
//

#import "UIImageView+Extend.h"

@implementation UIImageView (Extend)

+ (float)getHeightByNewWidth:(float)newWidth image:(UIImage *)image
{
    float newHeight = newWidth * image.size.height/image.size.width;
    return newHeight;
}

+ (float)getWidthByNewHeight:(float)newHeight image:(UIImage *)image
{
    float newWidth = newHeight * image.size.width/image.size.height;
    return newWidth;
}

- (UIImage *)cutImageFromImage:(UIImage *)aImage cutFrame:(CGSize)curRect
{
    //裁剪图片到合适的尺寸
    if(aImage.size.width < curRect.width && aImage.size.height < curRect.height)
    {
        return aImage;
    }

    CGImageRef imageRef = nil;
    CGSize newSize;
    if ((aImage.size.width / aImage.size.height) < (curRect.width / curRect.height))
    {
        newSize.width = aImage.size.width;
        newSize.height = aImage.size.width * curRect.height / curRect.width;
        
        imageRef = CGImageCreateWithImageInRect([aImage CGImage], CGRectMake(0, fabs(aImage.size.height - newSize.height) / 2, newSize.width, newSize.height));
    }
    else
    {
        newSize.height = aImage.size.height;
        newSize.width = aImage.size.height * curRect.width / curRect.height;
        
        imageRef = CGImageCreateWithImageInRect([aImage CGImage], CGRectMake(fabs(aImage.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
    }
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);//用完一定要释放，否则内存泄露
    return image;
}

@end
