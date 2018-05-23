//
//  GW_BarrageTextModel.h
//  GW_Barrage
//
//  Created by gw on 2018/5/19.
//  Copyright © 2018年 gw. All rights reserved.
//

#import "GW_BarrageBaseModel.h"
#import "GW_BarrageBaseView.h"
@interface GW_BarrageTextModel : GW_BarrageBaseModel
@property (strong,nonatomic,nullable)NSMutableDictionary *textAttributeDict;
//字体大小
@property (strong, nonatomic, nullable) UIFont *textFont;
//字体颜色
@property (strong, nonatomic, nullable) UIColor *textColor;
//背景颜色
@property (strong, nonatomic, nullable) UIColor *backColor;

//字体颜色
@property (strong, nonatomic, nullable) UIColor *strokeColor;
@property (assign, nonatomic) int strokeWidth;//笔画宽度(粗细)，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果

@property (copy, nonatomic, nullable) NSString *text;
@property (copy, nonatomic, nullable) NSAttributedString *attributedText;
@end

@interface GW_BarrageTextViewModel : GW_BarrageBaseView

@property (strong, nonatomic, nullable) UILabel *textLabel;
@property (strong, nonatomic, nullable) GW_BarrageTextModel *textModel;
@property (strong, nonatomic, nullable) CALayer *backImageLayer;
@end
