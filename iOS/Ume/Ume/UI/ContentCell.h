//
//  ContentCell.h
//  Ume
//
//  Created by Start on 5/20/15.
//  Copyright (c) 2015 Ancun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLabel.h"
@interface ContentCell : UITableViewCell

@property (strong,nonatomic)UIImageView *meHeader;
@property (strong,nonatomic)UIImageView *mFelationship;
@property (strong,nonatomic)UIImageView *youHeader;
@property (strong,nonatomic)UIImageView *mBackground;
@property (strong,nonatomic)UIButton *bPlayer;
@property (strong,nonatomic)CLabel *lblName;
@property (strong,nonatomic)CLabel *lblTime;
@property (strong,nonatomic)CLabel *lblContent;
@property (strong,nonatomic)UIButton *bShare;
@property (strong,nonatomic)UIButton *bDM;
@property (strong,nonatomic)UIButton *bPrivateLetter;

@property (strong,nonatomic)NSDictionary *data;

@end
