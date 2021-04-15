//
//  PAEBPhotoEditStickerTrashView.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditStickerTrashView.h"
#import "UIView+HXExtension.h"
#import "UIImage+HXExtension.h"
#import "PAEBPhotoEditDefine.h"
#import "UIColor+HXExtension.h"

@interface PAEBPhotoEditStickerTrashView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIVisualEffectView *visualView;
@property (nonatomic, strong) UIView *redView;

@end

@implementation PAEBPhotoEditStickerTrashView

+ (instancetype)initView {
    return [[self alloc] initWithFrame:CGRectMake(0, HX_ScreenHeight-56-HXBottomMargin, HX_ScreenWidth, 56+HXBottomMargin)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.redView];
    [self addSubview:self.visualView];
    [self addSubview:self.imageView];
    [self addSubview:self.titleLb];
    
    self.inArea = NO;
    self.redView.hidden = YES;
    self.imageView.image = [UIImage imageNamed:@"photo_edit_trash_close"];
}
- (void)setInArea:(BOOL)inArea {
    _inArea = inArea;
    if (inArea) {
        self.redView.hidden = NO;
        self.visualView.hidden = YES;
    }else {
        self.redView.hidden = YES;
        self.visualView.hidden = NO;
    }
}

- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc] initWithFrame:self.bounds];
        _redView.backgroundColor = [UIColor hx_colorWithHexStr:@"#FF5653"];
    }
    return _redView;
}

- (UIVisualEffectView *)visualView {
    if (_visualView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _visualView = [[UIVisualEffectView alloc] initWithFrame:self.bounds];
        _visualView.effect = effect;
    }
    return _visualView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        CGFloat hw = 24.0;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.hx_w*0.5-hw*0.5, 8, hw, hw)];
    }
    return _imageView;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, self.hx_w, 14.5)];
        _titleLb.textColor = [UIColor whiteColor];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.backgroundColor = [UIColor clearColor];
        _titleLb.text = @"拖动到此处删除";
    }
    return _titleLb;
}

@end
