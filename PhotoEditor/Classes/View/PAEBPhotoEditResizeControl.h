//
//  PAEBPhotoEditResizeControl.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/14.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PAEBPhotoEditResizeControlDelegate;

@interface PAEBPhotoEditResizeControl : UIView
@property (nonatomic, weak) id<PAEBPhotoEditResizeControlDelegate> delegate;
@property (nonatomic, readonly) CGPoint translation;
@property (nonatomic, getter=isEnabled) BOOL enabled;
@end

@protocol PAEBPhotoEditResizeControlDelegate <NSObject>

- (void)resizeConrolDidBeginResizing:(PAEBPhotoEditResizeControl *)resizeConrol;
- (void)resizeConrolDidResizing:(PAEBPhotoEditResizeControl *)resizeConrol;
- (void)resizeConrolDidEndResizing:(PAEBPhotoEditResizeControl *)resizeConrol;

@end

NS_ASSUME_NONNULL_END
