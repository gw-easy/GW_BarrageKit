//
//  CALayer+GW_Layer.h
//  GW_Barrage
//
//  Created by gw on 2018/5/16.
//  Copyright © 2018年 gw. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AVKit/AVKit.h>
@interface CALayer (GW_Layer)
- (UIImage *)convertContentToImageWithSize:(CGSize)contentSize;
@end
