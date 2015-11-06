//
//  HandleViewController.m
//  Car
//
//  Created by Start on 10/30/15.
//  Copyright © 2015 Ancun. All rights reserved.
//

#import "HandleViewController.h"
#import "UIImage+Utils.h"
#import "CameraUtility.h"

@interface HandleViewController ()

@end

@implementation HandleViewController{
    UIScrollView *scrollView;
    CameraView *cameraView1;
    CameraView *cameraView2;
    CameraView *cameraView3;
    CameraView *cameraView4;
    CameraView *cameraView5;
    CameraView *cameraView6;
    CameraView *cameraView7;
    CameraView *cameraView8;
    CameraView *cameraViewPai;
}

- (id)init
{
    self=[super init];
    if(self){
        [self setTitle:@"现场拍照取证 "];
        [self.view setBackgroundColor:BCOLOR(244)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    [scrollView setContentSize:CGSizeMake1(320, 528+50)];
    [scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [scrollView setBackgroundColor:BCOLOR(244)];
    [self.view addSubview:scrollView];
    XLButton *bSubmit=[[XLButton alloc]initWithFrame:CGRectMake(CGWidth(10), self.view.bounds.size.height-64-CGHeight(45), CGWidth(300),CGHeight(40)) Name:@"提交照片" Type:3];
    [bSubmit addTarget:self action:@selector(goSubmit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bSubmit];
    //图1
    cameraView1=[[CameraView alloc]initWithFrame:CGRectMake1(0, 0, 160, 132)];
    [cameraView1.lblInfo setText:@"碰撞部位局部照"];
    [cameraView1.currentImageView setImage:[UIImage imageNamed:@"局部照"]];
    [cameraView1 setControler:self];
    [scrollView addSubview:cameraView1];
    //图2
    cameraView2=[[CameraView alloc]initWithFrame:CGRectMake1(160, 0, 160, 132)];
    [cameraView2.lblInfo setText:@"前车前方5米前景"];
    [cameraView2.currentImageView setImage:[UIImage imageNamed:@"前景"]];
    [cameraView2 setControler:self];
    [scrollView addSubview:cameraView2];
    //图3
    cameraView3=[[CameraView alloc]initWithFrame:CGRectMake1(0, 132, 160, 132)];
    [cameraView3.lblInfo setText:@"后车后方5米后景"];
    [cameraView3.currentImageView setImage:[UIImage imageNamed:@"后景"]];
    [cameraView3 setControler:self];
    [scrollView addSubview:cameraView3];
    //图4
    cameraView4=[[CameraView alloc]initWithFrame:CGRectMake1(160, 132, 160, 132)];
    [cameraView4.lblInfo setText:@"当事人1驾驶证、行驶证"];
    [cameraView4.currentImageView setImage:[UIImage imageNamed:@"证件小"]];
//    [cameraView4 setControler:self];
    [cameraView4.pai addTarget:self action:@selector(goPai) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:cameraView4];
    //图5
    cameraView5=[[CameraView alloc]initWithFrame:CGRectMake1(0, 264, 160, 132)];
    [cameraView5.lblInfo setText:@"补充照片"];
    [cameraView5 setControler:self];
    [cameraView5 setDelegate:self];
    [cameraView5 setIsDelete:YES];
    [scrollView addSubview:cameraView5];
    //图6
    cameraView6=[[CameraView alloc]initWithFrame:CGRectMake1(160, 264, 160, 132)];
    [cameraView6.lblInfo setText:@"补充照片"];
    [cameraView6 setControler:self];
    [cameraView6 setDelegate:self];
    [cameraView6 setIsDelete:YES];
    [scrollView addSubview:cameraView6];
    //图7
    cameraView7=[[CameraView alloc]initWithFrame:CGRectMake1(0, 396, 160, 132)];
    [cameraView7.lblInfo setText:@"补充照片"];
    [cameraView7 setControler:self];
    [cameraView7 setDelegate:self];
    [cameraView7 setIsDelete:YES];
    [scrollView addSubview:cameraView7];
    //图8
    cameraView8=[[CameraView alloc]initWithFrame:CGRectMake1(160, 396, 160, 132)];
    [cameraView8.lblInfo setText:@"补充照片"];
    [cameraView8 setControler:self];
    [cameraView8 setIsDelete:YES];
    [scrollView addSubview:cameraView8];
    
    [cameraView6 setHidden:YES];
    [cameraView7 setHidden:YES];
    [cameraView8 setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.viewFrame==nil){
        self.viewFrame=[[UIView alloc]initWithFrame:self.view.bounds];
        [self.viewFrame setBackgroundColor:BCOLORA(100, 0.5)];
        [self.viewFrame setHidden:YES];
        [self.navigationController.view addSubview:self.viewFrame];
        CGFloat topX=64+CGHeight(20);
        if(inch35){
            topX=self.viewFrame.bounds.size.height-CGHeight(440);
        }
        UIView *viewFrameChild=[[UIView alloc]initWithFrame:CGRectMake(CGWidth(10), topX, CGWidth(300), CGHeight(400))];
        viewFrameChild.layer.borderWidth=CGWidth(1);
        viewFrameChild.layer.borderColor=BCOLOR(150).CGColor;
        [viewFrameChild setBackgroundColor:BCOLOR(244)];
        [self.viewFrame addSubview:viewFrameChild];
        
        XLTextField *mUserName=[[XLTextField alloc]initWithFrame:CGRectMake1(10, 10, 280, 40)];
        [mUserName setPlaceholder:@"当事人车牌号"];
        [mUserName setStyle:2];
        [viewFrameChild addSubview:mUserName];
        mUserName=[[XLTextField alloc]initWithFrame:CGRectMake1(10, 60, 280, 40)];
        [mUserName setPlaceholder:@"当事人手机号"];
        [mUserName setStyle:2];
        [viewFrameChild addSubview:mUserName];
        mUserName=[[XLTextField alloc]initWithFrame:CGRectMake1(10, 110, 145, 40)];
        [mUserName setPlaceholder:@"请输入验证码"];
        [mUserName setStyle:2];
        [mUserName setKeyboardType:UIKeyboardTypeNumberPad];
        [viewFrameChild addSubview:mUserName];
        XLButton *bGetCode=[[XLButton alloc]initWithFrame:CGRectMake1(160,110,130,40) Name:@"获取验证码" Type:2];
        [bGetCode addTarget:self action:@selector(goGetCode) forControlEvents:UIControlEventTouchUpInside];
        [viewFrameChild addSubview:bGetCode];
        cameraViewPai=[[CameraView alloc]initWithFrame:CGRectMake1(10, 160, 280, 180)];
        [cameraViewPai.lblInfo setText:@"当事人1驾驶证、行驶证"];
        [cameraViewPai.currentImageView setImage:[UIImage imageNamed:@"证件小"]];
        [cameraViewPai setControler:self];
        [viewFrameChild addSubview:cameraViewPai];
        XLButton *bCancel=[[XLButton alloc]initWithFrame:CGRectMake1(10,350,135,40) Name:@"取消" Type:2];
        [bCancel addTarget:self action:@selector(goCancel) forControlEvents:UIControlEventTouchUpInside];
        [viewFrameChild addSubview:bCancel];
        XLButton *bOk=[[XLButton alloc]initWithFrame:CGRectMake1(155,350,135,40) Name:@"确定" Type:3];
        [bOk addTarget:self action:@selector(goOK) forControlEvents:UIControlEventTouchUpInside];
        [viewFrameChild addSubview:bOk];
    }
}

- (void)CameraSuccess:(CameraView*)camera
{
    if(camera==cameraView5){
        if(cameraView5.currentImage){
            [cameraView6 setHidden:NO];
        }
    }if(camera==cameraView6){
        if(cameraView6.currentImage){
            [cameraView7 setHidden:NO];
        }
    }if(camera==cameraView7){
        if(cameraView7.currentImage){
            [cameraView8 setHidden:NO];
        }
    }
}

- (void)CameraDelete:(CameraView *)camera
{
    if(camera==cameraView5){
        if(cameraView6.currentImage){
            [self cameraCopy:cameraView5 To:cameraView6];
            [self resetCameraView:cameraView6];
            [cameraView6 setHidden:NO];
            [cameraView7 setHidden:YES];
            [cameraView8 setHidden:YES];
            if(cameraView7.currentImage){
                [self cameraCopy:cameraView6 To:cameraView7];
                [self resetCameraView:cameraView7];
                [cameraView7 setHidden:NO];
                [cameraView8 setHidden:YES];
                if(cameraView8.currentImage){
                    [self cameraCopy:cameraView7 To:cameraView8];
                    [self resetCameraView:cameraView8];
                    [cameraView8 setHidden:NO];
                }
            }
        }else{
            [cameraView6 setHidden:YES];
        }
    }else if(camera==cameraView6){
        if(cameraView7.currentImage){
            [self cameraCopy:cameraView6 To:cameraView7];
            [self resetCameraView:cameraView7];
            [cameraView7 setHidden:NO];
            [cameraView8 setHidden:YES];
            if(cameraView8.currentImage){
                [self cameraCopy:cameraView7 To:cameraView8];
                [self resetCameraView:cameraView8];
                [cameraView8 setHidden:NO];
            }
        }else{
            [cameraView7 setHidden:YES];
        }
    }else if(camera==cameraView7){
        if(cameraView8.currentImage){
            [self cameraCopy:cameraView7 To:cameraView8];
            [self resetCameraView:cameraView8];
            [cameraView8 setHidden:NO];
        }else{
            [cameraView7 setHidden:YES];
        }
    }
}

- (void)cameraCopy:(CameraView*)obj To:(CameraView*)to
{
    [obj setDelegate:self];
    [obj setIsDelete:to.isDelete];
    [obj setCurrentImage:to.currentImage];
    [obj.currentImageView setImage:to.currentImageView.image];
    [obj.pai setHidden:YES];
    [obj.rPai setHidden:NO];
}

- (void)resetCameraView:(CameraView*)camera
{
    [camera setIsDelete:YES];
    [camera setDelegate:self];
    [camera setCurrentImage:nil];
    [camera.currentImageView setImage:nil];
    [camera.pai setHidden:NO];
    [camera.rPai setHidden:YES];
}

- (void)goSubmit
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)goCancel
{
    [self.viewFrame setHidden:YES];
}

- (void)goOK
{
    [cameraView4 setCurrentImage:cameraViewPai.currentImage];
    [cameraView4.currentImageView setImage:cameraView4.currentImage];
    [self.viewFrame setHidden:YES];
}

- (void)goPai
{
    [self.viewFrame setHidden:NO];
}

- (void)goGetCode
{
}

@end