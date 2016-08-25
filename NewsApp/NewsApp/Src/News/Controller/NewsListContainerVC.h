////
////  NewsListContainerVC.h
////  NewsApp
////
////  Created by 杨方明 on 16/4/21.
////  Copyright © 2016年 杨方明. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//
///*列表方案0（使用UICollectionView重用UIView）
// * 优点：重用，占用很少的内存
// * 缺点：各种状态的处理非常繁琐，每次还要清空重用view的缓存，而且很难或者不能实现预加载（貌似系统只重用两个view，当view的宽度等于屏幕宽的时候，这样显示当前页的时候同时加载上下页的数据变得不可行，所以还是得自己实现一套重用机制），缺点不能忍受
// */
//
///*列表方案1（不重用,一次加载完所有subViews）
// * 优点：不用处理各种状态，放心加载数据
// * 缺点：占用很大的内存，由于是视图，没有导航栏，push的时候要使用代理
// */
//
///* 列表方案2 （不重用，但子视图是视图控制器的视图，并且作为childController加到容器控制器，需要显示的时候load进内存，相对1节省了内存）
// * 优点：与1相同，作为子视图控制器加到容器视图中，拥有了导航栏，可直接push到子视图
// * 缺点：没有重用，栏目较多的时候，一样会消耗巨大的内存
// */
//@interface NewsListContainerVC : UIViewController
//
//@end
