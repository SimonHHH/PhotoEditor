//
//  PAEBPhotoEditClippingToolBar.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/16.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PAEBPhotoEditClippingToolBar : UIView
@property (nonatomic, assign) BOOL enableRotaio;
@property (nonatomic, assign) BOOL enableReset;

@property (nonatomic, copy) void (^ didBtnBlock)(NSInteger tag);
@property (nonatomic, copy) void (^ didRotateBlock)(void);

+ (instancetype)initView;

@end

NS_ASSUME_NONNULL_END
