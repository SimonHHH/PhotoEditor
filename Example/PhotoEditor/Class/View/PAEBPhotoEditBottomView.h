//
//  PAEBPhotoEditBottomView.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/12.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PAEBPhotoEditBottomView : UIView
@property (nonatomic, copy) void (^ didToolsBtnBlock)(NSInteger tag, BOOL isSelected);
@property (nonatomic, copy) void (^ didDoneBtnBlock)(void);
- (void)endCliping;
@end

NS_ASSUME_NONNULL_END
