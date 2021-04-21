//
//  PAEBPhotoEditSplashView.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditSplashView.h"
#import "PAEBPhotoEditSplashMaskLayer.h"
#import "UIImage+HXExtension.h"

NSString *const kHXSplashViewData = @"HXSplashViewData";
NSString *const kHXSplashViewData_layerArray = @"HXSplashViewData_layerArray";
NSString *const kHXSplashViewData_frameArray = @"HXSplashViewData_frameArray";

@interface PAEBPhotoEditSplashView () {
    BOOL _isWork;
    BOOL _isBegan;
}

/// 笔画
@property (nonatomic, strong) NSMutableArray <UIBezierPath *>*lineArray;
/** 图层 */
@property (nonatomic, strong) NSMutableArray <CALayer *>*layerArray;
/** 已显示坐标 */
//@property (nonatomic, strong) NSMutableArray <NSValue *>*frameArray;

@property (nonatomic, assign) BOOL isErase;
/** 方形大小 */
//@property (nonatomic, assign) CGFloat squareWidth;
/** 画笔大小 */
@property (nonatomic, assign) CGFloat paintWidth;

@property (nonatomic, strong) UIImage *mosaicImage;
@end

@implementation PAEBPhotoEditSplashView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (CGFloat)paintWidth {
    return _paintWidth / self.screenScale;
}

- (void)customInit {
    self.exclusiveTouch = YES;
    _paintWidth = 15.0;
    _state = PAEBPhotoEditSplashStateType_Mosaic;
    _lineArray = [NSMutableArray array];
    _layerArray = [NSMutableArray array];
    self.screenScale = 1;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _mosaicImage = [self mosaicImage:image mosaicLevel:20];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches.allObjects.count == 1) {
        _isWork = NO;
        _isBegan = YES;
        
        //1、触摸坐标
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        //2、创建LFSplashBlur
        if (self.state == PAEBPhotoEditSplashStateType_Mosaic) {
            
            UIBezierPath *path = [[UIBezierPath alloc] init];
            path.lineWidth = self.paintWidth;
            path.lineCapStyle = kCGLineCapRound;
            path.lineJoinStyle = kCGLineJoinRound;
            [path moveToPoint:point];
            [self.lineArray addObject:path];

            CALayer *layer = [self createShapeLayer:path];
            [self.layer addSublayer:layer];
            [self.layerArray addObject:layer];
            
        }
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (CALayer *)createShapeLayer:(UIBezierPath *)path {
    
    CAShapeLayer *slayer = [CAShapeLayer layer];
    slayer.path = path.CGPath;
    slayer.fillColor = nil;
    slayer.lineCap = kCALineCapRound;
    slayer.lineJoin = kCALineJoinRound;
    slayer.strokeColor = [[UIColor blueColor] CGColor];
    slayer.lineWidth = path.lineWidth;
    
    CALayer *layer = [CALayer layer];
    layer.frame = self.bounds;
    layer.contents = (__bridge id _Nullable)(self.mosaicImage.CGImage);
    layer.mask = slayer;
    return layer;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([event allTouches].count == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        UIBezierPath *path = self.lineArray.lastObject;
        if (!CGPointEqualToPoint(path.currentPoint, point)) {
            if (self.splashBegan) {
                self.splashBegan();
            }
            _isBegan = NO;
            _isWork = YES;
            [path addLineToPoint:point];
            CALayer *layer = self.layerArray.lastObject;
            if (layer.mask && [layer.mask isKindOfClass:[CAShapeLayer class]]) {
                CAShapeLayer *slayer = layer.mask;
                slayer.path = path.CGPath;
            }
            
        }
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([event allTouches].count == 1){
        
        if (_isWork) {
            if (self.splashEnded) {
                self.splashEnded();
            }
        } else {
            [self undo];
        }
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([event allTouches].count == 1){
        if (_isWork) {
            if (self.splashEnded) {
                self.splashEnded();
            }
        } else {
            [self undo];
        }
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

/** 是否可撤销 */
- (BOOL)canUndo {
    return self.layerArray.count;
}

//撤销
- (void)undo {
    [self.layerArray.lastObject removeFromSuperlayer];
    [self.layerArray removeLastObject];
    [self.lineArray removeLastObject];
}

#pragma mark  - 数据
//- (NSDictionary *)data {
//    if (self.layerArray.count) {
//        NSMutableArray *lineArray = [@[] mutableCopy];
//        for (PAEBPhotoEditSplashMaskLayer *layer in self.layerArray) {
//            [lineArray addObject:layer.lineArray];
//        }
//
//        return @{kHXSplashViewData:@{
//                         kHXSplashViewData_layerArray:[lineArray copy],
//                         kHXSplashViewData_frameArray:[self.frameArray copy]
//                         }};
//    }
//    return nil;
//}

//- (void)setData:(NSDictionary *)data {
//    NSDictionary *dataDict = data[kHXSplashViewData];
//    NSArray *lineArray = dataDict[kHXSplashViewData_layerArray];
//    for (NSArray *subLineArray in lineArray) {
//        PAEBPhotoEditSplashMaskLayer *layer = [PAEBPhotoEditSplashMaskLayer layer];
//        layer.frame = self.bounds;
//        [layer.lineArray addObjectsFromArray:subLineArray];
//
//        [self.layer addSublayer:layer];
//        [self.layerArray addObject:layer];
//        [layer setNeedsDisplay];
//    }
//    NSArray *frameArray = dataDict[kHXSplashViewData_frameArray];
//    [self.frameArray addObjectsFromArray:frameArray];
//}

#pragma mark - 转成马赛克图
- (UIImage *)mosaicImage:(UIImage *)sourceImage mosaicLevel:(NSUInteger)level {
    
    //1、这一部分是为了把原始图片转成位图，位图再转成可操作的数据
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();//颜色通道
    CGImageRef imageRef = sourceImage.CGImage;//位图
    CGFloat width = CGImageGetWidth(imageRef);//位图宽
    CGFloat height = CGImageGetHeight(imageRef);//位图高
    CGContextRef context = CGBitmapContextCreate(nil, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast);//生成上下文
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), imageRef);//绘制图片到上下文中
    unsigned char *bitmapData = CGBitmapContextGetData(context);//获取位图的数据
    
    
    //2、这一部分是往右往下填充色值
    NSUInteger index,preIndex;
    unsigned char pixel[4] = {0};
    for (int i = 0; i < height; i++) {//表示高，也可以说是行
        for (int j = 0; j < width; j++) {//表示宽，也可以说是列
            index = i * width + j;
            if (i % level == 0) {
                if (j % level == 0) {
                    //把当前的色值数据保存一份，开始为i=0，j=0，所以一开始会保留一份
                    memcpy(pixel, bitmapData + index * 4, 4);
                }else{
                    //把上一次保留的色值数据填充到当前的内存区域，这样就起到把前面数据往后挪的作用，也是往右填充
                    memcpy(bitmapData +index * 4, pixel, 4);
                }
            }else{
                //这里是把上一行的往下填充
                preIndex = (i - 1) * width + j;
                memcpy(bitmapData + index * 4, bitmapData + preIndex * 4, 4);
            }
        }
    }
    
    //把数据转回位图，再从位图转回UIImage
    NSUInteger dataLength = width * height * 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData, dataLength, NULL);
    CGImageRef mosaicImageRef = CGImageCreate(width, height,
                                              8,
                                              32,
                                              width*4 ,
                                              colorSpace,
                                              kCGBitmapByteOrderDefault,
                                              provider,
                                              NULL, NO,
                                              kCGRenderingIntentDefault);
    CGContextRef outputContext = CGBitmapContextCreate(nil,
                                                       width,
                                                       height,
                                                       8,
                                                       width*4,
                                                       colorSpace,
                                                       kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(outputContext, CGRectMake(0.0f, 0.0f, width, height), mosaicImageRef);
    CGImageRef resultImageRef = CGBitmapContextCreateImage(outputContext);
    UIImage *resultImage = nil;
    if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
        float scale = [[UIScreen mainScreen] scale];
        resultImage = [UIImage imageWithCGImage:resultImageRef scale:scale orientation:UIImageOrientationUp];
    } else {
        resultImage = [UIImage imageWithCGImage:resultImageRef];
    }
    CFRelease(resultImageRef);
    CFRelease(mosaicImageRef);
    CFRelease(colorSpace);
    CFRelease(provider);
    CFRelease(context);
    CFRelease(outputContext);
    return resultImage;
}

@end
