//
//  PAEBPhotoEditTextView.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/13.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoEditTextView.h"
#import "UIView+HXExtension.h"
#import "PAEBPhotoEditDefine.h"
#import "UIImage+HXExtension.h"
#import "UIColor+HXExtension.h"
#import "UIFont+HXExtension.h"
#import "PAEBPhotoEditConfiguration.h"
#import "PAEBPhotoEditGraffitiColorModel.h"
#import "PAEBPhotoEditGraffitiColorViewCell.h"


#define PAEBEditTextBlankWidth 22
#define PAEBHXEditTextRadius 8.f

@interface PAEBPhotoEditTextView ()<UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSLayoutManagerDelegate>

@property (nonatomic, strong) NSMutableArray *rectArray;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *textBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSMutableArray *colorModels;
@property (nonatomic, strong) PAEBPhotoEditGraffitiColorModel *currentSelectModel;
@property (nonatomic, assign) NSRange currentTextRange;
@property (nonatomic, assign) BOOL currentIsBlank;
@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, copy) void (^ completion)(PAEBPhotoEditTextModel *textModel);
@property (nonatomic, strong) PAEBPhotoEditTextModel *textModel;
/// 将字体属性记录成公用的, 然后在每次UITextview的内容将要发生变化的时候，重置一下它的该属性。
@property (nonatomic, copy) NSDictionary *typingAttributes;

@property (nonatomic, strong) PAEBPhotoEditTextLayer *textLayer;
@property (nonatomic, strong) UIColor *useBgColor;
@property (nonatomic, assign) BOOL showBackgroudColor;
@property (nonatomic, assign) NSInteger maxIndex;
@property (nonatomic, assign) BOOL textIsDelete;
@end

@implementation PAEBPhotoEditTextView

+ (instancetype)showEitdTextViewWithConfiguration:(PAEBPhotoEditConfiguration *)configuration
                                       completion:(void (^ _Nullable)(PAEBPhotoEditTextModel *textModel))completion {
    return [self showEitdTextViewWithConfiguration:configuration textModel:nil completion:completion];
}

+ (instancetype)showEitdTextViewWithConfiguration:(PAEBPhotoEditConfiguration *)configuration
                                        textModel:(PAEBPhotoEditTextModel *)textModel
                                       completion:(void (^)(PAEBPhotoEditTextModel * _Nonnull))completion {
    if ([[[UIApplication sharedApplication].keyWindow.subviews lastObject] isKindOfClass:[PAEBPhotoEditTextView class]]) {  //防双击出现两个编辑页
        return nil;
    }
    PAEBPhotoEditTextView *view = [[PAEBPhotoEditTextView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.hx_y = view.hx_h;
    view.configuration = configuration;
    view.textModel = textModel;
    view.textColors = configuration.textColors;
    view.completion = completion;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    [view show];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle: UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = self.bounds;
    [self addSubview:effectview];

    [self addSubview:self.topView];
    [self.topView addSubview:self.cancelBtn];
    [self.topView addSubview:self.doneBtn];
    
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.textBtn];
    [self.bottomView addSubview:self.collectionView];
    
    [self addSubview:self.textView];
    
    [self.textView becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppearance:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDismiss:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setConfiguration:(PAEBPhotoEditConfiguration *)configuration {
    _configuration = configuration;
    self.textView.tintColor = [UIColor hx_colorWithHexStr:HXThemeColor];
    [self.doneBtn setBackgroundColor:[UIColor hx_colorWithHexStr:HXThemeColor]];
}

- (void)setTextAttributes {
    self.textView.font = self.configuration.textFont;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8.f;
    NSDictionary *attributes = @{
                                 NSFontAttributeName: self.configuration.textFont,
                                 NSParagraphStyleAttributeName : paragraphStyle
                                 };
    self.typingAttributes = attributes;
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:self.textModel.text? : @"" attributes:attributes];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (PAEBPhotoEditTextLayer *)createTextBackgroudColorWithPath:(CGPathRef)path {
    PAEBPhotoEditTextLayer *shapeLayer = [PAEBPhotoEditTextLayer layer];
    shapeLayer.path = path;
    shapeLayer.lineWidth = 0.f;
    CGColorRef color = self.showBackgroudColor ? self.useBgColor.CGColor : [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = color;
    shapeLayer.fillColor = color;
    return shapeLayer;
}
- (void)setTextModel:(PAEBPhotoEditTextModel *)textModel {
    _textModel = textModel;
    self.textView.text = textModel.text;
    self.showBackgroudColor = textModel.showBackgroud;
    self.textBtn.selected = textModel.showBackgroud;
    [self setTextAttributes];
}

- (void)setTextColors:(NSArray<UIColor *> *)textColors {
    _textColors = textColors;
    self.colorModels = [NSMutableArray array];
    for (UIColor *color in textColors) {
        PAEBPhotoEditGraffitiColorModel *model = [[PAEBPhotoEditGraffitiColorModel alloc] init];
        model.color = color;
        [self.colorModels addObject:model];
        if (self.textModel) {
            if ([color isEqual:self.textModel.textColor]) {
                if (self.textModel.showBackgroud) {
                    if ([model.color hx_colorIsWhite]) {
                        [self changeTextViewTextColor:[UIColor blackColor]];
                    }else {
                        [self changeTextViewTextColor:[UIColor whiteColor]];
                    }
                    self.useBgColor = model.color;
                }else {
                    [self changeTextViewTextColor:color];
                }
                model.selected = YES;
                self.currentSelectModel = model;
            }
        } else {
            if (self.colorModels.count == 1) {
                [self changeTextViewTextColor:color];
                model.selected = YES;
                self.currentSelectModel = model;
            }
        }
    }
    [self.collectionView reloadData];
    if (self.textBtn.selected) {
        [self drawTextBackgroudColor];
    }
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        self.hx_y = 0;
    }];
}

- (void)hide {
    [self.textView endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.hx_y = self.hx_h;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)didCancelClick:(UIButton *)button {
    [self hide];
}

- (void)didDoneClick:(UIButton *)button {
    [self.textView resignFirstResponder];
    if (!self.textView.text.length) {
        [self hide];
        return;
    }
    if (self.completion) {
        PAEBPhotoEditTextModel *textModel = [[PAEBPhotoEditTextModel alloc] init];
        for (UIView *view in self.textView.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"_UITextContainerView")]) {
                textModel.image = [self snapshotCALayer:view];
                view.layer.contents = (id)nil;
                break;
            }
        }
        textModel.text = self.textView.text;
        textModel.textColor = self.currentSelectModel.color;
        textModel.showBackgroud = self.showBackgroudColor;
        self.completion(textModel);
    }
    [self hide];
}

- (CGFloat)getTextMaximumWidthWithView:(UIView *)view {
    CGSize newSize = [self.textView sizeThatFits:CGSizeMake(view.hx_w, view.hx_h)];
    return newSize.width;
}

- (UIImage *)snapshotCALayer:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake([self getTextMaximumWidthWithView:view], view.hx_h), NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)didTextBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.showBackgroudColor = sender.selected;
    self.useBgColor = self.currentSelectModel.color;
    if (sender.selected) {
        if ([self.currentSelectModel.color hx_colorIsWhite]) {
            [self changeTextViewTextColor:[UIColor blackColor]];
        }else {
            [self changeTextViewTextColor:[UIColor whiteColor]];
        }
    }else {
        [self changeTextViewTextColor:self.currentSelectModel.color];
    }
}

- (void)changeTextViewTextColor:(UIColor *)color {
    self.textView.textColor = color;
    NSMutableDictionary *dicy = self.typingAttributes.mutableCopy;
    [dicy setObject:color forKey:NSForegroundColorAttributeName];
    self.typingAttributes = dicy.copy;
    self.textView.typingAttributes = self.typingAttributes;
}

- (void)keyboardWillAppearance:(NSNotification *)notification {
    NSInteger duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] integerValue];
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.bottomView.hx_y = self.hx_h-(height+self.bottomView.hx_h);
        self.textView.hx_h = self.hx_h-self.topView.hx_h-self.bottomView.hx_h-height;
        [self layoutIfNeeded];
    }];
}

- (void)keyboardWillDismiss:(NSNotification *)notification {
    NSInteger duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] integerValue];
    [UIView animateWithDuration:duration animations:^{
        self.bottomView.hx_y = self.hx_h-self.bottomView.hx_h-HXBottomMargin;
        self.textView.hx_h = self.hx_h-self.topView.hx_h-self.bottomView.hx_h;
        [self layoutIfNeeded];
    }];
}

#pragma mark <collectionDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colorModels.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PAEBPhotoEditGraffitiColorViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PAEBPhotoEditGraffitiColorViewCell class]) forIndexPath:indexPath];
    if (!cell) {
        cell = [[PAEBPhotoEditGraffitiColorViewCell alloc] init];
    }
    cell.model = self.colorModels[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PAEBPhotoEditGraffitiColorModel *model = self.colorModels[indexPath.item];
    if (self.currentSelectModel == model) {
        return;
    }
    if (self.currentSelectModel.selected) {
        self.currentSelectModel.selected = NO;
        PAEBPhotoEditGraffitiColorViewCell *beforeCell = (PAEBPhotoEditGraffitiColorViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[self.colorModels indexOfObject:self.currentSelectModel] inSection:0]];
        [beforeCell setSelected:NO];
    }
    model.selected = YES;
    self.currentSelectModel = model;
    if (self.showBackgroudColor) {
        self.useBgColor = model.color;
        if ([model.color hx_colorIsWhite]) {
            [self changeTextViewTextColor:[UIColor blackColor]];
        }else {
            [self changeTextViewTextColor:[UIColor whiteColor]];
        }
    }else {
        [self changeTextViewTextColor:model.color];
    }
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    long count = self.colorModels.count;
    return self.colorModels ? (self.hx_w - self.textBtn.hx_maxX - self.flowLayout.sectionInset.left - self.flowLayout.sectionInset.right) / count - 30.f : 10.f;
}

#pragma mark <TextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView {
    textView.typingAttributes = self.typingAttributes;
    if (self.textIsDelete) {
        [self drawTextBackgroudColor];
        self.textIsDelete = NO;
    }
    if (!self.textView.text.length) {
        self.textLayer.frame = CGRectZero;
        return;
    }else {
        if (textView.text.length > self.configuration.maximumLimitTextLength &&
            self.configuration.maximumLimitTextLength > 0) {
            textView.text = [textView.text substringToIndex:self.configuration.maximumLimitTextLength];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (!text.length) {
        self.textIsDelete = YES;
    }
    if ([text isEqualToString:@"\n"]) {
        [self didDoneClick:nil];
        return NO;
    }
    return YES;
}

- (void)drawTextBackgroudColor {
    if (!self.textView.text.length) {
        self.textLayer.path = nil;
        return;
    }
    NSRange range = [self.textView.layoutManager characterRangeForGlyphRange:NSMakeRange(0, self.textView.text.length) actualGlyphRange:NULL];
    NSRange glyphRange = [self.textView.layoutManager glyphRangeForCharacterRange:range
                                      actualCharacterRange:NULL];
    NSMutableArray *rectArray = @[].mutableCopy;
    HXWeakSelf
    [self.textView.layoutManager enumerateLineFragmentsForGlyphRange:glyphRange usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer * _Nonnull textContainer, NSRange glyphRange, BOOL * _Nonnull stop) {
        CGRect newRect = usedRect;
        NSString *glyphStr = (weakSelf.textView.text.length >= (glyphRange.location + glyphRange.length) && weakSelf.textView.text.length) ? [weakSelf.textView.text substringWithRange:glyphRange] : nil;
        if (glyphStr.length > 0 && [[glyphStr substringWithRange:NSMakeRange(glyphStr.length - 1, 1)] isEqualToString:@"\n"]) {
            newRect = CGRectMake(newRect.origin.x - 6, newRect.origin.y - 8, newRect.size.width + 12, newRect.size.height + 8);
        }else {
            newRect = CGRectMake(newRect.origin.x - 6, newRect.origin.y - 8, newRect.size.width + 12, newRect.size.height + 16);
        }
        NSValue *value = [NSValue valueWithCGRect:newRect];
        [rectArray addObject:value];
    }];
    UIBezierPath *path = [self drawBackgroundWithRectArray:rectArray];
    CGColorRef color = self.showBackgroudColor ? self.useBgColor.CGColor : [UIColor clearColor].CGColor;
    if (self.textLayer) {
        self.textLayer.path = path.CGPath;
        self.textLayer.strokeColor = color;
        self.textLayer.fillColor = color;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.textLayer.frame = CGRectMake(15, 15, path.bounds.size.width, self.textView.contentSize.height);
        [CATransaction commit];
    }else {
        for (UIView *view in self.textView.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"_UITextContainerView")]) {
                self.textLayer = [self createTextBackgroudColorWithPath:path.CGPath];
                [CATransaction begin];
                [CATransaction setDisableActions:YES];
                self.textLayer.frame = CGRectMake(15, 15, path.bounds.size.width, self.textView.contentSize.height);
                [CATransaction commit];
                [view.layer insertSublayer:self.textLayer atIndex:0];
                break;
            }
        }
    }
}

- (UIBezierPath *)drawBackgroundWithRectArray:(NSMutableArray *)rectArray {
    self.rectArray = rectArray;
    [self preProccess];
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath *bezierPath;
    CGPoint startPoint = CGPointZero;
    for (int i = 0; i < self.rectArray.count; i++) {
        NSValue *curValue = [self.rectArray objectAtIndex:i];
        CGRect cur = curValue.CGRectValue;
        if (cur.size.width <= PAEBEditTextBlankWidth) {
            continue;
        }
        CGFloat loctionX = cur.origin.x;
        CGFloat loctionY = cur.origin.y;
        BOOL half = NO;
        if (!bezierPath) {
            // 设置起点
            bezierPath = [UIBezierPath bezierPath];
            startPoint = CGPointMake(loctionX , loctionY + PAEBHXEditTextRadius);
            [bezierPath moveToPoint:startPoint];
            [bezierPath addArcWithCenter:CGPointMake(loctionX + PAEBHXEditTextRadius, loctionY + PAEBHXEditTextRadius) radius:PAEBHXEditTextRadius startAngle:M_PI endAngle:1.5 * M_PI clockwise:YES];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(cur) - PAEBHXEditTextRadius, loctionY)];
            [bezierPath addArcWithCenter:CGPointMake(CGRectGetMaxX(cur) - PAEBHXEditTextRadius, loctionY + PAEBHXEditTextRadius) radius:PAEBHXEditTextRadius startAngle:M_PI * 1.5 endAngle:0 clockwise:YES];
        }else {
            NSValue *lastCurValue = [self.rectArray objectAtIndex:i - 1];
            CGRect lastCur = lastCurValue.CGRectValue;
            CGRect nextCur;
            if (CGRectGetMaxX(lastCur) > CGRectGetMaxX(cur)) {
                if (i + 1 < self.rectArray.count) {
                    NSValue *nextCurValue = [self.rectArray objectAtIndex:i + 1];
                    nextCur = nextCurValue.CGRectValue;
                    if (nextCur.size.width > PAEBEditTextBlankWidth) {
                        if (CGRectGetMaxX(nextCur) > CGRectGetMaxX(cur)) {
                            half = YES;
                        }
                    }
                }
                if (half) {
                    CGFloat radius = (nextCur.origin.y - CGRectGetMaxY(lastCur)) / 2;
                    CGFloat centerY = nextCur.origin.y - radius;
                    [bezierPath addArcWithCenter:CGPointMake(CGRectGetMaxX(cur) + radius, centerY) radius:radius startAngle:-0.5 * M_PI endAngle:-1.5 * M_PI clockwise:NO];
                }else {
                    [bezierPath addArcWithCenter:CGPointMake(CGRectGetMaxX(cur) + PAEBHXEditTextRadius, CGRectGetMaxY(lastCur) + PAEBHXEditTextRadius) radius:PAEBHXEditTextRadius startAngle:-0.5 * M_PI endAngle:-M_PI clockwise:NO];
                }
            }else if (CGRectGetMaxX(lastCur) == CGRectGetMaxX(cur)) {
                [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(cur), CGRectGetMaxY(cur) - PAEBHXEditTextRadius)];
            }else {
                [bezierPath addArcWithCenter:CGPointMake(CGRectGetMaxX(cur) - PAEBHXEditTextRadius, cur.origin.y + PAEBHXEditTextRadius) radius:PAEBHXEditTextRadius startAngle:1.5 * M_PI endAngle:0.f clockwise:YES];
            }
        }
        BOOL hasNext = NO;
        if (i + 1 < self.rectArray.count) {
            NSValue *nextCurValue = [self.rectArray objectAtIndex:i + 1];
            CGRect nextCur = nextCurValue.CGRectValue;
            if (nextCur.size.width > PAEBEditTextBlankWidth) {
                if (CGRectGetMaxX(cur) > CGRectGetMaxX(nextCur)) {
                    CGPoint point = CGPointMake(CGRectGetMaxX(cur), CGRectGetMaxY(cur) - PAEBHXEditTextRadius);
                    if (!CGPointEqualToPoint(point, bezierPath.currentPoint)) {
                        [bezierPath addLineToPoint:point];
                        [bezierPath addArcWithCenter:CGPointMake(CGRectGetMaxX(cur) - PAEBHXEditTextRadius, CGRectGetMaxY(cur) - PAEBHXEditTextRadius) radius:PAEBHXEditTextRadius startAngle:0 endAngle:0.5 * M_PI clockwise:YES];
                    }else {
                        [bezierPath addArcWithCenter:CGPointMake(CGRectGetMaxX(cur) - PAEBHXEditTextRadius, CGRectGetMaxY(cur) - PAEBHXEditTextRadius) radius:PAEBHXEditTextRadius startAngle:0 endAngle:0.5 * M_PI clockwise:YES];
                    }
                    
                    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(nextCur) + PAEBHXEditTextRadius, CGRectGetMaxY(cur))];
                }else if (CGRectGetMaxX(cur) == CGRectGetMaxX(nextCur)) {
                    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(cur), CGRectGetMaxY(cur))];
                }else {
                    if (!half) {
                        CGPoint point = CGPointMake(CGRectGetMaxX(cur), nextCur.origin.y - PAEBHXEditTextRadius);
                        if (!CGPointEqualToPoint(point, bezierPath.currentPoint)) {
                            [bezierPath addLineToPoint:point];
                            [bezierPath addArcWithCenter:CGPointMake(CGRectGetMaxX(cur) + PAEBHXEditTextRadius, nextCur.origin.y - PAEBHXEditTextRadius) radius:PAEBHXEditTextRadius startAngle:-M_PI endAngle:-1.5f * M_PI clockwise:NO];
                        }else {
                            [bezierPath addArcWithCenter:CGPointMake(bezierPath.currentPoint.x + PAEBHXEditTextRadius, bezierPath.currentPoint.y) radius:PAEBHXEditTextRadius startAngle:-M_PI endAngle:-1.5f * M_PI clockwise:NO];
                        }
                    }
                    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(nextCur) - PAEBHXEditTextRadius, nextCur.origin.y)];
                }
                hasNext = YES;
            }
        }
        if (!hasNext) {
            [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(cur), CGRectGetMaxY(cur) - PAEBHXEditTextRadius)];
            
            [bezierPath addArcWithCenter:CGPointMake(CGRectGetMaxX(cur) - PAEBHXEditTextRadius, CGRectGetMaxY(cur) - PAEBHXEditTextRadius) radius:PAEBHXEditTextRadius startAngle:0 endAngle:0.5 * M_PI clockwise:YES];
            
            [bezierPath addLineToPoint:CGPointMake(cur.origin.x + PAEBHXEditTextRadius, CGRectGetMaxY(cur))];
            
            [bezierPath addArcWithCenter:CGPointMake(cur.origin.x + PAEBHXEditTextRadius, CGRectGetMaxY(cur) - PAEBHXEditTextRadius) radius:PAEBHXEditTextRadius startAngle:0.5 * M_PI endAngle:M_PI clockwise:YES];
            
            [bezierPath addLineToPoint:CGPointMake(cur.origin.x, startPoint.y)];
            
            [path appendPath:bezierPath];
            bezierPath = nil;
        }
    }
    return path;
}

- (void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag {
    if (layoutFinishedFlag) {
        [self drawTextBackgroudColor];
    }
}

- (void)preProccess {
    self.maxIndex = 0;
    if (self.rectArray.count < 2) {
        return;
    }
    for (int i = 1; i < self.rectArray.count; i++) {
        self.maxIndex = i;
        [self processRectIndex:i];
    }
}

- (void)processRectIndex:(int) index {
    if (self.rectArray.count < 2 || index < 1 || index > self.maxIndex) {
        return;
    }
    NSValue *value1 = [self.rectArray objectAtIndex:index - 1];
    NSValue *value2 = [self.rectArray objectAtIndex:index];
    CGRect last = value1.CGRectValue;
    CGRect cur = value2.CGRectValue;
    if (cur.size.width <= PAEBEditTextBlankWidth || last.size.width <= PAEBEditTextBlankWidth) {
        return;
    }
    BOOL t1 = NO;
    BOOL t2 = NO;
    //if t1 == true 改变cur的rect
    if (cur.origin.x > last.origin.x) {
        if (cur.origin.x - last.origin.x < 2 * PAEBHXEditTextRadius) {
            cur = CGRectMake(last.origin.x, cur.origin.y, cur.size.width, cur.size.height);
            t1 = YES;
        }
    }else if (cur.origin.x < last.origin.x) {
        if (last.origin.x - cur.origin.x < 2 * PAEBHXEditTextRadius) {
            cur = CGRectMake(last.origin.x, cur.origin.y, cur.size.width, cur.size.height);
            t1 = YES;
        }
    }
    if (CGRectGetMaxX(cur) > CGRectGetMaxX(last)) {
        CGFloat poor = CGRectGetMaxX(cur) - CGRectGetMaxX(last);
        if (poor < 2 * PAEBHXEditTextRadius) {
            last = CGRectMake(last.origin.x, last.origin.y, cur.size.width, last.size.height);
            t2 = YES;
        }
    }
    if (CGRectGetMaxX(cur) < CGRectGetMaxX(last)) {
        CGFloat poor = CGRectGetMaxX(last) - CGRectGetMaxX(cur);
        if (poor < 2 * PAEBHXEditTextRadius) {
            cur = CGRectMake(cur.origin.x, cur.origin.y, last.size.width, cur.size.height);
            t1 = YES;
        }
    }
    if (t1) {
        NSValue *newValue = [NSValue valueWithCGRect:cur];
        [self.rectArray replaceObjectAtIndex:index withObject:newValue];
        [self processRectIndex:index + 1];
    }
    if (t2) {
        NSValue *newValue = [NSValue valueWithCGRect:last];
        [self.rectArray replaceObjectAtIndex:index - 1 withObject:newValue];
        [self processRectIndex:index - 1];
    }
     
    return;
}

- (NSMutableArray *)rectArray {
    if (!_rectArray) {
        _rectArray = [NSMutableArray array];
    }
    return _rectArray;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HX_ScreenWidth, HXNavigationBarHeight)];
        _topView.backgroundColor = [UIColor clearColor];
    }
    return _topView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setFrame:CGRectMake(20, HXStatusBarHeight+(44*0.5-30*0.5), 32, 30)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont hx_pingFangFontOfSize:14.0]];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(didCancelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setFrame:CGRectMake(HX_ScreenWidth-96, HXStatusBarHeight+(44*0.5-32*0.5), 76, 32)];
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_doneBtn.titleLabel setFont:[UIFont hx_pingFangFontOfSize:14.0]];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneBtn setBackgroundColor:[UIColor hx_colorWithHexStr:HXThemeColor]];
        _doneBtn.layer.cornerRadius = 16.0;
        _doneBtn.clipsToBounds = YES;
        [_doneBtn addTarget:self action:@selector(didDoneClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.hx_h-56-HXBottomMargin, HX_ScreenWidth, 56)];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

- (UIButton *)textBtn {
    if (!_textBtn) {
        _textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_textBtn setFrame:CGRectMake(10, 0, 47, 56)];
        [_textBtn setImage:[UIImage imageNamed:@"photo_edit_text_normal"] forState:UIControlStateNormal];
        [_textBtn setImage:[UIImage imageNamed:@"photo_edit_text_selected"] forState:UIControlStateSelected];
        [_textBtn addTarget:self action:@selector(didTextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textBtn;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(57, 0, self.hx_w-57, 56) collectionViewLayout:self.flowLayout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerClass:[PAEBPhotoEditGraffitiColorViewCell class] forCellWithReuseIdentifier:NSStringFromClass([PAEBPhotoEditGraffitiColorViewCell class])];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _flowLayout.minimumInteritemSpacing = 5;
        _flowLayout.itemSize = CGSizeMake(30.f, 30.f);
    }
    return _flowLayout;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.topView.frame), self.hx_w-20, self.hx_h-self.topView.hx_h-self.bottomView.hx_h)];
        _textView.delegate = self;
        _textView.layoutManager.delegate = self;
        _textView.editable = YES;
        _textView.selectable = YES;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.returnKeyType = UIReturnKeyDone;
        // 使用textContainerInset设置top、leaft、right
        CGFloat xMargin = 15, yMargin = 15;
        _textView.textContainerInset = UIEdgeInsetsMake(yMargin, xMargin, yMargin, xMargin);
        _textView.contentInset = UIEdgeInsetsZero;
    }
    return _textView;
}

@end

@implementation PAEBPhotoEditTextModel
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.text = [aDecoder decodeObjectForKey:@"text"];
        self.textColor = [aDecoder decodeObjectForKey:@"textColor"];
        self.showBackgroud = [aDecoder decodeBoolForKey:@"showBackgroud"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeObject:self.textColor forKey:@"textColor"];
    [aCoder encodeBool:self.showBackgroud forKey:@"showBackgroud"];
}
@end

@implementation PAEBPhotoEditTextLayer

@end

