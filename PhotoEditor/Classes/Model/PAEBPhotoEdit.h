//
//  PAEBPhotoEdit.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/7.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PAEBPhotoEdit : NSObject
/// 编辑封面
@property (nonatomic, readonly) UIImage *editPosterImage;
/// 编辑预览图片
@property (nonatomic, readonly) UIImage *editPreviewImage;
/// 编辑图片数据
@property (nonatomic, readonly) NSData *editPreviewData;
/// 编辑原图片本地临时地址
@property (nonatomic, readonly) NSString *imagePath;
/// 编辑数据
@property (nonatomic, readonly) NSDictionary *editData;

- (instancetype)initWithEditImagePath:(NSString *)imagePath previewImage:(UIImage *)previewImage data:(NSDictionary *)data;

- (void)clearData;
@end


