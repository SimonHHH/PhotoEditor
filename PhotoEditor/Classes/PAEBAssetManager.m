//
//  PAEBAssetManager.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/14.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBAssetManager.h"

@implementation PAEBAssetManager
+ (PHImageRequestID)requestImageDataForAsset:(PHAsset *)asset
                                     version:(PHImageRequestOptionsVersion)version
                                  resizeMode:(PHImageRequestOptionsResizeMode)resizeMode
                        networkAccessAllowed:(BOOL)networkAccessAllowed
                             progressHandler:(PHAssetImageProgressHandler)progressHandler
                                  completion:(void (^)(NSData *imageData,  UIImageOrientation orientation, NSDictionary<NSString *, id> *info))completion {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.version = version;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.resizeMode = resizeMode;
    options.networkAccessAllowed = networkAccessAllowed;
    options.progressHandler = progressHandler;
    return [self requestImageDataForAsset:asset options:options completion:^(NSData * _Nonnull imageData, UIImageOrientation orientation, NSDictionary<NSString *,id> * _Nonnull info) {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(imageData, orientation, info);
            });
        }
    }];
}

+ (PHImageRequestID)requestImageDataForAsset:(PHAsset *)asset
                                     options:(PHImageRequestOptions *)options
                                  completion:(void (^)(NSData *imageData,  UIImageOrientation orientation, NSDictionary<NSString *, id> *info))completion {
    PHImageRequestID requestID;
    if (@available(iOS 13.0, *)) {
        requestID = [[PHImageManager defaultManager] requestImageDataAndOrientationForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(imageData, [self imageOrientationWithCGImageOrientation:orientation], info);
                });
            }
        }];
    }else {
        requestID = [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(imageData, orientation, info);
                });
            }
        }];
    }
    return requestID;
}

+ (UIImageOrientation)imageOrientationWithCGImageOrientation:(CGImagePropertyOrientation)orientation {
    UIImageOrientation sureOrientation;
    if (orientation == kCGImagePropertyOrientationUp) {
        sureOrientation = UIImageOrientationUp;
    } else if (orientation == kCGImagePropertyOrientationUpMirrored) {
        sureOrientation = UIImageOrientationUpMirrored;
    } else if (orientation == kCGImagePropertyOrientationDown) {
        sureOrientation = UIImageOrientationDown;
    } else if (orientation == kCGImagePropertyOrientationDownMirrored) {
        sureOrientation = UIImageOrientationDownMirrored;
    } else if (orientation == kCGImagePropertyOrientationLeftMirrored) {
        sureOrientation = UIImageOrientationLeftMirrored;
    } else if (orientation == kCGImagePropertyOrientationRight) {
        sureOrientation = UIImageOrientationRight;
    } else if (orientation == kCGImagePropertyOrientationRightMirrored) {
        sureOrientation = UIImageOrientationRightMirrored;
    } else if (orientation == kCGImagePropertyOrientationLeft) {
        sureOrientation = UIImageOrientationLeft;
    } else {
        sureOrientation = UIImageOrientationUp;
    }
    return sureOrientation;
}

+ (PHImageRequestID)requestPreviewImageForAsset:(PHAsset *)asset
                                     targetSize:(CGSize)targetSize
                           networkAccessAllowed:(BOOL)networkAccessAllowed
                                progressHandler:(PHAssetImageProgressHandler _Nullable)progressHandler
                                     completion:(void (^ _Nullable)(UIImage *result, NSDictionary<NSString *, id> *info))completion; {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = networkAccessAllowed;
    options.progressHandler = progressHandler;
    return [self requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options completion:^(UIImage * _Nonnull result, NSDictionary<NSString *,id> * _Nonnull info) {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(result, info);
            });
        }
    }];
}

+ (PHImageRequestID)requestImageForAsset:(PHAsset *)asset
                              targetSize:(CGSize)targetSize
                             contentMode:(PHImageContentMode)contentMode
                                 options:(PHImageRequestOptions *)options
                              completion:(void (^)(UIImage *result, NSDictionary<NSString *, id> *info))completion {
    return [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:contentMode options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(result, info);
            });
        }
    }];
}

+ (BOOL)downloadFininedForInfo:(NSDictionary *)info {
    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
    return downloadFinined;
}
@end
