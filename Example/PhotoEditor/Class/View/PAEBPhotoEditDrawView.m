//
//  PAEBPhotoEditDrawView.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditDrawView.h"
NSString *const kDrawViewData = @"DrawViewData";

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

@end
