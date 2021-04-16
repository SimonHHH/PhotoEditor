//
//  PAEBPhotoEditMosaicView.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/16.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PAEBPhotoEditMosaicView : UIView
@property (nonatomic, copy) void (^ undoBlock)(void);
@property (nonatomic, assign) BOOL undo;
+ (instancetype)initView;
@end

NS_ASSUME_NONNULL_END
