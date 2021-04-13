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
@property (strong, nonatomic) UIImage *editImage;

@property (strong, nonatomic) PAEBPhotoModel *photoModel;
/// 编辑的数据
/// 传入之前的编辑数据可以在原有基础上继续编辑
@property (strong, nonatomic) PAEBPhotoEdit *photoEdit;

/// 只要裁剪
@property (assign, nonatomic) BOOL onlyCliping;

@property (weak, nonatomic) id<PAEBPhotoEditViewControllerDelegate> delegate;

@property (copy, nonatomic) PAEBPhotoEditViewControllerDidFinishBlock finishBlock;

@property (copy, nonatomic) PAEBPhotoEditViewControllerDidCancelBlock cancelBlock;

- (instancetype)initWithConfiguration:(PAEBPhotoEditConfiguration *)configuration;
- (instancetype)initWithPhotoEdit:(PAEBPhotoEdit *)photoEdit
                    configuration:(PAEBPhotoEditConfiguration *)configuration;

#pragma mark - < other >
@property (assign, nonatomic) BOOL isCancel;

@end

NS_ASSUME_NONNULL_END
