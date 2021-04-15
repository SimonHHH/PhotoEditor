//
//  PAEBPhotoEditStickerItem.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PAEBPhotoEditTextModel;
@interface PAEBPhotoEditStickerItem : NSObject<NSCoding>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) PAEBPhotoEditTextModel *textModel;

@property (assign, nonatomic) CGRect itemFrame;

@end
NS_ASSUME_NONNULL_END
