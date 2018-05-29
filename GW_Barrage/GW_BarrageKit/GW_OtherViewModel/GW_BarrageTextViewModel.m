//
//  GW_BarrageTextModel.m
//  GW_Barrage
//
//  Created by gw on 2018/5/19.
//  Copyright © 2018年 gw. All rights reserved.
//

#import "GW_BarrageTextViewModel.h"
static const CGFloat backMargic = 10;
@implementation GW_BarrageTextModel
- (instancetype)init {
    if (self = [super init]) {
        _textAttributeDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    [_textAttributeDict setValue:textFont forKey:NSFontAttributeName];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor =  textColor;
    [_textAttributeDict setValue:textColor forKey:NSForegroundColorAttributeName];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor =  strokeColor;
    [_textAttributeDict setValue:strokeColor forKey:NSStrokeColorAttributeName];
}

- (void)setStrokeWidth:(int)strokeWidth {
    _strokeWidth = strokeWidth;
    [_textAttributeDict setValue:[NSNumber numberWithInt:strokeWidth] forKey:NSStrokeWidthAttributeName];
}

- (NSString *)text {
    if (!_text) {
        _text = _attributedText.string;
    }
    return _text;
}

- (NSAttributedString *)attributedText {
    if (!_attributedText) {
        if (!_text) {
            return nil;
        }
        _attributedText = [[NSAttributedString alloc] initWithString:_text attributes:_textAttributeDict];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setBaseWritingDirection:NSWritingDirectionLeftToRight];
    NSMutableAttributedString *tempText = [[NSMutableAttributedString alloc] initWithAttributedString:_attributedText];
    [tempText addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, tempText.string.length)];
    return [tempText copy];
}
@end

@interface GW_BarrageTextViewModel(){
    CGRect _backRect;
}
@property (strong, nonatomic, nullable) UILabel *textLabel;

@property (strong, nonatomic, nullable) CALayer *backImageLayer;
@end
@implementation GW_BarrageTextViewModel

- (void)updateSubviewsData {
    if (self.textModel.backImage) {
        self.textModel.backColor = nil;
    }
    if (!_textLabel) {
        [self addSubview:self.textLabel];
    }
    [self.textLabel setAttributedText:self.textModel.attributedText];
}

- (void)layoutContentSubviews {
    CGRect textFrame = [self.textModel.attributedText.string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[self.textModel.attributedText attributesAtIndex:0 effectiveRange:NULL] context:nil];
    self.textLabel.frame = textFrame;
    [self addGradientLayer:textFrame];
    [self setBackImageSize];
}

- (void)convertContentToImage {
    UIImage *contentImage = [self.layer convertContentToImageWithSize:self.textModel.backColor!=nil?_backRect.size:(self.textModel.backImage!=nil?(CGRectEqualToRect(self.textModel.backImageRect, CGRectNull)?self.textModel.backImage.size:self.textModel.backImageRect.size):_textLabel.frame.size)];
    [self.layer setContents:(__bridge id)contentImage.CGImage];
}

- (void)removeSubViewsAndSublayers {
    [super removeSubViewsAndSublayers];
    _textLabel = nil;
}

- (void)addBarrageAnimationWithDelegate:(id<CAAnimationDelegate>)animationDelegate {
    if (!self.superview) {
        return;
    }
    
    CGPoint startCenter = CGPointMake(CGRectGetMaxX(self.superview.bounds) + CGRectGetWidth(self.bounds)/2, self.center.y);
    CGPoint stopCenter = CGPointMake(CGRectGetMidX(self.superview.bounds), self.center.y);
    CGPoint endCenter = CGPointMake(-(CGRectGetWidth(self.bounds)/2), self.center.y);
    
    CAKeyframeAnimation *walkAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    walkAnimation.values = @[[NSValue valueWithCGPoint:startCenter], [NSValue valueWithCGPoint:endCenter]];
    if (self.textModel.backImage != nil) {
        walkAnimation.values = @[[NSValue valueWithCGPoint:startCenter], [NSValue valueWithCGPoint:stopCenter], [NSValue valueWithCGPoint:stopCenter], [NSValue valueWithCGPoint:endCenter]];
    }
    walkAnimation.keyTimes = self.textModel.backImage!=nil?@[@(0.0), @(0.25), @(0.75), @(1.0)]:@[@(0.0), @(1.0)];;
    walkAnimation.duration = self.textModel.animationDuration;
    walkAnimation.repeatCount = 1;
    walkAnimation.delegate =  animationDelegate;
    walkAnimation.removedOnCompletion = NO;
    walkAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:walkAnimation forKey:GW_Barrage_Animation];
}

- (void)setBackImageSize{
    if (!self.textModel.backImage) {
        return;
    }
    [self.layer insertSublayer:self.backImageLayer atIndex:0];
    [self.backImageLayer setContents:(__bridge id)self.textModel.backImage.CGImage];
    
    if (CGRectEqualToRect(self.textModel.backImageRect, CGRectNull)) {
        self.backImageLayer.frame = CGRectMake(0.0, 0.0, self.textModel.backImage.size.width, self.textModel.backImage.size.height);
    }else{
        self.backImageLayer.frame = self.textModel.backImageRect;
    }
    
    CGPoint center = self.backImageLayer.position;
    center.y += self.textModel.textToBackImageOffSet;
    self.textLabel.center = center;
}

- (void)addGradientLayer:(CGRect)textRect {
    if (!self.textModel.backColor) {
        return;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[self.textModel.backColor colorWithAlphaComponent:0.8].CGColor, (__bridge id)[self.textModel.backColor colorWithAlphaComponent:0.0].CGColor];
    gradientLayer.locations = @[@0.2, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    
    gradientLayer.frame = CGRectMake(0, 0, textRect.size.width + backMargic*2, textRect.size.height+backMargic);
    
    self.textLabel.center = CGPointMake(gradientLayer.bounds.size.width/2, gradientLayer.bounds.size.height/2);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:gradientLayer.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:gradientLayer.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = gradientLayer.bounds;
    maskLayer.path = maskPath.CGPath;
    gradientLayer.mask = maskLayer;
    _backRect = gradientLayer.frame;
    [self.layer insertSublayer:gradientLayer atIndex:0];
    maskPath = nil;
    maskLayer = nil;
    gradientLayer = nil;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (void)setBarrageModel:(GW_BarrageBaseModel *)barrageModel{
    [super setBarrageModel:barrageModel];
    self.textModel = (GW_BarrageTextModel *)barrageModel;
}

- (CALayer *)backImageLayer{
    if (!_backImageLayer) {
        _backImageLayer = [[CALayer alloc] init];
    }
    return _backImageLayer;
}

@end
