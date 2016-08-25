//
//  KrVideoPlayerController.h
//  KrVideoPlayerPlus
//
//  Created by JiaHaiyang on 15/6/19.
//  Copyright (c) 2015年 JiaHaiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MediaPlayer;

@interface KrVideoPlayerController : MPMoviePlayerController
@property (nonatomic, copy)void(^playCompleteBlock)(void);
/** video.view 消失 */
@property (nonatomic, copy)void(^dimissCompleteBlock)(void);
/** 进入最小化状态 */
@property (nonatomic, copy)void(^willBackOrientationPortrait)(void);
/** 进入全屏状态 */
@property (nonatomic, copy)void(^willChangeToFullscreenMode)(void);
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, copy) NSString *titleText;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)showInWindow;
- (void)showInView:(UIView *)view;
- (void)dismiss;
- (void)resetControl;
/**
 *  获取视频截图
 */
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
@end
