//
//  PAEBPhotoEditGraffitiColorView.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/15.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PAEBPhotoEditGraffitiColorView : UIView
@property (nonatomic, copy) NSArray<UIColor *> *drawColors;
@property (nonatomic, assign) NSInteger defaultDarwColorIndex;
@property (nonatomic, copy) void (^ selectColorBlock)(UIColor *color);
@property (nonatomic, copy) void (^ undoBlock)(void);
@property (nonatomic, assign) BOOL undo;
+ (instancetype)initView;
@end

NS_ASSUME_NONNULL_END
