//
//  PAEBPhotoEditImageView.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditImageView.h"
#import "UIView+HXExtension.h"
#import "PAEBPhotoEditStickerItemView.h"
#import "PAEBPhotoEditStickerItemContentView.h"
#import "UIImage+HXExtension.h"
#import "UIView+HXExtension.h"
#import "PAEBPhotoEditDefine.h"

NSString *const kPAEBImageViewData_draw = @"PAEBImageViewData_draw";
NSString *const kPAEBImageViewData_sticker = @"PAEBImageViewData_sticker";
NSString *const kPAEBImageViewData_splash = @"PAEBImageViewData_splash";
NSString *const kPAEBImageViewData_filter = @"PAEBImageViewData_filter";

@interface PAEBPhotoEditImageView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) PAEBPhotoEditDrawView *drawView;
@property (nonatomic, strong) PAEBPhotoEditStickerView *stickerView;
@property (nonatomic, strong) PAEBPhotoEditSplashView *splashView;
@end

@implementation PAEBPhotoEditImageView

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.splashView];
        [self addSubview:self.drawView];
        [self addSubview:self.stickerView];
    }
    return self;
}

- (void)changeSubviewFrame {
    self.imageView.frame = self.bounds;
    self.drawView.frame = self.imageView.frame;
    self.stickerView.frame = self.bounds;
    self.splashView.frame = self.bounds;
}
- (void)clearCoverage {
//    [self.drawView clearCoverage];
//    [self.stickerView clearCoverage];
//    [self.splashView clearCoverage];
}
- (void)setType:(PAEBPhotoEditImageViewType)type {
    self.drawView.userInteractionEnabled = NO;
    self.splashView.userInteractionEnabled = NO;
    if (type == PAEBPhotoEditImageViewTypeDraw) {
        self.drawView.userInteractionEnabled = YES;
    }else if (type == PAEBPhotoEditImageViewTypeSplash) {
        self.splashView.userInteractionEnabled = YES;
    }
}
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
    self.splashView.image = image;
}

- (void)setMoveCenter:(BOOL (^)(CGRect))moveCenter {
    _moveCenter = moveCenter;
    if (moveCenter) {
        self.stickerView.moveCenter = moveCenter;
    } else {
        self.stickerView.moveCenter = nil;
    }
}
- (void)setGetMaxScale:(CGFloat (^)(CGSize))getMaxScale {
    _getMaxScale = getMaxScale;
    if (getMaxScale) {
        self.stickerView.getMaxScale = getMaxScale;
    }else {
        self.stickerView.getMaxScale = nil;
    }
}
- (void)setGetMinScale:(CGFloat (^)(CGSize))getMinScale {
    _getMinScale = getMinScale;
    if (getMinScale) {
        self.stickerView.getMinScale = getMinScale;
    }else {
        self.stickerView.getMinScale = nil;
    }
}

- (void)setScreenScale:(CGFloat)screenScale {
    _screenScale = screenScale;
    self.drawView.screenScale = screenScale;
    self.stickerView.screenScale = screenScale;
    self.splashView.screenScale = screenScale;
}

- (UIImage * _Nullable)editOtherImagesInRect:(CGRect)rect rotate:(CGFloat)rotate {
    UIImage *image = nil;
    NSMutableArray *array = nil;
    for (UIView *subView in self.subviews) {
        if (subView == self.imageView) {
            continue;
        } else if ([subView isKindOfClass:[PAEBPhotoEditDrawView class]]) {
            if (((PAEBPhotoEditDrawView *)subView).count  == 0) {
                continue;
            }
        } else if ([subView isKindOfClass:[PAEBPhotoEditStickerView class]]) {
            if (((PAEBPhotoEditStickerView *)subView).count  == 0) {
                continue;
            }
        } else if ([subView isKindOfClass:[PAEBPhotoEditSplashView class]]) {
           if (!((PAEBPhotoEditSplashView *)subView).canUndo) {
               continue;
           }
       }
        if (array == nil) {
            array = [NSMutableArray arrayWithCapacity:3];
        }
        UIImage *subImage = [subView hx_captureImageAtFrame:rect];
        subView.layer.contents = (id)nil;
        if (subImage) {
            [array addObject:subImage];
        }
    }
    if (array.count) {
        image = [UIImage hx_mergeimages:array];
        if (rotate) {
            NSInteger angle = fabs(rotate * 180 / M_PI - 360);
            if (angle == 90) {
                image = [image hx_rotationImage:UIImageOrientationLeft];
            }else if (angle == 180) {
                image = [image hx_rotationImage:UIImageOrientationDown];
            }else if (angle == 270) {
                image = [image hx_rotationImage:UIImageOrientationRight];
            }
        }
    }
    return image;
}

- (void)setConfiguration:(PAEBPhotoEditConfiguration *)configuration {
    _configuration = configuration;
    self.stickerView.configuration = configuration;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.drawView.frame = self.imageView.frame;
    self.stickerView.frame = self.bounds;
    self.splashView.frame = self.bounds;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (PAEBPhotoEditDrawView *)drawView {
    if (!_drawView) {
        _drawView = [[PAEBPhotoEditDrawView alloc] initWithFrame:self.bounds];
        _drawView.userInteractionEnabled = NO;
    }
    return _drawView;
}

- (PAEBPhotoEditStickerView *)stickerView {
    if (!_stickerView) {
        _stickerView = [[PAEBPhotoEditStickerView alloc] initWithFrame:self.bounds];
    }
    return _stickerView;
}

- (PAEBPhotoEditSplashView *)splashView {
    if (!_splashView) {
        _splashView = [[PAEBPhotoEditSplashView alloc] initWithFrame:self.bounds];
        _splashView.userInteractionEnabled = NO;
        HXWeakSelf
        _splashView.splashColor = ^UIColor *(CGPoint point) {
            return [weakSelf.imageView hx_colorOfPoint:point];
        };
    }
    return _splashView;
}

#pragma mark - 数据
- (NSDictionary *)photoEditData {
    NSDictionary *drawData = self.drawView.data;
    NSDictionary *stickerData = self.stickerView.data;
    NSDictionary *splashData = self.splashView.data;
    
    NSMutableDictionary *data = [@{} mutableCopy];
    if (drawData) [data setObject:drawData forKey:kPAEBImageViewData_draw];
    if (stickerData) [data setObject:stickerData forKey:kPAEBImageViewData_sticker];
    if (splashData) [data setObject:splashData forKey:kPAEBImageViewData_splash];
    
    if (data.count) {
        return data;
    }
    return nil;
}

- (void)setPhotoEditData:(NSDictionary *)photoEditData {
    self.drawView.data = photoEditData[kPAEBImageViewData_draw];
    self.stickerView.data = photoEditData[kPAEBImageViewData_sticker];
    self.splashView.data = photoEditData[kPAEBImageViewData_splash];
}

@end
