//
//  PAEBPhotoEditStickerItemView.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditStickerItemView.h"
#import "PAEBPhotoEditStickerItemContentView.h"
#import "PAEBPhotoEditStickerItem.h"
#import "PAEBPhotoEditTextView.h"
#import "PAEBPhotoEditDefine.h"
#import "UIView+HXExtension.h"
#import "PAEBPhotoEditConfiguration.h"
#import "PAEBPhotoClippingView.h"
#import "PAEBPhotoEditStickerView.h"


#define PAEBItemView_margin 22

@interface PAEBPhotoEditStickerItemView ()
@property (strong, nonatomic) PAEBPhotoEditStickerItemContentView *contentView;
/// 拖动时初始的坐标
@property (assign, nonatomic) CGPoint initialPoint;
/// 捏合时的初始比例
@property (assign, nonatomic) CGFloat initialScale;
/// 旋转时的初始弧度
@property (assign, nonatomic) CGFloat initialArg;
@property (assign, nonatomic) BOOL touching;
@end

@implementation PAEBPhotoEditStickerItemView
@synthesize scale = _scale;

- (instancetype)initWithItem:(PAEBPhotoEditStickerItem *)item screenScale:(CGFloat)screenScale {
    self = [super initWithFrame:CGRectMake(0, 0, item.itemFrame.size.width + PAEBItemView_margin / screenScale, item.itemFrame.size.height + PAEBItemView_margin / screenScale)];
    if (self) {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        if (self.contentView.item.textModel) {
            self.layer.shadowColor = [UIColor blackColor].CGColor;
        }
        self.layer.shadowOpacity = .3f;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 1.f;
        self.contentView = [[PAEBPhotoEditStickerItemContentView alloc] initWithItem:item];
        self.contentView.center = self.center;
        [self addSubview:self.contentView];
        [self initGestures];
        
        _screenScale = screenScale;
        _scale = 1.f;
        _arg = 0;
        self.currentItemDegrees = 0;
    }
    return self;
}
- (void)setIsSelected:(BOOL)isSelected {
    if (_isSelected == isSelected) {
        return;
    }
    _isSelected = isSelected;
    
    self.layer.cornerRadius = (isSelected) ? 1 / self.screenScale : 0;
    if (!self.contentView.item.textModel) {
        self.layer.shadowColor = (isSelected) ? [UIColor blackColor].CGColor : [UIColor clearColor].CGColor;
    }
    if (isSelected) {
        [self updateFrameWithViewSize:self.contentView.item.itemFrame.size];
        self.layer.borderWidth = (isSelected) ? 1 / self.screenScale : 0;
        self.userInteractionEnabled = YES;
    }else {
        self.firstTouch = NO;
        self.layer.borderWidth = 0;
        self.userInteractionEnabled = NO;
    }
}
- (void)initGestures {
    self.contentView.userInteractionEnabled = YES;
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];

    [self.contentView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
    [self.contentView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPinch:)]];
    [self.contentView addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidRotation:)]];
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (CGRectContainsPoint(self.bounds, point)) {
        return self.contentView;
    }
    return view;
}
- (void)updateItem:(PAEBPhotoEditStickerItem *)item {
    [self.contentView updateItem:item];
    [self updateFrameWithViewSize:item.itemFrame.size];
}

- (void)updateFrameWithViewSize:(CGSize)viewSize {
    CGPoint center = self.center;
    CGRect frame = self.frame;
    frame.size = CGSizeMake(viewSize.width + PAEBItemView_margin / self.screenScale, viewSize.height + PAEBItemView_margin / self.screenScale);
    self.frame = frame;
    self.center = center;
    
    self.contentView.transform = CGAffineTransformIdentity;
    self.transform = CGAffineTransformIdentity;
     
    self.contentView.hx_size = viewSize;
    self.contentView.center = CGPointMake(self.hx_w / 2, self.hx_h / 2);
    
    [self setScale:_scale rotation:self.arg isInitialize:NO isPinch:NO];
}
- (void)resetRotation {
    [self setScale:_scale rotation:self.arg isInitialize:NO isPinch:NO];
}
- (void)setScale:(CGFloat)scale {
    [self setScale:scale rotation:MAXFLOAT];
}
- (void)setScale:(CGFloat)scale rotation:(CGFloat)rotation {
    [self setScale:scale rotation:rotation isInitialize:NO ];
}
- (void)setScale:(CGFloat)scale rotation:(CGFloat)rotation isInitialize:(BOOL)isInitialize  {
    [self setScale:scale rotation:rotation isInitialize:isInitialize isPinch:NO];
}
- (void)setScale:(CGFloat)scale rotation:(CGFloat)rotation isInitialize:(BOOL)isInitialize isPinch:(BOOL)isPinch {
    if (rotation != MAXFLOAT) {
        self.arg = rotation;
    }
    CGFloat minScale = 0.2f / self.screenScale;
    CGFloat maxScale = 3.0f / self.screenScale;
    if (self.getMaxScale) {
        maxScale = self.getMaxScale(self.contentView.item.itemFrame.size) / self.screenScale;
    }
    if (self.getMinScale) {
        minScale = self.getMinScale(self.contentView.item.itemFrame.size) / self.screenScale;
    }
    if (isInitialize) {
        _scale = scale;
    }else {
        if (isPinch) {
            if (scale > maxScale) {
                if (scale < self.initialScale) {
                    _scale = scale;
                }else {
                    if (self.initialScale < maxScale) {
                        _scale = MIN(MAX(scale, minScale), maxScale);
                    }else {
                        _scale = self.initialScale;
                    }
                }
            }else if (scale < minScale) {
                if (scale > self.initialScale) {
                    _scale = scale;
                }else {
                    if (self.initialScale > minScale) {
                        _scale = MIN(MAX(scale, minScale), maxScale);
                    }else {
                        _scale = self.initialScale;
                    }
                }
            }else {
                _scale = MIN(MAX(scale, minScale), maxScale);
            }
        }else {
            _scale = scale;
        }
    }
    self.transform = CGAffineTransformIdentity;
    CGFloat margin = PAEBItemView_margin / self.screenScale;
    if (self.touching) {
        margin *= self.screenScale;
        self.contentView.transform = CGAffineTransformMakeScale(self.scale * self.screenScale, self.scale * self.screenScale);
    }else {
        self.contentView.transform = CGAffineTransformMakeScale(self.scale, self.scale);
    }
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (self.contentView.frame.size.width + margin)) / 2;
    rct.origin.y += (rct.size.height - (self.contentView.frame.size.height + margin)) / 2;
    rct.size.width  = self.contentView.frame.size.width + margin;
    rct.size.height = self.contentView.frame.size.height + margin;
    self.frame = rct;
    
    self.contentView.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    
    self.transform = CGAffineTransformRotate(self.transform, self.arg);
    
    if (self.isSelected) {
        if (self.touching) {
            self.layer.borderWidth = 1;
            self.layer.cornerRadius = 1;
        }else {
            self.layer.borderWidth = 1  / self.screenScale;
            self.layer.cornerRadius = 1  / self.screenScale;
        }
    }
}
- (CGFloat)scale {
    return _scale;
}
- (void)setScreenScale:(CGFloat)screenScale {
    _screenScale = screenScale;
    
}
- (void)viewDidTap:(UITapGestureRecognizer*)sender {
    if (!self.shouldTouchBegan(self)) {
        return;
    }
    CGPoint point = [sender locationInView:self];
    BOOL contentContain = CGRectContainsPoint(self.contentView.frame, point);
    if (!contentContain) {
        // 点击不在当前范围内取消选中
        if (self.tapNotInScope) {
            self.isSelected = NO;
            self.tapNotInScope(self, point);
        }
        return;
    }
    if (self.tapEnded) self.tapEnded(self);
    if (self.firstTouch && self.isSelected && self.contentView.item.textModel) {
        HXWeakSelf
        [PAEBPhotoEditTextView showEitdTextViewWithConfiguration:self.getConfiguration() textModel:self.contentView.item.textModel completion:^(PAEBPhotoEditTextModel * _Nonnull textModel) {
            PAEBPhotoEditStickerItem *item = [[PAEBPhotoEditStickerItem alloc] init];
            item.textModel = textModel;
            [weakSelf updateItem:item];
        }];
    }
    self.firstTouch = YES;
}

- (void)viewDidPan:(UIPanGestureRecognizer *)sender {
    if (!self.shouldTouchBegan(self)) {
        return;
    }
    if(sender.state == UIGestureRecognizerStateBegan){
        self.firstTouch = YES;
        self.touching = YES;
        if (self.touchBegan) {
            self.touchBegan(self);
        }
        if (self.panBegan) {
            self.panBegan();
        }
        self.isSelected = YES;
        self.initialPoint = self.center;
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint p = [sender translationInView:self.superview];
        self.center = CGPointMake(self.initialPoint.x + p.x, self.initialPoint.y + p.y);
        if (self.panChanged) {
            self.panChanged(sender);
        }
    }
    
    if (sender.state == UIGestureRecognizerStateEnded ||
        sender.state == UIGestureRecognizerStateCancelled) {
            self.touching = NO;
        BOOL isDelete = NO;
        if (self.panEnded) {
            isDelete = self.panEnded(self);
        }
        if (self.touchEnded) {
            self.touchEnded(self);
        }
        BOOL isMoveCenter = NO;
        CGRect rect = [self convertRect:self.contentView.frame toView:self.superview];
        if (self.moveCenter) {
            isMoveCenter = self.moveCenter(rect);
        } else {
            isMoveCenter = !CGRectIntersectsRect(self.superview.frame, rect);
        }
        if (isMoveCenter && !isDelete) {
            /** 超出边界线 重置会中间 */
            [UIView animateWithDuration:0.25f animations:^{
                self.center = [self.superview convertPoint:[UIApplication sharedApplication].keyWindow.center fromView:(UIView *)[UIApplication sharedApplication].keyWindow];
            }];
        }
    }
}

- (void)viewDidPinch:(UIPinchGestureRecognizer *)sender {
    if (!self.shouldTouchBegan(self)) {
        return;
    }
    if(sender.state == UIGestureRecognizerStateBegan){
        self.firstTouch = YES;
        self.touching = YES;
        if (self.pinchBegan) {
            self.pinchBegan();
        }
        if (self.touchBegan) {
            self.touchBegan(self);
        }
        self.isSelected = YES;
        self.initialScale = self.scale;
    } else if (sender.state == UIGestureRecognizerStateEnded ||
               sender.state == UIGestureRecognizerStateCancelled) {
                   self.touching = NO;
        if (self.pinchEnded) {
            self.pinchEnded();
        }
        if (self.touchEnded) {
            self.touchEnded(self);
        }
    }
    [self setScale:(self.initialScale * sender.scale) rotation:MAXFLOAT isInitialize:NO isPinch:YES];
    if(sender.state == UIGestureRecognizerStateBegan && sender.state == UIGestureRecognizerStateChanged){
        sender.scale = 1.0;
    }
}

- (void)viewDidRotation:(UIRotationGestureRecognizer *)sender {
    if (!self.shouldTouchBegan(self)) {
        return;
    }
    if(sender.state == UIGestureRecognizerStateBegan){
        self.firstTouch = YES;
        self.touching = YES;
        self.isSelected = YES;
        if (self.rotationBegan) {
            self.rotationBegan();
        }
        if (self.touchBegan) {
            self.touchBegan(self);
        }
        self.initialArg = self.arg;
        sender.rotation = 0.0;
    } else if (sender.state == UIGestureRecognizerStateEnded ||
               sender.state == UIGestureRecognizerStateCancelled) {
        self.touching = NO;
        if (self.rotationEnded) {
            self.rotationEnded();
        }
        if (self.touchEnded) {
            self.touchEnded(self);
        }
        sender.rotation = 0.0;
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        self.arg = self.initialArg + sender.rotation;
        [self setScale:self.scale rotation:self.arg isInitialize:NO isPinch:NO];
    }
}
@end
