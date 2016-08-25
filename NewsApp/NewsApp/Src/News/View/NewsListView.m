////
////  NewsListView.m
////  NewsApp
////
////  Created by 杨方明 on 16/4/20.
////  Copyright © 2016年 杨方明. All rights reserved.
////
//
//#import "NewsListView.h"
//
//#import "ArticleCell.h"
//
//#import <MJRefresh/MJRefreshStateHeader.h>
//
//static NSString *noPicCellIdentify = @"NoPicCellIdentify";
//static NSString *onePicCellIdentify = @"OnePicCellIdentify";
//static NSString *threePicCellIdentify = @"ThreePicCellIdentify";
//static NSString *bigPicCellIdentify = @"BigPicCellIdentify";
//
//
//@interface NewsListView() <UITableViewDataSource, UITableViewDelegate>
//{
//    NSIndexPath *_indexPath;
//    NSInteger _page;
//}
//@property (nonatomic, strong) UITableView *newsTableView;
//
//@property (nonatomic, strong) NSMutableArray *newsData;
//
//@end
//
//@implementation NewsListView
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if(self = [super initWithFrame:frame])
//    {
//        _page = 1;
//        
//        self.newsTableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//    }
//    return self;
//}
//
//#pragma mark - lazy load
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
//        [self.contentView addSubview:_newsTableView];
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
//#pragma mark - 布局子视图
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//}
//
//#pragma mark - 加载数据
//- (void)reloadData:(ChannelModel *)model
//{
//    self.channelModel = model;
//    
//    [self.newsTableView reloadData];
//    
//    if(_page == 1)
//    {
//        [self.newsTableView.mj_header beginRefreshing];
//    }
//}
//
//- (void)reloadData:(ChannelModel *)model
//           layouts:(NSMutableArray<ArticleCellLayout *> *)layouts
//{
//    self.newsData = layouts;
//    
//    [self.newsTableView reloadData];
//}
//
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
//    _page = 1;
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
//    [params setObject:self.channelModel.channelID forKey:@"channelID"];
//    [params setObject:[NSNumber numberWithInteger:_page] forKey:@"pageNum"];
//    
//    [[BussinessManager sharedBussinessManager].newsMannager getNewsList:params success:^(NSMutableArray<NewsModel *> *newsArr) {
//        
//        if(newsArr.count > 0)
//        {
//            [self.newsTableView.mj_footer setState:MJRefreshStateIdle];
//
//            if(_page == 1)
//            {
//                self.newsData = newsArr;
//                [self.newsTableView.mj_header endRefreshing];
//                self.newsTableView.mj_footer.userInteractionEnabled = YES;
//            }
//            else
//            {
//                [self.newsData addObjectsFromArray:newsArr];
//                [self.newsTableView.mj_footer endRefreshing];
//            }
//            
//            [self.newsTableView reloadData];
//            
//            _page++;
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
//@end
