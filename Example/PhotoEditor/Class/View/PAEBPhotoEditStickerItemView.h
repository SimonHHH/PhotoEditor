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
@property (strong, nonatomic, readonly) PAEBPhotoEditStickerItemContentView *contentView;
/// 是否处于选中状态
@property (assign, nonatomic) BOOL isSelected;
/// 显示界面的缩放率
@property (nonatomic, assign) CGFloat screenScale;
/// 当前比例
@property (assign, nonatomic) CGFloat scale;
/// 当前弧度
@property (assign, nonatomic) CGFloat arg;
@property (assign, nonatomic) CGFloat currentItemDegrees;
@property (assign, nonatomic) BOOL firstTouch;

@property (copy, nonatomic) BOOL (^ shouldTouchBegan)(PAEBPhotoEditStickerItemView *view);
@property (copy, nonatomic) void (^ tapNotInScope)(PAEBPhotoEditStickerItemView *view, CGPoint point);
@property (nonatomic, copy, nullable) void (^ tapEnded)(PAEBPhotoEditStickerItemView *view);
@property (nonatomic, copy, nullable) BOOL (^ moveCenter)(CGRect rect);
@property (nonatomic, copy, nullable) CGFloat (^ getMinScale)(CGSize size);
@property (nonatomic, copy, nullable) CGFloat (^ getMaxScale)(CGSize size);
@property (nonatomic, strong, nullable) PAEBPhotoEditConfiguration * (^ getConfiguration)(void);

@property (copy, nonatomic) void (^ touchBegan)(PAEBPhotoEditStickerItemView *itemView);
@property (copy, nonatomic) void (^ touchEnded)(PAEBPhotoEditStickerItemView *itemView);

@property (copy, nonatomic) void (^ panBegan)(void);
@property (copy, nonatomic) void (^ panChanged)(UIPanGestureRecognizer *pan);
@property (copy, nonatomic) BOOL (^ panEnded)(PAEBPhotoEditStickerItemView *itemView);
@property (copy, nonatomic) void (^ pinchBegan)(void);
@property (copy, nonatomic) void (^ pinchEnded)(void);
@property (copy, nonatomic) void (^ rotationBegan)(void);
@property (copy, nonatomic) void (^ rotationEnded)(void);

@property (assign, nonatomic) NSInteger superAngle;

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
