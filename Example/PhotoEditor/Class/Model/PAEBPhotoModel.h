//
//  PAEBPhotoModel.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/12.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "PAEBPhotoEdit.h"

typedef NS_ENUM(NSUInteger, PAEBPhotoModelFormat) {
    HXPhotoModelFormatUnknown = 0,  //!< 未知格式
    HXPhotoModelFormatPNG,          //!< PNG格式
    HXPhotoModelFormatJPG,          //!< JPG格式
    HXPhotoModelFormatGIF,          //!< GIF格式
    HXPhotoModelFormatHEIC          //!< HEIC格式
};

@interface PAEBPhotoModel : NSObject<NSCoding>
/// PHAsset对象
@property (nonatomic, strong) PHAsset * _Nullable asset;
/// 照片格式
@property (assign, nonatomic) PAEBPhotoModelFormat photoFormat;
/// 照片原始宽高
@property (assign, nonatomic) CGSize imageSize;

/// 编辑的数据
/// 传入之前的编辑数据可以在原有基础上继续编辑
@property (strong, nonatomic) PAEBPhotoEdit * _Nullable photoEdit;

/// 通过PHAsset对象初始化
/// @param asset PHAsset
+ (instancetype _Nullable)photoModelWithPHAsset:(PHAsset * _Nullable)asset;

@end

