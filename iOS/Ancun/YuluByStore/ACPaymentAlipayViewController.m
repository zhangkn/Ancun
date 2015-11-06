//
//  ACPaymentViewController.m
//  Ancun
//
//  Created by Start on 4/4/14.
//
//

#import "ACPaymentAlipayViewController.h"
#import "ACRechargeNav.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import <AlipaySDK/AlipaySDK.h>

#define ALERTVIEWALIPAYTAG 123
#define ALIPAYREQUESTCODE 10000000
#define LBLTEXTCOLOR [UIColor colorWithRed:(102/255.0) green:(102/255.0) blue:(102/255.0) alpha:1]
#define LBLVALUETEXTCOLOR [UIColor colorWithRed:(76/255.0) green:(86/255.0) blue:(108/255.0) alpha:1]

@interface ACPaymentAlipayViewController ()

@end

@implementation ACPaymentAlipayViewController{
    
    ACRechargeNav *_rechargeNav;
    UIView *paymentMainView;
    UIView *paymentSuccessView;
    
    NSDictionary *_data;
    
}

- (id)initWithData:(NSDictionary *)data;
{
    _data=data;
    self = [super init];
    if (self) {
        
        self.title=@"支付";
        
        [self.view setBackgroundColor:[UIColor colorWithRed:(207/255.0) green:(212/255.0) blue:(221/255.0) alpha:1]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *container=[[UIView alloc]initWithFrame:CGRectMake1(0, 0, WIDTH, HEIGHT-STATUSHEIGHT-TOPNAVIGATIONHEIGHT-BOTTOMTABBARHEIGHT)];
    [self.view addSubview:container];
    
    _rechargeNav=[[ACRechargeNav alloc]initWithFrame:CGRectMake1(0, 0, 320, 40)];
    [container addSubview:_rechargeNav];
    
    paymentMainView=[[UIView alloc]initWithFrame:CGRectMake1(10, 60, 300, 285)];
    paymentMainView.layer.cornerRadius=10;
    paymentMainView.layer.masksToBounds=YES;
    [paymentMainView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake1(40, 40, 70, 30)];
    [lbl setFont:[UIFont systemFontOfSize:15]];
    [lbl setTextAlignment:NSTextAlignmentRight];
    [lbl setTextColor:LBLTEXTCOLOR];
    [lbl setText:@"套餐名称:"];
    [paymentMainView addSubview:lbl];
    
    lbl=[[UILabel alloc]initWithFrame:CGRectMake1(115, 40, 150, 30)];
    [lbl setFont:[UIFont systemFontOfSize:15]];
    [lbl setTextColor:LBLVALUETEXTCOLOR];
    [lbl setText:[_data objectForKey:@"name"]];
    [paymentMainView addSubview:lbl];
    
    lbl=[[UILabel alloc]initWithFrame:CGRectMake1(40, 70, 70, 30)];
    [lbl setFont:[UIFont systemFontOfSize:15]];
    [lbl setTextAlignment:NSTextAlignmentRight];
    [lbl setTextColor:LBLTEXTCOLOR];
    [lbl setText:@"支付金额:"];
    [paymentMainView addSubview:lbl];
    //支付金额
    UILabel *lblMoney=[[UILabel alloc]initWithFrame:CGRectMake1(115, 70, 70, 30)];
    [lblMoney setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    [lblMoney setTextColor:LBLVALUETEXTCOLOR];
    [lblMoney setText:[NSString stringWithFormat:@"%@元",[_data objectForKey:@"newprice"]]];
    [paymentMainView addSubview:lblMoney];
    
    lbl=[[UILabel alloc]initWithFrame:CGRectMake1(40, 100, 70, 30)];
    [lbl setFont:[UIFont systemFontOfSize:15]];
    [lbl setTextAlignment:NSTextAlignmentRight];
    [lbl setTextColor:LBLTEXTCOLOR];
    [lbl setText:@"生效日期:"];
    [paymentMainView addSubview:lbl];
    
    UILabel *lblStartDay=[[UILabel alloc]initWithFrame:CGRectMake1(115, 100, 150, 30)];
    [lblStartDay setFont:[UIFont systemFontOfSize:15]];
    [lblStartDay setTextColor:LBLVALUETEXTCOLOR];
    [paymentMainView addSubview:lblStartDay];
    
    lbl=[[UILabel alloc]initWithFrame:CGRectMake1(40, 130, 70, 30)];
    [lbl setFont:[UIFont systemFontOfSize:15]];
    [lbl setTextAlignment:NSTextAlignmentRight];
    [lbl setTextColor:LBLTEXTCOLOR];
    [lbl setText:@"到期日期:"];
    [paymentMainView addSubview:lbl];
    
    UILabel *lblEndDay=[[UILabel alloc]initWithFrame:CGRectMake1(115, 130, 150, 30)];
    [lblEndDay setFont:[UIFont systemFontOfSize:15]];
    [lblEndDay setTextColor:LBLVALUETEXTCOLOR];
    [paymentMainView addSubview:lblEndDay];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval secondsPerDay=24*60*60*[[_data objectForKey:@"valid"]intValue];
    
    NSDate *date=[[NSDate alloc]init];
    NSDate *tomorrow=[NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
    [lblStartDay setText:[formatter stringFromDate:date]];
    [lblEndDay setText:[formatter stringFromDate:tomorrow]];
    
    lbl=[[UILabel alloc]initWithFrame:CGRectMake1(40, 160, 70, 30)];
    [lbl setFont:[UIFont systemFontOfSize:15]];
    [lbl setTextAlignment:NSTextAlignmentRight];
    [lbl setTextColor:LBLTEXTCOLOR];
    [lbl setText:@"充值账户:"];
    [paymentMainView addSubview:lbl];
    
    lbl=[[UILabel alloc]initWithFrame:CGRectMake1(115, 160, 150, 30)];
    [lbl setFont:[UIFont systemFontOfSize:15]];
    [lbl setTextColor:LBLVALUETEXTCOLOR];
    [lbl setText:[[[Config Instance]userInfo]objectForKey:@"phone"]];
    [paymentMainView addSubview:lbl];
    
    UIButton *btnConfirm=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnConfirm setFrame:CGRectMake1(25, 210, 250, 35)];
    [btnConfirm setTitle:@"确认充值" forState:UIControlStateNormal];
    btnConfirm.layer.cornerRadius=5;
    btnConfirm.layer.masksToBounds=YES;
    [btnConfirm setBackgroundColor:[UIColor colorWithRed:(131/255.0) green:(186/255.0) blue:(248/255.0) alpha:1]];
    [btnConfirm addTarget:self action:@selector(confirmPayment:) forControlEvents:UIControlEventTouchDown];
    [paymentMainView addSubview:btnConfirm];
    [container addSubview:paymentMainView];
    
    paymentSuccessView=[[UIView alloc]initWithFrame:CGRectMake1(10, 50, 300, 195)];
    paymentSuccessView.layer.cornerRadius=10;
    paymentSuccessView.layer.masksToBounds=YES;
    [paymentSuccessView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"reg_for_done"]];
    [image setFrame:CGRectMake1(30, 30, 30, 30)];
    [paymentSuccessView addSubview:image];
    
    UILabel *lbl1=[[UILabel alloc]initWithFrame:CGRectMake1(65, 35, 80, 20)];
    [lbl1 setFont:[UIFont systemFontOfSize:18]];
    [lbl1 setTextAlignment:NSTextAlignmentLeft];
    [lbl1 setText:@"充值成功"];
    [paymentSuccessView addSubview:lbl1];
    
    lbl1=[[UILabel alloc]initWithFrame:CGRectMake1(30, 70, 240, 40)];
    [lbl1 setFont:[UIFont systemFontOfSize:16]];
    [lbl1 setTextAlignment:NSTextAlignmentLeft];
    [lbl1 setLineBreakMode:NSLineBreakByCharWrapping];
    [lbl1 setNumberOfLines:0];
    [lbl1 setText:[NSString stringWithFormat:@"您已经为账户(%@)\n购买：%@",[[[Config Instance]userInfo]objectForKey:@"phone"],[_data objectForKey:@"name"]]];
    [paymentSuccessView addSubview:lbl1];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake1(25, 130, 250, 35)];
    [btn setTitle:@"返回我的账户" forState:UIControlStateNormal];
    btn.layer.cornerRadius=5;
    btn.layer.masksToBounds=YES;
    [btn setBackgroundColor:[UIColor colorWithRed:(131/255.0) green:(186/255.0) blue:(248/255.0) alpha:1]];
    [btn addTarget:self action:@selector(backMyAccount:) forControlEvents:UIControlEventTouchDown];
    [paymentSuccessView addSubview:btn];
    
    [container addSubview:paymentSuccessView];
    
    [self paynmentedStep];
    
}

- (void)paynmentedStep
{
    [_rechargeNav secondStep];
    [paymentMainView setHidden:NO];
    [paymentSuccessView setHidden:YES];
}

- (void)paynmentingStep
{
    [_rechargeNav secondStep];
    [paymentMainView setHidden:NO];
    [paymentSuccessView setHidden:YES];
}

- (void)successStep
{
    [[Config Instance]setIsPayUser:YES];
    [[Config Instance]setIsRefreshUserInfo:YES];
    [[Config Instance]setIsRefreshAccountPayList:YES];
    [_rechargeNav fourthStep];
    [paymentMainView setHidden:YES];
    [paymentSuccessView setHidden:NO];
}

//确认支付
- (void)confirmPayment:(id)sender
{
    NSMutableDictionary *requestParams = [[NSMutableDictionary alloc] init];
    [requestParams setObject:@"4" forKey:@"payuse"];
    [requestParams setObject:[_data objectForKey:@"recordno"] forKey:@"recprod"];
    [requestParams setObject:@"1" forKey:@"actflag"];
    [requestParams setObject:@"1" forKey:@"quantity"];
    //支付宝支付
    self.hRequest=[[HttpRequest alloc]init];
    [self.hRequest setDelegate:self];
    [self.hRequest setController:self];
    [self.hRequest setIsShowMessage:YES];
    [self.hRequest setRequestCode:ALIPAYREQUESTCODE];
    [self.hRequest loginhandle:@"v4alipayReq" requestParams:requestParams];
    [self paynmentingStep];
}

//返回我的账户
- (void)backMyAccount:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)requestFinishedByResponse:(Response *)response requestCode:(int)reqCode {
    //支付宝
    if(reqCode==ALIPAYREQUESTCODE) {
        if([response successFlag]) {
            [[Config Instance] setMPaymentViewController:self];
            NSString *orderString=[[[response mainData] objectForKey:@"alipayinfo"] objectForKey:@"reqcontent"];
            orderString=[orderString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"ANCUNYULU" callback:^(NSDictionary *resultDic) {
                NSString *resultStatus=[resultDic objectForKey:@"resultStatus"];
                if([@"9000" isEqualToString:resultStatus]){
                    [self successStep];
                }else{
                    NSString *memo=[resultDic objectForKey:@"memo"];
                    [Common alert:[NSString stringWithFormat:@"错误编号:%@ %@",resultStatus,memo]];
                }
            }];
        }
    }
}

@end