//
//  CameraView.m
//  Car
//
//  Created by Start on 10/30/15.
//  Copyright © 2015 Ancun. All rights reserved.
//

#import "CameraView.h"
#import "SJAvatarBrowser.h"

@implementation CameraView{
    XLCamera *camera;
}

- (id)initWithFrame:(CGRect)rect
{
    self=[super initWithFrame:rect];
    if(self){
        CGFloat widht=self.bounds.size.width;
        CGFloat height=self.bounds.size.height;
        self.lblInfo=[[XLLabel alloc]initWithFrame:CGRectMake(0, 0, widht, CGHeight(25))];
        [self.lblInfo setBackgroundColor:[UIColor clearColor]];
        [self.lblInfo setFont:GLOBAL_FONTSIZE(13)];
        [self.lblInfo setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.lblInfo];
        self.currentImageView=[[UIImageView alloc]initWithFrame:CGRectMake(CGWidth(5), CGHeight(25), widht-CGWidth(5*2), height-CGHeight(25))];
        [self.currentImageView setBackgroundColor:[UIColor whiteColor]];
        [self.currentImageView setUserInteractionEnabled:YES];
        [self addSubview:self.currentImageView];
        CGFloat widhtI=self.currentImageView.bounds.size.width;
        CGFloat heightI=self.currentImageView.bounds.size.height;
        self.pai=[[UIButton alloc]initWithFrame:CGRectMake(widhtI/2-CGWidth(40)/2, heightI/2-CGHeight(40)/2, CGWidth(40), CGHeight(40))];
        [self.pai addTarget:self action:@selector(goPhotograph) forControlEvents:UIControlEventTouchUpInside];
        [self.pai setImage:[UIImage imageNamed:@"点击拍照"] forState:UIControlStateNormal];
        [self.currentImageView addSubview:self.pai];
        self.rPai=[[UIButton alloc]initWithFrame:CGRectMake(widhtI-CGWidth(15*2), CGHeight(5), CGWidth(15), CGHeight(15))];
        [self.rPai addTarget:self action:@selector(goRPhotograph) forControlEvents:UIControlEventTouchUpInside];
        [self.rPai setImage:[UIImage imageNamed:@"重拍"] forState:UIControlStateNormal];
        [self.currentImageView setUserInteractionEnabled:YES];
        [self.currentImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goZoom)]];
        [self.currentImageView addSubview:self.rPai];
        [self.pai setHidden:NO];
        [self.rPai setHidden:YES];
    }
    return self;
}

- (void)goPhotograph
{
    if(self.controler){
        camera=[[XLCamera alloc]initWithController:self.controler];
        [camera setPickerDelegate:self];
        [camera setIsImageCut:NO];
        [camera open];
    }
}

- (void)goRPhotograph
{
    if(self.isDelete){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"重拍",nil];
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }else{
        [self goPhotograph];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //照片
    self.currentImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    if(self.currentImage){
        if(self.isDelete){
            [self.pai setHidden:YES];
            [self.rPai setHidden:NO];
        }
        [self.currentImageView setImage:self.currentImage];
        if([self.delegate respondsToSelector:@selector(CameraSuccess:)]){
            [self.delegate CameraSuccess:self];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        self.currentImage=nil;
        [self.currentImageView setImage:nil];
        [self.pai setHidden:NO];
        [self.rPai setHidden:YES];
        if([self.delegate respondsToSelector:@selector(CameraDelete:)]){
            [self.delegate CameraDelete:self];
        }
        
    }else if(buttonIndex==1){
        self.currentImage=nil;
        [self goPhotograph];
    }
}

- (void)goZoom
{
    if(self.currentImage){
        [SJAvatarBrowser showImage:self.currentImageView];
    }
}

@end