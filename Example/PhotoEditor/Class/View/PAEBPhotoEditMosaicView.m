//
//  PAEBPhotoEditMosaicView.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/16.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditMosaicView.h"
#import "UIImage+HXExtension.h"
#import "UIView+HXExtension.h"
#import "PAEBPhotoEditDefine.h"

@interface PAEBPhotoEditMosaicView()
@property (nonatomic, strong) UIButton *undoBtn;
@end

@implementation PAEBPhotoEditMosaicView

+ (instancetype)initView {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, HX_ScreenWidth, 56.0)];
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
    CGFloat btnWidHei = 56.0;
    [self.undoBtn setFrame:CGRectMake(self.hx_w-btnWidHei-6, 0, btnWidHei, btnWidHei)];
    [self addSubview:self.undoBtn];
    self.undoBtn.enabled = NO;
}

- (void)setUndo:(BOOL)undo {
    _undo = undo;
    self.undoBtn.enabled = undo;
}

- (void)didUndoBtn:(UIButton *)button {
    if (self.undoBlock) {
        self.undoBlock();
    }
}

- (UIButton *)undoBtn {
    if (!_undoBtn) {
        _undoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _undoBtn.tintColor = [UIColor whiteColor];
        [_undoBtn addTarget:self action:@selector(didUndoBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_undoBtn setImage:[UIImage hx_imageOfName:@"photo_edit_repeal"] forState:UIControlStateNormal];
    }
    return _undoBtn;
}

@end
