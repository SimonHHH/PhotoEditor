//
//  PAEBPhotoEditTextView.h
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PAEBPhotoEditTextModel, PAEBPhotoEditConfiguration;
@interface PAEBPhotoEditTextView : UIView
@property (nonatomic, strong) PAEBPhotoEditConfiguration *configuration;
@property (nonatomic, copy) NSArray<UIColor *> *textColors;
+ (instancetype)showEitdTextViewWithConfiguration:(PAEBPhotoEditConfiguration *)configuration
                                       completion:(void (^ _Nullable)(PAEBPhotoEditTextModel *textModel))completion;

+ (instancetype)showEitdTextViewWithConfiguration:(PAEBPhotoEditConfiguration *)configuration
                                        textModel:(PAEBPhotoEditTextModel * _Nullable)textModel
                                       completion:(void (^ _Nullable)(PAEBPhotoEditTextModel *textModel))completion;
@end


@interface PAEBPhotoEditTextModel : NSObject<NSCoding>
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) BOOL showBackgroud;
@end

@interface PAEBPhotoEditTextLayer : CAShapeLayer

@end

NS_ASSUME_NONNULL_END
