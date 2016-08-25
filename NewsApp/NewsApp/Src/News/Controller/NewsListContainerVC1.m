//
//  NewsListContainerVC1.m
//  NewsApp
//
//  Created by 杨方明 on 16/4/25.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import "NewsListContainerVC1.h"
#import "NewsListVC.h"
#import "ChannelModel.h"

@interface NewsListContainerVC1 () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *newsContainerView;

@property (strong, nonatomic) NSNumber *currentPage;

@property (strong, nonatomic) NSMutableArray *reusableViewControllers;
@property (strong, nonatomic) NSMutableArray *visibleViewControllers;

@property (nonatomic, strong) NSMutableArray<ChannelModel *> *channelModels;


@end

@implementation NewsListContainerVC1

- (NSMutableArray *)reusableViewControllers
{
    if (!_reusableViewControllers) {
        _reusableViewControllers = [NSMutableArray array];
    }
    return _reusableViewControllers;
}

- (NSMutableArray *)visibleViewControllers
{
    if (!_visibleViewControllers) {
        _visibleViewControllers = [NSMutableArray array];
    }
    return _visibleViewControllers;
}


- (NSMutableArray<ChannelModel *> *)channelModels
{
    if(!_channelModels)
    {
        _channelModels = [[NSMutableArray alloc]init];
    }
    return _channelModels;
}

- (UIScrollView *)newsContainerView
{
    if(!_newsContainerView)
    {
        _newsContainerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, self.view.frame.size.height-64)];
        _newsContainerView.contentSize = CGSizeMake(ScreenWith*self.channelModels.count, _newsContainerView.frame.size.height);
        _newsContainerView.delegate = self;
        _newsContainerView.pagingEnabled = YES;
        [self.view addSubview:_newsContainerView];
    }
    return _newsContainerView;
}

- (instancetype)init
{
    if(self = [super init])
    {
        [self setupChannels];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"新闻";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self loadPage:0];
}

#pragma mark - 初始化
- (void)setupChannels
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Channel" ofType:@"plist"];
    NSArray *channels = [[NSArray alloc]initWithContentsOfFile:path];
    [channels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        ChannelModel *model = [[ChannelModel alloc]init];
        model.channelID = dic[@"id"];
        model.channelName_cn = dic[@"name"];
        [self.channelModels addObject:model];
    }];
    
    [self.channelModels removeObjectAtIndex:0];
    
    [self.channelModels addObjectsFromArray:self.channelModels];
}

- (void)setCurrentPage:(NSNumber *)currentPage
{
    if (_currentPage != currentPage) {
        _currentPage = currentPage;
    }
}

- (void)loadPage:(NSInteger)page
{
    if (self.currentPage && page == [self.currentPage integerValue]) {
        return;
    }
    self.currentPage = @(page);
    NSMutableArray *pagesToLoad = [@[@(page), @(page - 1), @(page + 1)] mutableCopy];
    NSMutableArray *vcsToEnqueue = [NSMutableArray array];
    for (NewsListVC *vc in self.visibleViewControllers) {
        if (!vc.listVCPage || ![pagesToLoad containsObject:vc.listVCPage]) {
            [vcsToEnqueue addObject:vc];
        } else if (vc.listVCPage) {
            [pagesToLoad removeObject:vc.listVCPage];
        }
    }
    for (NewsListVC *vc in vcsToEnqueue) {
        [vc.view removeFromSuperview];
        [self.visibleViewControllers removeObject:vc];
        [self enqueueReusableViewController:vc];
    }
    for (NSNumber *page in pagesToLoad) {
        [self addViewControllerForPage:[page integerValue]];
    }
}

- (void)enqueueReusableViewController:(NewsListVC *)viewController
{
    [self.reusableViewControllers addObject:viewController];
}

- (NewsListVC *)dequeueReusableViewController
{
    NewsListVC *vc = [self.reusableViewControllers firstObject];
    if (vc) {
        [self.reusableViewControllers removeObject:vc];
    } else {
        vc = [[NewsListVC alloc]initWithChannelModels:self.channelModels];
        [vc willMoveToParentViewController:self];
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
    }
    
    return vc;
}

- (void)addViewControllerForPage:(NSInteger)page
{
    if (page < 0 || page >= self.channelModels.count) {
        return;
    }
    NewsListVC *vc = [self dequeueReusableViewController];
    vc.listVCPage = @(page);
    vc.view.frame = CGRectMake(self.newsContainerView.frame.size.width * page, 0, self.newsContainerView.frame.size.width, self.newsContainerView.frame.size.height-64);
    [self.newsContainerView addSubview:vc.view];
    [self.visibleViewControllers addObject:vc];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.newsContainerView) {
//        NSInteger page = roundf(scrollView.contentOffset.x / scrollView.frame.size.width);
        NSInteger page = floor((scrollView.contentOffset.x-scrollView.frame.size.width)/ScreenWith)+1;
        page = MAX(page, 0);
        page = MIN(page, self.channelModels.count - 1);
        [self loadPage:page];
        self.title = self.channelModels[page].channelName_cn;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
