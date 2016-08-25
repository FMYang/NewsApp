//
//  BaseViewController.m
//  Urundc_IOS
//
//  Created by 杨方明 on 15/1/5.
//  Copyright (c) 2015年 urun. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

@synthesize customNav = _customNav;
@synthesize leftButton;
@synthesize navTitle;
@synthesize titleLabel;


/**
 *  自定义导航栏
 */
- (void)showCustomNav
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CGRect navRect = CGRectMake(0, 0, rect.size.width, NavHeight+StatusBarHeight);
    _customNav = [[UIImageView alloc]initWithFrame:navRect];
    [_customNav setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *navBottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, navRect.size.height-1, ScreenWith, 1)];
    navBottomLine.image = [UIImage imageNamed:@"icon_space_line"];
    [_customNav addSubview:navBottomLine];
    
    [self.view addSubview:_customNav];
}

/**
 *  自定义导航栏返回按钮
 */
- (void)showCustomNavBackButton
{
    if([self showBackButton])
    {
        _customNav.userInteractionEnabled = YES;
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(5, StatusBarHeight, 50, 44);
        [leftButton setImage:[UIImage imageNamed:@"icon_back_gray_normal"] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"icon_back_gray_selected"] forState:UIControlStateHighlighted];
        [leftButton setImage:[UIImage imageNamed:@"icon_back_gray_selected"] forState:UIControlStateSelected];
        [leftButton addTarget:self action:@selector(onBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_customNav addSubview:leftButton];
    }
}

/**
 *  自定义导航栏标题
 */
- (void)showCustomTitle
{
    if([self showTitle])
    {
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, StatusBarHeight, 200, NavHeight)];
        titleLabel.center = CGPointMake(ScreenWith/2, StatusBarHeight+NavHeight/2);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.customNav addSubview:titleLabel];
    }
}

/**
 *  默认显示导航栏返回按钮 如果不需要 在子类重写此方法 返回NO即可
 */
- (BOOL)showBackButton
{
    return YES;
}

/**
 *  默认显示导航栏标题 如果不需要 在子类重写 返回NO
 */
- (BOOL)showTitle
{
    return YES;
}

- (void)setNavTitleColor:(UIColor *)color
{
    titleLabel.textColor = color;
}

- (void)setNavTitle:(NSString *)aTitle
{
    titleLabel.text = aTitle;
}

- (void)onBackButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BaseViewController life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.delegate = self;
    
    [self showCustomNav];
    [self showCustomNavBackButton];
    [self showCustomTitle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - 右滑返回手势
#pragma mark - navgationDelegate
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count == 1) { // 跟控制器
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    }else{
        // 实现导航控制器的滑动返回
        navigationController.interactivePopGestureRecognizer.enabled = YES;
        navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
