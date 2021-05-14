//
//  UIFont+HXExtension.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "UIFont+HXExtension.h"

@implementation UIFont (HXExtension)
+ (instancetype)hx_pingFangFontOfSize:(CGFloat)size {
    UIFont *font = [self fontWithName:@"PingFangSC-Regular" size:size];
    return font ? font : [UIFont systemFontOfSize:size];
}

+ (instancetype)hx_mediumPingFangOfSize:(CGFloat)size {
    UIFont *font = [self fontWithName:@"PingFangSC-Medium" size:size];
    return font ? font : [UIFont systemFontOfSize:size];
}
+ (instancetype)hx_boldPingFangOfSize:(CGFloat)size {
    UIFont *font = [self fontWithName:@"PingFangSC-Semibold" size:size];
    return font ? font : [UIFont systemFontOfSize:size];
}
@end
