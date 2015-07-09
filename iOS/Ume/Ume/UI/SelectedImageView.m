//
//  SelectedImageView.m
//  Ume
//
//  Created by Start on 15/7/9.
//  Copyright (c) 2015年 Ancun. All rights reserved.
//

#import "SelectedImageView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CameraUtility.h"
#import "UIImage+Utils.h"


#define ORIGINAL_MAX_WIDTH 640.0f

@implementation SelectedImageView{
    UIButton *mLocalImage;
    UIButton *mCameraImage;
}


- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        //相册
        mLocalImage=[[UIButton alloc]initWithFrame:CGRectMake1(40,45,80,80)];
        mLocalImage.layer.cornerRadius=mLocalImage.bounds.size.width/2;
        mLocalImage.layer.masksToBounds=YES;
        mLocalImage.layer.borderWidth=1;
        mLocalImage.layer.borderColor=COLOR2552160.CGColor;
        [mLocalImage setImage:[UIImage imageNamed:@"icon-相册"] forState:UIControlStateNormal];
        [mLocalImage addTarget:self action:@selector(goLocalImage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mLocalImage];
        //相机
        mCameraImage=[[UIButton alloc]initWithFrame:CGRectMake1(180,45,80,80)];
        mCameraImage.layer.cornerRadius=mLocalImage.bounds.size.width/2;
        mCameraImage.layer.masksToBounds=YES;
        mCameraImage.layer.borderWidth=1;
        mCameraImage.layer.borderColor=COLOR2552160.CGColor;
        [mCameraImage setImage:[UIImage imageNamed:@"icon-相机"] forState:UIControlStateNormal];
        [mCameraImage addTarget:self action:@selector(goCamera:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mCameraImage];
        
    }
    return self;
}

- (void)goLocalImage:(id)sender
{
    // 从相册中选取
    if ([CameraUtility isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self.currentController presentViewController:controller animated:YES completion:nil];
    }
}

- (void)goCamera:(id)sender
{
    // 拍照
    if ([CameraUtility isCameraAvailable] && [CameraUtility doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([CameraUtility isFrontCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self.currentController presentViewController:controller
                                             animated:YES
                                           completion:^(void){
                                               NSLog(@"Picker View Controller is presented");
                                           }];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [portraitImg imageByScalingToMaxSize];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.currentController.view.frame.size.width, self.currentController.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self.currentController presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
//    [iUserNameImage setImage:editedImage];
    NSLog(@"设置图片了");
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

@end