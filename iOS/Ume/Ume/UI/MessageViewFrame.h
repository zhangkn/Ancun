//
//  MessageViewFrame.h
//  Ume
//
//  Created by Start on 15/7/13.
//  Copyright (c) 2015年 Ancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewFrame : UIView

@property (strong,nonatomic)UIImageView *meHeader;
@property (strong,nonatomic)CLabel *lblName;
@property (strong,nonatomic)CLabel *lblTime;
@property (strong,nonatomic)CLabel *lblValue;
@property (strong,nonatomic)ImageViewGesture *ivImage;
@property (strong,nonatomic)PlayerVoiceButton *player;

@end
