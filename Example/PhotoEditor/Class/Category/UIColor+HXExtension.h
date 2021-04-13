//
//  UIColor+HXExtension.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/7.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HXExtension)
+ (UIColor *)hx_colorWithHexStr:(NSString *)string;
+ (UIColor *)hx_colorWithHexStr:(NSString *)string alpha:(CGFloat)alpha;
+ (UIColor *)hx_colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha;
- (BOOL)hx_colorIsWhite;
@end

NS_ASSUME_NONNULL_END
