//
//  BaseViewController.h
//  Urundc_IOS
//
//  Created by 杨方明 on 15/1/5.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Expand.h"
#import "SystemConfig.h"
#import "URRequest.h"

#define StatusBarHeight 20 //状态栏高度固定为20
#define NavHeight 44 //自定义导航栏高度 默认为44

@interface BaseViewController : UIViewController <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

/**
 *  内容区域的frame
 */
@property(nonatomic, readonly) CGRect mainContentViewFrame;

/**
 *  自定义的导航栏View
 */
@property(nonatomic, strong) UIImageView *customNav;

/**
 *  自定义的导航栏返回按钮
 */
@property(nonatomic, strong) UIButton *leftButton;

/**
 *  导航栏标题
 */
@property(nonatomic, strong) NSString *navTitle;

/**
 *  导航栏标题label
 */
@property(nonatomic, strong) UILabel *titleLabel;


@end
