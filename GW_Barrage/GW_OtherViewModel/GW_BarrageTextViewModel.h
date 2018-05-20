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
@property (strong,nonatomic)NSMutableDictionary *textAttributeDict;

@property (nonatomic, strong, nullable) UIFont *textFont;
@property (nonatomic, strong, nullable) UIColor *textColor;

//字体颜色
@property (nonatomic, strong, nullable) UIColor *strokeColor;
@property (nonatomic, assign) int strokeWidth;//笔画宽度(粗细)，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果

@property (nonatomic, copy, nullable) NSString *text;
@property (nonatomic, copy, nullable) NSAttributedString *attributedText;
@end

@interface GW_BarrageTextViewModel : GW_BarrageBaseView

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong, nullable) GW_BarrageTextModel *textModel;

@end
