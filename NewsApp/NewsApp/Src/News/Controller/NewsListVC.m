////
////  NewsListVC.m
////  NewsApp
////
////  Created by 杨方明 on 16/4/25.
////  Copyright © 2016年 杨方明. All rights reserved.
////
//
//#import "NewsListVC.h"
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
//@interface NewsListVC () <UITableViewDataSource, UITableViewDelegate>
//{
//    NSInteger _newsPage;
//}
//
//@property (nonatomic, strong) UITableView *newsTableView;
//
//@property (nonatomic, strong) NSMutableArray *newsData;
//
//@property (nonatomic, strong) NSMutableArray *channelModels;
//
//@property (nonatomic, strong) NSMutableArray<NewsListViewStatus *> *viewStatues;
//
//@property (nonatomic, strong) ChannelModel *curChannelModel;
//
//@property (nonatomic, strong) NewsListViewStatus *curViewStatus;
//
//@end
//
//@implementation NewsListVC
//
//- (instancetype)initWithChannelModels:(NSMutableArray<ChannelModel *> *)channelModels
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
//    }
//    return self;
//}
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
//#pragma mark - 加载数据
//- (void)setListVCPage:(NSNumber *)listVCPage
//{
//    if(_listVCPage != listVCPage)
//    {
//        _listVCPage = listVCPage;
//        self.curChannelModel = self.channelModels[[listVCPage integerValue]];
//        self.curViewStatus = self.viewStatues[[listVCPage integerValue]];
//        [self loadData];
//    }
//}
//
//- (void)loadData
//{
////    [[URRequest sharedURRequest] cancelRequestWithOperationId:kRequestNewsListTag];
////
////    [self clearCache];
////
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
//            self.newsTableView.contentOffset = CGPointMake(0, self.curViewStatus.lastPoint);
//            
//            [self reloadData];
//
//            if(self.newsData && self.newsData.count > 0)
//            {
//                NewsModel *lastModel = [newsModels lastObject];
//                if([self isNeeRefreshLastUpdateTime:lastModel.updateTime curTime:[self getCurTimeStr]])
//                {
//                    _listVCPage = IntegerNumber(lastModel.page);
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
//- (void)reloadData
//{
//    NSLog(@"%@,%s", _listVCPage, __func__);
//    [self.newsTableView reloadData];
//}
//
//- (void)clearCache
//{
//    [self.newsData removeAllObjects];
////    [self reloadData];
//}
//
//#pragma mark - life cycle
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//        
//    NewsListViewStatus *statues = self.viewStatues[[_listVCPage integerValue]];
//    statues.lastPoint = self.newsTableView.contentOffset.y;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
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
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self getNewsList];
//    });
//    
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
//        NSString *channelID =  params[@"channelID"];
//        if(newsArr.count > 0)
//        {
//            [self.newsTableView.mj_footer setState:MJRefreshStateIdle];
//            
//            if(_newsPage == 1)
//            {
//                if([channelID isEqualToString:self.curChannelModel.channelID])
//                {
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                        NSArray *newsModels = [[DATManager sharedDATManager].articleDAT getAllByChannelID:self.curChannelModel.channelID];
//                        NSMutableArray *layouts = [NSMutableArray array];
//                        [newsModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                            ArticleCellLayout *layout = [ArticleCellLayout getLayoutByModel:obj];
//                            [layouts addObject:layout];
//                        }];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            self.newsData = layouts;
//                            [self reloadData];
//
//                        });
//                    });
//    //                self.newsData = newsArr;
//                }
//                [self.newsTableView.mj_header endRefreshing];
//                self.newsTableView.mj_footer.userInteractionEnabled = YES;
//            }
//            else
//            {
//                if([channelID isEqualToString:self.curChannelModel.channelID])
//                {
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                        NSArray *newsModels = [[DATManager sharedDATManager].articleDAT getAllByChannelID:self.curChannelModel.channelID];
//                        NSMutableArray *layouts = [NSMutableArray array];
//                        [newsModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                            ArticleCellLayout *layout = [ArticleCellLayout getLayoutByModel:obj];
//                            [layouts addObject:layout];
//                        }];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [self.newsData addObjectsFromArray:layouts];
//                            [self reloadData];
//
//                        });
//                    });
//                }
//                [self.newsTableView.mj_footer endRefreshing];
//            }
//            
//            
//            _newsPage++;
//        }
//        else
//        {
//            [self.newsTableView.mj_footer endRefreshing];
//            self.newsTableView.mj_footer.userInteractionEnabled = NO;
//            [self.newsTableView.mj_footer setState:MJRefreshStateNoMoreData];
//        }
//        
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
//
//@end
