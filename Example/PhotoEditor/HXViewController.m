//
//  HXViewController.m
//  PhotoEditor
//
//  Created by 234539037@qq.com on 04/02/2021.
//  Copyright (c) 2021 234539037@qq.com. All rights reserved.
//

#import "HXViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "PAEBPhotoEditViewController.h"
#import "PAEBPhotoEditConfiguration.h"

@interface HXViewController () <TZImagePickerControllerDelegate, PAEBPhotoEditViewControllerDelegate>
@property (nonatomic, strong) TZImagePickerController *imagePickerVc;
@property (nonatomic, strong) PAEBPhotoEdit *photoEdit;
@property (nonatomic, strong) PAEBPhotoModel *photoModel;
@end

@implementation HXViewController
- (IBAction)showAlbum:(id)sender {
    self.imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:4 delegate:self];
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    __weak typeof(self) weakSelf = self;
    [self.imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        PAEBPhotoEditConfiguration *photoEditConfig = [[PAEBPhotoEditConfiguration alloc] init];
        PAEBPhotoEditViewController *ctl = [[PAEBPhotoEditViewController alloc] initWithConfiguration:photoEditConfig];
        ctl.delegate = weakSelf;
        PAEBPhotoModel *photoModel = [PAEBPhotoModel photoModelWithPHAsset:[assets firstObject]];
        ctl.photoModel = photoModel;
        ctl.modalPresentationCapturesStatusBarAppearance = YES;
        ctl.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [weakSelf presentViewController:ctl animated:YES completion:nil];
    }];
    
    [self presentViewController:self.imagePickerVc animated:NO completion:nil];
}

- (IBAction)takePhoto:(id)sender {
    self.imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    __weak typeof(self) weakSelf = self;
    [self.imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        PAEBPhotoEditConfiguration *photoEditConfig = [[PAEBPhotoEditConfiguration alloc] init];
//        photoEditConfig.isAvatarCliping = YES;
        photoEditConfig.onlyCliping = YES;
        PAEBPhotoEditViewController *ctl = [[PAEBPhotoEditViewController alloc] initWithConfiguration:photoEditConfig];
        ctl.delegate = weakSelf;
        PAEBPhotoModel *photoModel = [PAEBPhotoModel photoModelWithPHAsset:[assets firstObject]];
        ctl.photoModel = photoModel;
        ctl.onlyCliping = YES;
        ctl.modalPresentationCapturesStatusBarAppearance = YES;
        ctl.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [weakSelf presentViewController:ctl animated:YES completion:nil];
    }];
    
    [self presentViewController:self.imagePickerVc animated:NO completion:nil];
}

- (IBAction)editClick:(id)sender {
    PAEBPhotoEditConfiguration *photoEditConfig = [[PAEBPhotoEditConfiguration alloc] init];
    PAEBPhotoEditViewController *vc = [[PAEBPhotoEditViewController alloc] initWithConfiguration:photoEditConfig];
    vc.photoModel = self.photoModel;
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.modalPresentationCapturesStatusBarAppearance = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)photoEditingController:(PAEBPhotoEditViewController *)photoEditingVC
            didFinishPhotoEdit:(PAEBPhotoEdit *)photoEdit
                    photoModel:(PAEBPhotoModel *)photoModel {
    _photoEdit = photoEdit;
    _photoModel = photoModel;
    NSLog(@"Finish");
}

@end
