//
//  PAEBPhotoModel.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/12.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoModel.h"
#import "PAEBPhotoEditDefine.h"
#import "NSString+HXExtension.h"
#import "UIImage+HXExtension.h"

@class PAEBPhotoModel;
@implementation PAEBPhotoModel


+ (instancetype)photoModelWithPHAsset:(PHAsset *)asset {
    return [[self alloc] initWithPHAsset:asset];
}

- (instancetype)initWithPHAsset:(PHAsset *)asset {
    if (self = [super init]) {
        self.type = PAEBPhotoModelMediaTypePhoto;
        self.asset = asset;
    }
    return self;
}


- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.photoEdit forKey:@"photoEdit"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if (self = [super init]) {
        self.photoEdit =  [coder decodeObjectForKey:@"photoEdit"];
    }
    return self;
}

- (PHImageRequestID)requestImageDataWithLoadOriginalImage:(BOOL)originalImage
                                       startRequestICloud:(PAEBModelStartRequestICloud)startRequestICloud
                                          progressHandler:(PAEBModelProgressHandler)progressHandler
                                                  success:(PAEBModelImageDataSuccessBlock)success
                                                   failed:(PAEBModelFailedBlock)failed {
    
    PHImageRequestOptionsVersion version = 0;
    self.iCloudDownloading = YES;
    PHImageRequestID requestID = [PAEBAssetManager requestImageDataForAsset:self.asset version:version resizeMode:PHImageRequestOptionsResizeModeFast networkAccessAllowed:NO progressHandler:nil completion:^(NSData * _Nonnull imageData, UIImageOrientation orientation, NSDictionary<NSString *,id> * _Nonnull info) {
        __strong typeof(self) strongSelf = self;
        [strongSelf requestDataWithResult:imageData info:info size:CGSizeZero resultClass:[NSData class] orientation:orientation audioMix:nil startRequestICloud:startRequestICloud progressHandler:progressHandler success:^(id result, NSDictionary *info, UIImageOrientation orientation, AVAudioMix *audioMix) {
            if (success) {
                success(result, orientation, strongSelf, info);
            }
        } failed:failed];
    }];
    self.iCloudRequestID = requestID;
    return requestID;
}

- (void)requestDataWithResult:(id)results
                         info:(NSDictionary *)info
                         size:(CGSize)size
                  resultClass:(Class)resultClass
                  orientation:(UIImageOrientation)orientation
                     audioMix:(AVAudioMix *)audioMix
           startRequestICloud:(PAEBModelStartRequestICloud)startRequestICloud
              progressHandler:(PAEBModelProgressHandler)progressHandler
                      success:(void (^)(id result, NSDictionary *info, UIImageOrientation orientation, AVAudioMix *audioMix))success
                       failed:(PAEBModelFailedBlock)failed {
    BOOL downloadFinined = [PAEBAssetManager downloadFininedForInfo:info];
    if (downloadFinined && results) {
        self.iCloudDownloading = NO;
        if (success) {
            success(results, info, orientation, audioMix);
        }
        return;
    }
    if (![[info objectForKey:PHImageCancelledKey] boolValue]) {
        self.iCloudDownloading = NO;
    }
    if (failed) {
        failed(info, self);
    }
}

- (PHContentEditingInputRequestID)requestImageURLStartRequestICloud:(void (^)(PHContentEditingInputRequestID iCloudRequestId, PAEBPhotoModel *model))startRequestICloud
                                                    progressHandler:(PAEBModelProgressHandler)progressHandler
                                                            success:(PAEBModelImageURLSuccessBlock)success
                                                             failed:(PAEBModelFailedBlock)failed {
    if (self.photoEdit) {
        [self getCameraImageURLWithSuccess:^(NSURL * _Nullable imageURL, PAEBPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
            if (success) {
                success(imageURL, model, nil);
            }
        } failed:^(NSDictionary * _Nullable info, PAEBPhotoModel * _Nullable model) {
            if (failed) {
                failed(info, model);
            }
        }];
        return 0;
    }
    if (self.type == PAEBPhotoModelMediaTypeCameraPhoto) {
        if (self.imageURL) {
            if (success) {
                success(self.imageURL, self, nil);
            }
        }else {
            if (failed) {
                failed(nil, self);
            }
        }
        return 0;
    }
    
    PHContentEditingInputRequestOptions *options = [[PHContentEditingInputRequestOptions alloc] init];
    options.networkAccessAllowed = NO;
    HXWeakSelf
    return [self.asset requestContentEditingInputWithOptions:options completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        BOOL downloadFinined = (![[info objectForKey:PHContentEditingInputCancelledKey] boolValue] && ![info objectForKey:PHContentEditingInputErrorKey]);
        
        if (downloadFinined && contentEditingInput.fullSizeImageURL) {
            NSURL *imageURL;
            if ([[contentEditingInput.fullSizeImageURL pathExtension] isEqualToString:@"GIF"]) {
                // 虽然是gif图片，但是没有开启显示gif 所以这里处理一下
                NSData *imageData = UIImageJPEGRepresentation(contentEditingInput.displaySizeImage, 1);
                NSString *fileName = [[NSString hx_fileName] stringByAppendingString:@".jpg"];
                NSString *fullPathToFile = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
                imageURL = [NSURL fileURLWithPath:fullPathToFile];
                if (![imageData writeToURL:imageURL atomically:YES]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (failed) {
                            failed(info, weakSelf);
                        }
                    });
                    return;
                }
            }else {
                imageURL = contentEditingInput.fullSizeImageURL;
            }
            weakSelf.imageURL = imageURL;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(imageURL, weakSelf, info);
                }
            });
        }else {
            if ([[info objectForKey:PHContentEditingInputResultIsInCloudKey] boolValue] &&
                ![[info objectForKey:PHContentEditingInputCancelledKey] boolValue]) {
                PHContentEditingInputRequestOptions *iCloudOptions = [[PHContentEditingInputRequestOptions alloc] init];
                iCloudOptions.networkAccessAllowed = YES;
                iCloudOptions.progressHandler = ^(double progress, BOOL * _Nonnull stop) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressHandler) {
                            progressHandler(progress, weakSelf);
                        }
                    });
                };
                
                PHContentEditingInputRequestID iCloudRequestID = [weakSelf.asset requestContentEditingInputWithOptions:iCloudOptions completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
                    BOOL downloadFinined = (![[info objectForKey:PHContentEditingInputCancelledKey] boolValue] && ![info objectForKey:PHContentEditingInputErrorKey]);
                    
                    if (downloadFinined && contentEditingInput.fullSizeImageURL) {
                        NSURL *imageURL = contentEditingInput.fullSizeImageURL;
                        weakSelf.imageURL = imageURL;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (success) {
                                success(imageURL, weakSelf, nil);
                            }
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failed) {
                                failed(info, weakSelf);
                            }
                        });
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (startRequestICloud) {
                        startRequestICloud(iCloudRequestID, weakSelf);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failed) {
                        failed(info, weakSelf);
                    }
                });
            }
        }
    }];
}

- (void)getCameraImageURLWithSuccess:(PAEBModelImageURLSuccessBlock _Nullable)success
                              failed:(PAEBModelFailedBlock _Nullable)failed {
                                    HXWeakSelf
    if (self.photoEdit) {
        [self getImageURLWithImage:self.photoEdit.editPreviewImage success:^(NSURL * _Nullable imageURL, PAEBPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
            weakSelf.imageURL = imageURL;
            if (success) {
                success(imageURL, weakSelf, nil);
            }
        } failed:^(NSDictionary * _Nullable info, PAEBPhotoModel * _Nullable model) {
            if (failed) {
                failed(nil, weakSelf);
            }
        }];
        return;
    }
    if (self.type != PAEBPhotoModelMediaTypeCameraPhoto) {
        if (failed) {
            failed(nil, self);
        }
        return;
    }
    if (self.cameraPhotoType == PAEBPhotoModelMediaTypeCameraPhotoTypeLocalLivePhoto) {
        if (success) {
            success(self.imageURL, self, nil);
        }
        return;
    }
    [self getImageURLWithImage:self.thumbPhoto success:^(NSURL * _Nullable imageURL, PAEBPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
        weakSelf.imageURL = imageURL;
        if (success) {
            success(imageURL, weakSelf, nil);
        }
    } failed:^(NSDictionary * _Nullable info, PAEBPhotoModel * _Nullable model) {
        if (failed) {
            failed(nil, weakSelf);
        }
    }];
}

- (void)getImageURLWithImage:(UIImage *)image
                     success:(PAEBModelImageURLSuccessBlock _Nullable)success
                      failed:(PAEBModelFailedBlock _Nullable)failed{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData;
        NSString *suffix;
        if (self.photoEdit) {
            imageData = self.photoEdit.editPreviewData;
            suffix = @"jpeg";
        }else {
            if (UIImagePNGRepresentation(image)) {
                //返回为png图像。
                imageData = UIImagePNGRepresentation(image);
                suffix = @"png";
            }else {
                //返回为JPEG图像。
                imageData = UIImageJPEGRepresentation(image, 0.8);
                suffix = @"jpeg";
            }
        }
        NSString *fileName = [[NSString hx_fileName] stringByAppendingString:[NSString stringWithFormat:@".%@",suffix]];
        NSString *fullPathToFile = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        
        if ([imageData writeToFile:fullPathToFile atomically:YES]) {
            NSURL *imageURL = [NSURL fileURLWithPath:fullPathToFile];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(imageURL, self, nil);
                }
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failed) {
                    failed(nil, self);
                }
            });
        }
    });
}

- (PHImageRequestID)requestPreviewImageWithSize:(CGSize)size
                             startRequestICloud:(PAEBModelStartRequestICloud)startRequestICloud
                                progressHandler:(PAEBModelProgressHandler)progressHandler
                                        success:(PAEBModelImageSuccessBlock)success
                                         failed:(PAEBModelFailedBlock)failed {
    if (self.photoEdit) {
        if (success) success(self.photoEdit.editPreviewImage, self, nil);
        return 0;
    }
    if (self.type == PAEBPhotoModelMediaTypeCameraPhoto) {
        if (success) success(self.previewPhoto, self, nil);
        return 0;
    }
    self.iCloudDownloading = YES;
    PHImageRequestID requestId = [PAEBAssetManager requestPreviewImageForAsset:self.asset targetSize:size networkAccessAllowed:NO progressHandler:nil completion:^(UIImage * _Nonnull result, NSDictionary<NSString *,id> * _Nonnull info) {
        __strong typeof(self) strongSelf = self;
        [strongSelf requestDataWithResult:result info:info size:size resultClass:[UIImage class] orientation:0 audioMix:nil startRequestICloud:startRequestICloud progressHandler:progressHandler success:^(id result, NSDictionary *info, UIImageOrientation orientation, AVAudioMix *audioMix) {
            if (success) {
                strongSelf.thumbPhoto = result;
                strongSelf.previewPhoto = result;
                success(result, strongSelf, info);
            }
        } failed:failed];
    }];
    self.iCloudRequestID = requestId;
    return requestId;
}

- (PAEBPhotoModelFormat)photoFormat {
    if (self.photoEdit) {
        return PAEBPhotoModelFormatJPG;
    }
    if (self.asset) {

        if ([[self.asset valueForKey:@"filename"] hasSuffix:@"PNG"]) {
            return PAEBPhotoModelFormatPNG;
        }
        if ([[self.asset valueForKey:@"filename"] hasSuffix:@"JPG"]) {
            return PAEBPhotoModelFormatJPG;
        }
        if ([[self.asset valueForKey:@"filename"] hasSuffix:@"HEIC"]) {
            return PAEBPhotoModelFormatHEIC;
        }

    }else {
        if (self.thumbPhoto) {
            if (UIImagePNGRepresentation(self.thumbPhoto)) {
                return PAEBPhotoModelFormatPNG;
            }else {
                return PAEBPhotoModelFormatJPG;
            }
        }
    }
    return PAEBPhotoModelFormatUnknown;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self.type = PAEBPhotoModelMediaTypeCameraPhoto;
        self.cameraPhotoType = PAEBPhotoModelMediaTypeCameraPhotoTypeLocal;
        if (image.imageOrientation != UIImageOrientationUp) {
            image = [image hx_normalizedImage];
        }
        self.thumbPhoto = image;
        self.previewPhoto = image;
        self.imageSize = image.size;
    }
    return self;
}

- (void)setPhotoEdit:(PAEBPhotoEdit *)photoEdit {
    _photoEdit = photoEdit;
    if (!photoEdit) {
        _imageSize = CGSizeZero;
    }
}

- (CGSize)imageSize {
    if (self.photoEdit) {
        _imageSize = self.photoEdit.editPreviewImage.size;
    }
    if (_imageSize.width == 0 || _imageSize.height == 0) {
        if (self.asset) {
            if (self.asset.pixelWidth == 0 || self.asset.pixelHeight == 0) {
                _imageSize = CGSizeMake(200, 200);
            }else {
                _imageSize = CGSizeMake(self.asset.pixelWidth, self.asset.pixelHeight);
            }
        }else {
            if (CGSizeEqualToSize(self.thumbPhoto.size, CGSizeZero)) {
                _imageSize = CGSizeMake(200, 200);
            }else {
                _imageSize = self.thumbPhoto.size;
            }
        }
    }
    return _imageSize;
}

- (UIImage *)thumbPhoto {
    if (self.photoEdit) {
        return self.photoEdit.editPreviewImage;
    }
    return _thumbPhoto;
}

- (UIImage *)previewPhoto {
    if (self.photoEdit) {
        return self.photoEdit.editPreviewImage;
    }
    return _previewPhoto;
}

- (void)dealloc {
    if (self.iCloudRequestID) {
        if (self.iCloudDownloading) {
            [[PHImageManager defaultManager] cancelImageRequest:self.iCloudRequestID];
        }
    }
}

@end
