//
//  GW_BarrageHeader.h
//  GW_Barrage
//
//  Created by gw on 2018/5/15.
//  Copyright © 2018年 gw. All rights reserved.
//

#ifndef GW_BarrageHeader_h
#define GW_BarrageHeader_h

@class GW_BarrageBaseModel;
//动画key
static NSString *const GW_Barrage_Animation = @"GW_Barrage_Animation";
//点击事件
typedef void(^GW_BarrageTouchAction)(__weak GW_BarrageBaseModel *description);

//图层位置等级
typedef NS_ENUM(NSInteger, GW_BarragePositionPriority) {
    GW_BarragePositionLow = 1,
    GW_BarragePositionMiddle,
    GW_BarragePositionHigh,
    GW_BarragePositionVeryHigh
};

//view展示方式
typedef NS_ENUM(NSInteger, GW_BarrageShowPositionStyle) {//新加的View的y坐标的类型
    GW_BarrageShowPositionRandomTracks = 1, //将showView分成几条轨道, 随机选一条展示
    GW_BarrageShowPositionRandom, // y坐标随机
    GW_BarrageShowPositionIncrease, //y坐标递增, 循环
};

//view展示状态
typedef NS_ENUM(NSInteger, GW_BarrageShowStatus) {
    GW_BarrageShowStop = 1,
    GW_BarrageShowStart,
    GW_BarrageShowPause,
    GW_BarrageShowResume
};
#endif /* GW_BarrageHeader_h */
