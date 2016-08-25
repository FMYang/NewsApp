////
////  NewsListVC2.m
////  NewsApp
////
////  Created by 杨方明 on 16/4/26.
////  Copyright © 2016年 杨方明. All rights reserved.
////
//
//#import "NewsListVC2.h"
//
//#import "ArticleCell.h"
//
//#import <MJRefresh/MJRefreshStateHeader.h>
//
//#import "NSString+Expand.h"
//
//#import "NewsListViewStatus.h"
//
//static NSString *noPicCellIdentify = @"NoPicCellIdentify";
//static NSString *onePicCellIdentify = @"OnePicCellIdentify";
//static NSString *threePicCellIdentify = @"ThreePicCellIdentify";
//static NSString *bigPicCellIdentify = @"BigPicCellIdentify";
//
//@interface NewsListVC2 () <UITableViewDataSource, UITableViewDelegate>
//{
//    NSInteger _newsPage;
//}
//
//@property (nonatomic, strong) NSMutableArray *channelModels;
//
//@property (nonatomic, strong) NSMutableArray<NewsListViewStatus *> *viewStatues;
//
//@property (nonatomic, strong) ChannelModel *curChannelModel;
//
//@property (nonatomic, strong) NewsListViewStatus *curViewStatus;
//
//@property (nonatomic, strong) NSMutableArray *newsData;
//
//@end
//
//@implementation NewsListVC2
//
//#pragma mark - lazy load
//
//- (NSMutableArray *)channelModels
//{
//    if(!_channelModels)
//    {
//        _channelModels = [NSMutableArray array];
//    }
//    return _channelModels;
//}
//
//- (NSMutableArray<NewsListViewStatus *> *)viewStatues
//{
//    if(!_viewStatues)
//    {
//        _viewStatues = [NSMutableArray array];
//    }
//    return _viewStatues;
//}
//
//- (NSMutableArray *)newsData
//{
//    if(!_newsData)
//    {
//        _newsData = [NSMutableArray array];
//    }
//    return _newsData;
//}
//
//- (UITableView *)newsTableView
//{
//    if(!_newsTableView)
//    {
//        _newsTableView = [[UITableView alloc]init];
//        _newsTableView.backgroundColor = [UIColor clearColor];
//        _newsTableView.dataSource = self;
//        _newsTableView.delegate = self;
//        _newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self.view addSubview:_newsTableView];
//        
//        MJRefreshStateHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//        header.lastUpdatedTimeLabel.hidden = YES;
//        _newsTableView.mj_header = header;
//        _newsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//        _newsTableView.mj_footer.automaticallyHidden = YES;
//    }
//    return _newsTableView;
//}
//
//- (void)setIndexNumber:(NSInteger)indexNumber
//{
//    _indexNumber = indexNumber;
//    
//    self.curChannelModel = self.channelModels[indexNumber];
//    
//    [self loadData];
//}
//
//#pragma mark - life cycle
//- (void)dealloc
//{
//    DFuctionLog();
//}
//
//- (instancetype)initWithChannelModels:(NSMutableArray<ChannelModel *> *)channelModels
//                          indexNumber:(NSInteger)indexNumber
//{
//    if(self = [super init])
//    {
//        _newsPage = 1;
//        
//        self.channelModels = channelModels;
//        
//        [self.channelModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NewsListViewStatus *status = [[NewsListViewStatus alloc]init];
//            [self.viewStatues addObject:status];
//        }];
//        
//        self.newsTableView.frame = CGRectMake(0, 0, self.view.width, self.view.height-64);
//        
//        self.indexNumber = indexNumber;
//
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    [self.delegate setCurrentIndex:self.indexNumber];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
////    [[URRequest sharedURRequest] cancelRequestWithOperationId:kRequestNewsListTag];
//}
//
//- (BOOL)isNeeRefreshLastUpdateTime:(NSString *)endTime curTime:(NSString *)curTime
//{
//    long timeSpace = [NSString getTimeIntervalSecond:endTime currentTime:curTime];
//    if(timeSpace > kNewsRefreshTime*60)
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}
//
//- (NSString *)getCurTimeStr
//{
//    return [NSString stringFromDate:[NSDate date] format:kTimeFormat];
//}
//
//- (void)loadData
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        NSMutableArray *newsModels = [[[DATManager sharedDATManager].articleDAT getAllByChannelID:self.curChannelModel.channelID] mutableCopy];
//        
//        NSMutableArray *layouts = [NSMutableArray array];
//        [newsModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            ArticleCellLayout *layout = [ArticleCellLayout getLayoutByModel:obj];
//            [layouts addObject:layout];
//        }];
//        
//        self.newsData = layouts;
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [self.newsTableView reloadData];
//            
//            if(self.newsData && self.newsData.count > 0)
//            {
//                NewsModel *lastModel = [newsModels lastObject];
//                if([self isNeeRefreshLastUpdateTime:lastModel.updateTime curTime:[self getCurTimeStr]])
//                {
//                    [self.newsTableView.mj_header beginRefreshing];
//                }
//            }
//            else
//            {
//                [self.newsTableView.mj_header beginRefreshing];
//            }
//        });
//    });
//}
//
//#pragma mark - UITableView代理方法
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.newsData.count;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ArticleCellLayout *layout = self.newsData[indexPath.row];
//    return layout.cellHeight;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ArticleCellLayout *layout = self.newsData[indexPath.row];
//    NewsModel *entity = layout.entity;
//    
//    if(entity.imageType == 1)
//    {
//        OnePicArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:onePicCellIdentify];
//        if(cell == nil)
//        {
//            cell = [[OnePicArticleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:onePicCellIdentify];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        
//        [cell layoutCellWithLayout:(OnePicArticleCellLayout *)layout];
//        
//        return cell;
//    }
//    else if(entity.imageType == 2)
//    {
//        ThreePicArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:threePicCellIdentify];
//        if(cell == nil)
//        {
//            cell = [[ThreePicArticleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:threePicCellIdentify];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        
//        [cell layoutCellWithLayout:(ThreePicArticleCellLayout *)layout];
//        
//        return cell;
//    }
//    else if(entity.imageType == 3)
//    {
//        BigPicArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:bigPicCellIdentify];
//        if(cell == nil)
//        {
//            cell = [[BigPicArticleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bigPicCellIdentify];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        
//        [cell layoutCellWithLayout:(BigPicArticleCellLayout *)layout];
//        
//        return cell;
//    }
//    else
//    {
//        NoPicArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:noPicCellIdentify];
//        if(cell == nil)
//        {
//            cell = [[NoPicArticleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noPicCellIdentify];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        
//        [cell layoutCellWithLayout:(NoPicArticleCellLayout *)layout];
//        
//        return cell;
//    }
//    
//}
//
//- (void)loadNewData
//{
//    _newsPage = 1;
//    [self getNewsList];
//}
//
//- (void)loadMoreData
//{
//    [self getNewsList];
//}
//
//#pragma mark - 获取网络数据
//- (void)getNewsList
//{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:self.curChannelModel.channelID forKey:@"channelID"];
//    [params setObject:[NSNumber numberWithInteger:_newsPage] forKey:@"pageNum"];
//    
//    [[BussinessManager sharedBussinessManager].newsMannager getNewsList:params success:^(NSMutableArray<NewsModel *> *newsArr) {
//        
//        [self.newsTableView.mj_header endRefreshing];
//        [self.newsTableView.mj_footer endRefreshing];
//        
//        if(newsArr.count > 0)
//        {
//            if(_newsPage == 1)
//            {
//                NSMutableArray *layouts = [NSMutableArray array];
//                [newsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    ArticleCellLayout *layout = [ArticleCellLayout getLayoutByModel:obj];
//                    [layouts addObject:layout];
//                    self.newsData = layouts;
//                    [self.newsTableView reloadData];
//                }];
//                 
//                self.newsTableView.mj_footer.userInteractionEnabled = YES;
//            }
//            else
//            {
//                NSMutableArray *layouts = [NSMutableArray array];
//                [newsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    ArticleCellLayout *layout = [ArticleCellLayout getLayoutByModel:obj];
//                    [layouts addObject:layout];
//                }];
//                
//                [self.newsData addObjectsFromArray:layouts];
//                [self.newsTableView reloadData];
//            }
//            
//            _newsPage++;
//        }
//        else
//        {
//            [self.newsTableView.mj_footer endRefreshingWithNoMoreData];
////            self.newsTableView.mj_footer.userInteractionEnabled = NO;
////            [self.newsTableView.mj_footer setState:MJRefreshStateNoMoreData];
//        }
//        
//    } fail:^(NSMutableDictionary *failDic) {
//        
//        [self.newsTableView.mj_header endRefreshing];
//        [self.newsTableView.mj_footer endRefreshing];
//        
//    }];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//}
//
//@end
