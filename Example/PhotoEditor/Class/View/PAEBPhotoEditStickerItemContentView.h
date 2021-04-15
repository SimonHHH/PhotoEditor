//
//  PAEBPhotoEditStickerItemContentView.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class PAEBPhotoEditStickerItem;
@interface PAEBPhotoEditStickerItemContentView : UIView
@property (strong, nonatomic, readonly) PAEBPhotoEditStickerItem *item;
- (instancetype)initWithItem:(PAEBPhotoEditStickerItem *)item;
- (void)updateItem:(PAEBPhotoEditStickerItem *)item;
@end

NS_ASSUME_NONNULL_END
