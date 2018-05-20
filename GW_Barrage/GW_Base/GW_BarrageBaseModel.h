//
//  GW_BarrageDescription.h
//  GW_Barrage
//
//  Created by gw on 2018/5/15.
//  Copyright © 2018年 gw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import "GW_BarrageHeader.h"
@interface GW_BarrageBaseModel : NSObject
@property (nonatomic, assign, nullable) Class barrageViewClass;
@property (nonatomic, assign) GW_BarragePositionPriority positionPriority;//显示位置normal型的渲染在low型的上面, height型的渲染在normal上面
@property (nonatomic, assign) CGFloat animationDuration;

@property (nonatomic, copy, nullable) GW_BarrageTouchAction touchAction;
@property (nonatomic, strong, nullable) UIColor *borderColor; // Default is no border
@property (nonatomic, assign) CGFloat borderWidth; // Default is 0
@property (nonatomic, assign) CGFloat cornerRadius; // Default is 8

@property (nonatomic, assign) NSRange showRange;//渲染范围, 最终渲染出来的弹幕的Y坐标 showRange.location<=showRange.y<=showRange.length-barrageView.height
@end

@interface GW_BarrageTrackModel:NSObject
@property (nonatomic, assign) int trackIndex;
@property (nonatomic, copy, nullable) NSString *trackIdentifier;
@property (nonatomic, assign) CFTimeInterval nextAvailableTime;//下次可用的时间
@property (nonatomic, assign) NSInteger barrageCount;//当前行的弹幕数量
@property (nonatomic, assign) CGFloat trackHeight;//轨道高度
@end
