//
//  GW_BarrageVerticalTextViewModel.m
//  GW_Barrage
//
//  Created by gw on 2018/5/29.
//  Copyright © 2018年 gw. All rights reserved.
//

#import "GW_BarrageVerticalTextViewModel.h"

@implementation GW_BarrageVerticalTextViewModel

- (void)addBarrageAnimationWithDelegate:(id<CAAnimationDelegate>)animationDelegate {
    if (!self.superview) {
        return;
    }
    
    CGPoint startCenter = CGPointMake(CGRectGetMidX(self.superview.bounds), -(CGRectGetHeight(self.bounds)/2));
    CGPoint endCenter = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetHeight(self.superview.bounds) + CGRectGetHeight(self.bounds)/2);
    
    CAKeyframeAnimation *walkAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    walkAnimation.values = @[[NSValue valueWithCGPoint:startCenter], [NSValue valueWithCGPoint:endCenter]];
    walkAnimation.keyTimes = @[@(0.0), @(1.0)];
    walkAnimation.duration = self.textModel.animationDuration;
    walkAnimation.repeatCount = 1;
    walkAnimation.delegate =  animationDelegate;
    walkAnimation.removedOnCompletion = NO;
    walkAnimation.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:walkAnimation forKey:GW_Barrage_Animation];
}


@end
