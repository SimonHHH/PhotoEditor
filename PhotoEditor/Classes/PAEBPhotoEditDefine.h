//
//  PAEBPhotoEditDefine.h
//  PhotoEditor
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/7.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#ifndef PAEBPhotoEditDefine_h
#define PAEBPhotoEditDefine_h

#define HX_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define HX_ScreenHeight [UIScreen mainScreen].bounds.size.height

#define HX_SafeAreaHeight  ({int tmp = 0;if (@available(iOS 11.0, *)) {tmp = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;}tmp;})
#define HX_IsIphoneX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(828, 1792),  [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) || HX_SafeAreaHeight : NO)

#define HXStatusBarHeight HX_IsIphoneX ? 44.0 : 20.0

#define HXNavigationBarHeight HXStatusBarHeight + 44.0

#define HXBottomMargin \
^(){\
if (@available(iOS 11.0, *)) {\
    return [UIApplication sharedApplication].windows.firstObject.safeAreaInsets.bottom;\
} else {\
    return UIEdgeInsetsMake(0, 0, 0, 0).bottom;\
}\
}()

#define HXTabbarHeight HXBottomMargin + 44.0

#define HXTopMargin ((HXStatusBarHeight == 44) ? 44 : 0)


// 弱引用
#define HXWeakSelf __weak typeof(self) weakSelf = self;

#define HXThemeColor @"FF4800"

#define HXRound(x) (round(x*100000)/100000)
#define HXRoundHundreds(x) (round(x*100)/100)
#define HXRoundDecade(x) (round(x*10)/10)

#define HXRoundFrame(rect) CGRectMake(HXRound(rect.origin.x), HXRound(rect.origin.y), HXRound(rect.size.width), HXRound(rect.size.height))

#define HXRoundFrameHundreds(rect) CGRectMake(HXRoundHundreds(rect.origin.x), HXRoundHundreds(rect.origin.y), HXRoundHundreds(rect.size.width), HXRoundHundreds(rect.size.height))

#endif /* PAEBPhotoEditDefine_h */
