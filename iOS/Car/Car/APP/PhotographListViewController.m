//
//  PhotographListViewController.m
//  Car
//
//  Created by Start on 10/20/15.
//  Copyright © 2015 Ancun. All rights reserved.
//

#import "PhotographListViewController.h"
#import "PhotographDetailViewController.h"
#import "VideoCell.h"

@interface PhotographListViewController ()

@end

@implementation PhotographListViewController

- (id)init
{
    self=[super init];
    if(self){
        [self setTitle:@"随手拍"];
        self.hDownload=[[HttpDownload alloc]initWithDelegate:self];
    }
    return self;
}

- (void)loadHttp
{
    self.hRequest=[[HttpRequest alloc]initWithRequestCode:501];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:@"getSecurityList" forKey:@"act"];
    [params setObject:[User getInstance].uid forKey:@"uid"];
    [params setObject:@"1" forKey:@"type"];
    [params setObject:[NSString stringWithFormat:@"%ld",self.currentPage] forKey:@"page"];
    [self.hRequest setDelegate:self];
    [self.hRequest setIsShowFailedMessage:YES];
    [self.hRequest handleWithParams:params];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[self dataItemArray] count]>0){
        static NSString *cellIdentifier = @"SAMPLECell";
        VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell) {
            cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        NSDictionary *data=[self.dataItemArray objectAtIndex:[indexPath row]];
        NSString *url=[data objectForKey:@"attchUrl"];
        [self.hDownload AsynchronousDownloadWithUrl:url RequestCode:500 Object:cell.ivIcon];
        [cell.lblName setText:[data objectForKey:@"localName"]];
        [cell.lblSize setText:[data objectForKey:@"fileSize"]];
        [cell.lblTime setText:[data objectForKey:@"addTime"]];
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[self dataItemArray] count]>0){
        NSDictionary *data=[self.dataItemArray objectAtIndex:[indexPath row]];
        [self.navigationController pushViewController:[[PhotographDetailViewController alloc]initWithData:data] animated:YES];
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"删除了");
}

@end