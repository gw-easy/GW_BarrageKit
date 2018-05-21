//
//  GW_BarrageBaseView.h
//  GW_Barrage
//
//  Created by gw on 2018/5/16.
//  Copyright © 2018年 gw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GW_BarrageBaseModel.h"
#import "CALayer+GW_Layer.h"
//代理继承CAAnimationDelegate
@protocol GW_BarrageBaseViewDelegate <NSObject, CAAnimationDelegate>

@end
@interface GW_BarrageBaseView : UIView
@property (assign, nonatomic, getter=isIdle) BOOL idle;//是否是空闲状态
@property (assign, nonatomic) NSTimeInterval idleTime;//开始闲置的时间, 闲置超过5秒的, 自动回收内存
@property (strong, nonatomic, nullable) GW_BarrageBaseModel *barrageModel;
@property (strong, nonatomic, readonly, nullable) CAAnimation *barrageAnimation;//当前view所执行的动画.
//动画速度
@property (assign, nonatomic) float speet;
//当前view所在的弹幕轨道的索引.
@property (assign, nonatomic) int trackIndex;

//可以监听动画执行完毕的事件以便将View放入缓存池等待下次复用
- (void)addBarrageAnimationWithDelegate:(nullable id <CAAnimationDelegate>)animationDelegate;
//在复用之前要进行的操作可以放在这个方法里执行
- (void)prepareForReuse;
//清空一下上次展示的遗留内容
- (void)clearContents;
//给view的各个子视图赋值
- (void)updateSubviewsData;
//计算一下子视图的的大小及位置.
- (void)layoutContentSubviews;
//将当前view内容绘制成一张图片
- (void)convertContentToImage;
- (void)sizeToFit;//设置好数据之后调用一下自动计算bounds
- (void)removeSubViewsAndSublayers;//默认删除所有的subview和sublayer; 如果需要选择性的删除可以重写这个方法.
- (void)addBorderAttributes;
@end
