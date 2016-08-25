//
//  NewsListContainerVC2.m
//  NewsApp
//
//  Created by 杨方明 on 16/4/26.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import "NewsListContainerVC2.h"

#import "ChannelList.h"

#import "SouHuNewsList.h"

#import "ChannelModel.h"

#import "NewsListViewStatus.h"

#import "VideoVC.h"

@interface NewsListContainerVC2 () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, NewsListContainerVC2Delegate, UIScrollViewDelegate, VideoVCDelegate>
{
    NSArray *namearray;
    NSArray *contentarray;
}

/*左右滚动的容器视图控制器*/
@property (nonatomic, strong) UIPageViewController *pageContainerVC;

/*当前选择的栏目*/
@property (nonatomic, assign) __block NSInteger currentIndex;

/*当前栏目名*/
@property (nonatomic, copy) NSString *currentChannelName;

/*栏目列表的顶部栏目数据源*/
@property (nonatomic, strong) NSMutableArray<ChannelModel *> *channelModels;

/*栏目列表的底部栏目数据源*/
@property (nonatomic, strong) NSMutableArray<ChannelModel *> *bottomChannelModels;

/*记录每个页面消失的时候tableview的contentoff.y*/
@property (nonatomic, strong) NSMutableArray<NewsListViewStatus *> *viewStatusArray;

/*顶部栏目视图*/
@property (nonatomic, strong) ChannelBar *channelBar;

@end

@implementation NewsListContainerVC2

#pragma mark - lazy load
- (NSMutableArray<ChannelModel *> *)channelModels
{
    if(!_channelModels)
    {
        _channelModels = [[NSMutableArray alloc]init];
    }
    return _channelModels;
}

- (NSMutableArray<ChannelModel *> *)bottomChannelModels
{
    if(!_bottomChannelModels)
    {
        _bottomChannelModels = [[NSMutableArray alloc]init];
    }
    return _bottomChannelModels;
}

- (NSMutableArray<NewsListViewStatus *> *)viewStatusArray
{
    if(!_viewStatusArray)
    {
        _viewStatusArray = [[NSMutableArray alloc]init];
    }
    return _viewStatusArray;
}

- (ChannelBar *)channelBar
{
    if(!_channelBar)
    {
        _channelBar = [[ChannelBar alloc]init];
        _channelBar.frame = CGRectMake(0, 64, ScreenWith, kBarHeight);
        [self.view addSubview:_channelBar];
    }
    return _channelBar;
}

- (BOOL)showBackButton
{
    return NO;
}

#pragma mark - life cycle
- (instancetype)init
{
    if(self = [super init])
    {
        self.currentIndex = 0;
        
        //搜狐新闻api数据源
        namearray = @[@"视频",@"国内",@"国际",@"娱乐",@"体育",@"科技",@"奇闻趣事",@"生活健康"];
        contentarray = @[@"video",@"guonei",@"world",@"huabian",@"tiyu",@"keji",@"qiwen",@"health"];

        NSMutableArray *bottomNameArray = [@[@"国内",@"国际",@"娱乐",@"体育",@"科技",@"奇闻趣事趣事",@"生活健康",@"国内",@"国际",@"娱乐",@"体育",@"科技",@"奇闻趣事",@"生活健康"] mutableCopy];
        NSMutableArray *bottomContentArray = [@[@"guonei",@"world",@"huabian",@"tiyu",@"keji",@"qiwen",@"health",@"guonei",@"world",@"huabian",@"tiyu",@"keji",@"qiwen",@"health"] mutableCopy];
        
        __weak NewsListContainerVC2 *weakSelf = self;
        [contentarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ChannelModel *model = [[ChannelModel alloc]init];
            model.channelName_en = obj;
            model.channelName_cn = namearray[idx];
            [weakSelf.channelModels addObject:model];
            
            NewsListViewStatus *viewStatus = [[NewsListViewStatus alloc]init];
            [weakSelf.viewStatusArray addObject:viewStatus];
        }];
        
        [bottomContentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ChannelModel *model = [[ChannelModel alloc]init];
            model.channelName_en = obj;
            model.channelName_cn = bottomNameArray[idx];
            [weakSelf.bottomChannelModels addObject:model];
        }];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.customNav.backgroundColor = [UIColor navRedColor];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navTitle = @"搜狐新闻";
    
    [self setupChanelBar];
    
    [self setupPageContainer];
}

#pragma mark - set init data/view

- (void)setupChanelBar
{
    self.channelBar.topChannelModels = self.channelModels;
    self.channelBar.bottomChannelModels = self.bottomChannelModels;
    
    __weak NewsListContainerVC2 *weakSelf = self;
    //栏目选中回调
    self.channelBar.itemClickBlock = ^ (NSInteger selectedIndex){
        
        _currentIndex = selectedIndex;
        UIViewController *vcObject;
        if([[weakSelf getCurrentChannelNameAtIndex:selectedIndex] isEqualToString:@"视频"])
        {
            vcObject = [weakSelf videoControllerAtIndex:selectedIndex];
        }
        else
        {
            vcObject = [weakSelf viewControllerAtIndex:selectedIndex];
        }
        
        [weakSelf.pageContainerVC setViewControllers:@[vcObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
    };
    
    //栏目修改回调
    self.channelBar.itemChangeBlock = ^(NSMutableArray<ChannelModel *> *topChannelModels,NSMutableArray<ChannelModel *> *bottomChannelModels, NSInteger selectedIndex) {
        
        [weakSelf.viewStatusArray removeAllObjects];
        weakSelf.channelModels = topChannelModels;
        weakSelf.bottomChannelModels = bottomChannelModels;
        weakSelf.currentIndex = selectedIndex;
        
        for(int i=0; i<topChannelModels.count; i++)
        {
            NewsListViewStatus *viewStatus = [[NewsListViewStatus alloc]init];
            [weakSelf.viewStatusArray addObject:viewStatus];
        }
    };

    
    [self.channelBar setSelectedIndex:0];
}

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

- (void)setupPageContainer
{
    if(!_pageContainerVC)
    {
        _pageContainerVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageContainerVC.dataSource = self;
        _pageContainerVC.delegate = self;
        _pageContainerVC.view.backgroundColor = [UIColor clearColor];
        [_pageContainerVC.view setFrame:CGRectMake(0, self.channelBar.y+self.channelBar.height, ScreenWith, ScreenHeight-kBarHeight-64)];
        [self.view addSubview:_pageContainerVC.view];
    }
    
    UIViewController *vcObject;
    if([[self getCurrentChannelNameAtIndex:0] isEqualToString:@"视频"])
    {
        vcObject = [self videoControllerAtIndex:0];
    }
    else
    {
        vcObject = [self viewControllerAtIndex:0];
    }
    
    [_pageContainerVC setViewControllers:@[vcObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:_pageContainerVC];
    [self.view addSubview:_pageContainerVC.view];
    [_pageContainerVC didMoveToParentViewController:self];
    
    UIScrollView *pageScrollView = self.pageContainerVC.view.subviews[0];
    pageScrollView.delegate = self;
}

#pragma mark - get willAppear vc
//普通新闻
-(SouHuNewsList *)viewControllerAtIndex:(NSUInteger)index
{
    SouHuNewsList *childVC = [[SouHuNewsList alloc]initWithChannelModels:self.channelModels viewStatusArray:self.viewStatusArray  indexNumber:index];
    childVC.newsTableView.frame = CGRectMake(0, 0, ScreenWith, ScreenHeight-64-kBarHeight);
    childVC.delegate = self;

    return childVC;
}

//视频新闻
- (VideoVC *)videoControllerAtIndex:(NSUInteger)index
{
    VideoVC *childVC = [[VideoVC alloc]initWithChannelModels:self.channelModels viewStatusArray:self.viewStatusArray  indexNumber:index];
    childVC.newsTableView.frame = CGRectMake(0, 0, ScreenWith, ScreenHeight-64-kBarHeight);
    childVC.delegate = self;
    
    return childVC;
}


#pragma mark - chird delegate
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
}

- (NSString *)getCurrentChannelNameAtIndex:(NSInteger)index
{
    ChannelModel *model = self.channelModels[index];
    return model.channelName_cn;
}

#pragma mark - PageView Datasource
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(SouHuNewsList *)viewController indexNumber];
    
    if(index == NSNotFound || index == 0)
    {
        return nil;
    }

    index--;
    
    if([[self getCurrentChannelNameAtIndex:index] isEqualToString:@"视频"])
    {
        VideoVC *vc = [self videoControllerAtIndex:index];
        return vc;
    }
    
    SouHuNewsList *vc = [self viewControllerAtIndex:index];

    return vc;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(SouHuNewsList *)viewController indexNumber];

    if(index == NSNotFound || index == self.channelModels.count-1)
    {
        return nil;
    }
    
    index++;
    
    if([[self getCurrentChannelNameAtIndex:index] isEqualToString:@"视频"])
    {
        VideoVC *vc = [self videoControllerAtIndex:index];
        return vc;
    }
    
    SouHuNewsList *vc = [self viewControllerAtIndex:index];

    return vc;
}

#pragma mark - PageView Delegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    SouHuNewsList *vc = (SouHuNewsList *)pendingViewControllers[0];
    vc.newsTableView.scrollsToTop = YES;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    SouHuNewsList *vc = (SouHuNewsList *)previousViewControllers[0];
    vc.newsTableView.scrollsToTop = NO;
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.channelBar setSelectedIndex:self.currentIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
