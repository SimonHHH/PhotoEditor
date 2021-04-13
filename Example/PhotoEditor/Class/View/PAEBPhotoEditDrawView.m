//
//  PAEBPhotoEditDrawView.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditDrawView.h"
NSString *const kPAEBDrawViewData = @"kPAEBDrawViewData";

@interface PAEBDrawBezierPath : UIBezierPath
@property (strong, nonatomic) UIColor *color;
@end

@implementation PAEBDrawBezierPath
@end

@interface PAEBPhotoEditDrawView ()
/// 笔画
@property (strong, nonatomic) NSMutableArray <PAEBDrawBezierPath *>*lineArray;
/// 图层
@property (strong, nonatomic) NSMutableArray <CAShapeLayer *>*slayerArray;
@property (assign, nonatomic) BOOL isWork;
@property (assign, nonatomic) BOOL isBegan;
@end


@implementation PAEBPhotoEditDrawView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lineWidth = 5.f;
        self.lineColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.exclusiveTouch = YES;
        self.lineArray = [NSMutableArray array];
        self.slayerArray = [NSMutableArray array];
        self.enabled = YES;
        self.screenScale = 1;
    }
    return self;
}

- (CAShapeLayer *)createShapeLayer:(PAEBDrawBezierPath *)path {
    CAShapeLayer *slayer = [CAShapeLayer layer];
    slayer.path = path.CGPath;
    slayer.backgroundColor = [UIColor clearColor].CGColor;
    slayer.fillColor = [UIColor clearColor].CGColor;
    slayer.lineCap = kCALineCapRound;
    slayer.lineJoin = kCALineJoinRound;
    slayer.strokeColor = path.color.CGColor;
    slayer.lineWidth = path.lineWidth;
    return slayer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([event allTouches].count == 1 && self.enabled) {
        self.isWork = NO;
        self.isBegan = YES;
        PAEBDrawBezierPath *path = [[PAEBDrawBezierPath alloc] init];
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        path.lineWidth = self.lineWidth;
        path.lineCapStyle = kCGLineCapRound;
        path.lineJoinStyle = kCGLineJoinRound;
        [path moveToPoint:point];
        path.color = self.lineColor;
        [self.lineArray addObject:path];
        
        CAShapeLayer *slayer = [self createShapeLayer:path];
        [self.layer addSublayer:slayer];
        [self.slayerArray addObject:slayer];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([event allTouches].count == 1 && self.enabled){
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        PAEBDrawBezierPath *path = self.lineArray.lastObject;
        if (!CGPointEqualToPoint(path.currentPoint, point)) {
            if (self.beganDraw) {
                self.beganDraw();
            }
            self.isBegan = NO;
            self.isWork = YES;
            [path addLineToPoint:point];
            CAShapeLayer *slayer = self.slayerArray.lastObject;
            slayer.path = path.CGPath;
        }
    } else {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    if ([event allTouches].count == 1 && self.enabled){
        if (self.isWork) {
            if (self.endDraw) {
                self.endDraw();
            }
        } else {
            [self undo];
        }
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}


- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([event allTouches].count == 1 && self.enabled){
        if (self.isWork) {
            if (self.endDraw) {
                self.endDraw();
            }
        } else {
            [self undo];
        }
    } else {
        [super touchesCancelled:touches withEvent:event];
    }
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
}

- (BOOL)canUndo {
    return self.lineArray.count;
}

- (void)undo {
    [self.slayerArray.lastObject removeFromSuperlayer];
    [self.slayerArray removeLastObject];
    [self.lineArray removeLastObject];
}
- (BOOL)isDrawing {
    if (!self.userInteractionEnabled || !self.enabled) {
        return NO;
    }
    return _isWork;
}

/** 图层数量 */
- (NSUInteger)count {
    return self.lineArray.count;
}

- (void)clearCoverage {
    [self.lineArray removeAllObjects];
    [self.slayerArray performSelector:@selector(removeFromSuperlayer)];
    [self.slayerArray removeAllObjects];
}

#pragma mark  - 数据
- (NSDictionary *)data {
    if (self.lineArray.count) {
        return @{kPAEBDrawViewData:[self.lineArray copy]};
    }
    return nil;
}

- (void)setData:(NSDictionary *)data {
    NSArray *lineArray = data[kPAEBDrawViewData];
    if (lineArray.count) {
        for (PAEBDrawBezierPath *path in lineArray) {
            CAShapeLayer *slayer = [self createShapeLayer:path];
            [self.layer addSublayer:slayer];
            [self.slayerArray addObject:slayer];
        }
        [self.lineArray addObjectsFromArray:lineArray];
    }
}

@end
