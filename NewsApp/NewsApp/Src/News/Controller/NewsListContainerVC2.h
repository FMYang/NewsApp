//
//  NewsListContainerVC2.h
//  NewsApp
//
//  Created by 杨方明 on 16/4/26.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChannelBar.h"

/*列表方案4（使用UIPageViewController）--目前最优方案--
 * 优点：重用viewcontroller，占用很小的内存，子视图控制器有完整的生命周期，处理数据紊乱、保持view状态这些缺点实现起来也很优雅
 * 缺点：要处理数据紊乱、保持view状态等等
 */
@interface NewsListContainerVC2 : BaseViewController

@end
