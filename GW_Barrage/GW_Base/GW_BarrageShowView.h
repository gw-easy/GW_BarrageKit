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
@property (strong,nonatomic)UIView *lowPositionView;
@property (strong,nonatomic)UIView *middlePositionView;
@property (strong,nonatomic)UIView *highPositionView;
@property (strong,nonatomic)UIView *veryHighPositionView;
@property (strong,nonatomic)GW_BarrageBaseView *lastestBarrageView;
@property (strong,nonatomic)NSMutableDictionary *trackNextAvailableTime;
@property (assign,nonatomic)BOOL autoClear;


//正在运动的弹幕的数组.
@property (strong,nonatomic,readonly) NSMutableArray<GW_BarrageBaseView *> *animatingViewArray;
//弹幕动画执行完毕后等待复用的弹幕的数组.
@property (strong,nonatomic,readonly) NSMutableArray<GW_BarrageBaseView *> *idleViewArray;
//视图模型
@property (strong,nonatomic)GW_BarrageBaseModel *barrageModel;
//新出生的弹幕的位置
@property (assign,nonatomic) GW_BarrageShowPositionStyle showPositionStyle;
//引擎状态
@property (assign,nonatomic) GW_BarrageShowStatus showStatus;
//从缓存池或者注册的列表中返回一个view
- (nullable GW_BarrageBaseView *)dequeueReusableViewWithClass:(Class)barrageViewClass;
//发射弹幕.
- (void)beginBarrageView:(GW_BarrageBaseView *)barrageView;

@end
