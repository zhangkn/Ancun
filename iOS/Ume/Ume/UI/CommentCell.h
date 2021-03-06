//
//  CommentCell.h
//  Ume
//
//  Created by Start on 15/7/10.
//  Copyright (c) 2015年 Ancun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLabel.h"
#import "PlayerVoiceButton.h"
#import "MessageViewFrame.h"

@interface CommentCell : UITableViewCell

@property (strong,nonatomic)UIImageView *meHeader;
@property (strong,nonatomic)CLabel *lblName;
@property (strong,nonatomic)CLabel *lblTime;
@property (strong,nonatomic)CLabel *lblValue;
@property (strong,nonatomic)UIButton *lblPCount;
@property (strong,nonatomic)UIButton *lblZCount;
@property (strong,nonatomic)UIImageView *ivImage;

@property (strong,nonatomic)PlayerVoiceButton *player;

@property (strong,nonatomic)MessageViewFrame *mMessageViewFrame;

@property (strong,nonatomic)UIViewController *currentViewController;


@end
