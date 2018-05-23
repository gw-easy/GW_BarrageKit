//
//  GW_BarrageShowView.m
//  GW_Barrage
//
//  Created by gw on 2018/5/15.
//  Copyright © 2018年 gw. All rights reserved.
//
#define GW_NextAvailableTimeKey(identifier, index) [NSString stringWithFormat:@"%@_%d", identifier, index]

#import "GW_BarrageShowView.h"
@interface GW_BarrageShowView()
@property (strong,nonatomic,readwrite) NSMutableArray<GW_BarrageBaseView *> *animatingViewArray;
@property (strong,nonatomic,readwrite) NSMutableArray<GW_BarrageBaseView *> *idleViewArray;
@property (assign,nonatomic)GW_BarrageShowStatus selectShowStatus;
@end
@implementation GW_BarrageShowView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initAllSet];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initAllSet];
}

- (void)initAllSet{
    _animatingViewLock = dispatch_semaphore_create(1);
    _idleViewLock = dispatch_semaphore_create(1);
    _trackInfoLock = dispatch_semaphore_create(1);
    _lowPositionView = [[UIView alloc] init];
    [self addSubview:_lowPositionView];
    _middlePositionView = [[UIView alloc] init];
    [self addSubview:_middlePositionView];
    _highPositionView = [[UIView alloc] init];
    [self addSubview:_highPositionView];
    _veryHighPositionView = [[UIView alloc] init];
    [self addSubview:_veryHighPositionView];
    self.layer.masksToBounds = YES;
    self.speet = 1.0;
}

- (void)setBarrageModel:(GW_BarrageBaseModel *)barrageModel{
    _barrageModel = barrageModel;
    if (!barrageModel) {
        return;
    }
    if (![barrageModel isKindOfClass:[GW_BarrageBaseModel class]]) {
        return;
    }

    GW_BarrageBaseView *barrageView = [self dequeueReusableViewWithClass:barrageModel.barrageViewClass];
    if (!barrageView) {
        return;
    }
    barrageView.barrageModel = barrageModel;
    [self beginBarrageView:barrageView];
}


- (nullable GW_BarrageBaseView *)dequeueReusableViewWithClass:(Class)barrageViewClass{
    switch (self.showStatus) {
        case GW_BarrageShowStart:
            break;
        default:
            return nil;
            break;
    }
    GW_BarrageBaseView *barrageView = nil;
    dispatch_semaphore_wait(_idleViewLock, DISPATCH_TIME_FOREVER);
    for (GW_BarrageBaseView *bar in self.idleViewArray) {
        if ([NSStringFromClass([bar class]) isEqualToString:NSStringFromClass(barrageViewClass)]) {
            barrageView = bar;
            break;
        }
    }
    if (barrageView) {
        [self.idleViewArray removeObject:barrageView];
        barrageView.idleTime = 0.0;
    } else {
        barrageView = [[barrageViewClass alloc] init];
    }
    dispatch_semaphore_signal(_idleViewLock);
    if (![barrageView isKindOfClass:[GW_BarrageBaseView class]]) {
        return nil;
    }
    return barrageView;
}

- (void)setShowStatus:(GW_BarrageShowStatus)showStatus{
    _showStatus = showStatus;
    if (_selectShowStatus == showStatus && showStatus != GW_BarrageShowStop) {
        return;
    }
    switch (showStatus) {
        case GW_BarrageShowStart:
            [self start];
            break;
        case GW_BarrageShowPause:
            [self pause];
            break;
        case GW_BarrageShowResume:
            _showStatus = GW_BarrageShowStart;
            [self resume];
            break;
        case GW_BarrageShowStop:
            [self stop];
            break;
        default:
            break;
    }
    _selectShowStatus = showStatus;
}
- (void)start {
    if (self.selectShowStatus == GW_BarrageShowPause) {
        [self resume];
    }
}

- (void)setSpeet:(float)speet{
    _speet = speet;
    
}

- (void)reloadSpeet{
    dispatch_semaphore_wait(_animatingViewLock, DISPATCH_TIME_FOREVER);
    NSEnumerator *enumerator = [self.animatingViewArray reverseObjectEnumerator];
    GW_BarrageBaseView *bView = nil;
    //    将layer的动画时间暂停
    while (bView = [enumerator nextObject]){
        CFTimeInterval pausedTime = [bView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        bView.layer.speed = 0.0;
        bView.layer.timeOffset = pausedTime;
        
        bView.layer.speed = self.speet;
        bView.layer.timeOffset = 0.0;
        bView.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [bView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        bView.layer.beginTime = timeSincePause;
    }
    dispatch_semaphore_signal(_animatingViewLock);
}

- (void)pause {
    
    dispatch_semaphore_wait(_animatingViewLock, DISPATCH_TIME_FOREVER);
    NSEnumerator *enumerator = [self.animatingViewArray reverseObjectEnumerator];
    GW_BarrageBaseView *bView = nil;
//    将layer的动画时间暂停
    while (bView = [enumerator nextObject]){
        CFTimeInterval pausedTime = [bView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        bView.layer.speed = 0.0;
        bView.layer.timeOffset = pausedTime;
    }
    dispatch_semaphore_signal(_animatingViewLock);
}

- (void)resume {
    dispatch_semaphore_wait(_animatingViewLock, DISPATCH_TIME_FOREVER);
    NSEnumerator *enumerator = [self.animatingViewArray reverseObjectEnumerator];
    GW_BarrageBaseView *bView = nil;
    //继续上一次时间动画
    while (bView = [enumerator nextObject]){
        CFTimeInterval pausedTime = bView.layer.timeOffset;
        bView.layer.speed = self.speet;
        bView.layer.timeOffset = 0.0;
        bView.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [bView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        bView.layer.beginTime = timeSincePause;
    }
    dispatch_semaphore_signal(_animatingViewLock);
}

- (void)stop {

    if (_autoClear) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearIdleViews) object:nil];
    }
    
    dispatch_semaphore_wait(_animatingViewLock, DISPATCH_TIME_FOREVER);
    NSEnumerator *animatingEnumerator = [self.animatingViewArray reverseObjectEnumerator];
    GW_BarrageBaseView *bView = nil;
    while (bView = [animatingEnumerator nextObject]){
        CFTimeInterval pausedTime = [bView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        bView.layer.speed = 0.0;
        bView.layer.timeOffset = pausedTime;
        [bView.layer removeAllAnimations];
        [bView removeFromSuperview];
    }
    [self.animatingViewArray removeAllObjects];
    dispatch_semaphore_signal(_animatingViewLock);
    
    dispatch_semaphore_wait(_idleViewLock, DISPATCH_TIME_FOREVER);
    [self.idleViewArray removeAllObjects];
    dispatch_semaphore_signal(_idleViewLock);
    
    dispatch_semaphore_wait(_trackInfoLock, DISPATCH_TIME_FOREVER);
    [self.trackNextAvailableTime removeAllObjects];
    dispatch_semaphore_signal(_trackInfoLock);
}

- (void)clearIdleViews {
    dispatch_semaphore_wait(_idleViewLock, DISPATCH_TIME_FOREVER);
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSEnumerator *enumerator = [self.idleViewArray reverseObjectEnumerator];
    GW_BarrageBaseView *bView = nil;
    while (bView = [enumerator nextObject]){
        CGFloat time = timeInterval - bView.idleTime;
        if (time > 5.0 && bView.idleTime > 0) {
            [self.idleViewArray removeObject:bView];
        }
    }
    
    if (self.idleViewArray.count == 0) {
        _autoClear = NO;
    } else {
        [self performSelector:@selector(clearIdleViews) withObject:nil afterDelay:5.0];
    }
    dispatch_semaphore_signal(_idleViewLock);
}

- (void)beginBarrageView:(GW_BarrageBaseView *)barrageView{
    switch (self.showStatus) {
        case GW_BarrageShowStart:
            break;
        default:
            return;
            break;
    }
    if (!barrageView) {
        return;
    }
    if (![barrageView isKindOfClass:[GW_BarrageBaseView class]]) {
        return;
    }
//    清理layer.contents
    [barrageView clearContents];
//    添加子视图，设置数据
    [barrageView updateSubviewsData];
//    设置子视图frame
    [barrageView layoutContentSubviews];
//    绘制图片
    [barrageView convertContentToImage];
//    获取图片的最大宽高
    [barrageView sizeToFit];
//    移除所有子视图和sublayer
    [barrageView removeSubViewsAndSublayers];
//    设置border样式
    [barrageView addBorderAttributes];
    
    dispatch_semaphore_wait(_animatingViewLock, DISPATCH_TIME_FOREVER);
    _lastestBarrageView = [self.animatingViewArray lastObject];
    [self.animatingViewArray addObject:barrageView];
    barrageView.idle = NO;
    dispatch_semaphore_signal(_animatingViewLock);
    
//    添加到指定图层
    [self addBarrageView:barrageView WithPositionPriority:barrageView.barrageModel.positionPriority];
    CGRect ViewFrame = [self calculationBarrageViewFrame:barrageView];
    barrageView.frame = ViewFrame;
    [barrageView addBarrageAnimationWithDelegate:self];
    [self recordTrackInfoWithBarrageView:barrageView];
    
    _lastestBarrageView = barrageView;
}

- (void)addBarrageView:(GW_BarrageBaseView *)barrageView WithPositionPriority:(GW_BarragePositionPriority)positionPriority {
    switch (positionPriority) {
        case GW_BarragePositionMiddle: {
            [self insertSubview:barrageView belowSubview:_middlePositionView];
        }
            break;
        case GW_BarragePositionHigh: {
            [self insertSubview:barrageView belowSubview:_highPositionView];
        }
            break;
        case GW_BarragePositionVeryHigh: {
            [self insertSubview:barrageView belowSubview:_veryHighPositionView];
        }
            break;
        default: {
            [self insertSubview:barrageView belowSubview:_lowPositionView];
        }
            break;
    }
}

- (CGRect)calculationBarrageViewFrame:(GW_BarrageBaseView *)barrageView {
    CGRect viewFrame = barrageView.bounds;
    viewFrame.origin.x = CGRectGetMaxX(self.frame);
    
    if (![[NSValue valueWithRange:barrageView.barrageModel.showRange] isEqualToValue:[NSValue valueWithRange:NSMakeRange(0, 0)]]) {
        CGFloat viewHeight = CGRectGetHeight(barrageView.bounds);
        CGFloat minOriginY = barrageView.barrageModel.showRange.location;
        CGFloat maxOriginY = barrageView.barrageModel.showRange.length;
        if (maxOriginY > CGRectGetHeight(self.bounds)) {
            maxOriginY = CGRectGetHeight(self.bounds);
        }
        if (minOriginY < 0) {
            minOriginY = 0;
        }
        CGFloat renderHeight = maxOriginY - minOriginY;
        if (renderHeight < 0) {
            renderHeight = viewHeight;
        }
        
        int trackCount = floorf(renderHeight/viewHeight);
        int trackIndex = arc4random_uniform(trackCount);//用户改变行高(比如弹幕文字大小不会引起显示bug, 因为虽然是同一个类, 但是trackCount变小了, 所以不会出现trackIndex*ViewHeight超出屏幕边界的情况)
        
        dispatch_semaphore_wait(_trackInfoLock, DISPATCH_TIME_FOREVER);
        GW_BarrageTrackModel *trackInfo = [self.trackNextAvailableTime objectForKey:[NSString stringWithFormat:@"%@_%d", NSStringFromClass([barrageView class]), trackIndex]];
        if (trackInfo && trackInfo.nextAvailableTime > CACurrentMediaTime()) {//当前行暂不可用
            
            NSMutableArray *availableTrackInfos = [NSMutableArray array];
            for (GW_BarrageTrackModel *info in self.trackNextAvailableTime.allValues) {
                if (CACurrentMediaTime() > info.nextAvailableTime && [info.trackIdentifier containsString:NSStringFromClass([barrageView class])]) {//只在同类弹幕中判断是否有可用的轨道
                    [availableTrackInfos addObject:info];
                }
            }
            if (availableTrackInfos.count > 0) {
                GW_BarrageTrackModel *randomInfo = [availableTrackInfos objectAtIndex:arc4random_uniform((int)availableTrackInfos.count)];
                trackIndex = randomInfo.trackIndex;
            } else {
                if (self.trackNextAvailableTime.count < trackCount) {//刚开始不是每一条轨道都跑过弹幕, 还有空轨道
                    NSMutableArray *numberArray = [NSMutableArray array];
                    for (int index = 0; index < trackCount; index++) {
                        GW_BarrageTrackModel *emptyTrackInfo = [self.trackNextAvailableTime objectForKey:[NSString stringWithFormat:@"%@_%d", NSStringFromClass([barrageView class]), trackIndex]];
                        if (!emptyTrackInfo) {
                            [numberArray addObject:[NSNumber numberWithInt:index]];
                        }
                    }
                    if (numberArray.count > 0) {
                        trackIndex = [[numberArray objectAtIndex:arc4random_uniform((int)numberArray.count)] intValue];
                    }
                }
                //真的是没有可用的轨道了
            }
        }
        dispatch_semaphore_signal(_trackInfoLock);
        
        barrageView.trackIndex = trackIndex;
        viewFrame.origin.y = trackIndex*viewHeight+minOriginY;
    } else {
        switch (self.showPositionStyle) {
            case GW_BarrageShowPositionRandom: {
                CGFloat maxY = CGRectGetHeight(self.bounds) - CGRectGetHeight(viewFrame);
                int originY = floorl(maxY);
                viewFrame.origin.y = arc4random_uniform(originY);
            }
                break;
            case GW_BarrageShowPositionIncrease: {
                if (_lastestBarrageView) {
                    CGRect lastestFrame = _lastestBarrageView.frame;
                    viewFrame.origin.y = CGRectGetMaxY(lastestFrame);
                } else {
                    viewFrame.origin.y = 0.0;
                }
            }
                break;
            default: {
                CGFloat showViewHeight = CGRectGetHeight(self.bounds);
                CGFloat viewHeight = CGRectGetHeight(barrageView.bounds);
                int trackCount = floorf(showViewHeight/viewHeight);
                int trackIndex = arc4random_uniform(trackCount);//用户改变行高(比如弹幕文字大小不会引起显示bug, 因为虽然是同一个类, 但是trackCount变小了, 所以不会出现trackIndex*ViewHeight超出屏幕边界的情况)
                
                dispatch_semaphore_wait(_trackInfoLock, DISPATCH_TIME_FOREVER);
                GW_BarrageTrackModel *trackInfo = [self.trackNextAvailableTime objectForKey:GW_NextAvailableTimeKey(NSStringFromClass([barrageView class]), trackIndex)];
                if (trackInfo && trackInfo.nextAvailableTime > CACurrentMediaTime()) {//当前行暂不可用
                    NSMutableArray *availableTrackInfos = [NSMutableArray array];
                    for (GW_BarrageTrackModel *info in self.trackNextAvailableTime.allValues) {
                        if (CACurrentMediaTime() > info.nextAvailableTime && [info.trackIdentifier containsString:NSStringFromClass([barrageView class])]) {//只在同类弹幕中判断是否有可用的轨道
                            [availableTrackInfos addObject:info];
                        }
                    }
                    if (availableTrackInfos.count > 0) {
                        GW_BarrageTrackModel *randomInfo = [availableTrackInfos objectAtIndex:arc4random_uniform((int)availableTrackInfos.count)];
                        trackIndex = randomInfo.trackIndex;
                    } else {
                        if (self.trackNextAvailableTime.count < trackCount) {//刚开始不是每一条轨道都跑过弹幕, 还有空轨道
                            NSMutableArray *numberArray = [NSMutableArray array];
                            for (int index = 0; index < trackCount; index++) {
                                GW_BarrageTrackModel *emptyTrackInfo = [self.trackNextAvailableTime objectForKey:[NSString stringWithFormat:@"%@_%d", NSStringFromClass([barrageView class]), trackIndex]];
                                if (!emptyTrackInfo) {
                                    [numberArray addObject:[NSNumber numberWithInt:index]];
                                }
                            }
                            if (numberArray.count > 0) {
                                trackIndex = [[numberArray objectAtIndex:arc4random_uniform((int)numberArray.count)] intValue];
                            }
                        }
                        //真的是没有可用的轨道了
                    }
                }
                dispatch_semaphore_signal(_trackInfoLock);
                
                barrageView.trackIndex = trackIndex;
                viewFrame.origin.y = trackIndex*viewHeight;
            }
                break;
        }
    }
    
    if (CGRectGetMaxY(viewFrame) > CGRectGetHeight(self.bounds)) {
        viewFrame.origin.y = 0.0; //超过底部, 回到顶部
    } else if (viewFrame.origin.y  < 0) {
        viewFrame.origin.y = 0.0;
    }
    
    return viewFrame;
}

- (void)recordTrackInfoWithBarrageView:(GW_BarrageBaseView *)barrageView {
    NSString *nextAvalibleTimeKey = GW_NextAvailableTimeKey(NSStringFromClass([barrageView class]), barrageView.trackIndex);
    CFTimeInterval duration = barrageView.barrageAnimation.duration;
    NSValue *fromValue = nil;
    NSValue *toValue = nil;
    if ([barrageView.barrageAnimation isKindOfClass:[CABasicAnimation class]]) {
        fromValue = [(CABasicAnimation *)barrageView.barrageAnimation fromValue];
        toValue = [(CABasicAnimation *)barrageView.barrageAnimation toValue];
    } else if ([barrageView.barrageAnimation isKindOfClass:[CAKeyframeAnimation class]]) {
        fromValue = [[(CAKeyframeAnimation *)barrageView.barrageAnimation values] firstObject];
        toValue = [[(CAKeyframeAnimation *)barrageView.barrageAnimation values] lastObject];
    } else {
        
    }
    const char *fromeValueType = [fromValue objCType];
    const char *toValueType = [toValue objCType];
    if (!fromeValueType || !toValueType) {
        return;
    }
    NSString *fromeValueTypeString = [NSString stringWithCString:fromeValueType encoding:NSUTF8StringEncoding];
    NSString *toValueTypeString = [NSString stringWithCString:toValueType encoding:NSUTF8StringEncoding];
    if (![fromeValueTypeString isEqualToString:toValueTypeString]) {
        return;
    }
    if ([fromeValueTypeString containsString:@"CGPoint"]) {
        CGPoint fromPoint = [fromValue CGPointValue];
        CGPoint toPoint = [toValue CGPointValue];
        
        dispatch_semaphore_wait(_trackInfoLock, DISPATCH_TIME_FOREVER);
        GW_BarrageTrackModel *trackInfo = [self.trackNextAvailableTime objectForKey:nextAvalibleTimeKey];
        if (!trackInfo) {
            trackInfo = [[GW_BarrageTrackModel alloc] init];
            trackInfo.trackIdentifier = nextAvalibleTimeKey;
            trackInfo.trackIndex = barrageView.trackIndex;
        }
        trackInfo.barrageCount++;
        
        trackInfo.nextAvailableTime = CGRectGetWidth(barrageView.bounds);
        CGFloat distanceX = fabs(toPoint.x - fromPoint.x);
        CGFloat distanceY = fabs(toPoint.y - fromPoint.y);
        CGFloat distance = MAX(distanceX, distanceY);
        CGFloat speed = distance/duration;
        if (distanceX == distance) {
            CFTimeInterval time = CGRectGetWidth(barrageView.bounds)/speed;
            trackInfo.nextAvailableTime = CACurrentMediaTime() + time + 0.1;//多加一点时间
            [self.trackNextAvailableTime setValue:trackInfo forKey:nextAvalibleTimeKey];
        } else if (distanceY == distance) {
            //            CFTimeInterval time = CGRectGetHeight(barrageView.bounds)/speed;
            
        } else {
            
        }
        dispatch_semaphore_signal(_trackInfoLock);
        return;
    } else if ([fromeValueTypeString containsString:@"CGVector"]) {
        
        return;
    } else if ([fromeValueTypeString containsString:@"CGSize"]) {
        
        return;
    } else if ([fromeValueTypeString containsString:@"CGRect"]) {
        
        return;
    } else if ([fromeValueTypeString containsString:@"CGAffineTransform"]) {
        
        return;
    } else if ([fromeValueTypeString containsString:@"UIEdgeInsets"]) {
        
        return;
    } else if ([fromeValueTypeString containsString:@"UIOffset"]) {
        
        return;
    }
}

#pragma mark ----- CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (!flag) {
        return;
    }
    
    if (self.showStatus == GW_BarrageShowStop) {
        return;
    }
    GW_BarrageBaseView *animationedView = nil;
    dispatch_semaphore_wait(_animatingViewLock, DISPATCH_TIME_FOREVER);
    for (GW_BarrageBaseView *View in self.animatingViewArray) {
        CAAnimation *barrageAnimation = [View barrageAnimation];
        if (barrageAnimation == anim) {
            animationedView = View;
            [self.animatingViewArray removeObject:View];
            break;
        }
    }
    dispatch_semaphore_signal(_animatingViewLock);
    
    if (!animationedView) {
        return;
    }
    
    dispatch_semaphore_wait(_trackInfoLock, DISPATCH_TIME_FOREVER);
    GW_BarrageTrackModel *trackInfo = [self.trackNextAvailableTime objectForKey:GW_NextAvailableTimeKey(NSStringFromClass([animationedView class]), animationedView.trackIndex)];
    if (trackInfo) {
        trackInfo.barrageCount--;
    }
    dispatch_semaphore_signal(_trackInfoLock);
    
    [animationedView removeFromSuperview];
    [animationedView prepareForReuse];
    
    dispatch_semaphore_wait(_idleViewLock, DISPATCH_TIME_FOREVER);
    animationedView.idleTime = [[NSDate date] timeIntervalSince1970];
    [self.idleViewArray addObject:animationedView];
    dispatch_semaphore_signal(_idleViewLock);
    
    if (!_autoClear) {
        [self performSelector:@selector(clearIdleViews) withObject:nil afterDelay:5.0];
        _autoClear = YES;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (event.type == UIEventTypeTouches) {
        UITouch *touch = [touches.allObjects firstObject];
        CGPoint touchPoint = [touch locationInView:self];
        
        dispatch_semaphore_wait(_animatingViewLock, DISPATCH_TIME_FOREVER);
        NSInteger count = self.animatingViewArray.count;
        for (int i = 0; i < count; i++) {
            GW_BarrageBaseView *barrageView = [self.animatingViewArray objectAtIndex:i];
            if ([barrageView.layer.presentationLayer hitTest:touchPoint]) {
                if (barrageView.barrageModel.touchAction) {
                    barrageView.barrageModel.touchAction(barrageView.barrageModel);
                }
                break;
            }
        }
        dispatch_semaphore_signal(_animatingViewLock);
    }
}

- (NSMutableArray<GW_BarrageBaseView *> *)animatingViewArray{
    if (!_animatingViewArray) {
        _animatingViewArray = [[NSMutableArray alloc] init];
    }
    return _animatingViewArray;
}

- (NSMutableArray<GW_BarrageBaseView *> *)idleViewArray{
    if (!_idleViewArray) {
        _idleViewArray = [[NSMutableArray alloc] init];
    }
    return _idleViewArray;
}

- (NSMutableDictionary *)trackNextAvailableTime{
    if (!_trackNextAvailableTime) {
        _trackNextAvailableTime = [[NSMutableDictionary alloc] init];
    }
    return _trackNextAvailableTime;
}

- (void)dealloc{
    [self stop];
}
@end
