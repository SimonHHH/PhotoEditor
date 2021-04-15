//
//  PAEBPhotoEditSplashMaskLayer.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/14.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface PAEBPhotoEditSplashBlur : NSObject

@property (nonatomic, assign) CGRect rect;
@property (nonatomic, strong, nullable) UIColor *color;

@end

@interface PAEBPhotoEditSplashImageBlur : PAEBPhotoEditSplashBlur

@property (nonatomic, copy) NSString *imageName;

@end

@interface PAEBPhotoEditSplashMaskLayer : CALayer
@property (nonatomic, strong) NSMutableArray <PAEBPhotoEditSplashBlur *>*lineArray;
@end

NS_ASSUME_NONNULL_END
