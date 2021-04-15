//
//  PAEBPhotoEditImageView.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAEBPhotoEditDrawView.h"
#import "PAEBPhotoEditStickerView.h"
#import "PAEBPhotoEditSplashView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PAEBPhotoEditImageViewType) {
    PAEBPhotoEditImageViewTypeNormal = 0, //!< 正常情况
    PAEBPhotoEditImageViewTypeDraw = 1,   //!< 绘图状态
    PAEBPhotoEditImageViewTypeSplash = 2  //!< 绘图状态
};
@class PAEBPhotoEditConfiguration;
@interface PAEBPhotoEditImageView : UIView
@property (strong, nonatomic, readonly) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) PAEBPhotoEditImageViewType type;
@property (strong, nonatomic, readonly) PAEBPhotoEditDrawView *drawView;
@property (strong, nonatomic, readonly) PAEBPhotoEditStickerView *stickerView;
@property (strong, nonatomic, readonly) PAEBPhotoEditSplashView *splashView;

@property (assign, nonatomic) BOOL splashViewEnable;
/// 显示界面的缩放率
@property (nonatomic, assign) CGFloat screenScale;

/** 贴图是否需要移到屏幕中心 */
@property (nonatomic, copy) BOOL(^moveCenter)(CGRect rect);
@property (nonatomic, copy, nullable) CGFloat (^ getMinScale)(CGSize size);
@property (nonatomic, copy, nullable) CGFloat (^ getMaxScale)(CGSize size);

@property (strong, nonatomic) PAEBPhotoEditConfiguration *configuration;
/** 数据 */
@property (nonatomic, strong, nullable) NSDictionary *photoEditData;
- (UIImage * _Nullable)editOtherImagesInRect:(CGRect)rect rotate:(CGFloat)rotate mirrorHorizontally:(BOOL)mirrorHorizontally;
- (void)changeSubviewFrame;
- (void)clearCoverage;
@end

NS_ASSUME_NONNULL_END
