//
//  UIView+HXExtension.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/7.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HXExtension)
@property (assign, nonatomic) CGFloat hx_x;
@property (assign, nonatomic) CGFloat hx_y;
@property (assign, nonatomic) CGFloat hx_w;
@property (assign, nonatomic) CGFloat hx_h;
@property (assign, nonatomic) CGFloat hx_centerX;
@property (assign, nonatomic) CGFloat hx_centerY;
@property (assign, nonatomic) CGSize hx_size;
@property (assign, nonatomic) CGPoint hx_origin;


- (UIImage *)hx_captureImageAtFrame:(CGRect)rect;

/// 根据坐标获取颜色
- (UIColor *)hx_colorOfPoint:(CGPoint)point;
@end

NS_ASSUME_NONNULL_END
