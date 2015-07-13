//
//  CommentViewController.h
//  Ume
//
//  Created by Start on 15/7/10.
//  Copyright (c) 2015年 Ancun. All rights reserved.
//

#import "BaseEGOTableViewPullRefreshViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HttpDownload.h"
#import "CLabel.h"
#import "PlayerButton.h"
#import "CLabel.h"
#import "PlayerVoiceButton.h"

@interface CommentViewController : BaseEGOTableViewPullRefreshViewController<AVAudioPlayerDelegate,HttpDownloadDelegate>

@property (strong,nonatomic)UIImageView *meHeader;
@property (strong,nonatomic)CLabel *lblName;
@property (strong,nonatomic)CLabel *lblTime;
@property (strong,nonatomic)CLabel *lblValue;

@property (strong,nonatomic)PlayerButton *bPlayer;
@property (strong,nonatomic)PlayerVoiceButton *player;

@property (strong,nonatomic)AVAudioPlayer *audioPlayer;
@property (strong,nonatomic)HttpDownload *httpDownload;

@end
