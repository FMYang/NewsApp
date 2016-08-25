//
//  ChannelList.m
//  NewsApp
//
//  Created by 杨方明 on 16/4/30.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import "ChannelList.h"

#import "ItemCell.h"

#import "ChannelHeadView.h"

#import "DragCollectionView.h"

#define kItemSpace 5 //设置cell的间距

#define kItemWidth (ScreenWith-40-8*kItemSpace)/4

#define kItemHeight 30

static NSString *cellIdentify = @"itemCell";
static NSString *headerCellIdentify = @"headerCell";
static NSString *footerCellIdentify = @"footerCell";

@interface ChannelList() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DragCollectionViewDelegate>
{
    UILabel *_placeholderLabel;
}

@property (nonatomic, strong) DragCollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UIView *navView;

@property (nonatomic, assign, getter=isEdit) BOOL edit;

@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (nonatomic, strong) UIButton *editBtn;

@end

@implementation ChannelList

#pragma mark - lazy load
- (NSMutableArray<ChannelModel *> *)topChannelModels
{
    if(!_topChannelModels)
    {
        _topChannelModels = [NSMutableArray array];
    }
    return _topChannelModels;
}

- (NSMutableArray<ChannelModel *> *)bottomChannelModels
{
    if(!_bottomChannelModels)
    {
        _bottomChannelModels = [NSMutableArray array];
    }
    return _bottomChannelModels;
}

- (UILabel *)placeHolderLabel
{
    if(!_placeHolderLabel)
    {
        _placeHolderLabel = [[UILabel alloc]init];
        _placeHolderLabel.hidden = YES;
    }
    return _placeHolderLabel;
}

- (UIButton *)editBtn
{
    if(!_editBtn)
    {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        _editBtn.layer.borderColor = [UIColor redColor].CGColor;
        _editBtn.layer.borderWidth = 0.5;
        _editBtn.layer.cornerRadius = 8;
        [_editBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _editBtn;
}

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor backgoundLightGrayColor];
        
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, ScreenWith, NavHeight)];
        _navView.backgroundColor = [UIColor backgoundLightGrayColor];
        [self addSubview:_navView];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(ScreenWith-50, 0, 50, NavHeight);
        [closeBtn setImage:[UIImage imageNamed:@"icon_channel_close"] forState:UIControlStateNormal];
        [closeBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 13, 10, 13)];
        [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:closeBtn];
        
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.itemSize = CGSizeMake(kItemWidth, kItemHeight);
        _flowLayout.minimumLineSpacing = kItemSpace;
        _flowLayout.minimumInteritemSpacing = kItemSpace;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[DragCollectionView alloc]initWithFrame:CGRectMake(0, _navView.y+_navView.height, ScreenWith, ScreenHeight-StatusBarHeight-_navView.height) collectionViewLayout:_flowLayout];
        _collectionView.gestureDelegate = self;
        _collectionView.backgroundColor = [UIColor backgoundLightGrayColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[ItemCell class] forCellWithReuseIdentifier:cellIdentify];
        [_collectionView registerClass:[ChannelHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerCellIdentify];
        [_collectionView registerClass:[ChannelHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerCellIdentify];
        [self addSubview:_collectionView];

    }
    return self;
}

#pragma mark - collection datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return self.topChannelModels.count;
    }
    return self.bottomChannelModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentify forIndexPath:indexPath];

    if(indexPath.section == 0)
    {
        ChannelModel *model = self.topChannelModels[indexPath.row];
        cell.itemLabel.text = model.channelName_cn;
        cell.deleteImgView.hidden = !self.isEdit;
        if(indexPath.row == self.selectedIndex)
        {
            cell.itemLabel.textColor = [UIColor redColor];
        }
        else
        {
            cell.itemLabel.textColor = [UIColor blackColor];
        }
    }
    else
    {
        ChannelModel *model = self.bottomChannelModels[indexPath.row];
        cell.itemLabel.text = model.channelName_cn;
        cell.deleteImgView.hidden = YES;
        cell.itemLabel.textColor = [UIColor blackColor];
    }
    
    if(self.isEdit)
    {
        cell.itemLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reuseView = nil;
    if(kind == UICollectionElementKindSectionHeader)
    {
        ChannelHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerCellIdentify forIndexPath:indexPath];
        if(indexPath.section == 0)
        {
            headView.headLabel.text = @"我的频道";
            [headView.headLabel sizeToFit];
            
            self.placeHolderLabel.frame = CGRectMake(headView.headLabel.x+headView.headLabel.width+20, 0, 100, 20);
            self.placeHolderLabel.text = @"拖拽可以排序";
            self.placeHolderLabel.textColor = [UIColor darkGrayColor];
            self.placeHolderLabel.font = [UIFont systemFontOfSize:10];
            [headView addSubview:self.placeHolderLabel];
            
            self.editBtn.frame = CGRectMake(headView.frame.size.width-70, 0, 50, 20);
            [headView addSubview:self.editBtn];
        }
        else
        {
            headView.headLabel.text = @"频道推荐";
        }
        reuseView = headView;
    }
    else
    {
        ChannelHeadView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerCellIdentify forIndexPath:indexPath];
        reuseView = footView;
    }
    
    
    return reuseView;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{//纵向间距
    return kItemSpace*2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{//横向间距
    return kItemSpace;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{//页眉size
    return CGSizeMake(ScreenWith-40, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{//页脚size
    return CGSizeMake(ScreenWith-40, 20);
}

#pragma mark - gesture delegate 响应手势代理，修改数据源，处理选中的栏目（如果删除的是选中的栏目，默认选择第一个栏目）
- (void)selectedItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(didSelectedItemAtIndexPath:)])
    {
        [self.delegate didSelectedItemAtIndexPath:indexPath];
    }
    
    [self dismiss];
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCell *cell = (ItemCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.deleteImgView.hidden = YES; //顶部视图移动前，显示删除按钮
    
    //修改数据源
    [self.bottomChannelModels insertObject:self.topChannelModels[indexPath.row] atIndex:0];
    [self.topChannelModels removeObjectAtIndex:indexPath.row];
    
    NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_collectionView moveItemAtIndexPath:indexPath toIndexPath:toIndexPath];
    
    //修改选中栏目的下标
    [self changeSelectedIndex];
    
    if([self.delegate respondsToSelector:@selector(didItemChangedTopChannelModels:bottomChannelModels:selectedIndex:)])
    {
        [self.delegate didItemChangedTopChannelModels:self.topChannelModels bottomChannelModels:self.bottomChannelModels selectedIndex:self.selectedIndex];
    }
}

- (void)addItemAtIndexPath:(NSIndexPath *)indexPath
{
    //底部视图移动前隐藏删除按钮
    ItemCell *cell = (ItemCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.deleteImgView.hidden = !self.edit;
    
    //修改数据源
    [self.topChannelModels addObject:self.bottomChannelModels[indexPath.row]];
    [self.bottomChannelModels removeObjectAtIndex:indexPath.row];
    
    NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:self.topChannelModels.count-1 inSection:0];
    [_collectionView moveItemAtIndexPath:indexPath toIndexPath:toIndexPath];
    
    [self changeSelectedIndex];
    
    if([self.delegate respondsToSelector:@selector(didItemChangedTopChannelModels:bottomChannelModels:selectedIndex:)])
    {
        [self.delegate didItemChangedTopChannelModels:self.topChannelModels bottomChannelModels:self.bottomChannelModels selectedIndex:self.selectedIndex];
    }
}

- (void)moveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)indexPath
{
    //修改数据源
    ChannelModel *moveModel = self.topChannelModels[fromIndexPath.row];
    [self.topChannelModels removeObject:moveModel];
    [self.topChannelModels insertObject:moveModel atIndex:indexPath.row];
    
    //修改选中栏目的下标
    [self changeSelectedIndex];
    
    if([self.delegate respondsToSelector:@selector(didItemChangedTopChannelModels:bottomChannelModels:selectedIndex:)])
    {
        [self.delegate didItemChangedTopChannelModels:self.topChannelModels bottomChannelModels:self.bottomChannelModels selectedIndex:self.selectedIndex];
    }
}

- (void)changeSelectedIndex
{//根据栏目名来获取下标
    self.selectedIndex = 0;
    for(int i=0; i<self.topChannelModels.count; i++)
    {
        ChannelModel *model = self.topChannelModels[i];
        if([model.channelName_cn isEqualToString:self.selectedChannelName])
        {
            self.selectedIndex = i;
            break;
        }
    }

    if([self.delegate respondsToSelector:@selector(didSelectedItemAtIndexPath:)])
    {
        [self.delegate didSelectedItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
    }

}

#pragma mark - 编辑按钮点击
- (void)editBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    self.edit = btn.selected;
    self.collectionView.enableLongGesture = btn.selected;
    self.placeHolderLabel.hidden = !btn.selected;

    if(btn.selected)
    {
        [btn setTitle:@"完成" forState:UIControlStateNormal];
    }
    else
    {
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    
    [self.collectionView reloadData];
    

}

#pragma mark - show or dismiss
- (void)close
{
    [self dismiss];
}

- (void)show
{
    if([self.delegate respondsToSelector:@selector(channelListViewDidShow)])
    {
        [self.delegate channelListViewDidShow];
    }
    
    self.collectionView.enableLongGesture = NO;
    self.frame = CGRectMake(0, 0, ScreenWith, ScreenHeight);
    [KWindow addSubview:self];
    
    self.alpha = 0.0;
    [UIView animateWithDuration:0.15 animations:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        self.alpha = 1.0;
    }];
}

- (void)dismiss
{
    self.alpha = 1.0;
    [UIView animateWithDuration:0.15 animations:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if(finished)
        {
            if([self.delegate respondsToSelector:@selector(channelListViewDidDissmiss)])
            {
                [self.delegate channelListViewDidDissmiss];
            }
            
            [self removeFromSuperview];
        }
    }];
}

@end
