//
//  GW_BarrageGifViewModel.m
//  GW_Barrage
//
//  Created by gw on 2018/5/23.
//  Copyright © 2018年 gw. All rights reserved.
//

#import "GW_BarrageGifViewModel.h"

@implementation GW_BarrageGifViewModel

- (void)updateSubviewsData {
    if (!_aniImageView) {
        [self addSubview:self.aniImageView];
    }
    self.aniImageView.image = self.barrageModel.backImage;
}

- (void)layoutContentSubviews {
    self.aniImageView.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
}


- (void)addBarrageAnimationWithDelegate:(id<CAAnimationDelegate>)animationDelegate {
    [super addBarrageAnimationWithDelegate:animationDelegate];
}

- (UIImageView *)aniImageView{
    if (!_aniImageView) {
        _aniImageView = [[UIImageView alloc] init];
    }
    return _aniImageView;
}

@end
