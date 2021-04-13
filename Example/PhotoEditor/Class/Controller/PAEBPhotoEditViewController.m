//
//  PAEBPhotoEditViewController.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/7.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditViewController.h"
#import "PAEBPhotoEditDefine.h"
#import "PAEBPhotoEditBottomView.h"
#import "PAEBPhotoEditTextView.h"
#import "UIView+HXExtension.h"
#import "UIButton+HXExtension.h"


#define HXGraffitiColorViewHeight 60.f
#define HXmosaicViewHeight 60.f
#define HXClippingToolBar 60.f

@interface PAEBPhotoEditViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *topMaskView;
@property (nonatomic, strong) CAGradientLayer *topMaskLayer;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIView *bottomMaskView;
@property (nonatomic, strong) CAGradientLayer *bottomMaskLayer;

@property (assign, nonatomic) PHContentEditingInputRequestID requestId;

@property (nonatomic, strong) PAEBPhotoEditBottomView *toolsView;

@property (nonatomic, weak) UITapGestureRecognizer *tap;
@property (nonatomic, strong, nullable) NSDictionary *editData;
@end

@implementation PAEBPhotoEditViewController 

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (instancetype)initWithConfiguration:(PAEBPhotoEditConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.configuration = configuration;
    }
    return self;
}

- (instancetype)initWithPhotoEdit:(PAEBPhotoEdit *)photoEdit
                    configuration:(PAEBPhotoEditConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.photoEdit = photoEdit;
        self.configuration = configuration;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.requestId) {
        [self.photoModel.asset cancelContentEditingInputRequest:self.requestId];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showTopBottomView];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self hiddenTopBottomView];
}

- (void)setupUI {
    if (!self.onlyCliping) {
        self.onlyCliping = self.configuration.onlyCliping;
    }
    self.backBtn.alpha = 0;
//    self.clippingToolBar.alpha = 0;
    self.toolsView.alpha = 0;
    self.topMaskView.alpha = 0;
    self.bottomMaskView.alpha = 0;
//
    self.view.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewClick)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    self.tap = tap;
    self.view.exclusiveTouch = YES;
//    [self setupPhotoModel];
//    [self.view addSubview:self.editingView];
    [self.view addSubview:self.bottomMaskView];
//    if (self.onlyCliping) {
//        [self.view addSubview:self.clippingToolBar];
//        [self.editingView photoEditEnable:NO];
//        self.tap.enabled = NO;
//        self.clippingToolBar.userInteractionEnabled = YES;
//    }else {
        [self.view addSubview:self.topMaskView];
        [self.topMaskView addSubview:self.backBtn];
        [self.view addSubview:self.toolsView];
//        [self.view addSubview:self.clippingToolBar];
//        [self.view addSubview:self.brushLineWidthPromptView];
//    }
}

- (void)hiddenTopBottomView {
    self.backBtn.hx_y = HXNavigationBarHeight - 20 - self.backBtn.hx_h - 13;
//    self.clippingToolBar.hx_y = self.view.hx_h;
    self.toolsView.hx_y = self.view.hx_h;
}

- (void)showTopBottomView {
    [self changeSubviewFrame];
    self.backBtn.alpha = 1;
    if (self.onlyCliping) {
//        self.clippingToolBar.alpha = 1;
    }
    self.toolsView.alpha = 1;
    self.topMaskView.alpha = 1;
    self.bottomMaskView.alpha = 1;
}

- (void)changeSubviewFrame {
    CGFloat leftMargin = HXBottomMargin;
    leftMargin = 0;
    self.backBtn.hx_x = 20;
    self.backBtn.hx_y = HXNavigationBarHeight - 13 - self.backBtn.hx_h;
//    self.clippingToolBar.frame = CGRectMake(0, self.view.hx_h - HXClippingToolBar - hxBottomMargin, self.view.hx_w, HXClippingToolBar + hxBottomMargin);
    self.toolsView.frame = CGRectMake(0, self.view.hx_h - 56 - HXBottomMargin, self.view.hx_w, 56 + HXBottomMargin);
        
//    self.graffitiColorView.frame = CGRectMake(leftMargin, self.toolsView.hx_y - HXGraffitiColorViewHeight, self.view.hx_w - leftMargin * 2, HXGraffitiColorViewHeight);
//    self.graffitiColorSizeView.frame = CGRectMake(self.view.hx_w - 50 - 12, 0, 50, 180);
//    self.graffitiColorSizeView.hx_centerY = self.view.hx_h / 2;
//    [self setBrushinePromptViewSize];
    
//    self.mosaicView.frame = CGRectMake(leftMargin, self.toolsView.hx_y - HXmosaicViewHeight, self.view.hx_w - leftMargin * 2, HXmosaicViewHeight);
    self.topMaskView.frame = CGRectMake(0, 0, HX_ScreenWidth, HXNavigationBarHeight);
    self.topMaskLayer.frame = CGRectMake(0, 0, HX_ScreenWidth, HXNavigationBarHeight + 30.f);

    self.bottomMaskView.frame = CGRectMake(0, HX_ScreenHeight - HXBottomMargin - 120, HX_ScreenWidth, HXBottomMargin + 120);
    self.bottomMaskLayer.frame = self.bottomMaskView.bounds;
}

- (void)setPhotoEdit:(PAEBPhotoEdit *)photoEdit {
    _photoEdit = photoEdit;
    if (photoEdit) {
        NSData *imageData = [NSData dataWithContentsOfFile:photoEdit.imagePath];
        _editImage = [UIImage imageWithData:imageData];
        self.editData = photoEdit.editData;
    }
}

- (PAEBPhotoEditBottomView *)toolsView {
    if (!_toolsView) {
        _toolsView = [[PAEBPhotoEditBottomView alloc] initWithFrame:CGRectMake(0, self.view.hx_h - 56 - HXBottomMargin, self.view.hx_w, 56 + HXBottomMargin)];
        HXWeakSelf
        _toolsView.didToolsBtnBlock = ^(NSInteger tag, BOOL isSelected) {
//            [weakSelf.editingView.clippingView.imageView.stickerView removeSelectItem];
            if (tag == 0) {
                // 绘画
//                [weakSelf.mosaicView removeFromSuperview];
//                weakSelf.editingView.splashEnable = NO;
//                weakSelf.editingView.drawEnable = isSelected;
//                if (isSelected) {
//                    weakSelf.editingView.clippingView.imageView.type = HXPhotoEditImageViewTypeDraw;
//                    [weakSelf.view addSubview:weakSelf.graffitiColorView];
//                    [weakSelf.view addSubview:weakSelf.graffitiColorSizeView];
//                }else {
//                    weakSelf.editingView.clippingView.imageView.type = HXPhotoEditImageViewTypeNormal;
//                    [weakSelf.graffitiColorView removeFromSuperview];
//                    [weakSelf.graffitiColorSizeView removeFromSuperview];
//                }
            }else if (tag == 1) {
                // 文字
                [PAEBPhotoEditTextView showEitdTextViewWithConfiguration:weakSelf.configuration completion:^(PAEBPhotoEditTextModel * _Nonnull textModel) {
//                    PAEBPhotoEditStickerItem *item = [[PAEBPhotoEditStickerItem alloc] init];
//                    item.textModel = textModel;
//                    [weakSelf.editingView.clippingView.imageView.stickerView addStickerItem:item isSelected:YES];
                }];
            }else if (tag == 2) {
                // 裁剪
//                [weakSelf.editingView photoEditEnable:!isSelected];
//                weakSelf.tap.enabled = !isSelected;
//                weakSelf.clippingToolBar.userInteractionEnabled = isSelected;
//                [UIView animateWithDuration:0.25 animations:^{
//                    weakSelf.clippingToolBar.alpha = isSelected ? 1 : 0;
//                }];
//                [weakSelf.clippingToolBar setRotateAlpha:1.f];
//                if (isSelected) {
//                    [weakSelf.editingView setClipping:YES animated:YES];
//                    [weakSelf hideBgViews];
//                    weakSelf.bottomMaskView.alpha = 1;
//                }else {
//                    [weakSelf showBgViews];
//                }
            }else if (tag == 3) {
                // 马赛克
//                weakSelf.editingView.drawEnable = NO;
//                weakSelf.editingView.splashEnable = isSelected;
//                weakSelf.editingView.clippingView.imageView.type = HXPhotoEditImageViewTypeNormal;
//                [weakSelf.graffitiColorView removeFromSuperview];
//                [weakSelf.graffitiColorSizeView removeFromSuperview];
//                if (isSelected) {
//                    weakSelf.editingView.clippingView.imageView.type = HXPhotoEditImageViewTypeSplash;
//                    [weakSelf.view addSubview:weakSelf.mosaicView];
//                }else {
//                    weakSelf.editingView.clippingView.imageView.type = HXPhotoEditImageViewTypeNormal;
//                    [weakSelf.mosaicView removeFromSuperview];
//                }
            }
        };
        _toolsView.didDoneBtnBlock = ^{
//            [weakSelf startEditImage];
        };
    }
    return _toolsView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backBtn.hx_size = _backBtn.titleLabel.intrinsicContentSize;
        _backBtn.hx_x = 20;
        [_backBtn hx_setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
        [_backBtn addTarget:self action:@selector(didBackClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (void)didBackClick {
    if (self.cancelBlock) {
        self.cancelBlock(self);
    }
    self.isCancel = YES;
    if (self.navigationController.viewControllers.count <= 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIView *)topMaskView {
    if (!_topMaskView) {
        _topMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HX_ScreenWidth, HXNavigationBarHeight)];
        self.topMaskLayer.frame = CGRectMake(0, 0, HX_ScreenWidth, HXNavigationBarHeight + 30.f);
        [_topMaskView.layer addSublayer:self.topMaskLayer];
    }
    return _topMaskView;
}

- (UIView *)bottomMaskView {
    if (!_bottomMaskView) {
        _bottomMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, HX_ScreenHeight - HXBottomMargin - 120, HX_ScreenWidth, HXBottomMargin + 120)];
        _bottomMaskView.userInteractionEnabled = NO;
        self.bottomMaskLayer.frame = _bottomMaskView.bounds;
        [_bottomMaskView.layer addSublayer:self.bottomMaskLayer];
    }
    return _bottomMaskView;;
}

- (CAGradientLayer *)bottomMaskLayer {
    if (!_bottomMaskLayer) {
        _bottomMaskLayer = [CAGradientLayer layer];
        _bottomMaskLayer.colors = @[
                                    (id)[[UIColor blackColor] colorWithAlphaComponent:0].CGColor,
                                    (id)[[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor
                                    ];
        _bottomMaskLayer.startPoint = CGPointMake(0, 0);
        _bottomMaskLayer.endPoint = CGPointMake(0, 1);
        _bottomMaskLayer.locations = @[@(0),@(1.f)];
        _bottomMaskLayer.borderWidth  = 0.0;
    }
    return _bottomMaskLayer;
}

- (PAEBPhotoEditConfiguration *)configuration {
    if (!_configuration) {
        _configuration = [[PAEBPhotoEditConfiguration alloc] init];
    }
    return _configuration;
}

@end
