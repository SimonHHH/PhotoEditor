//
//  PAEBPhotoEdit.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/7.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEdit.h"
#import "UIImage+HXExtension.h"
#import "PAEBHXCancelBlock.h"


@interface PAEBPhotoEdit ()
/// 编辑封面
@property (nonatomic, strong) UIImage *editPosterImage;
/// 编辑预览图片
@property (nonatomic, strong) UIImage *editPreviewImage;
/// 编辑图片数据
@property (nonatomic, strong) NSData *editPreviewData;
/// 编辑原图片临时地址
@property (nonatomic, copy) NSString *imagePath;
/// 编辑数据
@property (nonatomic, copy) NSDictionary *editData;
@end

@implementation PAEBPhotoEdit

- (instancetype)initWithEditImagePath:(NSString *)imagePath previewImage:(UIImage *)previewImage data:(NSDictionary *)data {
    self = [super init];
    if (self) {
        if (!previewImage) {
            NSData *data = [NSData dataWithContentsOfFile:imagePath];
            previewImage = [UIImage imageWithData:data];
        }
        [self setEditingImage:previewImage];
        _imagePath = imagePath;
        _editData = data;
    }
    return self;
}

#pragma mark - private
- (void)clearData {
    self.editPreviewImage = nil;
    self.editPosterImage = nil;
    self.imagePath = nil;
    self.editData = nil;
}
- (void)setEditingImage:(UIImage *)editPreviewImage {
    _editPreviewImage = editPreviewImage;
    /** 设置编辑封面 */
    CGFloat width = MIN(80.f * 2.f, MIN(editPreviewImage.size.width, editPreviewImage.size.height));
    CGSize size = [UIImage hx_scaleImageSizeBySize:editPreviewImage.size targetSize:CGSizeMake(width, width) isBoth:YES];
    _editPosterImage = [editPreviewImage hx_scaleToFitSize:size];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.editPosterImage = [aDecoder decodeObjectForKey:@"editPosterImage"];
        self.editPreviewImage = [aDecoder decodeObjectForKey:@"editPreviewImage"];
        self.editPreviewData = [aDecoder decodeObjectForKey:@"editPreviewData"];
        self.imagePath = [aDecoder decodeObjectForKey:@"imagePath"];
        self.editData = [aDecoder decodeObjectForKey:@"editData"];
        
    }
    return self;
}
- (NSData *)editPreviewData {
    if (!_editPreviewData) {
        _editPreviewData = HX_UIImageJPEGRepresentation(self.editPreviewImage);
    }
    return _editPreviewData;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.editPosterImage forKey:@"editPosterImage"];
    [aCoder encodeObject:self.editPreviewImage forKey:@"editPreviewImage"];
    [aCoder encodeObject:self.editPreviewData forKey:@"editPreviewData"];
    [aCoder encodeObject:self.imagePath forKey:@"imagePath"];
    [aCoder encodeObject:self.editData forKey:@"editData"];
}
@end
