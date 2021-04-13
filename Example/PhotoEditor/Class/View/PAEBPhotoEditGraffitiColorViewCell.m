//
//  PAEBPhotoEditGraffitiColorViewCell.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditGraffitiColorViewCell.h"
#import "UIView+HXExtension.h"
#import "UIColor+HXExtension.h"

@interface PAEBPhotoEditGraffitiColorViewCell()
@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UIView *colorCenterView;
@end

@implementation PAEBPhotoEditGraffitiColorViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.colorView];
        [self.contentView addSubview:self.colorCenterView];
    }
    return self;
}

- (void)setModel:(PAEBPhotoEditGraffitiColorModel *)model {
    _model = model;
    if ([model.color hx_colorIsWhite]) {
        self.colorView.backgroundColor = [UIColor hx_colorWithHexStr:@"#dadada"];
    }else {
        self.colorView.backgroundColor = [UIColor whiteColor];
    }
    self.colorCenterView.backgroundColor = model.color;
    [self setupColor];
}

- (void)setupColor {
    if (self.model.selected) {
        self.colorView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }else {
        self.colorView.transform = CGAffineTransformIdentity;
    }
}
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.model.selected = selected;
    [UIView animateWithDuration:0.2 animations:^{
        [self setupColor];
    }];
}



- (UIView *)colorView {
    if (!_colorView) {
        CGFloat wh = 23.0;
        _colorView = [[UIView alloc] initWithFrame:CGRectMake(self.hx_w*0.5-wh*0.5, self.hx_h*0.5-wh*0.5, wh, wh)];
        _colorView.layer.cornerRadius = wh*0.5;
        _colorView.layer.masksToBounds = YES;
        _colorView.backgroundColor = [UIColor whiteColor];
    }
    return _colorView;
}

- (UIView *)colorCenterView {
    if (!_colorCenterView) {
        CGFloat wh = 18.0;
        _colorCenterView = [[UIView alloc] initWithFrame:CGRectMake(self.hx_w*0.5-wh*0.5, self.hx_h*0.5-wh*0.5, wh, wh)];
        _colorCenterView.layer.cornerRadius = wh*0.5;
        _colorCenterView.layer.masksToBounds = YES;
    }
    return _colorCenterView;
}


@end
