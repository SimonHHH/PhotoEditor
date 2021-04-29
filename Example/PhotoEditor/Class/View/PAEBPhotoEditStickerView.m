//
//  PAEBPhotoEditStickerView.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditStickerView.h"
#import "PAEBPhotoEditStickerItem.h"
#import "PAEBPhotoEditStickerItemView.h"
#import "PAEBPhotoEditStickerItemContentView.h"
#import "PAEBPhotoEditDefine.h"
#import "PAEBPhotoEditStickerTrashView.h"
#import "UIView+HXExtension.h"
#import "PAEBPhotoEditTextView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PAEBPhotoClippingView.h"


NSString *const kPAEBStickerViewData_angel = @"HXStickerViewData_angel";

NSString *const kPAEBStickerViewData_movingView = @"HXStickerViewData_movingView";
NSString *const kPAEBStickerViewData_movingView_content = @"HXStickerViewData_movingView_content";
NSString *const kPAEBStickerViewData_movingView_center = @"HXStickerViewData_movingView_center";
NSString *const kPAEBStickerViewData_movingView_scale = @"HXStickerViewData_movingView_scale";
NSString *const kPAEBStickerViewData_movingView_rotation = @"HXStickerViewData_movingView_rotation";
NSString *const kPAEBStickerViewData_movingView_superAngel = @"HXStickerViewData_movingView_superAngel";

@interface PAEBPhotoEditStickerView ()
@property (nonatomic, weak) PAEBPhotoEditStickerItemView *selectItemView;
@property (nonatomic, strong) PAEBPhotoEditStickerTrashView *transhView;
@property (nonatomic, assign) BOOL hasImpactFeedback;
@property (nonatomic, assign) BOOL addWindowCompletion;
@property (nonatomic, assign) BOOL transhViewIsVisible;
@property (nonatomic, assign) BOOL transhViewDidRemove;
@property (nonatomic, assign) BOOL touching;
@property (nonatomic, assign) CGFloat currentItemDegrees;
@property (nonatomic, assign) CGFloat currentItemArg;
@property (nonatomic, assign) CGFloat beforeItemArg;
@end

@implementation PAEBPhotoEditStickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        _screenScale = 1;
    }
    return self;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (self.touching) {
        return view;
    }
    if ([view isKindOfClass:[PAEBPhotoEditStickerItemContentView class]]) {
        if (self.selectItemView) {
            CGRect rect = self.selectItemView.frame;
            // 贴图事件范围增大，便于在过小情况下可以放大
            rect = CGRectMake(rect.origin.x - 35, rect.origin.y - 35, rect.size.width + 70, rect.size.height + 70);
            if (CGRectContainsPoint(rect, point)) {
                self.hitTestSubView = YES;
                return self.selectItemView.contentView;
            }
        }
        PAEBPhotoEditStickerItemView *itemView = (PAEBPhotoEditStickerItemView *)view.superview;
        if (itemView != self.selectItemView) {
            self.selectItemView.isSelected = NO;
            self.selectItemView = nil;
        }
        itemView.isSelected = YES;
        [self bringSubviewToFront:itemView];
        [itemView resetRotation];
        self.selectItemView = itemView;
    }else {
        if (self.selectItemView) {
            CGRect rect = self.selectItemView.frame;
            // 贴图事件范围增大，便于在过小情况下可以放大
            rect = CGRectMake(rect.origin.x - 35, rect.origin.y - 35, rect.size.width + 70, rect.size.height + 70);
            if (CGRectContainsPoint(rect, point)) {
                self.hitTestSubView = YES;
                return self.selectItemView.contentView;
            }
        }
        self.selectItemView.isSelected = NO;
        self.selectItemView = nil;
    }
    self.hitTestSubView = [view isDescendantOfView:self];
    return (view == self ? nil : view);
}

- (PAEBPhotoEditStickerItemView *)addStickerItem:(PAEBPhotoEditStickerItem *)item isSelected:(BOOL)selected {
    self.selectItemView.isSelected = NO;
    PAEBPhotoEditStickerItemView *itemView = [[PAEBPhotoEditStickerItemView alloc] initWithItem:item screenScale:self.screenScale];
    HXWeakSelf
    itemView.getConfiguration = ^PAEBPhotoEditConfiguration * _Nonnull{
        return weakSelf.configuration;
    };
    if (self.moveCenter) {
        itemView.moveCenter = ^BOOL(CGRect rect) {
            return weakSelf.moveCenter(rect);
        };
    }
    itemView.shouldTouchBegan = ^BOOL(PAEBPhotoEditStickerItemView * _Nonnull view) {
        if (weakSelf.selectItemView && view != weakSelf.selectItemView) {
            return NO;
        }
        return YES;
    };
    itemView.tapNotInScope = ^(PAEBPhotoEditStickerItemView * _Nonnull view, CGPoint point) {
        if (weakSelf.selectItemView == view) {
            weakSelf.selectItemView = nil;
            point = [view convertPoint:point toView:weakSelf];
            for (PAEBPhotoEditStickerItemView *itemView in weakSelf.subviews) {
                if ([itemView isKindOfClass:[PAEBPhotoEditStickerItemView class]]) {
                    if (CGRectContainsPoint(itemView.frame, point)) {
                        itemView.isSelected = YES;
                        weakSelf.selectItemView = itemView;
                        [weakSelf bringSubviewToFront:itemView];
                        [itemView resetRotation];
                        return;
                    }
                }
            }
        }
    };
    itemView.touchBegan = ^(PAEBPhotoEditStickerItemView * _Nonnull itemView) {
        weakSelf.touching = YES;
        if (weakSelf.touchBegan) {
            weakSelf.touchBegan(itemView);
        }
        if (!weakSelf.selectItemView) {
            weakSelf.selectItemView =  itemView;
        }else if (weakSelf.selectItemView != itemView) {
            weakSelf.selectItemView.isSelected = NO;
            weakSelf.selectItemView =  itemView;
        }
        if (!weakSelf.addWindowCompletion) {
            [weakSelf windowAddItemView:itemView];
        }
        if (!weakSelf.transhViewIsVisible) {
            weakSelf.transhViewIsVisible = YES;
            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.transhView];
            [weakSelf showTranshView];
        }
    };
    itemView.panChanged = ^(UIPanGestureRecognizer * _Nonnull pan) {
        if (!weakSelf.transhViewDidRemove) {
            if (!weakSelf.transhViewIsVisible) {
                weakSelf.transhViewIsVisible = YES;
                [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.transhView];
                [weakSelf showTranshView];
            }else {
                if (weakSelf.transhView.hx_y != HX_ScreenHeight - weakSelf.transhView.hx_h ||
                    weakSelf.transhView.alpha == 0) {
                    [weakSelf showTranshView];
                }else if (!weakSelf.transhView.superview) {
                    [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.transhView];
                    [weakSelf showTranshView];
                }
            }
        }
        CGPoint point = [pan locationInView:[UIApplication sharedApplication].keyWindow];
        if (CGRectContainsPoint(weakSelf.transhView.frame, point) && !weakSelf.transhViewDidRemove) {
            weakSelf.transhView.inArea = YES;
            if (!weakSelf.hasImpactFeedback) {
                [UIView animateWithDuration:0.2 animations:^{
                    weakSelf.selectItemView.alpha = 0.4;
                }];
                [weakSelf performSelector:@selector(hideTranshView) withObject:nil afterDelay:1.2f];
                if (@available(iOS 10.0, *)){
                    UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
                    [feedBackGenertor impactOccurred];
                }
                weakSelf.hasImpactFeedback = YES;
            }
        }else {
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.selectItemView.alpha = 1.f;
            }];
            [UIView cancelPreviousPerformRequestsWithTarget:weakSelf];
            weakSelf.hasImpactFeedback = NO;
            weakSelf.transhView.inArea = NO;
        }
    };
    itemView.panEnded = ^BOOL(PAEBPhotoEditStickerItemView * _Nonnull itemView) {
        BOOL inArea = weakSelf.transhView.inArea;
        if (inArea) {
            weakSelf.addWindowCompletion = NO;
            weakSelf.transhView.inArea = NO;
            [UIView animateWithDuration:0.25 animations:^{
                itemView.alpha = 0;
            } completion:^(BOOL finished) {
                [itemView removeFromSuperview];
            }];
            weakSelf.selectItemView = nil;
        }else {
            if (!weakSelf.selectItemView) {
                weakSelf.selectItemView =  itemView;
            }else if (weakSelf.selectItemView != itemView) {
                weakSelf.selectItemView.isSelected = NO;
                weakSelf.selectItemView =  itemView;
            }
            [weakSelf resetItemView:itemView];
        }
        if (weakSelf.addWindowCompletion) {
            [weakSelf hideTranshView];
        }
        return inArea;
    };
    itemView.touchEnded = ^(PAEBPhotoEditStickerItemView * _Nonnull itemView) {
        if (weakSelf.touchEnded) {
            weakSelf.touchEnded(itemView);
        }
        if (!weakSelf.selectItemView) {
            weakSelf.selectItemView =  itemView;
        }else if (weakSelf.selectItemView != itemView) {
            weakSelf.selectItemView.isSelected = NO;
            weakSelf.selectItemView =  itemView;
        }
        [weakSelf resetItemView:itemView];
        if (weakSelf.transhView.alpha == 1) {
            [weakSelf hideTranshView];
        }
        weakSelf.touching = NO;
    };
    /** 屏幕缩放率 */
    itemView.screenScale = self.screenScale;
    itemView.getMinScale = self.getMinScale;
    itemView.getMaxScale = self.getMaxScale;
    CGFloat scale;
    if (!item.textModel) {
        CGFloat ratio = 0.5f;
        CGFloat width = self.hx_w * self.screenScale;
        CGFloat height = self.hx_h * self.screenScale;
        if (width > HX_ScreenWidth) {
            width = HX_ScreenWidth;
        }
        if (height > HX_ScreenHeight) {
            height = HX_ScreenHeight;
        }
        scale = MIN( (ratio * width) / itemView.frame.size.width, (ratio * height) / itemView.frame.size.height);
    }else {
        scale = MIN( MIN(self.hx_w  * self.screenScale - 40, itemView.hx_w) / itemView.hx_w , MIN(self.hx_h * self.screenScale - 40, itemView.hx_h) / itemView.hx_h);
    }
    itemView.superAngle = self.angle;
    // 旋转后，需要处理弧度的变化
    CGFloat radians = [self currentAngleRadians];
    radians = -radians;
    itemView.isSelected = selected;
    itemView.center = [self convertPoint:[UIApplication sharedApplication].keyWindow.center fromView:(UIView *)[UIApplication sharedApplication].keyWindow];
    itemView.firstTouch = selected;
    [self addSubview:itemView];
    [itemView setScale:scale / self.screenScale rotation:radians isInitialize:NO isPinch:NO];
    if (selected) {
        self.selectItemView = itemView;
    }
    return itemView;
}
- (void)resetItemView:(PAEBPhotoEditStickerItemView *)itemView {
    if (self.addWindowCompletion) {
        self.addWindowCompletion = NO;
        CGRect rect = [[UIApplication sharedApplication].keyWindow convertRect:itemView.frame toView:self];
        itemView.frame = rect;
        [self addSubview:itemView];
        [itemView setScale:itemView.scale rotation:itemView.arg - self.currentItemDegrees isInitialize:NO isPinch:NO];
    }
}

- (CGFloat)currentAngleRadians {
    CGFloat angleInRadians = 0.0f;
    switch (self.angle) {
        case 90:    angleInRadians = M_PI_2;            break;
        case -90:   angleInRadians = -M_PI_2;           break;
        case 180:   angleInRadians = M_PI;              break;
        case -180:  angleInRadians = -M_PI;             break;
        case 270:   angleInRadians = (M_PI + M_PI_2);   break;
        case -270:  angleInRadians = -(M_PI + M_PI_2);  break;
        default:                                        break;
    }
    return angleInRadians;
}
- (void)windowAddItemView:(PAEBPhotoEditStickerItemView *)itemView {
    self.beforeItemArg = itemView.arg;
    self.addWindowCompletion = YES;
    // 旋转后，需要处理弧度的变化
    CGFloat radians = [self currentAngleRadians];
    self.currentItemDegrees = radians;
    
    CGRect rect = [self convertRect:itemView.frame toView:[UIApplication sharedApplication].keyWindow];
    itemView.frame = rect;
    [[UIApplication sharedApplication].keyWindow addSubview:itemView];
    
    [itemView setScale:itemView.scale rotation:itemView.arg + radians isInitialize:NO isPinch:NO];
    self.currentItemArg = itemView.arg;
}

- (PAEBPhotoEditStickerTrashView *)transhView {
    if (!_transhView) {
        _transhView = [PAEBPhotoEditStickerTrashView initView];
        _transhView.hx_y = HX_ScreenHeight;
        _transhView.alpha = 0;
    }
    return _transhView;
}

- (void)showTranshView {
    self.transhViewDidRemove = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.transhView.hx_y = HX_ScreenHeight - self.transhView.hx_h;
        self.transhView.alpha = 1;
    }];
}
- (void)hideTranshView {
    self.transhViewIsVisible = NO;
    self.transhViewDidRemove = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.transhView.hx_y = HX_ScreenHeight;
        self.transhView.alpha = 0;
        self.selectItemView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.transhView removeFromSuperview];
        self.transhView.inArea = NO;
    }];
}

- (BOOL)isEnable {
    return self.isHitTestSubView && self.selectItemView.isSelected;
}

- (void)removeSelectItem {
    self.selectItemView.isSelected = NO;
    self.selectItemView = nil;
}

/** 贴图数量 */
- (NSUInteger)count {
    return self.subviews.count;
}

- (void)setScreenScale:(CGFloat)screenScale {
    if (screenScale > 0) {
        _screenScale = screenScale;
        for (PAEBPhotoEditStickerItemView *subView in self.subviews) {
            if ([subView isKindOfClass:[PAEBPhotoEditStickerItemView class]]) {
                subView.screenScale = screenScale;
            }
        }
    }
}

- (void)setMoveCenter:(BOOL (^)(CGRect))moveCenter {
    _moveCenter = moveCenter;
    for (PAEBPhotoEditStickerItemView *subView in self.subviews) {
        if ([subView isKindOfClass:[PAEBPhotoEditStickerItemView class]]) {
            if (moveCenter) {
                HXWeakSelf
                [subView setMoveCenter:^BOOL (CGRect rect) {
                    return weakSelf.moveCenter(rect);
                }];
            } else {
                [subView setMoveCenter:nil];
            }
        }
    }
}
- (void)clearCoverage {
    [self.subviews performSelector:@selector(removeFromSuperview)];
    [self.selectItemView removeFromSuperview];
}
#pragma mark  - 数据
- (NSDictionary *)data {
    NSMutableArray *itemDatas = [@[] mutableCopy];
    for (PAEBPhotoEditStickerItemView *view in self.subviews) {
        if ([view isKindOfClass:[PAEBPhotoEditStickerItemView class]]) {

            [itemDatas addObject:@{kPAEBStickerViewData_movingView_content:view.contentView.item
                                     , kPAEBStickerViewData_movingView_scale:@(view.scale)
                                     , kPAEBStickerViewData_movingView_rotation:@(view.arg)
                                     , kPAEBStickerViewData_movingView_center:[NSValue valueWithCGPoint:view.center]
                                   , kPAEBStickerViewData_movingView_superAngel:@(view.superAngle)
                                     }];
        }
    }
    if (itemDatas.count) {
        return @{kPAEBStickerViewData_movingView:[itemDatas copy],
                 kPAEBStickerViewData_angel : @(self.angle)
        };
    }else {
        if (self.angle != 0) {
            return @{
                kPAEBStickerViewData_angel : @(self.angle)
            };
        }
    }
    return nil;
}

- (void)setData:(NSDictionary *)data {
    NSInteger angle = [data[kPAEBStickerViewData_angel] integerValue];
    self.angle = angle;
    NSArray *itemDatas = data[kPAEBStickerViewData_movingView];
    if (itemDatas.count) {
        for (NSDictionary *itemData in itemDatas) {
            PAEBPhotoEditStickerItem *item = itemData[kPAEBStickerViewData_movingView_content];
            CGFloat scale = [itemData[kPAEBStickerViewData_movingView_scale] floatValue];
            NSInteger superAngle= [itemData[kPAEBStickerViewData_movingView_superAngel] integerValue];
            CGFloat rotation = [itemData[kPAEBStickerViewData_movingView_rotation] floatValue];
            CGPoint center = [itemData[kPAEBStickerViewData_movingView_center] CGPointValue];
            
            PAEBPhotoEditStickerItemView *view = [self addStickerItem:item isSelected:NO];
            view.superAngle = superAngle;
            [view setScale:scale rotation:rotation isInitialize:YES isPinch:NO];
            view.center = center;
        }
    }
}
@end
