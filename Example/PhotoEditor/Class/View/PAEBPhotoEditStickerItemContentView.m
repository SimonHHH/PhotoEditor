//
//  PAEBPhotoEditStickerItemContentView.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditStickerItemContentView.h"
#import "PAEBPhotoEditStickerItem.h"
#import "PAEBPhotoEditViewController.h"

@interface PAEBPhotoEditStickerItemContentView ()<UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) PAEBPhotoEditStickerItem *item;
@end

@implementation PAEBPhotoEditStickerItemContentView

- (instancetype)initWithItem:(PAEBPhotoEditStickerItem *)item {
    self = [super initWithFrame:item.itemFrame];
    if (self) {
        self.item = item;
        [self addSubview:self.imageView];
    }
    return self;
}
- (void)updateItem:(PAEBPhotoEditStickerItem *)item {
    self.item = item;
    self.frame = item.itemFrame;
    self.imageView.image = item.image;
}
- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    gestureRecognizer.delegate = self;
    [super addGestureRecognizer:gestureRecognizer];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.delegate isKindOfClass:[PAEBPhotoEditViewController class]]) {
        return NO;
    }
    if ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] &&
        [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return YES;
    }
    if ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] ||
        [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    }
    if (gestureRecognizer.view == self && otherGestureRecognizer.view == self) {
        return YES;
    }
    return NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:self.item.image];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end
