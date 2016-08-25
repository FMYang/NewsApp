//
//  NewsListContainerVC1.h
//  NewsApp
//
//  Created by 杨方明 on 16/4/25.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import <UIKit/UIKit.h>

/*列表方案3（重用UIViewController）--优化方案--
 * 优点：占用较小的内存，消耗io
 * 缺点：要处理数据加载紊乱、保持tableview的滑动结束的位置等等，要配合数据库使用，用起来也是非常繁琐的一套流程，这套与UICollectionView相似，但可以自定义重用的view的个数
 */
@interface NewsListContainerVC1 : UIViewController

@end
