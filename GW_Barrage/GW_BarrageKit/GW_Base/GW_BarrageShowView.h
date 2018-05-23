//
//  GW_BarrageShowView.h
//  GW_Barrage
//
//  Created by gw on 2018/5/15.
//  Copyright © 2018年 gw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GW_BarrageBaseView.h"
#import "GW_BarrageHeader.h"
@interface GW_BarrageShowView : UIView<CAAnimationDelegate>{
    dispatch_semaphore_t _animatingViewLock;
    dispatch_semaphore_t _idleViewLock;
    dispatch_semaphore_t _trackInfoLock;
}

@property (strong, nonatomic, nullable)UIView *lowPositionView;
@property (strong, nonatomic, nullable)UIView *middlePositionView;
@property (strong, nonatomic, nullable)UIView *highPositionView;
@property (strong, nonatomic, nullable)UIView *veryHighPositionView;
@property (strong, nonatomic, nullable)GW_BarrageBaseView *lastestBarrageView;
@property (strong, nonatomic, nullable)NSMutableDictionary *trackNextAvailableTime;
@property (assign,nonatomic)BOOL autoClear;

//动画速度
@property (assign, nonatomic) float speet;

//正在运动的弹幕的数组.
@property (strong,nonatomic,nullable,readonly) NSMutableArray<GW_BarrageBaseView *> *animatingViewArray;
//弹幕动画执行完毕后等待复用的弹幕的数组.
@property (strong,nonatomic,nullable,readonly) NSMutableArray<GW_BarrageBaseView *> *idleViewArray;
//视图模型
@property (strong, nonatomic, nullable)GW_BarrageBaseModel *barrageModel;
//新出生的弹幕的位置
@property (assign,nonatomic) GW_BarrageShowPositionStyle showPositionStyle;
//引擎状态
@property (assign,nonatomic) GW_BarrageShowStatus showStatus;
//从缓存池或者注册的列表中返回一个view
- (nullable GW_BarrageBaseView *)dequeueReusableViewWithClass:(Class _Nullable )barrageViewClass;
//发射弹幕.
- (void)beginBarrageView:(GW_BarrageBaseView *_Nullable)barrageView;
//重新设置速度
- (void)reloadSpeet;

@end
