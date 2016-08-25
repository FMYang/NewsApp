//
//  VideoLoadingView.m
//  NewsApp
//
//  Created by 杨方明 on 16/5/16.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import "VideoLoadingView.h"

@interface VideoLoadingView()

@property (nonatomic, strong) UIImageView *animationView;

@property (nonatomic, assign, getter=isLoading) BOOL loading;

@end

@implementation VideoLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    if([super initWithFrame:frame])
    {
        _loading = NO;
        
        _animationView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _animationView.image = [UIImage imageNamed:@"icon_video_white_loding"];
        [self addSubview:_animationView];
    }
    return self;
}

- (void)startLoading
{
    if(self.isLoading)
    {
        [self stopLoading];
    }
    
    [self startRotateAnimation];
}

- (void)stopLoading
{
    if(self.isLoading)
    {
        [self stopRotateAnimation];
    }
}

- (void)startRotateAnimation
{
    self.loading = YES;
    self.animationView.alpha = 1;

    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];///* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

}

- (void)stopRotateAnimation
{
    self.loading = NO;
    self.animationView.alpha = 0;
    [self.layer removeAllAnimations];
}


@end
