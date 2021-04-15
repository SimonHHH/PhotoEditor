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
#import "PAEBPhotoEditImageView.h"
#import "PAEBPhotoEditStickerItem.h"
#import "PAEBPhotoEditingView.h"
#import "PAEBPhotoClippingView.h"

#import "UIView+HXExtension.h"
#import "UIImage+HXExtension.h"
#import "UIButton+HXExtension.h"

#import "PAEBHXCancelBlock.h"


#define HXGraffitiColorViewHeight 60.f
#define HXmosaicViewHeight 60.f
#define HXClippingToolBar 60.f

@interface PAEBPhotoEditViewController () <UIGestureRecognizerDelegate, PAEBPhotoEditingViewDelegate>
@property (nonatomic, strong) UIView *topMaskView;
@property (nonatomic, strong) CAGradientLayer *topMaskLayer;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIView *bottomMaskView;
@property (nonatomic, strong) CAGradientLayer *bottomMaskLayer;

@property (strong, nonatomic) PAEBPhotoEditingView *editingView;

@property (assign, nonatomic) PHContentEditingInputRequestID requestId;
@property (assign, nonatomic) CGFloat imageWidth;
@property (assign, nonatomic) CGFloat imageHeight;

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
    [self setupPhotoModel];
    [self.view addSubview:self.editingView];
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

- (void)showBgViews {
    self.backBtn.userInteractionEnabled = YES;
    self.toolsView.userInteractionEnabled = YES;
//    self.graffitiColorView.userInteractionEnabled = YES;
//    self.graffitiColorSizeView.userInteractionEnabled = YES;
//    self.mosaicView.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.backBtn.alpha = 1;
        self.toolsView.alpha = 1;
//        self.graffitiColorView.alpha = 1;
//        self.graffitiColorSizeView.alpha = 1;
//        self.mosaicView.alpha = 1;
        self.topMaskView.alpha = 1;
        self.bottomMaskView.alpha = 1;
    }];
}

- (void)hideBgViews {
    self.backBtn.userInteractionEnabled = NO;
    self.toolsView.userInteractionEnabled = NO;
//    self.graffitiColorView.userInteractionEnabled = NO;
//    self.graffitiColorSizeView.userInteractionEnabled = NO;
//    self.mosaicView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.backBtn.alpha = 0;
        self.toolsView.alpha = 0;
//        self.graffitiColorView.alpha = 0;
//        self.graffitiColorSizeView.alpha = 0;
//        self.mosaicView.alpha = 0;
        self.topMaskView.alpha = 0;
        self.bottomMaskView.alpha = 0;
    }];
}

- (void)setupPhotoModel {
    self.imageWidth = self.photoModel.imageSize.width;
    self.imageHeight = self.photoModel.imageSize.height;
    if (self.photoModel.photoEdit) {
        self.imageRequestComplete = YES;
        if (!self.transitionCompletion) {
            self.editingView.hidden = YES;
        }
        self.photoEdit = self.photoModel.photoEdit;
        if (self.editImage) {
            self.editingView.image = self.editImage;
            [self setupPhotoData];
        }else {
            [self setAsetImage];
        }
    }else {
        [self setAsetImage];
    }
}

- (void)setAsetImage {
    if (self.photoModel.asset) {
        [self requestImageData];
    }else {
        UIImage *image;
        if (self.photoModel.thumbPhoto.images.count > 1) {
            image = self.photoModel.thumbPhoto.images.firstObject;
        }else {
            image = self.photoModel.thumbPhoto;
        }
        CGSize imageSize = image.size;
        if (imageSize.width * imageSize.height > 3 * 1000 * 1000) {
            while (imageSize.width * imageSize.height > 3 * 1000 * 1000) {
                imageSize.width /= 2;
                imageSize.height /= 2;
            }
            image = [image hx_scaleToFillSize:imageSize];
        }
        self.editImage = image;
        [self loadImageCompletion];
    }
}

- (void)loadImageCompletion {
    self.imageRequestComplete = YES;
    if (self.transitionCompletion) {
        self.editingView.image = self.editImage;
        [self setupPhotoData];
        if (self.onlyCliping) {
            [self.editingView setClipping:YES animated:YES];
//            [self.clippingToolBar setRotateAlpha:1.f];
            [UIView animateWithDuration:0.2 animations:^{
//                self.clippingToolBar.alpha = 1;
            }];
        }
//        [self.view hx_handleLoading];
    }
}

- (void)requestImageData {
    HXWeakSelf
    self.requestId = [self.photoModel requestImageDataWithLoadOriginalImage:YES startRequestICloud:^(PHImageRequestID iCloudRequestId, PAEBPhotoModel * _Nullable model) {
        weakSelf.requestId = iCloudRequestId;
    } progressHandler:nil success:^(NSData * _Nullable imageData, UIImageOrientation orientation, PAEBPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
        @autoreleasepool {
            UIImage *image = [UIImage imageWithData:imageData];
            [weakSelf requestImageCompletion:image];
        }
    } failed:^(NSDictionary * _Nullable info, PAEBPhotoModel * _Nullable model) {
        [weakSelf requestImageURL];
    }];
}

- (void)requestImageURL {
    HXWeakSelf
    self.requestId = [self.photoModel requestImageURLStartRequestICloud:^(PHContentEditingInputRequestID iCloudRequestId, PAEBPhotoModel *model) {
        weakSelf.requestId = iCloudRequestId;
    } progressHandler:nil success:^(NSURL *imageURL, PAEBPhotoModel *model, NSDictionary *info) {
        @autoreleasepool {
            NSData * imageData = [NSData dataWithContentsOfFile:imageURL.relativePath];
            UIImage *image = [UIImage imageWithData:imageData];
            [weakSelf requestImageCompletion:image];
        }
    } failed:^(NSDictionary *info, PAEBPhotoModel *model) {
        [weakSelf requestImage];
    }];
}

- (void)requestImage {
    HXWeakSelf
    self.requestId = [self.photoModel requestPreviewImageWithSize:PHImageManagerMaximumSize startRequestICloud:^(PHImageRequestID iCloudRequestId, PAEBPhotoModel * _Nullable model) {
        weakSelf.requestId = iCloudRequestId;
    } progressHandler:nil success:^(UIImage * _Nullable image, PAEBPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
        if (image.images.count > 1) {
            image = image.images.firstObject;
        }
        [weakSelf requestImageCompletion:image];
    } failed:^(NSDictionary * _Nullable info, PAEBPhotoModel * _Nullable model) {
//        [weakSelf.view hx_handleLoading];
        [weakSelf loadImageCompletion];
    }];
}

- (void)requestImageCompletion:(UIImage *)image {
    if (image.imageOrientation != UIImageOrientationUp) {
        image = [image hx_normalizedImage];
    }
    CGSize imageSize = image.size;
    if (imageSize.width * imageSize.height > 3 * 1000 * 1000) {
        while (imageSize.width * imageSize.height > 3 * 1000 * 1000) {
            imageSize.width /= 2;
            imageSize.height /= 2;
        }
        image = [image hx_scaleToFillSize:imageSize];
    }
    self.editImage = image;
    [self loadImageCompletion];
}

- (void)setupPhotoData {
    if (self.editData) {
        self.editingView.photoEditData = self.editData;
//        self.graffitiColorView.undo = self.editingView.clippingView.imageView.drawView.canUndo;
//        self.mosaicView.undo = self.editingView.clippingView.imageView.splashView.canUndo;
        self.editData = nil;
    }
}



- (void)didBgViewClick {
    [UIView cancelPreviousPerformRequestsWithTarget:self];
    if (self.toolsView.alpha != 1) {
//        [self showBgViews];
    }else {
//        [self hideBgViews];
    }
}

#pragma mark - PAEBPhotoEditingViewDelegate
- (void)editingViewViewDidEndZooming:(PAEBPhotoEditingView *)editingView {
    CGFloat lineWidth = self.configuration.brushLineWidth / editingView.zoomScale;
    self.editingView.drawLineWidth = lineWidth;
}
/** 开始编辑目标 */
- (void)editingViewWillBeginEditing:(PAEBPhotoEditingView *)EditingView {
    [UIView animateWithDuration:0.25f animations:^{
//        [self.clippingToolBar setRotateAlpha: 0.5f];
    }];
}
/** 停止编辑目标 */
- (void)editingViewDidEndEditing:(PAEBPhotoEditingView *)EditingView {
    [UIView animateWithDuration:0.25f animations:^{
//        [self.clippingToolBar setRotateAlpha:1.f];
    }];
//    self.clippingToolBar.enableReset = self.editingView.canReset;
}
/** 进入剪切界面 */
- (void)editingViewDidAppearClip:(PAEBPhotoEditingView *)EditingView {
//    self.clippingToolBar.enableReset = self.editingView.canReset;
}
/// 离开剪切界面
- (void)editingViewDidDisappearClip:(PAEBPhotoEditingView *)EditingView {
    
}


#pragma mark <GET/SET>
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
//                }else {
//                    weakSelf.editingView.clippingView.imageView.type = HXPhotoEditImageViewTypeNormal;
//                    [weakSelf.graffitiColorView removeFromSuperview];
//                }
            }else if (tag == 1) {
                // 文字
                [PAEBPhotoEditTextView showEitdTextViewWithConfiguration:weakSelf.configuration completion:^(PAEBPhotoEditTextModel * _Nonnull textModel) {
                    PAEBPhotoEditStickerItem *item = [[PAEBPhotoEditStickerItem alloc] init];
                    item.textModel = textModel;
                    [weakSelf.editingView.clippingView.imageView.stickerView addStickerItem:item isSelected:YES];
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

- (PAEBPhotoEditingView *)editingView {
    if (!_editingView) {
        _editingView = [[PAEBPhotoEditingView alloc] initWithFrame:self.view.bounds];
        _editingView.onlyCliping = self.onlyCliping;
        _editingView.configuration = self.configuration;
        _editingView.clippingDelegate = self;
        if (self.configuration.drawColors.count > self.configuration.defaultDarwColorIndex) {
            _editingView.clippingView.imageView.drawView.lineColor = self.configuration.drawColors[self.configuration.defaultDarwColorIndex];
        }else {
            _editingView.clippingView.imageView.drawView.lineColor = self.configuration.drawColors.firstObject;
        }

        CGFloat lineWidth = self.configuration.brushLineWidth;
        _editingView.drawLineWidth = lineWidth;
        HXWeakSelf
        /** 模糊 */
        _editingView.clippingView.imageView.splashView.splashBegan = ^{
            [weakSelf hideBgViews];
            [UIView cancelPreviousPerformRequestsWithTarget:weakSelf];
        };
        _editingView.clippingView.imageView.splashView.splashEnded = ^{
//            weakSelf.mosaicView.undo = YES;
            [weakSelf performSelector:@selector(showBgViews) withObject:nil afterDelay:.5f];
        };
        _editingView.clippingView.imageView.drawView.beganDraw = ^{
            // 开始绘画
            [weakSelf hideBgViews];
            [UIView cancelPreviousPerformRequestsWithTarget:weakSelf];
        };
        _editingView.clippingView.imageView.drawView.endDraw = ^{
            // 结束绘画
//            weakSelf.graffitiColorView.undo = YES;
            [weakSelf performSelector:@selector(showBgViews) withObject:nil afterDelay:.5f];
        };
        _editingView.clippingView.imageView.stickerView.touchBegan = ^(PAEBPhotoEditStickerItemView * _Nonnull itemView) {
            [weakSelf hideBgViews];
        };
        _editingView.clippingView.imageView.stickerView.touchEnded = ^(PAEBPhotoEditStickerItemView * _Nonnull itemView) {
            [weakSelf showBgViews];
        };
    }
    return _editingView;
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

- (void)setEditImage:(UIImage *)editImage {
    _editImage = HX_UIImageDecodedCopy(editImage);
}

- (void)setPhotoEdit:(PAEBPhotoEdit *)photoEdit {
    _photoEdit = photoEdit;
    if (photoEdit) {
        NSData *imageData = [NSData dataWithContentsOfFile:photoEdit.imagePath];
        _editImage = [UIImage imageWithData:imageData];
        self.editData = photoEdit.editData;
    }
}
@end
