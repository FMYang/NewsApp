//
//  ArticleCellLayout.h
//  UrunNews
//
//  Created by 杨方明 on 16/4/1.
//  Copyright © 2016年 URUN. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NewsModel.h"

#define kPaddingLeft 10

#ifndef kPaddingTop
#define kPaddingTop 10
#endif

#ifndef kPaddingRight
#define kPaddingRight 10
#endif

#ifndef kPaddingBottom
#define kPaddingBottom 10
#endif

#ifndef kSpaceWidth
#define kSpaceWidth 8
#endif

#ifndef kSpaceHeight
#define kSpaceHeight 8
#endif

#ifndef kBottomTagHeight
#define kBottomTagHeight 20
#endif

#ifndef kOnePicWidth
#define kOnePicWidth ((ScreenWith-2*kPaddingLeft)/3)
#endif

#ifndef kOnePicHeight
#define kOnePicHeight (11*kOnePicWidth/15)
#endif

#ifndef kThreeImageSpace
#define kThreeImageSpace 5
#endif

#ifndef kThreePicWidth
#define kThreePicWidth ((ScreenWith-2*kThreeImageSpace-20)/3)
#endif

#ifndef kThreePicHeight
#define kThreePicHeight (11*kThreePicWidth/15)
#endif

#ifndef kBigPickWidth
#define kBigPickWidth (ScreenWith-20)
#endif

#ifndef kBigPickHeight
#define kBigPickHeight 200
#endif

#ifndef kTitleWidth
#define kTitleWidth (ScreenWith-20)
#endif

#ifndef kOnePicTitleWidth
#define kOnePicTitleWidth (ScreenWith-20-2*kSpaceWidth-kOnePicWidth)
#endif

#ifndef kBottomTagFont
#define kBottomTagFont [UIFont systemFontOfSize:12]
#endif

#ifndef kCommentNumWidth
#define kCommentNumWidth 25
#endif

@interface ArticleCellLayout : NSObject

@property (nonatomic, strong) NewsModel *model;

@property (nonatomic, assign) float titleHeight;

@property (nonatomic, assign) float cellHeight;

@property (nonatomic, assign) float commentLabelWidth;

- (instancetype)initWithNewsModel:(NewsModel *)model;

- (void)layout;

+ (ArticleCellLayout *)getLayoutByModel:(NewsModel *)model;

@end

/*********** 一张图cell布局对象 ***********/
@interface OnePicArticleCellLayout : ArticleCellLayout

@end
