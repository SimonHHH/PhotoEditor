//
//  PAEBPhotoEditConfiguration.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/7.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditConfiguration.h"
#import "UIColor+HXExtension.h"

#define kPAEBPhotoEditColorArr @[[UIColor hx_colorWithHexStr:@"#ffffff"], [UIColor hx_colorWithHexStr:@"#000000"], [UIColor hx_colorWithHexStr:@"#FF0000"], [UIColor hx_colorWithHexStr:@"#FFB112"], [UIColor hx_colorWithHexStr:@"#00BDAE"], [UIColor hx_colorWithHexStr:@"#0F76FF"], [UIColor hx_colorWithHexStr:@"#AC1CFF"]]

@implementation PAEBPhotoEditConfiguration
- (instancetype)init {
    self = [super init];
    if (self) {
        self.maximumLimitTextLength = 100;   //文字贴图最大字数限制100个字符
    }
    return self;
}
- (CGFloat)brushLineWidth {
    if (!_brushLineWidth) {
        _brushLineWidth = 7.f;
    }
    return _brushLineWidth;
}

- (NSArray<UIColor *> *)drawColors {
    if (!_drawColors) {
        _drawColors = kPAEBPhotoEditColorArr;
        self.defaultDarwColorIndex = 2;
    }
    return _drawColors;
}
- (NSArray<UIColor *> *)textColors {
    if (!_textColors) {
        _textColors = kPAEBPhotoEditColorArr;
    }
    return _textColors;
}
- (UIFont *)textFont {
    if (!_textFont) {
        _textFont = [UIFont boldSystemFontOfSize:25];
    }
    return _textFont;
}

@end
