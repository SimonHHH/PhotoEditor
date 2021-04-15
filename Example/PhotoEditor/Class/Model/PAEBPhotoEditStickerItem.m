//
//  PAEBPhotoEditStickerItem.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditStickerItem.h"
#import "PAEBPhotoEditTextView.h"

@interface PAEBPhotoEditStickerItem ()

@end

@implementation PAEBPhotoEditStickerItem


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.itemFrame = [aDecoder decodeCGRectForKey:@"itemFrame"];
        self.textModel = [aDecoder decodeObjectForKey:@"textModel"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeCGRect:self.itemFrame forKey:@"itemFrame"];
    [aCoder encodeObject:self.textModel forKey:@"textModel"];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (UIImage *)image {
    if (!_image) {
        _image = self.textModel.image;
    }
    return _image;
}
- (CGRect)itemFrame {
    return [self getImageFrame];
}

- (CGRect)getImageFrame {
    CGFloat width;
    if (self.textModel) {
        width = [UIScreen mainScreen].bounds.size.width - 30;
    }else {
        width = [UIScreen mainScreen].bounds.size.width - 80;
    }
    CGFloat height = width;
    CGFloat imgWidth = self.image.size.width;
    CGFloat imgHeight = self.image.size.height;
    CGFloat w;
    CGFloat h;
    
    if (imgWidth > width) {
        imgHeight = width / imgWidth * imgHeight;
    }
    if (imgHeight > height) {
        w = height / self.image.size.height * imgWidth;
        h = height;
    }else {
        if (imgWidth > width) {
            w = width;
        }else {
            w = imgWidth;
        }
        h = imgHeight;
    }
    return CGRectMake(0, 0, w, h);
}
@end

