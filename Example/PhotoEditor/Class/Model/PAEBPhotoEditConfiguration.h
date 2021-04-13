//
//  PAEBPhotoEditConfiguration.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/7.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PAEBPhotoEditConfiguration : NSObject

/// 只要裁剪功能
@property (assign, nonatomic) BOOL onlyCliping;

#pragma mark - < 画笔相关 >

/// 画笔颜色数组
@property (copy, nonatomic) NSArray<UIColor *> *drawColors;

/// 默认选择的画笔颜色下标
/// 与 drawColors 对应，默认 2
@property (assign, nonatomic) NSInteger defaultDarwColorIndex;

/// 画笔宽度
/// 默认 12.f
@property (assign, nonatomic) CGFloat brushLineWidth;

#pragma mark - < 文字贴图相关 >

/// 文字颜色数组
@property (copy, nonatomic) NSArray<UIColor *> *textColors;
/// 文字字体
@property (strong, nonatomic) UIFont *textFont;
/// 最大文本长度限制
@property (assign, nonatomic) NSInteger maximumLimitTextLength;


#pragma mark - < 裁剪相关 >

/// 圆形裁剪框，只要裁剪功能
@property (assign, nonatomic) BOOL isRoundCliping;

@end

NS_ASSUME_NONNULL_END
