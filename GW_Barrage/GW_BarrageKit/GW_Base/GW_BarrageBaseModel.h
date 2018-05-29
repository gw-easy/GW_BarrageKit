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
@property (assign, nonatomic, nullable) Class barrageViewClass;
@property (assign, nonatomic) GW_BarragePositionPriority positionPriority;//显示位置normal型的渲染在low型的上面, height型的渲染在normal上面
@property (assign, nonatomic) CGFloat animationDuration;

@property (copy, nonatomic, nullable) GW_BarrageTouchAction touchAction;
@property (strong, nonatomic, nullable) UIColor *borderColor; // Default is no border
@property (assign, nonatomic) CGFloat borderWidth; // Default is 0
@property (assign, nonatomic) CGFloat cornerRadius; // Default is 8
@property (assign, nonatomic) CGRect backImageRect;//背景图片大小
@property (assign, nonatomic) CGFloat textToBackImageOffSet;//字体和背景图片中心点的偏移量
@property (assign, nonatomic) NSRange showRange;//渲染范围, 最终渲染出来的弹幕的Y坐标 showRange.location<=showRange.y<=showRange.length-barrageView.height
//背景图片
@property (strong, nonatomic, nullable) UIImage *backImage;
@end

@interface GW_BarrageTrackModel:NSObject
@property (assign, nonatomic) int trackIndex;
@property (copy, nonatomic, nullable) NSString *trackIdentifier;
@property (assign, nonatomic) CFTimeInterval nextAvailableTime;//下次可用的时间
@property (assign, nonatomic) NSInteger barrageCount;//当前行的弹幕数量
@property (assign, nonatomic) CGFloat trackHeight;//轨道高度
@end
