//
//  ACModifyPasswordViewController.m
//  Ancun
//
//  Created by Start on 4/8/14.
//
//

#import "ACModifyPasswordViewController.h"
#import "LoginTextField.h"

@interface ACModifyPasswordViewController ()

@end

@implementation ACModifyPasswordViewController {
    LoginTextField *txtOldPassword;
    LoginTextField *txtNewPassword;
    LoginTextField *txtReNewPassword;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.title=@"修改密码";
        
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        UIControl *container=[[UIControl alloc]initWithFrame:CGRectMake1(0, 0, WIDTH, HEIGHT-STATUSHEIGHT-TOPNAVIGATIONHEIGHT-BOTTOMTABBARHEIGHT)];
        [container addTarget:self action:@selector(backgroundDoneEditing:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:container];
        
        UIImageView *view=[[UIImageView alloc]initWithFrame:CGRectMake1(14.5, 10, 291, 194)];
//        [view addTarget:self action:@selector(backgroundDoneEditing:) forControlEvents:UIControlEventTouchDown];
//        [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg1"]]];
        [view setUserInteractionEnabled:YES];
        [view setImage:[UIImage imageNamed:@"bg1"]];
        [container addSubview:view];
        
        
        txtOldPassword=[[LoginTextField alloc] initWithFrame:CGRectMake1(17, 20.25, 257, 44.5) Placeholder:@"输入旧密码"];
        txtOldPassword.layer.cornerRadius = 5;
        [txtOldPassword setFont:[UIFont systemFontOfSize: 18]];
        [txtOldPassword setSecureTextEntry:YES];
        [view addSubview:txtOldPassword];
        
        txtNewPassword=[[LoginTextField alloc] initWithFrame:CGRectMake1(17, 74.75, 257, 44.5) Placeholder:@"输入旧密码"];
        txtNewPassword.layer.cornerRadius = 5;
        [txtNewPassword setFont:[UIFont systemFontOfSize: 18]];
        [txtNewPassword setSecureTextEntry:YES];
        [view addSubview:txtNewPassword];
        
        txtReNewPassword=[[LoginTextField alloc] initWithFrame:CGRectMake1(17, 129.25, 257, 44.5)Placeholder:@"确认新密码"];
        txtReNewPassword.layer.cornerRadius = 5;
        [txtReNewPassword setFont:[UIFont systemFontOfSize: 18]];
        [txtReNewPassword setSecureTextEntry:YES];
        [view addSubview:txtReNewPassword];
        
        UIButton *btnSubmit=[[UIButton alloc]initWithFrame:CGRectMake1(14.5, 224, 291, 40)];
        [btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
        btnSubmit.titleLabel.font=[UIFont systemFontOfSize:22];
        btnSubmit.layer.cornerRadius=5;
        btnSubmit.layer.masksToBounds=YES;
        [btnSubmit setBackgroundColor:[UIColor colorWithRed:(69/255.0) green:(168/255.0) blue:(249/255.0) alpha:1]];
        [btnSubmit addTarget:self action:@selector(submitPwdModify:) forControlEvents:UIControlEventTouchUpInside];
        [container addSubview:btnSubmit];
    }
    return self;
}

#pragma mark -
#pragma mark Delegate Methods

- (void)requestFinishedByResponse:(Response*)response requestCode:(int)reqCode{
    if([response successFlag]){
        [Common alert:@"密码修改成功！"];
        NSString *password=txtNewPassword.text;
        [[Config Instance] setPASSWORD:password];
        //如果为自动登录则更新已保存的密码
        if((BOOL)[Common getCacheByBool:DEFAULTDATA_AUTOLOGIN]) {
            [Common setCache:DEFAULTDATA_PASSWORD data:password];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [txtOldPassword setText:@""];
        [txtNewPassword setText:@""];
        [txtReNewPassword setText:@""];
        //将光标移到第一个文本框位置
        [txtOldPassword becomeFirstResponder];
    }
}

#pragma mark -
#pragma mark Custom Methods

- (void)submitPwdModify:(id)sender{
    NSString *oldPwd=txtOldPassword.text;
    NSString *newPwd=txtNewPassword.text;
    NSString *reNewPwd=txtReNewPassword.text;
    if([oldPwd isEqualToString:@""]){
        [Common alert:@"原始密码不能为空"];
    }else if([newPwd isEqualToString:@""]){
        [Common alert:@"新密码不能为空"];
    }else if([reNewPwd isEqualToString:@""]){
        [Common alert:@"请再输入一次新密码"];
    }else if(![newPwd isEqualToString: reNewPwd]){
        [Common alert:@"两次密码输入不相同"];
    }else{
        NSMutableDictionary *requestParams = [[NSMutableDictionary alloc] init];
        [requestParams setObject:[oldPwd md5] forKey:@"passwordold"];
        [requestParams setObject:[newPwd md5] forKey:@"passwordnew"];
        self.hRequest=[[HttpRequest alloc]init];
        [self.hRequest setIsShowMessage:YES];
        [self.hRequest setDelegate:self];
        [self.hRequest setController:self];
        [self.hRequest loginhandle:@"v4pwdModify" requestParams:requestParams];
    }
}

- (void)backgroundDoneEditing:(id)sender{
    [txtOldPassword resignFirstResponder];
    [txtNewPassword resignFirstResponder];
    [txtReNewPassword resignFirstResponder];
}

@end
