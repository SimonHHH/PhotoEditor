//
//  PAEBPhotoEditGraffitiColorView.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/15.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditGraffitiColorView.h"
#import "PAEBPhotoEditGraffitiColorViewCell.h"
#import "PAEBPhotoEditDefine.h"
#import "UIImage+HXExtension.h"
#import "UIView+HXExtension.h"

@interface PAEBPhotoEditGraffitiColorView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIButton *repealBtn;
@property (nonatomic, strong) NSMutableArray *colorModels;
@property (nonatomic, strong) PAEBPhotoEditGraffitiColorModel *currentSelectModel;
@end

@implementation PAEBPhotoEditGraffitiColorView

+ (instancetype)initView {
    return [[self alloc] initWithFrame: CGRectMake(0, 0, HX_ScreenWidth, 56)];
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
    [self addSubview:self.repealBtn];
    [self addSubview:self.collectionView];
    
    self.repealBtn.enabled = NO;
    [self.repealBtn setImage:[UIImage imageNamed:@"photo_edit_repeal"] forState:UIControlStateNormal];
}

- (void)setUndo:(BOOL)undo {
    _undo = undo;
    self.repealBtn.enabled = undo;
}
- (void)setDrawColors:(NSArray<UIColor *> *)drawColors {
    _drawColors = drawColors;
    self.colorModels = @[].mutableCopy;
    for (UIColor *color in drawColors) {
        PAEBPhotoEditGraffitiColorModel *model = [[PAEBPhotoEditGraffitiColorModel alloc] init];
        model.color = color;
        [self.colorModels addObject:model];
        if (self.colorModels.count == self.defaultDarwColorIndex + 1) {
            model.selected = YES;
            self.currentSelectModel = model;
        }
    }
    [self.collectionView reloadData];
}

- (void)didRepealBtnClick:(UIButton *)sender {
    if (self.undoBlock) {
        self.undoBlock();
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colorModels.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PAEBPhotoEditGraffitiColorViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PAEBPhotoEditGraffitiColorViewCell class]) forIndexPath:indexPath];
    cell.model = self.colorModels[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PAEBPhotoEditGraffitiColorModel *model = self.colorModels[indexPath.item];
    if (self.currentSelectModel == model) {
        return;
    }
    if (self.currentSelectModel.selected) {
        self.currentSelectModel.selected = NO;
        PAEBPhotoEditGraffitiColorViewCell *beforeCell = (PAEBPhotoEditGraffitiColorViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[self.colorModels indexOfObject:self.currentSelectModel] inSection:0]];
        [beforeCell setSelected:NO];
    }
    model.selected = YES;
    self.currentSelectModel = model;
    if (self.selectColorBlock) {
        self.selectColorBlock(model.color);
    }
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.repealBtn.hx_x, 56) collectionViewLayout:self.flowLayout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerClass:[PAEBPhotoEditGraffitiColorViewCell class] forCellWithReuseIdentifier:NSStringFromClass([PAEBPhotoEditGraffitiColorViewCell class])];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _flowLayout.minimumInteritemSpacing = 5;
        _flowLayout.itemSize = CGSizeMake(30.f, 30.f);
    }
    return _flowLayout;
}

- (UIButton *)repealBtn {
    if (!_repealBtn) {
        _repealBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repealBtn setFrame:CGRectMake(self.hx_w-10-47, 0, 47, 56)];
        [_repealBtn addTarget:self action:@selector(didRepealBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repealBtn;
}


@end
