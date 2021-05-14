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
@property (nonatomic, assign) CGFloat hx_x;
@property (nonatomic, assign) CGFloat hx_y;
@property (nonatomic, assign) CGFloat hx_w;
@property (nonatomic, assign) CGFloat hx_h;
@property (nonatomic, assign) CGFloat hx_centerX;
@property (nonatomic, assign) CGFloat hx_centerY;
@property (nonatomic, assign) CGSize hx_size;
@property (nonatomic, assign) CGPoint hx_origin;
@property (nonatomic, assign, readonly) CGFloat hx_maxX;
@property (nonatomic, assign, readonly) CGFloat hx_maxY;


- (UIImage *)hx_captureImageAtFrame:(CGRect)rect;

/// 根据坐标获取颜色
- (UIColor *)hx_colorOfPoint:(CGPoint)point;
@end

NS_ASSUME_NONNULL_END
