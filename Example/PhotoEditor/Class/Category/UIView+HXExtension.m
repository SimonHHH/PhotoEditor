//
//  UIView+HXExtension.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/7.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "UIView+HXExtension.h"

@implementation UIView (HXExtension)

- (void)setHx_x:(CGFloat)hx_x
{
    CGRect frame = self.frame;
    frame.origin.x = hx_x;
    self.frame = frame;
}

- (CGFloat)hx_x
{
    return self.frame.origin.x;
}

- (void)setHx_y:(CGFloat)hx_y
{
    CGRect frame = self.frame;
    frame.origin.y = hx_y;
    self.frame = frame;
}

- (CGFloat)hx_y
{
    return self.frame.origin.y;
}

- (void)setHx_w:(CGFloat)hx_w
{
    CGRect frame = self.frame;
    frame.size.width = hx_w;
    self.frame = frame;
}

- (CGFloat)hx_w
{
    return self.frame.size.width;
}

- (void)setHx_h:(CGFloat)hx_h
{
    CGRect frame = self.frame;
    frame.size.height = hx_h;
    self.frame = frame;
}

- (CGFloat)hx_h
{
    return self.frame.size.height;
}

- (CGFloat)hx_centerX
{
    return self.center.x;
}

- (void)setHx_centerX:(CGFloat)hx_centerX {
    CGPoint center = self.center;
    center.x = hx_centerX;
    self.center = center;
}

- (CGFloat)hx_centerY
{
    return self.center.y;
}

- (void)setHx_centerY:(CGFloat)hx_centerY {
    CGPoint center = self.center;
    center.y = hx_centerY;
    self.center = center;
}

- (void)setHx_size:(CGSize)hx_size
{
    CGRect frame = self.frame;
    frame.size = hx_size;
    self.frame = frame;
}

- (CGSize)hx_size
{
    return self.frame.size;
}

- (void)setHx_origin:(CGPoint)hx_origin
{
    CGRect frame = self.frame;
    frame.origin = hx_origin;
    self.frame = frame;
}

- (CGPoint)hx_origin
{
    return self.frame.origin;
}


- (UIImage *)hx_captureImageAtFrame:(CGRect)rect {
    
    UIImage* image = nil;
    
    if (/* DISABLES CODE */ (YES)) {
        CGSize size = self.bounds.size;
        CGPoint point = self.bounds.origin;
        if (!CGRectEqualToRect(CGRectZero, rect)) {
            size = rect.size;
            point = CGPointMake(-rect.origin.x, -rect.origin.y);
        }
        @autoreleasepool {
            UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
            [self drawViewHierarchyInRect:(CGRect){point, self.bounds.size} afterScreenUpdates:YES];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
    } else {
        
            BOOL translateCTM = !CGRectEqualToRect(CGRectZero, rect);
        
            if (!translateCTM) {
                rect = self.frame;
            }
        
            /** 参数取整，否则可能会出现1像素偏差 */
            /** 有小数部分才调整差值 */
#define lfme_fixDecimal(d) ((fmod(d, (int)d)) > 0.59f ? ((int)(d+0.5)*1.f) : (((fmod(d, (int)d)) < 0.59f && (fmod(d, (int)d)) > 0.1f) ? ((int)(d)*1.f+0.5f) : (int)(d)*1.f))
            rect.origin.x = lfme_fixDecimal(rect.origin.x);
            rect.origin.y = lfme_fixDecimal(rect.origin.y);
            rect.size.width = lfme_fixDecimal(rect.size.width);
            rect.size.height = lfme_fixDecimal(rect.size.height);
#undef lfme_fixDecimal
            CGSize size = rect.size;
        
        @autoreleasepool {
            //1.开启上下文
            UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            if (translateCTM) {
                /** 移动上下文 */
                CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
            }
            //2.绘制图层
            [self.layer renderInContext: context];
            
            //3.从上下文中获取新图片
            image = UIGraphicsGetImageFromCurrentImageContext();
            
            //4.关闭图形上下文
            UIGraphicsEndImageContext();
        }
    }
    return image;
}

/// 根据坐标获取颜色
- (UIColor *)hx_colorOfPoint:(CGPoint)point {
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast);
    
    //旋转变换根据指定的角度来移动坐标空间
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

@end
