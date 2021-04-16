//
//  PAEBPhotoEditViewController.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/7.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAEBPhotoModel.h"
#import "PAEBPhotoEditConfiguration.h"
#import "PAEBPhotoEdit.h"


NS_ASSUME_NONNULL_BEGIN

@class PAEBPhotoEditViewController, PAEBPhotoModel;

typedef void (^ PAEBPhotoEditViewControllerDidFinishBlock)(PAEBPhotoEdit *photoEdit, PAEBPhotoModel *photoModel, PAEBPhotoEditViewController *viewController);
typedef void (^ PAEBPhotoEditViewControllerDidCancelBlock)(PAEBPhotoEditViewController   *viewController);

@protocol PAEBPhotoEditViewControllerDelegate <NSObject>
@optional
/// 照片编辑完成
/// @param photoEditingVC 编辑控制器
/// @param photoEdit 编辑完之后的数据，如果为nil。则未处理
- (void)photoEditingController:(PAEBPhotoEditViewController *)photoEditingVC
            didFinishPhotoEdit:(PAEBPhotoEdit *)photoEdit
                    photoModel:(PAEBPhotoModel *)photoModel;

/// 取消编辑
/// @param photoEditingVC 编辑控制器
- (void)photoEditingControllerDidCancel:(PAEBPhotoEditViewController *)photoEditingVC;
@end


@interface PAEBPhotoEditViewController : UIViewController
/// 编辑配置
@property (nonatomic, strong) PAEBPhotoEditConfiguration *configuration;
/// 编辑原图
@property (nonatomic, strong) UIImage *editImage;

@property (nonatomic, strong) PAEBPhotoModel *photoModel;
/// 编辑的数据
/// 传入之前的编辑数据可以在原有基础上继续编辑
@property (nonatomic, strong) PAEBPhotoEdit *photoEdit;

/// 只要裁剪
@property (nonatomic, assign) BOOL onlyCliping;

@property (nonatomic, weak) id<PAEBPhotoEditViewControllerDelegate> delegate;

@property (nonatomic, copy) PAEBPhotoEditViewControllerDidFinishBlock finishBlock;

@property (nonatomic, copy) PAEBPhotoEditViewControllerDidCancelBlock cancelBlock;

- (instancetype)initWithConfiguration:(PAEBPhotoEditConfiguration *)configuration;
- (instancetype)initWithPhotoEdit:(PAEBPhotoEdit *)photoEdit
                    configuration:(PAEBPhotoEditConfiguration *)configuration;

#pragma mark - < other >
@property (nonatomic, assign) BOOL imageRequestComplete;
@property (nonatomic, assign) BOOL transitionCompletion;
@property (nonatomic, assign) BOOL isCancel;
- (CGRect)getImageFrame;
- (void)showBgViews;
- (void)completeTransition:(UIImage *)image;
- (CGRect)getDismissImageFrame;
- (UIImage *)getCurrentImage;
- (void)hideImageView;
- (void)hiddenTopBottomView;
- (void)showTopBottomView;
@end

NS_ASSUME_NONNULL_END
