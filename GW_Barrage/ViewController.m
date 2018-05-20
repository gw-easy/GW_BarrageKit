//
//  ViewController.m
//  GW_Barrage
//
//  Created by gw on 2018/5/15.
//  Copyright © 2018年 gw. All rights reserved.
//

#import "ViewController.h"
#import "GW_BarrageShowView.h"
#import "GW_BarrageTextViewModel.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet GW_BarrageShowView *showView;
@property (weak, nonatomic) IBOutlet UIButton *beginBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *resumeBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)startBtnAction:(id)sender {
    switch (self.showView.showStatus) {
        case GW_BarrageShowStart:
            return;
            break;
        case GW_BarrageShowPause:
            self.showView.showStatus = GW_BarrageShowStart;
            return;
            break;
        default:
            self.showView.showStatus = GW_BarrageShowStart;
            break;
    }
    [self addBarrage];
}
- (IBAction)pauseBtnAction:(id)sender {
    self.showView.showStatus = GW_BarrageShowPause;
}
- (IBAction)resumeBtnAction:(id)sender {
    switch (self.showView.showStatus) {
        case GW_BarrageShowStart:
            return;
            break;
        default:
            self.showView.showStatus = GW_BarrageShowResume;
            break;
    }
}
- (IBAction)stopBtnAction:(id)sender {
    self.showView.showStatus = GW_BarrageShowStop;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addNormalBarrage) object:nil];
}

- (void)addBarrage {
    [self performSelector:@selector(addNormalBarrage) withObject:nil afterDelay:0.5];
//    [self performSelector:@selector(addGradientBackgroundColorBarrage) withObject:nil afterDelay:0.5];
//    [self performSelector:@selector(addWalkBannerBarrage) withObject:nil afterDelay:0.5];
//    [self performSelector:@selector(addStopoverBarrage) withObject:nil afterDelay:0.5];
//    [self performSelector:@selector(addMixedImageAndTextBarrage) withObject:nil afterDelay:0.5];
//    [self performSelector:@selector(addGifBarrage) withObject:nil afterDelay:0.5];
//    [self performSelector:@selector(addVerticalAnimationCell) withObject:nil afterDelay:0.5];
}

- (void)addNormalBarrage {
    [self updateTitle];
    
    GW_BarrageTextModel *textDescriptor = [[GW_BarrageTextModel alloc] init];
    textDescriptor.text = [NSString stringWithFormat:@"///GW_Barrage///"];
    textDescriptor.textColor = [UIColor yellowColor];
    textDescriptor.positionPriority = GW_BarragePositionLow;
    textDescriptor.textFont = [UIFont systemFontOfSize:17.0];
    textDescriptor.strokeColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    textDescriptor.strokeWidth = -1;
    textDescriptor.animationDuration = arc4random()%5 + 5;
    textDescriptor.barrageViewClass = [GW_BarrageTextViewModel class];
//    self.showView.autoClear = YES;
    self.showView.barrageModel = textDescriptor;

    [self performSelector:@selector(addNormalBarrage) withObject:nil afterDelay:0.25];
}

- (void)updateTitle {
    NSInteger barrageCount = self.showView.animatingViewArray.count;
    self.title = [NSString stringWithFormat:@"现在有 %ld 条弹幕", (unsigned long)barrageCount];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addNormalBarrage) object:nil];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addGradientBackgroundColorBarrage) object:nil];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addWalkBannerBarrage) object:nil];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addMixedImageAndTextBarrage) object:nil];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addGifBarrage) object:nil];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addStopoverBarrage) object:nil];
}
@end
