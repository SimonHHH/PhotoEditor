//
//  PAEBPhotoEditGridLayer.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/14.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditGridLayer.h"

NSString *const hxGridLayerAnimtionKey = @"hxGridLayerAnimtionKey";

@interface PAEBPhotoEditGridLayer ()<CAAnimationDelegate>
@property (nonatomic, weak) CAShapeLayer *topLeftCornerLayer;
@property (nonatomic, weak) CAShapeLayer *topRightCornerLayer;
@property (nonatomic, weak) CAShapeLayer *bottomLeftCornerLayer;
@property (nonatomic, weak) CAShapeLayer *bottomRightCornerLayer;
@property (nonatomic, weak) CAShapeLayer *middleLineLayer;
@property (nonatomic, copy) void (^callback)(BOOL finished);
@end

@implementation PAEBPhotoEditGridLayer
- (instancetype)init {
    self = [super init];
    if (self) {
        CAShapeLayer *topLeftCornerLayer = [self creatLayer:NO];
        CAShapeLayer *topRightCornerLayer = [self creatLayer:NO];
        CAShapeLayer *bottomLeftCornerLayer = [self creatLayer:NO];
        CAShapeLayer *bottomRightCornerLayer = [self creatLayer:NO];
        CAShapeLayer *middleLineLayer = [self creatLayer:YES];
        [self addSublayer:topLeftCornerLayer];
        [self addSublayer:topRightCornerLayer];
        [self addSublayer:bottomLeftCornerLayer];
        [self addSublayer:bottomRightCornerLayer];
        [self addSublayer:middleLineLayer];
        self.topLeftCornerLayer = topLeftCornerLayer;
        self.topRightCornerLayer = topRightCornerLayer;
        self.bottomLeftCornerLayer = bottomLeftCornerLayer;
        self.bottomRightCornerLayer = bottomRightCornerLayer;
        self.middleLineLayer = middleLineLayer;
        self.contentsScale = [[UIScreen mainScreen] scale];
        _bgColor = [UIColor clearColor];
        _gridColor = [UIColor blackColor];
        self.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
        self.shadowRadius = 2.f;
        self.shadowOffset = CGSizeZero;
        self.shadowOpacity = .5f;
    }
    return self;
}
- (CAShapeLayer *)creatLayer:(BOOL)shadow {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.contentsScale = [[UIScreen mainScreen] scale];
    if (shadow) {
        layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
        layer.shadowRadius = 1.f;
        layer.shadowOffset = CGSizeZero;
        layer.shadowOpacity = .4f;
    }
    return layer;
}

- (void)setGridRect:(CGRect)gridRect {
    [self setGridRect:gridRect animated:NO];
}

- (void)setGridRect:(CGRect)gridRect animated:(BOOL)animated {
    [self setGridRect:gridRect animated:animated completion:nil];
}
- (void)setGridRect:(CGRect)gridRect animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    _gridRect = gridRect;
    if (completion) {
        self.callback = completion;
    }
    
    CGPathRef path = [self drawGrid];
    if (animated) {
        [self setMiddleLine];
        [self setAllCorner:UIRectCornerTopLeft];
        [self setAllCorner:UIRectCornerTopRight];
        [self setAllCorner:UIRectCornerBottomLeft];
        [self setAllCorner:UIRectCornerBottomRight];
        CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"path"];
        animate.duration = 0.25f;
        animate.fromValue = (__bridge id _Nullable)(self.path);
        animate.toValue = (__bridge id _Nullable)(path);
        animate.removedOnCompletion = NO;
        animate.delegate = self;
        self.path = path;
        [self addAnimation:animate forKey:hxGridLayerAnimtionKey];
        
    } else {
        self.topLeftCornerLayer.path = [self setAllCornerPath:UIRectCornerTopLeft].CGPath;
        self.topRightCornerLayer.path = [self setAllCornerPath:UIRectCornerTopRight].CGPath;
        self.bottomLeftCornerLayer.path = [self setAllCornerPath:UIRectCornerBottomLeft].CGPath;
        self.bottomRightCornerLayer.path = [self setAllCornerPath:UIRectCornerBottomRight].CGPath;
        self.middleLineLayer.path = [self setMiddleLinePath].CGPath;
        self.path = path;
        if (self.callback) {
            self.callback(YES);
            self.callback = nil;
        }
    }
    
}

- (UIBezierPath *)setAllCornerPath:(UIRectCorner)rectConrner {
    CGFloat lineWidth = 3.f;
    CGFloat length = 20.f;
    CGFloat margin = lineWidth / 2.f - 0.2f;
    CGRect rct = self.gridRect;
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (rectConrner == UIRectCornerTopLeft) {
        [path moveToPoint:CGPointMake(rct.origin.x + length, rct.origin.y - lineWidth / 2)];
        [path addLineToPoint:CGPointMake(rct.origin.x - margin, rct.origin.y - margin)];
        [path addLineToPoint:CGPointMake(rct.origin.x - margin, rct.origin.y + length)];
    }else if (rectConrner == UIRectCornerTopRight) {
        [path moveToPoint:CGPointMake(CGRectGetMaxX(rct) - length, rct.origin.y - margin)];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rct) + margin, rct.origin.y - margin)];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rct) + margin, rct.origin.y + length)];
    }else if (rectConrner == UIRectCornerBottomLeft) {
        [path moveToPoint:CGPointMake(rct.origin.x - margin, CGRectGetMaxY(rct) - length)];
        [path addLineToPoint:CGPointMake(rct.origin.x - margin, CGRectGetMaxY(rct) + margin)];
        [path addLineToPoint:CGPointMake(rct.origin.x + length, CGRectGetMaxY(rct) + margin)];
    }else if (rectConrner == UIRectCornerBottomRight) {
        [path moveToPoint:CGPointMake(CGRectGetMaxX(rct) - length, CGRectGetMaxY(rct) + margin)];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rct) + margin, CGRectGetMaxY(rct) + margin)];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rct) + margin, CGRectGetMaxY(rct) - length)];
    }
    return path;
}
- (CAAnimation *)setAllCorner:(UIRectCorner)rectConrner {
    CGFloat lineWidth = 2;
    UIBezierPath *path = [self setAllCornerPath:rectConrner];
    CAShapeLayer *layer;
    if (rectConrner == UIRectCornerTopLeft) {
        layer = self.topLeftCornerLayer;
    }else if (rectConrner == UIRectCornerTopRight) {
        layer = self.topRightCornerLayer;
    }else if (rectConrner == UIRectCornerBottomLeft) {
        layer = self.bottomLeftCornerLayer;
    }else if (rectConrner == UIRectCornerBottomRight) {
        layer = self.bottomRightCornerLayer;
    }
    layer.fillColor = self.bgColor.CGColor;
    layer.strokeColor = self.gridColor.CGColor;
    layer.lineWidth = lineWidth;
    
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"path"];
    animate.duration = 0.25f;
    animate.fromValue = (__bridge id _Nullable)(layer.path);
    animate.toValue = (__bridge id _Nullable)(path.CGPath);
    animate.removedOnCompletion = NO;
    layer.path = path.CGPath;
    [layer addAnimation:animate forKey:nil];
    return animate;
}
- (UIBezierPath *)setMiddleLinePath {
    CGRect rct = self.gridRect;
    CGFloat widthMargin = rct.size.width / 3;
    CGFloat heightMargin = rct.size.height / 3;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(rct.origin.x, rct.origin.y + heightMargin)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rct), rct.origin.y + heightMargin)];
    
    [path moveToPoint:CGPointMake(rct.origin.x, rct.origin.y + heightMargin * 2)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rct), rct.origin.y + heightMargin * 2)];
    
    [path moveToPoint:CGPointMake(rct.origin.x + widthMargin, rct.origin.y)];
    [path addLineToPoint:CGPointMake(rct.origin.x + widthMargin, CGRectGetMaxY(rct))];
    
    [path moveToPoint:CGPointMake(rct.origin.x + widthMargin * 2, rct.origin.y)];
    [path addLineToPoint:CGPointMake(rct.origin.x + widthMargin * 2, CGRectGetMaxY(rct))];
    return path;
}
- (CAAnimation *)setMiddleLine {
    self.middleLineLayer.fillColor = self.bgColor.CGColor;
    self.middleLineLayer.strokeColor = self.gridColor.CGColor;
    self.middleLineLayer.lineWidth = 0.5f;
    UIBezierPath *path = [self setMiddleLinePath];

    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"path"];
    animate.duration = 0.25f;
    animate.fromValue = (__bridge id _Nullable)(self.middleLineLayer.path);
    animate.toValue = (__bridge id _Nullable)(path.CGPath);
    animate.removedOnCompletion = NO;
    self.middleLineLayer.path = path.CGPath;
    
    [self.middleLineLayer addAnimation:animate forKey:nil];
    return animate;
}

- (CGPathRef)drawGrid {
    self.fillColor = self.bgColor.CGColor;
    self.strokeColor = self.gridColor.CGColor;
    self.lineWidth = 1;
//    self.borderWidth = 1.5f;
    CGRect rct = self.gridRect;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rct];
    return path.CGPath;
}
- (void)layoutSublayers {
    [super layoutSublayers];
    
    self.topLeftCornerLayer.frame = self.frame;
    self.topRightCornerLayer.frame = self.frame;
    self.bottomLeftCornerLayer.frame = self.frame;
    self.bottomRightCornerLayer.frame = self.frame;
    self.middleLineLayer.frame = self.frame;
}

- (void)setCornerLayerHidden:(BOOL)isHidden {
    
}

#pragma mark <CAAnimationDelegate>
- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([self animationForKey:hxGridLayerAnimtionKey] == anim) {
        if (self.callback) {
            self.callback(flag);
            self.callback = nil;
        }
        [self removeAnimationForKey:hxGridLayerAnimtionKey];
    }
}
@end
