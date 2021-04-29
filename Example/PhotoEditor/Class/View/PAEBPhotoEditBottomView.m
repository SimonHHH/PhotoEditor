//
//  PAEBPhotoEditBottomView.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/12.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditBottomView.h"
#import "UIView+HXExtension.h"
#import "UIImage+HXExtension.h"
#import "UIColor+HXExtension.h"
#import "UIFont+HXExtension.h"
#import "PAEBPhotoEditDefine.h"

@interface PAEBPhotoEditBottomView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *graffitiBtn;
@property (nonatomic, strong) UIButton *textBtn;
@property (nonatomic, strong) UIButton *clipBtn;
@property (nonatomic, strong) UIButton *mosaicBtn;
@property (nonatomic, strong) UIButton *doneBtn;
@end

@implementation PAEBPhotoEditBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HX_ScreenWidth, 56)];
    [self addSubview:self.bgView];
    
    [self.bgView addSubview:self.graffitiBtn];
    [self.bgView addSubview:self.textBtn];
    [self.bgView addSubview:self.clipBtn];
    [self.bgView addSubview:self.mosaicBtn];
    [self.bgView addSubview:self.doneBtn];
}

- (void)didToolsBtnClick:(UIButton *)button {
    if (button.tag == 1) {
        if (self.didToolsBtnBlock) {
            self.didToolsBtnBlock(button.tag, button.selected);
        }
        return;
    }
    if (button.selected) {
        button.selected = NO;
        button.imageView.tintColor = nil;
    }else {
        button.selected = YES;
        if (button.tag != 2) {
            button.imageView.tintColor = [UIColor hx_colorWithHexStr:HXThemeColor];
        }
    }
    if (button.tag != 2) {
        [self resetAllBtnState:button];
    }
    if (self.didToolsBtnBlock) {
        self.didToolsBtnBlock(button.tag, button.selected);
    }
}

- (void)didDoneBtnClick:(UIButton *)button {
    if (self.didDoneBtnBlock) {
        self.didDoneBtnBlock();
    }
}

- (void)resetAllBtnState:(UIButton *)button {
    if (self.graffitiBtn != button) {
        self.graffitiBtn.selected = NO;
        self.graffitiBtn.imageView.tintColor = nil;
    }
    if (self.textBtn != button) {
        self.textBtn.selected = NO;
        self.textBtn.imageView.tintColor = nil;
    }
    if (self.clipBtn != button) {
        self.clipBtn.selected = NO;
        self.clipBtn.imageView.tintColor = nil;
    }
    if (self.mosaicBtn != button) {
        self.mosaicBtn.selected = NO;
        self.mosaicBtn.imageView.tintColor = nil;
    }
}

- (void)endCliping {
    if (self.clipBtn.selected) {
        [self didToolsBtnClick:self.clipBtn];
    }
}

- (UIButton *)graffitiBtn {
    if (!_graffitiBtn) {
        _graffitiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_graffitiBtn setFrame:CGRectMake(10, 0, 56, 56)];
        UIImage *image = [UIImage imageNamed:@"photo_edit_tools_graffiti"];
        UIImage *imageSelected = [UIImage imageNamed:@"photo_edit_tools_graffiti_selected"];
        [_graffitiBtn setImage:image forState:UIControlStateNormal];
        [_graffitiBtn setImage:imageSelected forState:UIControlStateSelected];
        [_graffitiBtn setTitle:@"画笔" forState:UIControlStateNormal];
        [_graffitiBtn.titleLabel setFont:[UIFont hx_pingFangFontOfSize:10.0]];
        [_graffitiBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, -_graffitiBtn.titleLabel.intrinsicContentSize.width)];
        [_graffitiBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, -_graffitiBtn.currentImage.size.width, 0, 0)];
        [_graffitiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_graffitiBtn setTitleColor:[UIColor hx_colorWithHexStr:HXThemeColor] forState:UIControlStateSelected];
        _graffitiBtn.tag = 0;
        [_graffitiBtn addTarget:self action:@selector(didToolsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _graffitiBtn;
}

- (UIButton *)textBtn {
    if (!_textBtn) {
        _textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_textBtn setFrame:CGRectMake(CGRectGetMaxX(_graffitiBtn.frame), 0, 56, 56)];
        UIImage *image = [UIImage imageNamed:@"photo_edit_tools_text"];
        [_textBtn setImage:image forState:UIControlStateNormal];
        [_textBtn setImage:image forState:UIControlStateSelected];
        [_textBtn setTitle:@"备注" forState:UIControlStateNormal];
        [_textBtn.titleLabel setFont:[UIFont hx_pingFangFontOfSize:10.0]];
        [_textBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, -_textBtn.titleLabel.intrinsicContentSize.width)];
        [_textBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, -_textBtn.currentImage.size.width, 0, 0)];
        [_textBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _textBtn.tag = 1;
        [_textBtn addTarget:self action:@selector(didToolsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textBtn;
}

- (UIButton *)clipBtn {
    if (!_clipBtn) {
        _clipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clipBtn setFrame:CGRectMake(CGRectGetMaxX(_textBtn.frame), 0, 56, 56)];
        UIImage *image = [UIImage imageNamed:@"photo_edit_tools_clip"];
        [_clipBtn setImage:image forState:UIControlStateNormal];
        [_clipBtn setImage:image forState:UIControlStateSelected];
        [_clipBtn setTitle:@"裁剪" forState:UIControlStateNormal];
        [_clipBtn.titleLabel setFont:[UIFont hx_pingFangFontOfSize:10.0]];
        [_clipBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, -_clipBtn.titleLabel.intrinsicContentSize.width)];
        [_clipBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, -_clipBtn.currentImage.size.width, 0, 0)];
        [_clipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _clipBtn.tag = 2;
        [_clipBtn addTarget:self action:@selector(didToolsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clipBtn;
}

- (UIButton *)mosaicBtn {
    if (!_mosaicBtn) {
        _mosaicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mosaicBtn setFrame:CGRectMake(CGRectGetMaxX(_clipBtn.frame), 0, 56, 56)];
        UIImage *image = [UIImage imageNamed:@"photo_edit_tools_mosaic"];
        UIImage *imageSelected = [UIImage imageNamed:@"photo_edit_tools_mosaic_selected"];
        [_mosaicBtn setImage:image forState:UIControlStateNormal];
        [_mosaicBtn setImage:imageSelected forState:UIControlStateSelected];
        [_mosaicBtn setTitle:@"模糊" forState:UIControlStateNormal];
        [_mosaicBtn.titleLabel setFont:[UIFont hx_pingFangFontOfSize:10.0]];
        [_mosaicBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, -_mosaicBtn.titleLabel.intrinsicContentSize.width)];
        [_mosaicBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, -_mosaicBtn.currentImage.size.width, 0, 0)];
        [_mosaicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mosaicBtn setTitleColor:[UIColor hx_colorWithHexStr:HXThemeColor] forState:UIControlStateSelected];
        [_mosaicBtn addTarget:self action:@selector(didToolsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _mosaicBtn.tag = 3;
    }
    return _mosaicBtn;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setFrame:CGRectMake(HX_ScreenWidth-96, self.bgView.hx_h*0.5-32*0.5, 76, 32)];
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_doneBtn.titleLabel setFont:[UIFont hx_pingFangFontOfSize:14.0]];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneBtn setBackgroundColor:[UIColor hx_colorWithHexStr:HXThemeColor]];
        _doneBtn.layer.cornerRadius = 16.0;
        _doneBtn.clipsToBounds = YES;
        [_doneBtn addTarget:self action:@selector(didDoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
