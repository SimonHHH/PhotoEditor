//
//  PAEBPhotoEditStickerView.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PAEBPhotoEditStickerItem, PAEBPhotoEditStickerItemView, PAEBPhotoEditConfiguration;

@interface PAEBPhotoEditStickerView : UIView

@property (nonatomic, weak, readonly) PAEBPhotoEditStickerItemView *selectItemView;
@property (nonatomic, copy) void (^ touchBegan)(PAEBPhotoEditStickerItemView *itemView);
@property (nonatomic, copy) void (^ touchEnded)(PAEBPhotoEditStickerItemView *itemView);

@property (nonatomic, strong) PAEBPhotoEditConfiguration *configuration;
/** 贴图数量 */
@property (nonatomic, readonly) NSUInteger count;
/// 显示界面的缩放率
@property (nonatomic, assign) CGFloat screenScale;
/** 是否启用（移动或点击） */
@property (nonatomic, readonly, getter=isEnable) BOOL enable;
@property (nonatomic, copy, nullable) BOOL (^ moveCenter)(CGRect rect);
@property (nonatomic, copy, nullable) CGFloat (^ getMinScale)(CGSize size);
@property (nonatomic, copy, nullable) CGFloat (^ getMaxScale)(CGSize size);

/** 数据 */
@property (nonatomic, strong, nullable) NSDictionary *data;
@property (nonatomic, assign, getter=isHitTestSubView) BOOL hitTestSubView;
- (PAEBPhotoEditStickerItemView *)addStickerItem:(PAEBPhotoEditStickerItem *)item isSelected:(BOOL)selected;

@property (nonatomic, assign) NSInteger angle;

- (void)removeSelectItem;
- (void)clearCoverage;
@end

NS_ASSUME_NONNULL_END
