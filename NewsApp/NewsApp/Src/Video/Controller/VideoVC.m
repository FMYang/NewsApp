//
//  VideoVC.m
//  NewsApp
//
//  Created by 杨方明 on 16/5/13.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import "VideoVC.h"

#import "KrVideoPlayerController.h"

#import <math.h>

static NSString *videoCellIdentify = @"videoCellIdentify";

@interface VideoVC() <UITableViewDelegate, UITableViewDataSource, VideoCellDelegate>
{
    NSInteger _newsPage;
}
@property (nonatomic, strong) KrVideoPlayerController  *videoController;

@property (nonatomic, strong) NSMutableArray<NewsListViewStatus *> *viewStatus;

@property (nonatomic, strong) NSMutableArray *newsData;

@property (nonatomic, strong) NewsListViewStatus *curViewStatus;

@property (nonatomic, assign) NSInteger curPlayRow;

@end

@implementation VideoVC

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
        
        self.viewStatus = viewStatus;
        
        self.indexNumber = indexNumber;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(self.indexNumber >= self.viewStatus.count)
    {
        self.curViewStatus = [[NewsListViewStatus alloc]init];
    }
    else
    {
        self.curViewStatus = self.viewStatus[self.indexNumber];
    }
    
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
    
    if(self.videoController)
    {
        [self.videoController dismiss];
    }
    
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
        NSArray<VideoModel *> *models = [[DATManager sharedDATManager].videoDAT getAll];
        NSMutableArray<VideoCellLayout *> *layouts = [NSMutableArray array];
        [models enumerateObjectsUsingBlock:^(VideoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            VideoCellLayout *layout = [[VideoCellLayout alloc]initWithModel:obj];
            [layouts addObject:layout];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadVideoLocalData:layouts];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self loadVideoNetData];
            });
            
        });
    });
}

//加载本地数据
- (void)loadVideoLocalData:(NSMutableArray<VideoCellLayout *> *)localData
{
    self.newsData = localData;
    
    [self.newsTableView reloadData];
    
    self.newsTableView.contentOffset = CGPointMake(0, self.curViewStatus.lastPoint);
}

//本地数据为空或者超过刷新时间，加载网络数据
- (void)loadVideoNetData
{
    if(self.newsData.count > 0)
    {
        VideoCellLayout *layout = self.newsData.lastObject;
        VideoModel *model = layout.model;
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
    VideoCellLayout *layout = self.newsData[indexPath.row];
    return layout.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCellLayout *layout = self.newsData[indexPath.row];
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCellIdentify];
    
    if(cell == nil)
    {
        cell = [[VideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoCellIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell layoutCellWithLayout:layout];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - video cell delegate
- (void)didClickPlayButtonAtIndexPath:(NSIndexPath *)indexPath
{
    self.curPlayRow = indexPath.row;
    VideoCellLayout *layout = self.newsData[indexPath.row];
    VideoModel *model = layout.model;
    NSURL *url = [NSURL URLWithString:model.mp4_url];
    [self addVideoPlayerWithURL:url];
}

#pragma mark - 上下拉刷新
- (void)loadNewData
{
    _newsPage = 1;
    
    [self getVideoList];
}

- (void)loadMoreData
{
    [self getVideoList];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.newsData && self.newsData.count > 0)
    {
        VideoCellLayout *layout = self.newsData[self.curPlayRow];
        if(self.videoController.view)
        {
            //超出屏幕停止播放
            if(layout.cellHeight*(self.curPlayRow+1) < fabs(scrollView.contentOffset.y) ||  (layout.cellHeight*self.curPlayRow+1) > fabs(scrollView.contentOffset.y) + (ScreenHeight-64))
            {
                [self.videoController dismiss];
            }
        }
    }
}

#pragma mark - 加载网络数据
- (void)getVideoList
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:IntegerNumber(_newsPage) forKey:@"page"];
    
    [[BussinessManager sharedBussinessManager].newsMannager getVideoNewsList:params success:^(NSMutableArray<VideoCellLayout *> *videoNewsArr) {
        
        if(self.videoController)
        {
            [self.videoController dismiss];
        }
        
        [self.newsTableView.mj_header endRefreshing];
        [self.newsTableView.mj_footer endRefreshing];
        
        if(videoNewsArr && videoNewsArr.count > 0)
        {
            if(_newsPage == 1)
            {
                self.newsData = videoNewsArr;
                [self.newsTableView reloadData];
                
                self.newsTableView.mj_footer.userInteractionEnabled = YES;
            }
            else
            {
                [self.newsData addObjectsFromArray:videoNewsArr];
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

#pragma mark - 视频播放
- (void)addVideoPlayerWithURL:(NSURL *)url
{
    VideoCellLayout *layout = self.newsData[self.curPlayRow];
    
    VideoCell *cell = [self.newsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.curPlayRow inSection:0]];
    
    [self.videoController resetControl];

    if(!self.videoController)
    {
        self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, layout.videoImageWidth, layout.videoImageHeight)];
        __weak typeof(self)weakSelf = self;
        [self.videoController setPlayCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
        [self.videoController setWillBackOrientationPortrait:^{
            [weakSelf toolbarHidden:NO];
        }];
        [self.videoController setWillChangeToFullscreenMode:^{
            [weakSelf toolbarHidden:YES];
        }];
    }
    
    [self.videoController showInView:cell];
    self.videoController.titleText = layout.model.title;
    self.videoController.contentURL = url;
    
}

//隐藏navigation tabbar 电池栏
- (void)toolbarHidden:(BOOL)Bool{
//    self.navigationController.navigationBar.hidden = Bool;
//    self.tabBarController.tabBar.hidden = Bool;
    [[UIApplication sharedApplication] setStatusBarHidden:Bool withAnimation:UIStatusBarAnimationFade];
}

@end
