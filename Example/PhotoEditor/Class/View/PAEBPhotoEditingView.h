//
//  PAEBPhotoEditingView.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/12.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class PAEBPhotoEditingView, PAEBPhotoClippingView, PAEBPhotoEditConfiguration;

@protocol PAEBPhotoEditingViewDelegate <NSObject>
/// 开始编辑目标
- (void)editingViewWillBeginEditing:(PAEBPhotoEditingView *)EditingView;
/// 停止编辑目标
- (void)editingViewDidEndEditing:(PAEBPhotoEditingView *)EditingView;

@optional
/// 即将进入剪切界面
- (void)editingViewWillAppearClip:(PAEBPhotoEditingView *)EditingView;
/// 进入剪切界面
- (void)editingViewDidAppearClip:(PAEBPhotoEditingView *)EditingView;
/// 即将离开剪切界面
- (void)editingViewWillDisappearClip:(PAEBPhotoEditingView *)EditingView;
/// 离开剪切界面
- (void)editingViewDidDisappearClip:(PAEBPhotoEditingView *)EditingView;

- (void)editingViewViewDidEndZooming:(PAEBPhotoEditingView *)editingView;
@end

@interface PAEBPhotoEditingView : UIScrollView
@property (nonatomic, weak, readonly) PAEBPhotoClippingView *clippingView;
@property (nonatomic, weak, readonly) UIView *clipZoomView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id<PAEBPhotoEditingViewDelegate> clippingDelegate;
@property (nonatomic, strong) PAEBPhotoEditConfiguration *configuration;

/// 最小尺寸 CGSizeMake(80, 80)
@property (nonatomic, assign) CGSize clippingMinSize;
/// 最大尺寸
@property (nonatomic, assign) CGRect clippingMaxRect;
/// 启用绘画功能
@property (nonatomic, assign) BOOL drawEnable;
/// 启用模糊功能
@property (nonatomic, assign) BOOL splashEnable;
/// 启用贴图
@property (nonatomic, readonly) BOOL stickerEnable;

@property (nonatomic, assign) CGFloat drawLineWidth;

/// 开启编辑模式
@property (nonatomic, assign, getter=isClipping) BOOL clipping;
- (void)setClipping:(BOOL)clipping animated:(BOOL)animated;
- (void)setClipping:(BOOL)clipping animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;
/// 取消裁剪
/// @param animated 是否需要动画
- (void)cancelClipping:(BOOL)animated;
/// 还原
- (void)reset;
- (BOOL)canReset;
/// 旋转
- (void)rotate;
/// 默认长宽比例
@property (nonatomic, assign) NSUInteger defaultAspectRatioIndex;
/// 自定义固定比例
@property (nonatomic, assign) CGSize customRatioSize;
/// 只要裁剪
@property (nonatomic, assign) BOOL onlyCliping;

- (void)resetToRridRectWithAspectRatioIndex:(NSInteger)aspectRatioIndex;

- (void)photoEditEnable:(BOOL)enable;

/// 创建编辑图片
- (void)createEditImage:(void (^)(UIImage *editImage))complete;
@property (nonatomic, strong, nullable) NSDictionary *photoEditData;

- (void)resetRotateAngle;
- (void)changeSubviewFrame;
- (void)clearCoverage;
@end

NS_ASSUME_NONNULL_END
