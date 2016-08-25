//
//  DragCollectionView.h
//  NewsApp
//
//  Created by 杨方明 on 16/5/3.
//  Copyright © 2016年 杨方明. All rights reserved.
//
//  可拖拽cell排序的collectionView

#import <UIKit/UIKit.h>

@protocol DragCollectionViewDelegate;

@interface DragCollectionView : UICollectionView

//是否启用长按手势
@property (nonatomic, assign) BOOL enableLongGesture;

//手势代理
@property (nonatomic, weak) id<DragCollectionViewDelegate> gestureDelegate;

@end

@protocol DragCollectionViewDelegate <NSObject>

@optional

//选中item
- (void)selectedItemAtIndexPath:(NSIndexPath *)indexPath;

//删除item
- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath;

//添加item
- (void)addItemAtIndexPath:(NSIndexPath *)indexPath;

//移动item
- (void)moveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)indexPath;

@end

