//
//  AccidentViewController.m
//  Car
//
//  Created by Start on 10/13/15.
//  Copyright © 2015 Ancun. All rights reserved.
//

#import "AccidentViewController.h"
#import "InputAddressViewController.h"
#import "InsuranceCompanyViewController.h"
#import "TimeUtils.h"

@interface AccidentViewController ()

@end

@implementation AccidentViewController{
    UIButton *bLocation;
    UIImageView *mark;
    CLLocation *location;
    BMKGeoCodeSearch *geoCodeSearch;
    NSString *address;
    NSString *time;
    XLLabel *lblTime;
    XLLabel *lblAddress;
}

- (id)init
{
    self=[super init];
    if(self){
        [self setTitle:@"事故处理"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //地图视图
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, CGWidth(320), self.view.bounds.size.height-64-CGHeight(105))];
    [self.mapView setZoomLevel:20];
    [self.mapView setShowMapPoi:YES];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setMapType:BMKMapTypeStandard];
    [self.mapView setUserTrackingMode:BMKUserTrackingModeFollow];
    [self.view addSubview: self.mapView];
    //当前位置
    mark=[[UIImageView alloc]initWithFrame:CGRectMake1(0, 0, 23, 23)];
    [mark setCenter:CGPointMake(self.mapView.bounds.size.width/2, self.mapView.bounds.size.height/2-mark.bounds.size.height/2)];
    [mark setImage:[UIImage imageNamed:@"mark_d"]];
    [self.mapView addSubview:mark];
    bLocation=[[UIButton alloc]initWithFrame:CGRectMake(self.mapView.bounds.size.width-CGWidth(20+10), self.mapView.bounds.size.height-CGHeight(20+10), CGWidth(20), CGHeight(20))];
    bLocation.layer.masksToBounds=YES;
    bLocation.layer.cornerRadius=CGWidth(1);
    bLocation.layer.borderWidth=CGWidth(1);
    bLocation.layer.borderColor=BCOLOR(224).CGColor;
    [bLocation setBackgroundColor:[UIColor whiteColor]];
    [bLocation setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
    [bLocation addTarget:self action:@selector(goLocaltion) forControlEvents:UIControlEventTouchUpInside];
    [bLocation setHidden:YES];
    [self.mapView addSubview:bLocation];
    
    UIView *moreView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-CGHeight(105)-64, CGWidth(320), CGHeight(105))];
    [moreView setBackgroundColor:BCOLOR(244)];
    [self.view addSubview:moreView];
    UIView *infoView=[[UIView alloc]initWithFrame:CGRectMake1(0, 0, 320, 60)];
    [infoView setBackgroundColor:[UIColor whiteColor]];
    [moreView addSubview:infoView];
    
    UIImageView *addIcon=[[UIImageView alloc]initWithFrame:CGRectMake1(6, 3, 23, 23)];
    [addIcon setImage:[UIImage imageNamed:@"mark_a"]];
    [infoView addSubview:addIcon];
        lblAddress=[[XLLabel alloc]initWithFrame:CGRectMake1(35, 0, 275, 30)];
    [lblAddress setBackgroundColor:[UIColor clearColor]];
    [lblAddress setUserInteractionEnabled:YES];
    [lblAddress addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goInputAddress)]];
    [infoView addSubview:lblAddress];
    UIImageView *timeIcon=[[UIImageView alloc]initWithFrame:CGRectMake1(6, 33, 23, 23)];
    [timeIcon setImage:[UIImage imageNamed:@"time"]];
    [infoView addSubview:timeIcon];
    time=[TimeUtils getTimeFormatter:FORMAT_yyyyMMddHHmmss];
    lblTime=[[XLLabel alloc]initWithFrame:CGRectMake1(35, 30, 275, 30)];
    [lblTime setText:[NSString stringWithFormat:@"%@",time]];
    [lblTime setBackgroundColor:[UIColor clearColor]];
    [infoView addSubview:lblTime];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake1(0, 30, 320, 1)];
    [line setBackgroundColor:BCOLOR(244)];
    [infoView addSubview:line];
    XLButton *bSingle=[[XLButton alloc]initWithFrame:CGRectMake1(10, 65, 140, 35) Name:@"单车事故" Type:4];
    [bSingle addTarget:self action:@selector(goHandleSingle) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:bSingle];
    XLButton *bDouble=[[XLButton alloc]initWithFrame:CGRectMake1(170, 65, 140, 35) Name:@"两车事故" Type:5];
    [bDouble addTarget:self action:@selector(goHandleMore) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:bDouble];
    geoCodeSearch=[[BMKGeoCodeSearch alloc]init];
    self.locService = [[BMKLocationService alloc]init];
    [self.locService setDelegate:self];
    //启动LocationService
    [self.locService startUserLocationService];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    [self.mapView setDelegate:self];
    [geoCodeSearch setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    [self.mapView setDelegate:nil];
    [geoCodeSearch setDelegate:nil];
}

- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    [mark setImage:[UIImage imageNamed:@"mark_a"]];
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [mark setImage:[UIImage imageNamed:@"mark_d"]];
    //反地理编码出地理位置
    if([self reverseGeoCodeLat:mapView.centerCoordinate.latitude Lng:mapView.centerCoordinate.longitude]){
//        self.mapView.showsUserLocation=NO;
    }
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
//    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [self didUpdateBMKUserLocation:userLocation];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    location=userLocation.location;
    //反地理编码出地理位置
    if([self reverseGeoCodeLat:location.coordinate.latitude Lng:location.coordinate.longitude]){
        [bLocation setHidden:NO];
        [self.locService stopUserLocationService];
    }
    //将定位的点居中显示
    BMKCoordinateRegion region;
    region.center.latitude=location.coordinate.latitude;
    region.center.longitude=location.coordinate.longitude;
    [self.mapView setRegion:region animated:YES];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
//    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
//    NSLog(@"location error");
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if([result.poiList count]>0){
        self.poiList=result.poiList;
        for(int i=0;i<result.poiList.count;i++){
            BMKPoiInfo *info=[result.poiList objectAtIndex:i];
            address=[BaiduMapUtils getAddress:info];
            if(![@"" isEqualToString:address]){
                break;
            }
        }
    }
    if([@""isEqualToString:address]){
        address=result.address;
    }
    [lblAddress setText:[NSString stringWithFormat:@"%@",address]];
}

- (BOOL)reverseGeoCodeLat:(CLLocationDegrees)latitude Lng:(CLLocationDegrees)longitude
{
    //反地理编码出地理位置
    CLLocationCoordinate2D pt=(CLLocationCoordinate2D){0,0};
    pt=(CLLocationCoordinate2D){latitude,longitude};
    BMKReverseGeoCodeOption *option=[[BMKReverseGeoCodeOption alloc]init];
    [option setReverseGeoPoint:pt];
    return [geoCodeSearch reverseGeoCode:option];
}

- (void)goHandleSingle
{
    InsuranceCompanyViewController *mInsuranceCompanyViewController=[[InsuranceCompanyViewController alloc]initWithType:1];
    [mInsuranceCompanyViewController setMapData:@{
                                                  KEYLATITUDE:[NSString stringWithFormat:@"%lf",location.coordinate.latitude],
                                                  KEYLONGITUDE:[NSString stringWithFormat:@"%lf",location.coordinate.longitude],
                                                  KEYADDRESSNAME:address,
                                                  KEYTIME:time
                                                  }];
    [self.navigationController pushViewController:mInsuranceCompanyViewController animated:YES];
}

- (void)goHandleMore
{
    InsuranceCompanyViewController *mInsuranceCompanyViewController=[[InsuranceCompanyViewController alloc]initWithType:2];
    [mInsuranceCompanyViewController setMapData:@{
                                                  KEYLATITUDE:[NSString stringWithFormat:@"%lf",location.coordinate.latitude],
                                                  KEYLONGITUDE:[NSString stringWithFormat:@"%lf",location.coordinate.longitude],
                                                  KEYADDRESSNAME:address,
                                                  KEYTIME:time
                                                  }];
    [self.navigationController pushViewController:mInsuranceCompanyViewController animated:YES];
}

- (void)goInputAddress
{
    InputAddressViewController *mInputAddressViewController=[[InputAddressViewController alloc]init];
    [mInputAddressViewController setRDelegate:self];
    [mInputAddressViewController setDataItemArray:[[NSMutableArray alloc]initWithArray:self.poiList]];
    [self.navigationController pushViewController:mInputAddressViewController animated:YES];
}

- (void)onControllerResult:(NSInteger)resultCode requestCode:(NSInteger)requestCode data:(NSMutableDictionary*)result
{
    //获取地址
    address=[result objectForKey:@"address"];
    [lblAddress setText:[NSString stringWithFormat:@"%@",address]];
}

- (void)goLocaltion
{
    [bLocation setHidden:YES];
    //启动LocationService
    [self.locService startUserLocationService];
}

@end