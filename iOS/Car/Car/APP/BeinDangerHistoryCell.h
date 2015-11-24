//
//  BeinDangerHistoryCell.h
//  Car
//
//  Created by Start on 11/3/15.
//  Copyright © 2015 Ancun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpDownload.h"

@interface BeinDangerHistoryCell : UITableViewCell<HttpDownloadDelegate>

@property (strong,nonatomic)UIScrollView *scrollView;
@property (strong,nonatomic)XLLabel *lblTime;
@property (strong,nonatomic)XLLabel *lblStatus;
@property (strong,nonatomic)XLLabel *lblAddress;
@property (strong,nonatomic)HttpDownload *hDownload;

- (void)addSubImage:(NSString*)imageNamed;

@end
