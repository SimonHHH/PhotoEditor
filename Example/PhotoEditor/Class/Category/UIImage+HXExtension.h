//
//  UIImage+HXExtension.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/7.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (HXExtension)
+ (CGSize)hx_scaleImageSizeBySize:(CGSize)imageSize targetSize:(CGSize)size isBoth:(BOOL)isBoth;
- (UIImage *)hx_scaleToFitSize:(CGSize)size;

/// 合并图片(图片大小以第一张为准)
+ (UIImage *)hx_mergeimages:(NSArray <UIImage *>*)images;
/** 合并图片（图片大小一致） */
- (UIImage *)hx_mergeimages:(NSArray <UIImage *>*)images;

- (UIImage *)hx_rotationImage:(UIImageOrientation)orient;

- (UIImage *)hx_scaleToFillSize:(CGSize)size;

- (UIImage *)hx_cropInRect:(CGRect)rect;

- (UIImage *)hx_roundClipingImage;

- (UIImage *)hx_normalizedImage;

+ (UIImage *)hx_imageOfName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
