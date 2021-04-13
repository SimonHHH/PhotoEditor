//
//  PAEBPhotoEditDrawView.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PAEBPhotoEditDrawView : UIView

@property (assign, nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) UIColor *lineColor;
@property (copy, nonatomic) void (^ beganDraw)(void);
@property (copy, nonatomic) void (^ endDraw)(void);

/** 正在绘画 */
@property (nonatomic, readonly) BOOL isDrawing;
/** 图层数量 */
@property (nonatomic, readonly) NSUInteger count;
/// 显示界面的缩放率
@property (nonatomic, assign) CGFloat screenScale;

@property (assign, nonatomic) BOOL enabled;

/** 数据 */
@property (nonatomic, strong, nullable) NSDictionary *data;

/// 是否可以撤销
- (BOOL)canUndo;

/// 撤销
- (void)undo;
- (void)clearCoverage;
@end

NS_ASSUME_NONNULL_END
