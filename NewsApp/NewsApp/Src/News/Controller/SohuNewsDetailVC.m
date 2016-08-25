//
//  SohuNewsDetailVC.m
//  NewsApp
//
//  Created by 杨方明 on 16/4/27.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import "SohuNewsDetailVC.h"
#import "UIWebView+Clean.h"

@interface SohuNewsDetailVC () <UIWebViewDelegate, NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation SohuNewsDetailVC

- (void)dealloc
{
    [self.webView cleanForDealloc];
    self.webView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight-64)];
    [self.view addSubview:_webView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, self.customNav.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.progress = 0.0;
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailUrl]]];

    [self.customNav addSubview:_progressView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
