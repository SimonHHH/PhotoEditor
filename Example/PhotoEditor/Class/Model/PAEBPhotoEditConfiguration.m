//
//  PAEBPhotoEditConfiguration.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/7.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditConfiguration.h"
#import "UIColor+HXExtension.h"

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
        _drawColors = @[[UIColor hx_colorWithHexStr:@"#ffffff"], [UIColor hx_colorWithHexStr:@"#2B2B2B"], [UIColor hx_colorWithHexStr:@"#FA5150"], [UIColor hx_colorWithHexStr:@"#FEC200"], [UIColor hx_colorWithHexStr:@"#07C160"], [UIColor hx_colorWithHexStr:@"#10ADFF"], [UIColor hx_colorWithHexStr:@"#6467EF"]];
        self.defaultDarwColorIndex = 2;
    }
    return _drawColors;
}
- (NSArray<UIColor *> *)textColors {
    if (!_textColors) {
        _textColors = @[[UIColor hx_colorWithHexStr:@"#ffffff"], [UIColor hx_colorWithHexStr:@"#2B2B2B"], [UIColor hx_colorWithHexStr:@"#FA5150"], [UIColor hx_colorWithHexStr:@"#FEC200"], [UIColor hx_colorWithHexStr:@"#07C160"], [UIColor hx_colorWithHexStr:@"#10ADFF"], [UIColor hx_colorWithHexStr:@"#6467EF"]];
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
