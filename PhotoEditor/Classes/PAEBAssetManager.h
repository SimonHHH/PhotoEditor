//
//  PAEBAssetManager.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/14.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PAEBAssetManager : NSObject
+ (PHImageRequestID)requestImageDataForAsset:(PHAsset *)asset
                                     version:(PHImageRequestOptionsVersion)version
                                  resizeMode:(PHImageRequestOptionsResizeMode)resizeMode
                        networkAccessAllowed:(BOOL)networkAccessAllowed
                             progressHandler:(PHAssetImageProgressHandler _Nullable)progressHandler
                                  completion:(void (^)(NSData *imageData,  UIImageOrientation orientation, NSDictionary<NSString *, id> *info))completion;

+ (UIImageOrientation)imageOrientationWithCGImageOrientation:(CGImagePropertyOrientation)orientation;

+ (PHImageRequestID)requestPreviewImageForAsset:(PHAsset *)asset
                                     targetSize:(CGSize)targetSize
                           networkAccessAllowed:(BOOL)networkAccessAllowed
                                progressHandler:(PHAssetImageProgressHandler _Nullable)progressHandler
                                     completion:(void (^ _Nullable)(UIImage *result, NSDictionary<NSString *, id> *info))completion;

+ (BOOL)downloadFininedForInfo:(NSDictionary *)info;
@end

NS_ASSUME_NONNULL_END
