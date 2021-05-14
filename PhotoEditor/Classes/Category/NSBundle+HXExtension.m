//
//  NSBundle+HXExtension.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/5/8.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "NSBundle+HXExtension.h"

@implementation NSBundle (HXExtension)
+ (instancetype)hx_photoPickerBundle {
    static NSBundle *stBundle = nil;
    if (stBundle == nil) {
        NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"PAEBPhotoEditor")];
        NSString *path = [bundle pathForResource:@"PhotoEditor" ofType:@"bundle"];
        //使用framework形式
        if (!path) {
            NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
            if (associateBundleURL) {
                associateBundleURL = [associateBundleURL URLByAppendingPathComponent:@"PhotoEditor"];
                associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
                NSBundle *associateBunle = [NSBundle bundleWithURL:associateBundleURL];
                path = [associateBunle pathForResource:@"PhotoPicker" ofType:@"bundle"];
            }
        }
        stBundle = path ? [NSBundle bundleWithPath:path]: [NSBundle mainBundle];
    }
    return stBundle;
}
@end
