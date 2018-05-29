//
//  ViewController.m
//  GW_Barrage
//
//  Created by gw on 2018/5/15.
//  Copyright © 2018年 gw. All rights reserved.
//

#import "ViewController.h"
#import "GW_BarrageTextViewModel.h"
#import "GW_BarrageGifViewModel.h"
#import "GW_BarrageShowView.h"
#import "GW_AnimatedGIFImageSerialization.h"
#import "GW_BarrageVerticalTextViewModel.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet GW_BarrageShowView *showView;
@property (weak, nonatomic) IBOutlet UIButton *beginBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *resumeBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UIButton *fastBtn;
@property (weak, nonatomic) IBOutlet UIButton *slowBtn;

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
    [self performSelector:@selector(addBackgroundColorBarrage) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(addStopoverBarrage) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(addMixedImageAndTextBarrage) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(addGifBarrage) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(addVerticalBarrage) withObject:nil afterDelay:0.5];
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
    textDescriptor.animationDuration = 3;
    textDescriptor.barrageViewClass = [GW_BarrageTextViewModel class];
    self.showView.barrageModel = textDescriptor;

    [self performSelector:@selector(addNormalBarrage) withObject:nil afterDelay:0.25];
}

- (void)addVerticalBarrage {
    [self updateTitle];
    
    GW_BarrageTextModel *textDescriptor = [[GW_BarrageTextModel alloc] init];
    textDescriptor.text = [NSString stringWithFormat:@"///GW_Barrage///"];
    textDescriptor.textColor = [UIColor yellowColor];
    textDescriptor.positionPriority = GW_BarragePositionLow;
    textDescriptor.textFont = [UIFont systemFontOfSize:17.0];
    textDescriptor.strokeColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    textDescriptor.strokeWidth = -1;
    textDescriptor.animationDuration = 3;
    textDescriptor.barrageViewClass = [GW_BarrageVerticalTextViewModel class];
    self.showView.barrageModel = textDescriptor;
    
    [self performSelector:@selector(addVerticalBarrage) withObject:nil afterDelay:0.25];
}

- (void)addBackgroundColorBarrage {
    GW_BarrageTextModel *textDescriptor = [[GW_BarrageTextModel alloc] init];
    textDescriptor.text = [NSString stringWithFormat:@"///GW_直播///"];
    textDescriptor.textColor = [UIColor whiteColor];
    textDescriptor.positionPriority = GW_BarragePositionMiddle;
    textDescriptor.textFont = [UIFont systemFontOfSize:17.0];
    textDescriptor.strokeColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    textDescriptor.strokeWidth = -1;
    textDescriptor.animationDuration = 3;
    textDescriptor.backColor = GW_RandomColor;
    textDescriptor.barrageViewClass = [GW_BarrageTextViewModel class];
    
    self.showView.barrageModel = textDescriptor;

    [self performSelector:@selector(addBackgroundColorBarrage) withObject:nil afterDelay:0.5];
}

- (void)addStopoverBarrage {
    
    GW_BarrageTextModel *textDescriptor = [[GW_BarrageTextModel alloc] init];
    textDescriptor.positionPriority = GW_BarragePositionVeryHigh;
    textDescriptor.textFont = [UIFont systemFontOfSize:17.0];
    textDescriptor.strokeColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    textDescriptor.strokeWidth = -1;
    textDescriptor.animationDuration = 4;
    textDescriptor.backColor = GW_RandomColor;
    textDescriptor.barrageViewClass = [GW_BarrageTextViewModel class];
    
    
    NSMutableAttributedString *mAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"~GW_Barrage~"]];
    [mAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, mAttributedString.length)];
    [mAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(1, 3)];
    [mAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor cyanColor] range:NSMakeRange(4, 2)];
    [mAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(7, 2)];
    [mAttributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0] range:NSMakeRange(0, mAttributedString.length)];
    textDescriptor.attributedText = mAttributedString;
    CGFloat bannerHeight = 185.0/2.0;
    CGFloat minOriginY = CGRectGetMidY(self.view.frame) - bannerHeight;
    CGFloat maxOriginY = CGRectGetMidY(self.view.frame) + bannerHeight;
    textDescriptor.showRange = NSMakeRange(minOriginY, maxOriginY);
    textDescriptor.backImageRect = CGRectMake(0, 0, self.view.frame.size.width, 100);
    textDescriptor.backImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"backImage.jpg" ofType:nil]];
    self.showView.barrageModel = textDescriptor;
    
    [self performSelector:@selector(addStopoverBarrage) withObject:nil afterDelay:4.0];
}

- (void)addMixedImageAndTextBarrage {
    GW_BarrageTextModel *textDescriptor = [[GW_BarrageTextModel alloc] init];
    textDescriptor.touchAction = ^(GW_BarrageBaseModel *descriptor){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"OCBarrage" message:@"全民超人为您服务" delegate:nil cancelButtonTitle:@"朕知道了" otherButtonTitles:nil];
        [alertView show];
    };
    textDescriptor.positionPriority = GW_BarragePositionVeryHigh;
    textDescriptor.animationDuration = 4;
    textDescriptor.backColor = GW_RandomColor;
    textDescriptor.barrageViewClass = [GW_BarrageTextViewModel class];
    
    NSMutableAttributedString *mAttStr = [[NSMutableAttributedString alloc] init];

    [mAttStr insertAttributedString:[self setAttTextImage] atIndex:0];

    [mAttStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"~GW_hhh~"] attributes:@{NSForegroundColorAttributeName:GW_RandomColor}]];
    
    [mAttStr appendAttributedString:[self setAttTextImage]];
    
    [mAttStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"~GW_hhh~"] attributes:@{NSForegroundColorAttributeName:GW_RandomColor}]];
    
    [mAttStr appendAttributedString:[self setAttTextImage]];
    
    [mAttStr addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithInteger:-1] range:NSMakeRange(0, mAttStr.length)];
    [mAttStr addAttribute:NSStrokeColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, mAttStr.length)];
    [mAttStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25.0] range:NSMakeRange(0, mAttStr.length)];
    textDescriptor.attributedText = mAttStr;
    textDescriptor.animationDuration = arc4random()%5 + 5;;
    textDescriptor.barrageViewClass = [GW_BarrageTextViewModel class];
    self.showView.barrageModel = textDescriptor;
    
    [self performSelector:@selector(addMixedImageAndTextBarrage) withObject:nil afterDelay:2.0];
}

- (void)addGifBarrage {
    GW_BarrageTextModel *textDescriptor = [[GW_BarrageTextModel alloc] init];
    textDescriptor.positionPriority = GW_BarragePositionHigh;
    textDescriptor.animationDuration = 3;
    textDescriptor.backImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"小太阳.gif" ofType:nil]];
    textDescriptor.barrageViewClass = [GW_BarrageGifViewModel class];
    self.showView.barrageModel = textDescriptor;
    
    [self performSelector:@selector(addGifBarrage) withObject:nil afterDelay:3.0];
}

- (NSAttributedString *)setAttTextImage{
    NSTextAttachment *attach  = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"小太阳.gif" ofType:nil]];
    // 位置调整Y值就行
    attach.bounds = CGRectMake(0, 0, 30, 30);
    NSAttributedString *mAttributedString = [NSAttributedString attributedStringWithAttachment:attach];
    return mAttributedString;
}

- (void)updateTitle {
    NSInteger barrageCount = self.showView.animatingViewArray.count;
    self.title = [NSString stringWithFormat:@"现在有 %ld 条弹幕", (unsigned long)barrageCount];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addNormalBarrage) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addBackgroundColorBarrage) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addMixedImageAndTextBarrage) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addGifBarrage) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addStopoverBarrage) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addVerticalBarrage) object:nil];
}
@end
