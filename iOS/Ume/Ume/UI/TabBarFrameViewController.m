#import "TabBarFrameViewController.h"
#import "MainViewController.h"
#import "MessageViewController.h"
#import "PublishedSpeechSoundViewController.h"
#import "DiscoverViewController.h"
#import "MyViewController.h"
#import "CButton.h"

#define HTTP_REQUESTCODE_DOWNIMAGE 500
#define DEFAULTDATA_LASTVERSIONNO @"DEFAULTDATA_LASTVERSIONNO"

@interface TabBarFrameViewController ()

@end

@implementation TabBarFrameViewController{
    UIView *noLoginView;
    BOOL isFirstAddView;
    MainViewController *mMainViewController;
}

- (id)init
{
    self=[super init];
    if(self){
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mMainViewController=[[MainViewController alloc]init];
    self.viewControllers = [NSArray arrayWithObjects:
                            [self viewControllerWithTabTitle:@"懂你" image:@"icon-nav-heart" ViewController:mMainViewController],
                            [self viewControllerWithTabTitle:@"消息" image:@"icon-nav-message" ViewController:[[MessageViewController alloc]init]],
                            [self viewControllerWithTabTitle:@"" image:nil ViewController:[[PublishedSpeechSoundViewController alloc]init]],
                            [self viewControllerWithTabTitle:@"发现" image:@"icon-nav-search" ViewController:[[DiscoverViewController alloc]init]],
                            [self viewControllerWithTabTitle:@"我的" image:@"icon-nav-me" ViewController:[[MyViewController alloc]init]], nil];
    [self addCenterButtonWithImage:[UIImage imageNamed:@"icon-nav-share"] highlightImage:[UIImage imageNamed:@"icon-nav-share"]];
    
    noLoginView=[[UIView alloc]initWithFrame:CGRectMake1(0, HEIGHT-66, 320, 66)];
    [noLoginView setBackgroundColor:DEFAULTITLECOLOR(50)];
//    [self.view addSubview:noLoginView];
    CButton *cLogin=[[CButton alloc]initWithFrame:CGRectMake1(10, 13, 300, 40) Name:@"登录懂我，发现不一样的自己" Type:2];
    [cLogin addTarget:self action:@selector(goLogin:) forControlEvents:UIControlEventTouchUpInside];
    [noLoginView addSubview:cLogin];
    
    //获取最后保存的版本号不存在则为0
    float lastVersionNo=[[Common getCache:DEFAULTDATA_LASTVERSIONNO] floatValue];
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    //获取当前使用的版本号
    NSString *currentVersionNo=[infoDict objectForKey:@"CFBundleShortVersionString"];
    if([currentVersionNo floatValue]>lastVersionNo){
        [self showIntroWithCrossDissolve];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [noLoginView setHidden:[[User Instance]isLogin]];
}

- (void)showIntroWithCrossDissolve
{
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"guide1"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"guide2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"guide3"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)introDidFinish
{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersionNo=[infoDict objectForKey:@"CFBundleShortVersionString"];
    [Common setCache:DEFAULTDATA_LASTVERSIONNO data:currentVersionNo];
}

- (UINavigationController*)viewControllerWithTabTitle:(NSString*) title image:(NSString*)image ViewController:(UIViewController*)viewController
{
    UINavigationController *frameViewControllerNav=[[UINavigationController alloc]initWithRootViewController:viewController];
//    [[frameViewControllerNav navigationBar]setBarTintColor:NAVBG];
//    [[frameViewControllerNav navigationBar]setBarStyle:UIBarStyleBlackTranslucent];
    UITabBarItem *tabBarItem=[[UITabBarItem alloc]init];
    [tabBarItem setTitle:title];
    if(image){
        [tabBarItem setImage:[UIImage imageNamed:image]];
        [tabBarItem setSelectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@2",image]]];
    }
    frameViewControllerNav.tabBarItem = tabBarItem;
    return frameViewControllerNav;
}

- (void)addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setFrame:CGRectMake1(0, 0, 56, 56)];
    button.layer.cornerRadius=button.bounds.size.width/2;
    button.layer.masksToBounds=YES;
    [button setBackgroundColor:COLOR2552160];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0){
        button.center = self.tabBar.center;
    } else {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    [button addTarget:self action:@selector(published:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

//下载图片
- (void)downLoadPicture
{
//    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
//    [params setObject:@"2" forKey:@"type"];
//    [params setObject:[NSString stringWithFormat:@"%d",TOPIMAGENUM] forKey:@"num"];
//    self.hRequest=[[HttpRequest alloc]init];
//    [self.hRequest setRequestCode:HTTP_REQUESTCODE_DOWNIMAGE];
//    [self.hRequest setDelegate:self];
//    [self.hRequest setController:self];
//    [self.hRequest handle:URL_news requestParams:params];
}

- (void)requestFinishedByResponse:(Response*)response responseCode:(int)repCode
{
    if(repCode==HTTP_REQUESTCODE_DOWNIMAGE){
    }
}

- (void)goLogin:(id)sender
{
    LoginViewController *mLoginViewController=[[LoginViewController alloc]init];
    [mLoginViewController setDelegate:self];
    UINavigationController *frameViewControllerNav=[[UINavigationController alloc]initWithRootViewController:mLoginViewController];
    [self presentViewController:frameViewControllerNav animated:YES completion:nil];
}

- (void)published:(id)sender
{
    UINavigationController *frameViewControllerNav=[[UINavigationController alloc]initWithRootViewController:[[PublishedSpeechSoundViewController alloc]init]];
    [self presentViewController:frameViewControllerNav animated:YES completion:nil];
}

- (void)handleLogin:(NSDictionary*)data
{
    BOOL flag=[[User Instance]isLogin];
    [noLoginView setHidden:!flag];
    if(flag){
        //已经登陆刷新主界面
        mMainViewController.tableView.pullTableIsRefreshing=YES;
        [mMainViewController performSelector:@selector(refreshTable) withObject:nil afterDelay:1.0f];
    }
}

- (void)logout
{
    [[User Instance]clear];
    [noLoginView setHidden:NO];
}

@end