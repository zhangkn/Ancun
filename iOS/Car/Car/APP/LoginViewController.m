//
//  LoginViewController.m
//  Car
//
//  Created by Start on 10/13/15.
//  Copyright © 2015 Ancun. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController{
    XLTextField *mUserName;
    XLTextField *mPassword;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:nil];
    UIImageView *bgView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    [bgView setImage:[UIImage imageNamed:@"BJ_1"]];
    [bgView setUserInteractionEnabled:YES];
    [self.view addSubview:bgView];
    
    UIImageView *logo=[[UIImageView alloc]initWithFrame:CGRectMake1(94, 60, 132, 62)];
    [logo setImage:[UIImage imageNamed:@"LOGO"]];
    [bgView addSubview:logo];
    
    mUserName=[[XLTextField alloc]initWithFrame:CGRectMake1(20, 150, 280, 40)];
    [mUserName setPlaceholder:@"请输入手机号"];
    [mUserName setStyle:1];
    [bgView addSubview:mUserName];
    
    mPassword=[[XLTextField alloc]initWithFrame:CGRectMake1(20, 210, 280, 40)];
    [mPassword setPlaceholder:@"请输入密码"];
    [mPassword setSecureTextEntry:YES];
    [mPassword setStyle:1];
    [bgView addSubview:mPassword];
    
    XLButton *bLogin=[[XLButton alloc]initWithFrame:CGRectMake1(20, 270, 280, 40) Name:@"登录" Type:3];
    [bLogin addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:bLogin];
    
    XLButton *bForgetPassword=[[XLButton alloc]initWithFrame:CGRectMake1(20, 320, 100, 40) Name:@"忘记密码？" Type:6];
    [bForgetPassword.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [bForgetPassword setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [bForgetPassword addTarget:self action:@selector(goForgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:bForgetPassword];
    
    XLButton *bRegister=[[XLButton alloc]initWithFrame:CGRectMake1(200, 320, 100, 40) Name:@"快速注册" Type:6];
    [bRegister.titleLabel setTextAlignment:NSTextAlignmentRight];
    [bRegister setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [bRegister addTarget:self action:@selector(goRegister) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:bRegister];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)goLogin
{
    [[User getInstance]setIsLogin:YES];
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [myDelegate windowRootViewController];
}

- (void)goForgetPassword
{
    [self.navigationController pushViewController:[[ForgetPasswordViewController alloc]init] animated:YES];
}

- (void)goRegister
{
    [self.navigationController pushViewController:[[RegisterViewController alloc]init] animated:YES];
}

@end