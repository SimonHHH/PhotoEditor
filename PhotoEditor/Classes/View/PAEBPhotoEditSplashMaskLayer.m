//
//  PAEBPhotoEditSplashMaskLayer.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/14.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditSplashMaskLayer.h"
#import "UIImage+HXExtension.h"

#define PAEBRadiansToDegrees(x) (180.0 * x / M_PI)

CGFloat angleBetweenPoints(CGPoint startPoint, CGPoint endPoint) {
    CGPoint Xpoint = CGPointMake(startPoint.x + 100, startPoint.y);
    
    CGFloat a = endPoint.x - startPoint.x;
    CGFloat b = endPoint.y - startPoint.y;
    CGFloat c = Xpoint.x - startPoint.x;
    CGFloat d = Xpoint.y - startPoint.y;
    
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    
    if (startPoint.y>endPoint.y) {
        rads = -rads;
    }
    return rads;
}

CGFloat angleBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End) {
    
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    
    return PAEBRadiansToDegrees(rads);
}

@implementation PAEBPhotoEditSplashBlur

@end

@implementation PAEBPhotoEditSplashImageBlur

@end
@interface PAEBPhotoEditSplashMaskLayer ()

@end

@implementation PAEBPhotoEditSplashMaskLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentsScale = [[UIScreen mainScreen] scale];
        self.backgroundColor = [UIColor clearColor].CGColor;
        _lineArray = [NSMutableArray array];
    }
    return self;
}


- (void)drawInContext:(CGContextRef)context {
    UIGraphicsPushContext(context);
    
    [[UIColor clearColor] setFill];
    UIRectFill(self.bounds);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    for (NSInteger i = 0; i < self.lineArray.count; i++) {
        PAEBPhotoEditSplashBlur *blur = self.lineArray[i];
        CGRect rect = blur.rect;
        
        CGContextSetStrokeColorWithColor(context, (blur.color ? blur.color.CGColor : [UIColor clearColor].CGColor));
        
        // 模糊矩形可以用到，用于填充矩形
        CGContextSetFillColorWithColor(context, (blur.color ? blur.color.CGColor : [UIColor clearColor].CGColor));
        
        if ([blur isMemberOfClass:[PAEBPhotoEditSplashImageBlur class]]) {
            
            UIImage *image = [UIImage hx_imageOfName:((PAEBPhotoEditSplashImageBlur *)blur).imageName];
            
            if (image) {
//                CGPoint firstPoint = CGPointZero;
//                if (i > 0) {
//                    HXPhotoEditSplashBlur *prevBlur = self.lineArray[i-1];
//                    firstPoint = prevBlur.rect.origin;
//                }
                /** 创建颜色图片 */
                CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
                CGContextRef contextRef = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, image.size.width*4, colorRef, kCGImageAlphaPremultipliedFirst);
                
                CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
                CGContextClipToMask(contextRef, imageRect, image.CGImage);
                CGContextSetFillColorWithColor(contextRef, (blur.color ? blur.color.CGColor : [UIColor clearColor].CGColor));
                CGContextFillRect(contextRef,imageRect);
                
                /** 生成图片 */
                CGImageRef imageRef = CGBitmapContextCreateImage(contextRef);
                
                CGContextDrawImage(context, rect, imageRef);
                
                CGImageRelease(imageRef);
                CGContextRelease(contextRef);
                CGColorSpaceRelease(colorRef);
            }
            
        } else {
            // 模糊矩形  填充 画完一个小正方形
            CGContextFillRect(context, rect);
        }
    }
    
    UIGraphicsPopContext();
}

@end
