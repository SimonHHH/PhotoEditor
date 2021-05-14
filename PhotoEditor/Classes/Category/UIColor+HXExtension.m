//
//  UIColor+HXExtension.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/7.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "UIColor+HXExtension.h"

@implementation UIColor (HXExtension) 

+ (UIColor *)hx_colorWithHexStr:(NSString *)string {
    return [UIColor hx_colorWithHexStr:string alpha:1.0];
}

+ (UIColor *)hx_colorWithHexStr:(NSString *)string alpha:(CGFloat)alpha {
    NSString *str;
    if ([string containsString:@"#"]) {
        str = [string substringFromIndex:1];
    } else {
        str = string;
    }
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:str];
    unsigned int hexNum = 0;
    if ([scanner scanHexInt:&hexNum] == NO) {
        NSLog(@"16进制转UIColor, hexString为空");
    }
    
    return [UIColor hx_colorWithR:(hexNum & 0xFF0000) >> 16 g:(hexNum & 0x00FF00) >> 8 b:hexNum & 0x0000FF a:alpha];
}

+ (UIColor *)hx_colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

- (BOOL)hx_colorIsWhite {
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    [self getRed:&red green:&green blue:&blue alpha:NULL];
    if (red >= 0.99 && green >= 0.99 & blue >= 0.99) {
        return YES;
    }
    return NO;
}
@end
