//
//  DragCollectionView.m
//  DragCollectionViewDemo
//
//  Created by 杨方明 on 16/5/3.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import "DragCollectionView.h"

@interface DragCollectionView()

@property (nonatomic, strong) NSIndexPath *draggedCellIndexPath;
@property (nonatomic, strong) UIImageView *draggingImageView;
@property (nonatomic, assign) CGPoint touchOffsetFromCenterOfCell;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressRecognizer;
@property (nonatomic, assign, getter=isEdit) BOOL edit;

@end

@implementation DragCollectionView

- (void)setEnableLongGesture:(BOOL)enableLongGesture
{
    self.edit = enableLongGesture;
    self.longPressRecognizer.enabled = enableLongGesture;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if(self =[super initWithFrame:frame collectionViewLayout:layout])
    {
        //单击手势
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:_tapGesture];
        
        //长按手势
        _longPressRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGesture:)];
        _longPressRecognizer.minimumPressDuration = 0.2; //长按手势响应时间，默认1s
        [self addGestureRecognizer:self.longPressRecognizer];
    }
    return self;
}

//单击响应事件
- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    CGPoint touchLocation = [self.tapGesture locationInView:self];
    NSIndexPath *touchIndexPath = [self indexPathForItemAtPoint:touchLocation];
    if(touchIndexPath == nil)
    {
        return;
    }
    
    if(touchIndexPath.section == 0)
    {//顶部视图点击事件
        if(self.isEdit)
        {//编辑状态点击，调用删除代理
            if([self.gestureDelegate respondsToSelector:@selector(deleteItemAtIndexPath:)])
            {
                [self.gestureDelegate deleteItemAtIndexPath:touchIndexPath];
            }
        }
        else
        {//非编辑状态点击，调用点击选中代理
            if([self.gestureDelegate respondsToSelector:@selector(selectedItemAtIndexPath:)])
            {
                [self.gestureDelegate selectedItemAtIndexPath:touchIndexPath];
            }
        }
    }
    else if(touchIndexPath.section == 1)
    {
        if(!self.isEdit)
        {//非编辑状态，底部视图不响应单机手势 （修改为编辑和非编辑都响应单击手势）
//            return;
        }
        
        if([self.gestureDelegate respondsToSelector:@selector(addItemAtIndexPath:)])
        {//编辑状态点击底部按钮，调用添加代理
            [self.gestureDelegate addItemAtIndexPath:touchIndexPath];
        }
    }
}

//长按响应事件
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPressGesture
{
    CGPoint touchLocation = [self.longPressRecognizer locationInView:self];
    
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.draggedCellIndexPath = [self indexPathForItemAtPoint:touchLocation];
            if (self.draggedCellIndexPath != nil)
            {
                if(self.draggedCellIndexPath.section == 1)
                {//底部视图不响应长按手势
                    return;
                }
                //截取当前的cell作为拖拽对象
                UICollectionViewCell *draggedCell = [self cellForItemAtIndexPath:self.draggedCellIndexPath];
                self.draggingImageView = [[UIImageView alloc] initWithImage:[self rasterizedImageCopyOfCell:draggedCell]];
                self.draggingImageView.center = draggedCell.center;
                [self addSubview:self.draggingImageView];
                
                //隐藏原cell
                draggedCell.alpha = 0.0;
                self.touchOffsetFromCenterOfCell = CGPointMake(draggedCell.center.x - touchLocation.x, draggedCell.center.y - touchLocation.y);
                [UIView animateWithDuration:0.4 animations:^{
                    self.draggingImageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
                    self.draggingImageView.alpha = 0.8;
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            if (self.draggedCellIndexPath != nil)
            {
                self.draggingImageView.center = CGPointMake(touchLocation.x + self.touchOffsetFromCenterOfCell.x, touchLocation.y + self.touchOffsetFromCenterOfCell.y);
            }
            float pingInterval = 0.3;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(pingInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSIndexPath *newIndexPath = [self indexPathToSwapCellWithAtPreviousTouchLocation:touchLocation];
                if (newIndexPath)
                {
                    if(newIndexPath.section==0)
                    {
                        [self swapDraggedCellWithCellAtIndexPath:newIndexPath];
                    }
                }
            });
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            if (self.draggedCellIndexPath != nil )
            {
                UICollectionViewCell *draggedCell = [self cellForItemAtIndexPath:self.draggedCellIndexPath];
                UICollectionViewCell *bottomFirstCell = [self cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                [UIView animateWithDuration:0.4 animations:^{
                    self.draggingImageView.transform = CGAffineTransformIdentity;
                    self.draggingImageView.alpha = 1.0;
                    if (draggedCell != nil)
                    {
                        if(bottomFirstCell && touchLocation.y > bottomFirstCell.frame.origin.y)
                        {//,拖动超过底部栏目的时候响应单击事件
                            self.draggingImageView.center = bottomFirstCell.center;
                            draggedCell.hidden = YES;
                            
                            if([self.gestureDelegate respondsToSelector:@selector(deleteItemAtIndexPath:)])
                            {
                                [self.gestureDelegate deleteItemAtIndexPath:self.draggedCellIndexPath];
                            }
                        }
                        else
                        {
                            self.draggingImageView.center = draggedCell.center;
                        }
                    }
                } completion:^(BOOL finished) {
                    
                    [self.draggingImageView removeFromSuperview];
                    self.draggingImageView = nil;
                    
                    if (draggedCell != nil) {
                        draggedCell.alpha = 1.0;
                        draggedCell.hidden = NO;
                        self.draggedCellIndexPath = nil;
                    }
                }];
            }
            break;
        }
            
        default:
            break;
    }
}

//截图
- (UIImage *)rasterizedImageCopyOfCell:(UICollectionViewCell *)cell
{
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0.0);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

//根据移动距离返回手势停止时的indexPath
- (NSIndexPath *)indexPathToSwapCellWithAtPreviousTouchLocation:(CGPoint)previousTouchLocation
{
    CGPoint currentTouchLocation = [self.longPressRecognizer locationInView:self];
    if (!isnan(currentTouchLocation.x) && !isnan(currentTouchLocation.y))
    {
        if ([self distanceBetweenPoints:currentTouchLocation secondPoint:previousTouchLocation] < 20.0)
        {
            NSIndexPath *newIndexPath = [self indexPathForItemAtPoint:currentTouchLocation];
            return newIndexPath;
        }
    }
    return nil;
}

//计算两点之间的距离
- (CGFloat)distanceBetweenPoints:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint
{
    CGFloat xDistance = firstPoint.x - secondPoint.x;
    CGFloat yDistance = firstPoint.y - secondPoint.y;
    return sqrtf(xDistance * xDistance + yDistance * yDistance);
}

//move拖拽的cell到新的位置
- (void)swapDraggedCellWithCellAtIndexPath:(NSIndexPath *)newIndexPath
{
    [self moveItemAtIndexPath:self.draggedCellIndexPath toIndexPath:newIndexPath];
    UICollectionViewCell *draggedCell = [self cellForItemAtIndexPath:newIndexPath];
    draggedCell.alpha = 0.0;
    
    //移动cell的时候调用移动Item的代理方法
    if(self.draggedCellIndexPath.row != newIndexPath.row)
    {
    if([self.gestureDelegate respondsToSelector:@selector(moveItemFromIndexPath:toIndexPath:)])
    {
        [self.gestureDelegate moveItemFromIndexPath:self.draggedCellIndexPath toIndexPath:newIndexPath];
    }
    }
    
    self.draggedCellIndexPath = newIndexPath;

}

@end

