//
//  AppDelegate.m
//  NewsApp
//
//  Created by 杨方明 on 16/4/20.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "NewsListContainerVC2.h"
#import <SDWebImage/SDWebImageManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor  = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //不存内存缓存，刷新列表的时候从沙盒加载图片会闪一下
//    [[SDWebImageManager sharedManager].imageCache setShouldCacheImagesInMemory:NO];
    
    [[DATManager sharedDATManager] initDB];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    NewsListContainerVC2 *newsListContainerVC = [[NewsListContainerVC2 alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:newsListContainerVC];
    [self.window setRootViewController:nav];
    
    [self.window makeKeyAndVisible];
        
    return YES;
}

@end