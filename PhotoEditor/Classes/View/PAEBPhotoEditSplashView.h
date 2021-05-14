//
//  PAEBPhotoEditSplashView.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PAEBPhotoEditSplashStateType) {
    /** 马赛克 */
    PAEBPhotoEditSplashStateType_Mosaic,
};

@interface PAEBPhotoEditSplashView : UIView
/// 显示界面的缩放率
@property (nonatomic, assign) CGFloat screenScale;

/** 数据 */
@property (nonatomic, strong, nullable) NSDictionary *data;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) void(^splashBegan)(void);
@property (nonatomic, copy) void(^splashEnded)(void);
/** 绘画颜色 */
@property (nonatomic, copy) UIColor *(^splashColor)(CGPoint point);

/** 改变模糊状态 */
@property (nonatomic, assign) PAEBPhotoEditSplashStateType state;

/** 是否可撤销 */
- (BOOL)canUndo;

//撤销
- (void)undo;
- (void)clearCoverage;
@end

NS_ASSUME_NONNULL_END
