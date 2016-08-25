//
//  SouHuNewsList.m
//  NewsApp
//
//  Created by 杨方明 on 16/4/27.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import "SouHuNewsList.h"

#import "ArticleCell.h"

#import "NewsListViewStatus.h"

#import "SohuNewsDetailVC.h"

static NSString *noPicCellIdentify = @"NoPicCellIdentify";
static NSString *onePicCellIdentify = @"OnePicCellIdentify";
static NSString *threePicCellIdentify = @"ThreePicCellIdentify";
static NSString *bigPicCellIdentify = @"BigPicCellIdentify";
static NSString *videoCellIdentify = @"videoCellIdentify";

@interface SouHuNewsList() <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    NSInteger _newsPage;
}

@property (nonatomic, strong) NSMutableArray *channelModels;

@property (nonatomic, strong) ChannelModel *curChannelModel;

@property (nonatomic, strong) NewsListViewStatus *curViewStatus;

@property (nonatomic, copy) NSString *curChannelName;

@property (nonatomic, strong) NSMutableArray<NewsListViewStatus *> *viewStatus;

@property (nonatomic, strong) NSMutableArray *newsData;

@end

@implementation SouHuNewsList

#pragma mark - lazy load

- (NSMutableArray *)channelModels
{
    if(!_channelModels)
    {
        _channelModels = [NSMutableArray array];
    }
    return _channelModels;
}

- (NSMutableArray *)newsData
{
    if(!_newsData)
    {
        _newsData = [NSMutableArray array];
    }
    return _newsData;
}

- (UITableView *)newsTableView
{
    if(!_newsTableView)
    {
        _newsTableView = [[UITableView alloc]init];
        _newsTableView.backgroundColor = [UIColor clearColor];
        _newsTableView.dataSource = self;
        _newsTableView.delegate = self;
        _newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_newsTableView];
        
        MJRefreshStateHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        _newsTableView.mj_header = header;
        _newsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _newsTableView.mj_footer.automaticallyHidden = YES;
    }
    return _newsTableView;
}

- (void)setIndexNumber:(NSInteger)indexNumber
{
    _indexNumber = indexNumber;
}

#pragma mark - 电池栏样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - life cycle
- (void)dealloc
{
    DFuctionLog();
}

- (instancetype)initWithChannelModels:(NSMutableArray<ChannelModel *> *)channelModels
                      viewStatusArray:(NSMutableArray<NewsListViewStatus *> *)viewStatus
                          indexNumber:(NSInteger)indexNumber
{
    if(self = [super init])
    {
        _newsPage = 1;
        
        self.channelModels = channelModels;
        
        self.viewStatus = viewStatus;

        self.indexNumber = indexNumber;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.curChannelModel = self.channelModels[self.indexNumber];
    
    self.curChannelName = self.curChannelModel.channelName_cn;

    self.curViewStatus = self.viewStatus[self.indexNumber];
    
    [self loadListData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([self.delegate respondsToSelector:@selector(setCurrentIndex:)])
    {
        [self.delegate setCurrentIndex:self.indexNumber];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NewsListViewStatus *disapperViewStatus = self.viewStatus[self.indexNumber];
    disapperViewStatus.lastPoint = self.newsTableView.contentOffset.y;
}

#pragma mark - 数据加载相关
- (BOOL)isNeeRefreshLastUpdateTime:(NSString *)endTime curTime:(NSString *)curTime
{
    long timeSpace = [NSString getTimeIntervalSecond:endTime currentTime:curTime];
    if(timeSpace > kNewsRefreshTime*60)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSString *)getCurTimeStr
{
    return [NSString stringFromDate:[NSDate date] format:kTimeFormat];
}

//加载列表数据
- (void)loadListData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray<NewsModel *> *models = [[DATManager sharedDATManager].newsDAT getNewsByChannelName_en:self.curChannelModel.channelName_en];
        NSMutableArray<ArticleCellLayout *> *layouts = [NSMutableArray array];
        [models enumerateObjectsUsingBlock:^(NewsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ArticleCellLayout *layout = [ArticleCellLayout getLayoutByModel:obj];
            [layouts addObject:layout];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadLocalData:layouts];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self loadNetData];
            });
            
        });
    });
}


//新闻
- (void)loadLocalData:(NSMutableArray<ArticleCellLayout *> *)localData
{
    self.newsData = localData;
    [self.newsTableView reloadData];
    
    self.newsTableView.contentOffset = CGPointMake(0, self.curViewStatus.lastPoint);
}

//本地数据为空或者超时，加载网络数据
- (void)loadNetData
{
    if(self.newsData.count > 0)
    {
        ArticleCellLayout *layout = self.newsData.lastObject;
        NewsModel *model = layout.model;
        if(model.page != 0)
        {
            _newsPage = model.page+1; //下一页
        }
        
        if([self isNeeRefreshLastUpdateTime:model.updateTime curTime:[self getCurTimeStr]])
        {
            [self.newsTableView.mj_header beginRefreshing];
        }
    }
    else
    {
        [self.newsTableView.mj_header beginRefreshing];
    }
}

#pragma mark - 上下拉刷新
- (void)loadNewData
{
    _newsPage = 1;
    
    [self getNewsList];
}

- (void)loadMoreData
{
    [self getNewsList];
}


#pragma mark - UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleCellLayout *layout = self.newsData[indexPath.row];
    return layout.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleCellLayout *layout = self.newsData[indexPath.row];
    OnePicArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:onePicCellIdentify];
    if(cell == nil)
    {
        cell = [[OnePicArticleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:onePicCellIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell layoutCellWithLayout:(OnePicArticleCellLayout *)layout];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleCellLayout *layout = self.newsData[indexPath.row];
    NewsModel *newsModel = layout.model;
    
    SohuNewsDetailVC *detailVC = [[SohuNewsDetailVC alloc]init];
    detailVC.detailUrl = newsModel.newsUrl;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 获取网络数据
- (void)getNewsList
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.curChannelModel.channelName_en forKey:@"content"];
    [params setObject:IntegerNumber(_newsPage) forKey:@"page"];
    
    [[BussinessManager sharedBussinessManager].newsMannager getSouhuNewsList:params success:^(NSMutableArray<NewsModel *> *newsArr) {
        
        [self.newsTableView.mj_header endRefreshing];
        [self.newsTableView.mj_footer endRefreshing];
        
        if(newsArr && newsArr.count > 0)
        {
            if(_newsPage == 1)
            {
                self.newsData = newsArr;
                [self.newsTableView reloadData];

                self.newsTableView.mj_footer.userInteractionEnabled = YES;
            }
            else
            {
                [self.newsData addObjectsFromArray:newsArr];
                [self.newsTableView reloadData];
            }
            
            _newsPage++;
        }
        else
        {
            [self.newsTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } fail:^(NSMutableDictionary *failDic) {
        
        [self.newsTableView.mj_header endRefreshing];
        [self.newsTableView.mj_footer endRefreshing];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
