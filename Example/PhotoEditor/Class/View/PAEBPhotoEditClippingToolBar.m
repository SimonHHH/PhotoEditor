//
//  PAEBPhotoEditClippingToolBar.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/16.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditClippingToolBar.h"
#import "UIImage+HXExtension.h"
#import "UIButton+HXExtension.h"
#import "UIView+HXExtension.h"
#import "UIFont+HXExtension.h"
#import "PAEBPhotoEditDefine.h"

#define HXClipBarHeight 56.f

@interface PAEBPhotoEditClippingToolBar()
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *resetBtn;
@property (nonatomic, strong) UIButton *rotateBtn;

@end

@implementation PAEBPhotoEditClippingToolBar

+ (instancetype)initView {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, HX_ScreenWidth, HXClipBarHeight+HXBottomMargin)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    CGFloat btnWidHei = HXClipBarHeight;
    [self.cancelBtn setFrame:CGRectMake(6, 0, btnWidHei, btnWidHei)];
    [self addSubview:self.cancelBtn];
    
    self.resetBtn.hx_size = CGSizeMake(btnWidHei, btnWidHei);
    self.resetBtn.center = self.center;
    [self addSubview:self.resetBtn];
    
    self.rotateBtn.hx_size = CGSizeMake(btnWidHei, btnWidHei);
    self.rotateBtn.center = CGPointMake(self.cancelBtn.hx_maxX+(self.resetBtn.hx_x-self.cancelBtn.hx_maxX)*0.5, self.hx_centerY);
    [self addSubview:self.rotateBtn];
    
    [self.confirmBtn setFrame:CGRectMake(self.hx_w-6-btnWidHei, 0, btnWidHei, btnWidHei)];
    [self addSubview:self.confirmBtn];
    
    self.resetBtn.enabled = NO;
}



- (void)setEnableReset:(BOOL)enableReset {
    _enableReset = enableReset;
    self.resetBtn.enabled = enableReset;
}

- (void)didBtnClick:(UIButton *)sender {
    if (self.didBtnBlock) {
        self.didBtnBlock(sender.tag);
    }
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelBtn.tag = 0;
        [_cancelBtn setImage:[UIImage imageNamed:@"photo_edit_clip_cancel"] forState:UIControlStateNormal];
        _cancelBtn.tintColor = [UIColor whiteColor];
        [_cancelBtn addTarget:self action:@selector(didBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)rotateBtn {
    if (!_rotateBtn) {
        _rotateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_rotateBtn setImage:[UIImage imageNamed:@"photo_edit_clip_rotate"] forState:UIControlStateNormal];
        _rotateBtn.tintColor = [UIColor whiteColor];
        [_rotateBtn addTarget:self action:@selector(didRotateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rotateBtn;
}

- (UIButton *)resetBtn {
    if (!_resetBtn) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_resetBtn setTitle:@"还原" forState:UIControlStateNormal];
        _resetBtn.tag = 2;
        [_resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resetBtn.titleLabel setFont:[UIFont hx_pingFangFontOfSize:16.0]];
        [_resetBtn addTarget:self action:@selector(didBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _confirmBtn.tag = 1;
        [_confirmBtn setImage:[UIImage imageNamed:@"photo_edit_clip_confirm"] forState:UIControlStateNormal];
        _confirmBtn.tintColor = [UIColor whiteColor];
        [_confirmBtn addTarget:self action:@selector(didBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (void)didRotateBtnClick:(UIButton *)button {
    if (self.didRotateBlock) {
        self.didRotateBlock();
    }
}

@end
