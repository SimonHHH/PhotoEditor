//
//  PAEBPhotoEditGridLayer.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/14.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface PAEBPhotoEditGridLayer : CAShapeLayer

@property (nonatomic, assign) CGRect gridRect;
- (void)setGridRect:(CGRect)gridRect animated:(BOOL)animated;
- (void)setGridRect:(CGRect)gridRect animated:(BOOL)animated completion:(void (^ _Nullable)(BOOL finished))completion;
@property (nonatomic, assign) BOOL isRound;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIColor *gridColor;
@end

NS_ASSUME_NONNULL_END
