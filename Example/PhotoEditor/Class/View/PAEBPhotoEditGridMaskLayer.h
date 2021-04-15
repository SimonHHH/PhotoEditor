//
//  PAEBPhotoEditGridMaskLayer.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/14.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface PAEBPhotoEditGridMaskLayer : CAShapeLayer

/** 遮罩颜色 */
@property (nonatomic, assign) CGColorRef maskColor;
@property (nonatomic, assign) BOOL isRound;
/** 遮罩范围 */
@property (nonatomic, assign, setter=setMaskRect:) CGRect maskRect;
- (void)setMaskRect:(CGRect)maskRect animated:(BOOL)animated;
/** 取消遮罩 */
- (void)clearMask;
- (void)clearMaskWithAnimated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
