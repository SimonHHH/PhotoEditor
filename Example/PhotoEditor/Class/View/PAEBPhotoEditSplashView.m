//
//  PAEBPhotoEditSplashView.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditSplashView.h"
#import "PAEBPhotoEditSplashMaskLayer.h"
#import "UIImage+HXExtension.h"

NSString *const kHXSplashViewData = @"HXSplashViewData";
NSString *const kHXSplashViewData_layerArray = @"HXSplashViewData_layerArray";
NSString *const kHXSplashViewData_frameArray = @"HXSplashViewData_frameArray";

@interface PAEBPhotoEditSplashView () {
    BOOL _isWork;
    BOOL _isBegan;
}
/** 图层 */
@property (nonatomic, strong) NSMutableArray <PAEBPhotoEditSplashMaskLayer *>*layerArray;
/** 已显示坐标 */
@property (nonatomic, strong) NSMutableArray <NSValue *>*frameArray;

@property (nonatomic, assign) BOOL isErase;
/** 方形大小 */
@property (nonatomic, assign) CGFloat squareWidth;
/** 画笔大小 */
@property (nonatomic, assign) CGSize paintSize;
@end

@implementation PAEBPhotoEditSplashView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}
- (CGSize)paintSize {
    return CGSizeMake(50.f / self.screenScale, 50.f / self.screenScale);
}
- (CGFloat)squareWidth {
    return _squareWidth / self.screenScale;
}
- (void)customInit {
    self.exclusiveTouch = YES;
    _squareWidth = 10.f;
    _paintSize = CGSizeMake(50, 50);
    _state = PAEBPhotoEditSplashStateType_Mosaic;
    _layerArray = [NSMutableArray array];
    _frameArray = [NSMutableArray array];
    self.screenScale = 1;
}

- (CGPoint)divideMosaicPoint:(CGPoint)point {
    CGFloat scope = self.squareWidth;
    int x = point.x/scope;
    int y = point.y/scope;
    return CGPointMake(x*scope, y*scope);
}

- (NSArray <NSValue *>*)divideMosaicRect:(CGRect)rect {
    CGFloat scope = self.squareWidth;
    
    NSMutableArray *array = @[].mutableCopy;
    
    if (CGRectEqualToRect(CGRectZero, rect)) {
        return array;
    }
    
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    
    /** 左上角 */
    CGPoint leftTop = [self divideMosaicPoint:CGPointMake(minX, minY)];
    /** 右下角 */
    CGPoint rightBoom = [self divideMosaicPoint:CGPointMake(maxX, maxY)];
    
    NSInteger countX = (rightBoom.x - leftTop.x)/scope;
    NSInteger countY = (rightBoom.y - leftTop.y)/scope;
    
    for (NSInteger i = 0; i < countX; i++) {
        for (NSInteger j = 0; j < countY;  j++) {
            CGPoint point = CGPointMake(leftTop.x + i * scope, leftTop.y + j * scope);
            NSValue *value = [NSValue valueWithCGPoint:point];
            [array addObject:value];
        }
    }
    
    return array;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touches.allObjects.count == 1) {
        _isWork = NO;
        _isBegan = YES;
        
        //1、触摸坐标
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        //2、创建LFSplashBlur
        if (self.state == PAEBPhotoEditSplashStateType_Mosaic) {
            CGPoint mosaicPoint = [self divideMosaicPoint:point];
            NSValue *value = [NSValue valueWithCGPoint:mosaicPoint];
            if (![self.frameArray containsObject:value]) {
                [self.frameArray addObject:value];
                
                PAEBPhotoEditSplashBlur *blur = [PAEBPhotoEditSplashBlur new];
                blur.rect = CGRectMake(mosaicPoint.x, mosaicPoint.y, self.squareWidth, self.squareWidth);
                if (self.splashColor) {
                    blur.color = self.splashColor(blur.rect.origin);
                }
//                blur.color = self.splashColor ? self.splashColor(blur.rect.origin) : nil;
                
                PAEBPhotoEditSplashMaskLayer *layer = [PAEBPhotoEditSplashMaskLayer layer];
                layer.frame = self.bounds;
                [layer.lineArray addObject:blur];
                
                [self.layer addSublayer:layer];
                [self.layerArray addObject:layer];
            } else {
                PAEBPhotoEditSplashMaskLayer *layer = [PAEBPhotoEditSplashMaskLayer layer];
                layer.frame = self.bounds;
                
                [self.layer addSublayer:layer];
                [self.layerArray addObject:layer];
            }
        }
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touches.allObjects.count == 1) {
        //1、触摸坐标
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        if (_isBegan && self.splashBegan) self.splashBegan();
        _isWork = YES;
        _isBegan = NO;
        /** 获取上一个对象坐标判断是否重叠 */
        PAEBPhotoEditSplashMaskLayer *layer = self.layerArray.lastObject;
        
        if (self.state == PAEBPhotoEditSplashStateType_Mosaic) {
            CGPoint mosaicPoint = [self divideMosaicPoint:point];
            NSValue *value = [NSValue valueWithCGPoint:mosaicPoint];
            if (![self.frameArray containsObject:value]) {
                [self.frameArray addObject:value];
                //2、创建LFSplashBlur
                PAEBPhotoEditSplashBlur *blur = [PAEBPhotoEditSplashBlur new];
                blur.rect = CGRectMake(mosaicPoint.x, mosaicPoint.y, self.squareWidth, self.squareWidth);
                if (self.splashColor) {
                    blur.color = self.splashColor(blur.rect.origin);
                }
//                blur.color = self.splashColor ? self.splashColor(blur.rect.origin) : nil;
                
                [layer.lineArray addObject:blur];
                [layer setNeedsDisplay];
            }
        }
    } else {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([event allTouches].count == 1){
        if (_isWork) {
            if (self.splashEnded) self.splashEnded();
            PAEBPhotoEditSplashMaskLayer *layer = self.layerArray.lastObject;
            if (layer.lineArray.count == 0) {
                [self undo];
            }
        } else {
            [self undo];
        }
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([event allTouches].count == 1){
        if (_isWork) {
            if (self.splashEnded) self.splashEnded();
            PAEBPhotoEditSplashMaskLayer *layer = self.layerArray.lastObject;
            if (layer.lineArray.count == 0) {
                [self undo];
            }
        } else {
            [self undo];
        }
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

/** 是否可撤销 */
- (BOOL)canUndo {
    return self.layerArray.count;
}

//撤销
- (void)undo {
    PAEBPhotoEditSplashMaskLayer *layer = self.layerArray.lastObject;
    if ([layer.lineArray.firstObject isMemberOfClass:[PAEBPhotoEditSplashBlur class]]) {
        for (PAEBPhotoEditSplashBlur *blur in layer.lineArray) {
            [self.frameArray removeObject:[NSValue valueWithCGPoint:blur.rect.origin]];
        }
    }
    [layer removeFromSuperlayer];
    [self.layerArray removeLastObject];
}

- (void)clearCoverage {
    for (PAEBPhotoEditSplashMaskLayer *layer in self.layerArray) {
        if ([layer.lineArray.firstObject isMemberOfClass:[PAEBPhotoEditSplashBlur class]]) {
            for (PAEBPhotoEditSplashBlur *blur in layer.lineArray) {
                [self.frameArray removeObject:[NSValue valueWithCGPoint:blur.rect.origin]];
            }
        }
        [layer removeFromSuperlayer];
    }
    [self.layerArray removeAllObjects];
    [self.frameArray removeAllObjects];
}
#pragma mark  - 数据
- (NSDictionary *)data {
    if (self.layerArray.count) {
        NSMutableArray *lineArray = [@[] mutableCopy];
        for (PAEBPhotoEditSplashMaskLayer *layer in self.layerArray) {
            [lineArray addObject:layer.lineArray];
        }
        
        return @{kHXSplashViewData:@{
                         kHXSplashViewData_layerArray:[lineArray copy],
                         kHXSplashViewData_frameArray:[self.frameArray copy]
                         }};
    }
    return nil;
}

- (void)setData:(NSDictionary *)data {
    NSDictionary *dataDict = data[kHXSplashViewData];
    NSArray *lineArray = dataDict[kHXSplashViewData_layerArray];
    for (NSArray *subLineArray in lineArray) {
        PAEBPhotoEditSplashMaskLayer *layer = [PAEBPhotoEditSplashMaskLayer layer];
        layer.frame = self.bounds;
        [layer.lineArray addObjectsFromArray:subLineArray];
        
        [self.layer addSublayer:layer];
        [self.layerArray addObject:layer];
        [layer setNeedsDisplay];
    }
    NSArray *frameArray = dataDict[kHXSplashViewData_frameArray];
    [self.frameArray addObjectsFromArray:frameArray];
}

@end
