//
//  PAEBPhotoEditStickerItemView.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PAEBPhotoEditStickerItem, PAEBPhotoEditStickerItemContentView, PAEBPhotoEditConfiguration;
@interface PAEBPhotoEditStickerItemView : UIView
@property (nonatomic, strong, readonly) PAEBPhotoEditStickerItemContentView *contentView;
/// 是否处于选中状态
@property (nonatomic, assign) BOOL isSelected;
/// 显示界面的缩放率
@property (nonatomic, assign) CGFloat screenScale;
/// 当前比例
@property (nonatomic, assign) CGFloat scale;
/// 当前弧度
@property (nonatomic, assign) CGFloat arg;
@property (nonatomic, assign) CGFloat currentItemDegrees;
@property (nonatomic, assign) BOOL firstTouch;

@property (nonatomic, copy) BOOL (^ shouldTouchBegan)(PAEBPhotoEditStickerItemView *view);
@property (nonatomic, copy) void (^ tapNotInScope)(PAEBPhotoEditStickerItemView *view, CGPoint point);
@property (nonatomic, copy, nullable) void (^ tapEnded)(PAEBPhotoEditStickerItemView *view);
@property (nonatomic, copy, nullable) BOOL (^ moveCenter)(CGRect rect);
@property (nonatomic, copy, nullable) CGFloat (^ getMinScale)(CGSize size);
@property (nonatomic, copy, nullable) CGFloat (^ getMaxScale)(CGSize size);
@property (nonatomic, strong, nullable) PAEBPhotoEditConfiguration * (^ getConfiguration)(void);

@property (nonatomic, copy) void (^ touchBegan)(PAEBPhotoEditStickerItemView *itemView);
@property (nonatomic, copy) void (^ touchEnded)(PAEBPhotoEditStickerItemView *itemView);

@property (nonatomic, copy) void (^ panBegan)(void);
@property (nonatomic, copy) void (^ panChanged)(UIPanGestureRecognizer *pan);
@property (nonatomic, copy) BOOL (^ panEnded)(PAEBPhotoEditStickerItemView *itemView);
@property (nonatomic, copy) void (^ pinchBegan)(void);
@property (nonatomic, copy) void (^ pinchEnded)(void);
@property (nonatomic, copy) void (^ rotationBegan)(void);
@property (nonatomic, copy) void (^ rotationEnded)(void);

@property (nonatomic, assign) NSInteger superAngle;

- (instancetype)initWithItem:(PAEBPhotoEditStickerItem *)item screenScale:(CGFloat)screenScale;
- (void)setScale:(CGFloat)scale;
- (void)setScale:(CGFloat)scale rotation:(CGFloat)rotation;
- (void)setScale:(CGFloat)scale rotation:(CGFloat)rotation isInitialize:(BOOL)isInitialize;
- (void)setScale:(CGFloat)scale rotation:(CGFloat)rotation isInitialize:(BOOL)isInitialize isPinch:(BOOL)isPinch;
//- (void)updateItem:(HXPhotoEditStickerItem *)item;
- (void)resetRotation;
- (void)viewDidPan:(UIPanGestureRecognizer *)sender;
- (void)viewDidPinch:(UIPinchGestureRecognizer *)sender;
- (void)viewDidRotation:(UIRotationGestureRecognizer *)sender;
@end

NS_ASSUME_NONNULL_END
