//
//  CALayer+GW_Layer.m
//  GW_Barrage
//
//  Created by gw on 2018/5/16.
//  Copyright © 2018年 gw. All rights reserved.
//

#import "CALayer+GW_Layer.h"

@implementation CALayer (GW_Layer)
- (UIImage *)convertContentToImageWithSize:(CGSize)contentSize {
    if (CGSizeEqualToSize(contentSize, CGSizeZero)) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(contentSize, 0.0, [UIScreen mainScreen].scale);
    //self为需要截屏的UI控件 即通过改变此参数可以截取特定的UI控件
    [self renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
