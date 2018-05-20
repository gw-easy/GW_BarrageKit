//
//  GW_BarrageTextModel.m
//  GW_Barrage
//
//  Created by gw on 2018/5/19.
//  Copyright © 2018年 gw. All rights reserved.
//

#import "GW_BarrageTextViewModel.h"
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
@implementation GW_BarrageTextViewModel
- (void)prepareForReuse {
    [super prepareForReuse];    
}

- (void)updateSubviewsData {
    if (!_textLabel) {
        [self addSubview:self.textLabel];
    }
    [self.textLabel setAttributedText:self.textModel.attributedText];
}

- (void)layoutContentSubviews {
    CGRect textFrame = [self.textModel.attributedText.string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[self.textModel.attributedText attributesAtIndex:0 effectiveRange:NULL] context:nil];
    self.textLabel.frame = textFrame;
}

- (void)convertContentToImage {
    UIImage *contentImage = [self.layer convertContentToImageWithSize:_textLabel.frame.size];
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
    CGPoint endCenter = CGPointMake(-(CGRectGetWidth(self.bounds)/2), self.center.y);
    
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

@end
