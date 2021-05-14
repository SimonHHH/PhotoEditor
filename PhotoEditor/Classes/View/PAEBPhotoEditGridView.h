//
//  PAEBPhotoEditGridView.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/14.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAEBPhotoEditGridLayer.h"
#import "PAEBPhotoEditGridMaskLayer.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HXPhotoEditGridViewDelegate;
@interface PAEBPhotoEditGridView : UIView
@property (nonatomic, assign) CGRect gridRect;
@property (nonatomic, weak, readonly) PAEBPhotoEditGridMaskLayer *gridMaskLayer;
- (void)setGridRect:(CGRect)gridRect animated:(BOOL)animated;
- (void)setGridRect:(CGRect)gridRect maskLayer:(BOOL)isMaskLayer animated:(BOOL)animated;
- (void)setGridRect:(CGRect)gridRect maskLayer:(BOOL)isMaskLayer animated:(BOOL)animated completion:(void (^ _Nullable)(BOOL finished))completion;
/** 最小尺寸 CGSizeMake(80, 80); */
@property (nonatomic, assign) CGSize controlMinSize;
/** 最大尺寸 CGRectInset(self.bounds, 20, 20) */
@property (nonatomic, assign) CGRect controlMaxRect;
/** 原图尺寸 */
@property (nonatomic, assign) CGSize controlSize;

/** 显示遮罩层（触发拖动条件必须设置为YES）default is YES */
@property (nonatomic, assign) BOOL showMaskLayer;

/** 是否正在拖动 */
@property(nonatomic,readonly,getter=isDragging) BOOL dragging;

/** 比例是否水平翻转 */
@property (nonatomic, assign) BOOL aspectRatioHorizontally;

/// 自定义固定比例
@property (nonatomic, assign) CGSize customRatioSize;


@property (nonatomic, weak) id<HXPhotoEditGridViewDelegate> delegate;
/** 遮罩颜色 */
@property (nonatomic, assign) CGColorRef maskColor;
@property (nonatomic, weak, readonly) PAEBPhotoEditGridLayer *gridLayer;

@property (nonatomic, assign) BOOL isAvatarClipping;

- (void)changeSubviewFrame:(CGRect)frame;
@end

@protocol HXPhotoEditGridViewDelegate <NSObject>

- (void)gridViewDidBeginResizing:(PAEBPhotoEditGridView *)gridView;
- (void)gridViewDidResizing:(PAEBPhotoEditGridView *)gridView;
- (void)gridViewDidEndResizing:(PAEBPhotoEditGridView *)gridView;

/** 调整长宽比例 */
- (void)gridViewDidAspectRatio:(PAEBPhotoEditGridView *)gridView;
@end

NS_ASSUME_NONNULL_END
