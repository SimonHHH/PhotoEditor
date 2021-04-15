//
//  PAEBPhotoModel.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/12.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "PAEBPhotoEdit.h"
#import "PAEBAssetManager.h"

@class PAEBPhotoModel;
typedef void (^ PAEBModelStartRequestICloud)(PHImageRequestID iCloudRequestId, PAEBPhotoModel * _Nullable model);
typedef void (^ PAEBModelProgressHandler)(double progress, PAEBPhotoModel * _Nullable model);
typedef void (^ PAEBModelImageDataSuccessBlock)(NSData * _Nullable imageData, UIImageOrientation orientation, PAEBPhotoModel * _Nullable model, NSDictionary * _Nullable info);
typedef void (^ PAEBModelFailedBlock)(NSDictionary * _Nullable info, PAEBPhotoModel * _Nullable model);
typedef void (^ PAEBModelImageURLSuccessBlock)(NSURL * _Nullable imageURL, PAEBPhotoModel * _Nullable model, NSDictionary * _Nullable info);
typedef void (^ PAEBModelLivePhotoSuccessBlock)(PHLivePhoto * _Nullable livePhoto, PAEBPhotoModel * _Nullable model, NSDictionary * _Nullable info);
typedef void (^ PAEBModelImageSuccessBlock)(UIImage * _Nullable image, PAEBPhotoModel * _Nullable model, NSDictionary * _Nullable info);


typedef NS_ENUM(NSUInteger, PAEBPhotoModelFormat) {
    PAEBPhotoModelFormatUnknown = 0,  //!< 未知格式
    PAEBPhotoModelFormatPNG,          //!< PNG格式
    PAEBPhotoModelFormatJPG,          //!< JPG格式
    PAEBPhotoModelFormatHEIC          //!< HEIC格式
};

typedef NS_ENUM(NSUInteger, PAEBPhotoModelMediaType) {
    PAEBPhotoModelMediaTypePhoto          = 0,    //!< 照片
    PAEBPhotoModelMediaTypeLivePhoto,             //!< LivePhoto
    PAEBPhotoModelMediaTypeCameraPhoto,           //!< 通过相机拍的临时照片、本地/网络图片
    PAEBPhotoModelMediaTypeCamera                 //!< 跳转相机
};

typedef NS_ENUM(NSUInteger, PAEBPhotoModelMediaTypeCameraPhotoType) {
    PAEBPhotoModelMediaTypeCameraPhotoTypeLocal = 1,          //!< 本地图片
    PAEBPhotoModelMediaTypeCameraPhotoTypeNetWork,            //!< 网络图片
    PAEBPhotoModelMediaTypeCameraPhotoTypeLocalLivePhoto,     //!< 本地LivePhoto
    PAEBPhotoModelMediaTypeCameraPhotoTypeNetWorkLivePhoto    //!< 网络LivePhoto
};


@interface PAEBPhotoModel : NSObject<NSCoding>
/// PHAsset对象
@property (nonatomic, strong) PHAsset * _Nullable asset;
/// 照片格式
@property (assign, nonatomic) PAEBPhotoModelFormat photoFormat;
/// 照片类型
@property (assign, nonatomic) PAEBPhotoModelMediaType type;
/// 照片子类型
@property (assign, nonatomic) PAEBPhotoModelMediaTypeCameraPhotoType cameraPhotoType;
/// 照片原始宽高
@property (assign, nonatomic) CGSize imageSize;

/// 编辑的数据
/// 传入之前的编辑数据可以在原有基础上继续编辑
@property (strong, nonatomic) PAEBPhotoEdit * _Nullable photoEdit;

/// 临时的列表小图 - 本地图片才用这个上传
/// 获取图片请使用 request相关方法
@property (strong, nonatomic) UIImage * _Nullable thumbPhoto;

/// 临时的预览大图  - 本地图片才用这个上传
/// 获取图片请使用 request相关方法
@property (strong, nonatomic) UIImage * _Nullable previewPhoto;

/// 图片本地地址
/// 正常情况下为空
/// 1.调用过 requestImageURLStartRequestICloud 这个方法会有值
/// 2.HXPhotoConfiguration.requestImageAfterFinishingSelection = YES 时，并且选择了原图或者 tpye = HXPhotoModelMediaTypePhotoGif 有值
@property (strong, nonatomic) NSURL * _Nullable imageURL;


#pragma mark - < Disabled >
/// 是否正在下载iCloud上的资源
@property (assign, nonatomic) BOOL iCloudDownloading;

/// iCloud下载进度
@property (assign, nonatomic) CGFloat iCloudProgress;

/// 下载iCloud的请求id
@property (assign, nonatomic) PHImageRequestID iCloudRequestID;

/// 通过PHAsset对象初始化
/// @param asset PHAsset
+ (instancetype _Nullable)photoModelWithPHAsset:(PHAsset * _Nullable)asset;

- (PHImageRequestID)requestImageDataWithLoadOriginalImage:(BOOL)originalImage
                                       startRequestICloud:(PAEBModelStartRequestICloud _Nonnull)startRequestICloud
                                          progressHandler:(PAEBModelProgressHandler _Nullable)progressHandler
                                                  success:(PAEBModelImageDataSuccessBlock _Nullable)success
                                                   failed:(PAEBModelFailedBlock _Nullable)failed;

- (PHContentEditingInputRequestID)requestImageURLStartRequestICloud:(void (^_Nonnull)(PHContentEditingInputRequestID iCloudRequestId, PAEBPhotoModel * _Nullable model))startRequestICloud
                                                    progressHandler:(PAEBModelProgressHandler _Nullable)progressHandler
                                                            success:(PAEBModelImageURLSuccessBlock _Nullable)success
                                                             failed:(PAEBModelFailedBlock _Nullable)failed;

- (PHImageRequestID)requestPreviewImageWithSize:(CGSize)size
                             startRequestICloud:(PAEBModelStartRequestICloud _Nullable)startRequestICloud
                                progressHandler:(PAEBModelProgressHandler _Nullable)progressHandler
                                        success:(PAEBModelImageSuccessBlock _Nullable)success failed:(PAEBModelFailedBlock _Nullable)failed;

@end

