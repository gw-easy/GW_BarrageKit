//
//  GW_BarrageBaseView.m
//  GW_Barrage
//
//  Created by gw on 2018/5/16.
//  Copyright © 2018年 gw. All rights reserved.
//

#import "GW_BarrageBaseView.h"

@implementation GW_BarrageBaseView

- (instancetype)init {
    self = [super init];
    if (self) {
        _trackIndex = -1;
    }
    return self;
}

- (void)prepareForReuse {
    [self.layer removeAnimationForKey:GW_Barrage_Animation];
    _barrageModel = nil;
    if (!_idle) {
        _idle = YES;
    }
    _trackIndex = -1;
}

- (void)setBarrageModel:(GW_BarrageBaseModel *)barrageModel{
    _barrageModel = barrageModel;
}

- (void)clearContents {
    self.layer.contents = nil;
}

- (void)convertContentToImage {
    
}

- (void)sizeToFit {
    CGFloat height = 0.0;
    CGFloat width = 0.0;
    //获取子layer的最大宽高
    for (CALayer *sublayer in self.layer.sublayers) {
        CGFloat maxY = CGRectGetMaxY(sublayer.frame);
        if (maxY > height) {
            height = maxY;
        }
        CGFloat maxX = CGRectGetMaxX(sublayer.frame);
        if (maxX > width) {
            width = maxX;
        }
    }
    //没有子layer的情况处理 获取自身的宽高
    if (width == 0 || height == 0) {
        CGImageRef content = (__bridge CGImageRef)self.layer.contents;
        if (content) {
            UIImage *image = [UIImage imageWithCGImage:content];
            width = image.size.width/[UIScreen mainScreen].scale;
            height = image.size.height/[UIScreen mainScreen].scale;
        }
    }
    self.bounds = CGRectMake(0.0, 0.0, width, height);
}

- (void)removeSubViewsAndSublayers {
    NSEnumerator *viewEnumerator = [self.subviews reverseObjectEnumerator];
    UIView *subView = nil;
//    将子view移除
    while (subView = [viewEnumerator nextObject]){
        [subView removeFromSuperview];
    }
    
    NSEnumerator *layerEnumerator = [self.layer.sublayers reverseObjectEnumerator];
    CALayer *sublayer = nil;
//    将子layer移除
    while (sublayer = [layerEnumerator nextObject]){
        [sublayer removeFromSuperlayer];
    }
}

- (void)addBorderAttributes {
    if (self.barrageModel.borderColor) {
        self.layer.borderColor = self.barrageModel.borderColor.CGColor;
    }
    if (self.barrageModel.borderWidth > 0) {
        self.layer.borderWidth = self.barrageModel.borderWidth;
    }
    if (self.barrageModel.cornerRadius > 0) {
        self.layer.cornerRadius = self.barrageModel.cornerRadius;
    }
}

- (void)addBarrageAnimationWithDelegate:(id<CAAnimationDelegate>)animationDelegate {
    
}

- (void)updateSubviewsData {
    
}

- (void)layoutContentSubviews {
    
}

- (CAAnimation *)barrageAnimation {
    //取出动画
    return [self.layer animationForKey:GW_Barrage_Animation];
}





@end
