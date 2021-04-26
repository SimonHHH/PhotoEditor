//
//  PAEBPhotoClippingView.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PAEBPhotoClippingViewDelegate;
@class PAEBPhotoEditImageView, PAEBPhotoEditConfiguration;
@interface PAEBPhotoClippingView : UIScrollView
@property (nonatomic, strong, readonly) PAEBPhotoEditImageView *imageView;
@property (nonatomic, strong) UIImage *image;
/// 获取除图片以外的编辑图层
/// @param rect 大小
/// @param rotate 旋转角度
- (UIImage *)editOtherImagesInRect:(CGRect)rect rotate:(CGFloat)rotate;

@property (nonatomic, strong) PAEBPhotoEditConfiguration *configuration;

@property (nonatomic, weak) id<PAEBPhotoClippingViewDelegate> clippingDelegate;
/** 首次缩放后需要记录最小缩放值 */
@property (nonatomic, readonly) CGFloat first_minimumZoomScale;
/** 与父视图中心偏差坐标 */
@property (nonatomic, assign) CGPoint offsetSuperCenter;
/** 是否重置中 */
@property (nonatomic, readonly) BOOL isReseting;
/** 是否旋转中 */
@property (nonatomic, readonly) BOOL isRotating;
/** 旋转系数 */
@property (nonatomic, assign, readonly) NSInteger angle;
/** 是否可还原 */
@property (nonatomic, readonly) BOOL canReset;
/// 显示界面的缩放率
@property (nonatomic, assign) CGFloat screenScale;
/** 以某个位置作为可还原的参照物 */
- (BOOL)canResetWithRect:(CGRect)trueFrame;

/** 可编辑范围 */
@property (nonatomic, assign) CGRect editRect;
/** 剪切范围 */
@property (nonatomic, assign) CGRect cropRect;
/** 手势开关，一般编辑模式下开启 默认NO */
@property (nonatomic, assign) BOOL useGesture;

@property (nonatomic, assign) BOOL fixedAspectRatio;
- (void)zoomToRect:(CGRect)rect;
/** 缩小到指定坐标 */
- (void)zoomOutToRect:(CGRect)toRect;
/** 放大到指定坐标(必须大于当前坐标) */
- (void)zoomInToRect:(CGRect)toRect;
/** 旋转 */
- (void)rotateClockwise:(BOOL)clockwise;
/** 还原 */
- (void)reset;
/** 取消 */
- (void)cancel;
/** 数据 */
@property (nonatomic, strong, nullable) NSDictionary *photoEditData;
- (void)changeSubviewFrame;
- (void)resetRotateAngle;
- (void)clearCoverage;
@end

@protocol PAEBPhotoClippingViewDelegate <NSObject>

/** 同步缩放视图（调用zoomOutToRect才会触发） */
- (void (^ _Nullable)(CGRect))clippingViewWillBeginZooming:(PAEBPhotoClippingView *)clippingView;
- (void)clippingViewDidZoom:(PAEBPhotoClippingView *)clippingView;
- (void)clippingViewDidEndZooming:(PAEBPhotoClippingView *)clippingView;

/** 移动视图 */
- (void)clippingViewWillBeginDragging:(PAEBPhotoClippingView *)clippingView;
- (void)clippingViewDidEndDecelerating:(PAEBPhotoClippingView *)clippingView;

@end

NS_ASSUME_NONNULL_END
