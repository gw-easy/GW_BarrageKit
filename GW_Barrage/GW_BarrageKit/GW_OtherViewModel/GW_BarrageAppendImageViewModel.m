//
//  GW_BarrageAppendImageViewModel.m
//  GW_Barrage
//
//  Created by gw on 2018/5/29.
//  Copyright © 2018年 gw. All rights reserved.
//

#import "GW_BarrageAppendImageViewModel.h"
@interface GW_BarrageAppendImageViewModel()
@property (strong, nonatomic, nullable) UIImageView *leftImageView;
@property (strong, nonatomic, nullable) UIImageView *middleImageView;
@property (strong, nonatomic, nullable) UIImageView *rightImageView;
@end
@implementation GW_BarrageAppendImageViewModel

- (void)updateSubviewsData{
    [self addSubview:self.leftImageView];
    [self addSubview:self.middleImageView];
    [self addSubview:self.rightImageView];
}



- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftImageView;
}

- (UIImageView *)middleImageView {
    if (!_middleImageView) {
        _middleImageView = [[UIImageView alloc] init];
        _middleImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _middleImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _rightImageView;
}

@end
