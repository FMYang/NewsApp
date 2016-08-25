////
////  NewsListContainerVC.m
////  NewsApp
////
////  Created by 杨方明 on 16/4/21.
////  Copyright © 2016年 杨方明. All rights reserved.
////
//
//#import "NewsListContainerVC.h"
//
//#import "ChannelModel.h"
//
//#import "NewsListView.h"
//
//#define kVisibleMax 3
//
//@interface NewsListContainerVC () <UIScrollViewDelegate>
//
//@property (nonatomic, strong) UIScrollView *newsContainerView;
//
//@property (nonatomic, strong) NSMutableArray *visibleViews;
//
//@property (nonatomic, strong) NSMutableArray<ChannelModel *> *channelModels;
//
//@end
//
//@implementation NewsListContainerVC
//
//- (UIScrollView *)newsContainerView
//{
//    if(!_newsContainerView)
//    {
//        _newsContainerView = [[UIScrollView alloc]init];
//        _newsContainerView.delegate = self;
//        _newsContainerView.pagingEnabled = YES;
//        [self.view addSubview:_newsContainerView];
//    }
//    return _newsContainerView;
//}
//
//- (NSMutableArray *)visibleViews
//{
//    if(!_visibleViews)
//    {
//        _visibleViews = [[NSMutableArray alloc]init];
//    }
//    return _visibleViews;
//}
//
//- (NSMutableArray<ChannelModel *> *)channelModels
//{
//    if(!_channelModels)
//    {
//        _channelModels = [[NSMutableArray alloc]init];
//    }
//    return _channelModels;
//}
//
//#pragma mark - life cycle
//
//- (instancetype)init
//{
//    if(self = [super init])
//    {
//        [self setupChannels];
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    self.title = @"新闻";
//    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    
//    [self setupSubViews];
//    
//    ChannelModel *firstModel = self.channelModels[0];
//    NewsListView *firstListView = self.visibleViews[0];
//    [firstListView reloadData:firstModel];
//}
//
//#pragma mark - 初始化
//- (void)setupChannels
//{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Channel" ofType:@"plist"];
//    NSArray *channels = [[NSArray alloc]initWithContentsOfFile:path];
//    [channels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSDictionary *dic = obj;
//        ChannelModel *model = [[ChannelModel alloc]init];
//        model.channelID = dic[@"id"];
//        model.channelName_cn = dic[@"name"];
//        [self.channelModels addObject:model];
//    }];
//    
//    [self.channelModels removeObjectAtIndex:0];
//    
//    [self.channelModels addObjectsFromArray:self.channelModels];
//}
//
//- (void)setupSubViews
//{
//    [self setupContainerView];
//}
//
//- (void)setupContainerView
//{
//    self.newsContainerView.frame = CGRectMake(0, 0, ScreenWith, self.view.height-64);
//    self.newsContainerView.contentSize = CGSizeMake(self.channelModels.count*self.view.width, self.newsContainerView.height);
//    
//    __weak NewsListContainerVC *weakSelf = self;
//    [self.channelModels enumerateObjectsUsingBlock:^(ChannelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NewsListView *subView = [[NewsListView alloc]initWithFrame:CGRectMake(idx*ScreenWith, 0, ScreenWith, self.newsContainerView.height)];
//        [weakSelf.visibleViews addObject:subView];
//        [weakSelf.newsContainerView addSubview:subView];
//    }];
//}
//
////- (void)scrollViewDidScroll:(UIScrollView *)scrollView
////{jalkfsjflksjfdlkasjldkjfsiydaligjvijlksajfdlkfjklsdfhsdkjafkljdfkjsdkjfljdkjfksjlfjalkdklsdfjjsfl
////    if(scrollView == self.newsContainerView)
////    {
////        NSInteger viewIndex = scrollView.contentOffset.x/ScreenWith;
////        NewsListView *curView = self.visibleViews[viewIndex];
////        [curView reloadData:self.channelModels[viewIndex]];
////    }
////}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if(scrollView == self.newsContainerView)
//    {
//        NSInteger viewIndex = scrollView.contentOffset.x/ScreenWith;
//        NewsListView *curView = self.visibleViews[viewIndex];
//        [curView reloadData:self.channelModels[viewIndex]];
//        self.title = self.channelModels[viewIndex].channelName_cn;
//    }
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//}
//
//@end
