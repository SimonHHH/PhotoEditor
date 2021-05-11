//
//  UIImage+HXExtension.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/7.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "UIImage+HXExtension.h"
#import "NSBundle+HXExtension.h"

@implementation UIImage (HXExtension)

+ (CGSize)hx_scaleImageSizeBySize:(CGSize)imageSize targetSize:(CGSize)size isBoth:(BOOL)isBoth {
    
    /** 原图片大小为0 不再往后处理 */
    if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
        return imageSize;
    }
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (isBoth) {
            if(widthFactor > heightFactor){
                scaleFactor = widthFactor;
            }
            else{
                scaleFactor = heightFactor;
            }
        } else {
            if(widthFactor > heightFactor){
                scaleFactor = heightFactor;
            }
            else{
                scaleFactor = widthFactor;
            }
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    return CGSizeMake(ceilf(scaledWidth), ceilf(scaledHeight));
}

- (UIImage*)hx_scaleToFitSize:(CGSize)size {
    if (CGSizeEqualToSize(self.size, size)) {
        return self;
    }
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = roundf(width*radio);
    height = roundf(height*radio);
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

/** 合并图片(图片大小以第一张为准) */
+ (UIImage *)hx_mergeimages:(NSArray <UIImage *>*)images {
    UIGraphicsBeginImageContextWithOptions(images.firstObject.size ,NO, 0);
    for (UIImage *image in images) {
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    }
    UIImage *mergeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return mergeImage;
}

/** 合并图片（图片大小一致） */
- (UIImage *)hx_mergeimages:(NSArray <UIImage *>*)images {
    CGSize size = self.size;
    while (size.width * size.height > 3 * 1000 * 1000) {
        size.width /= 2;
        size.height /= 2;
    }
    UIGraphicsBeginImageContextWithOptions(size ,NO, 0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    for (UIImage *image in images) {
        size = image.size;
        while (size.width * size.height > 3 * 1000 * 1000) {
            size.width /= 2;
            size.height /= 2;
        }
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    }
    UIImage *mergeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return mergeImage;
}

/** 交换宽和高 */
static CGRect swapWidthAndHeight(CGRect rect) {
    CGFloat swap = rect.size.width;
    
    rect.size.width = rect.size.height;
    rect.size.height = swap;
    
    return rect;
}

- (UIImage *)hx_rotationImage:(UIImageOrientation)orient {
    CGRect bnds = CGRectZero;
    UIImage* copy = nil;
    CGContextRef ctxt = nil;
    CGImageRef imag = self.CGImage;
    CGRect rect = CGRectZero;
    CGAffineTransform tran = CGAffineTransformIdentity;
    
    rect.size.width = CGImageGetWidth(imag) * self.scale;
    rect.size.height = CGImageGetHeight(imag) * self.scale;
    
    while (rect.size.width * rect.size.height > 3 * 1000 * 1000) {
        rect.size.width /= 2;
        rect.size.height /= 2;
    }
    
    bnds = rect;
    
    switch (orient)
    {
        case UIImageOrientationUp:
            return self;
            
        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeft:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height,
                                                    rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        default:
            return self;
    }
    
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;
            
        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }
    
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}

- (UIImage *)hx_scaleToFillSize:(CGSize)size {
    if (CGSizeEqualToSize(self.size, size)) {
        return self;
    }
    
    // 创建一个context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *)hx_cropInRect:(CGRect)rect {
    if (CGPointEqualToPoint(CGPointZero, rect.origin) && CGSizeEqualToSize(self.size, rect.size)) {
        return self;
    }
    UIImage *smallImage = nil;
    CGImageRef sourceImageRef = [self CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    if (newImageRef) {
        smallImage = [UIImage imageWithCGImage:newImageRef scale:self.scale orientation:self.imageOrientation];
        CGImageRelease(newImageRef);
    }

    return smallImage;
}


- (UIImage *)hx_normalizedImage {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

+ (UIImage *)hx_imageOfName:(NSString *)imageName {
    if (!imageName) {
        return nil;
    }
    UIImage *image;
    NSBundle *bundle = [NSBundle hx_photoPickerBundle];
    if (bundle) {
        NSString *path = [bundle pathForResource:@"images" ofType:nil];
        path = [path stringByAppendingPathComponent:imageName];
        image = [UIImage imageWithContentsOfFile:path];
    }
    if (!image) {
        image = [self hx_imageOfName:imageName];
    }
    return image;
}

@end
