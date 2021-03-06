//
//  UYourDetailViewController.m
//  Ume
//  懂你详细页
//  Created by Start on 15/6/9.
//  Copyright (c) 2015年 Ancun. All rights reserved.
//

#import "UYourDetailViewController.h"
#import "WordsDetailViewController.h"
#import "ContactViewController.h"
#import "ReplyMDCell.h"
#import "RecordingPlayerView.h"
#import "SelectedImageView.h"
#import "AtUserView.h"

@interface UYourDetailViewController ()<ContactDelegate>

@end

@implementation UYourDetailViewController{
    UIButton *currentPlayerButton;
    UIView *wordViewFrame;
    
    UIButton *bSendVoice,*bSendImage,*bAtUser;
    AtUserView *mAtUserView;
    SelectedImageView *mSelectedImageView;
    RecordingPlayerView *mRecordingPlayerView;
    
    UIView *bgFrame;
}

- (id)initWithData:(NSDictionary*)data
{
    self=[super init];
    if(self){
        self.data=data;
        [self cTitle:@"懂你详情"];
        self.isFirstRefresh=YES;
        UIView *headContent=[[UIView alloc]initWithFrame:CGRectMake1(0, 0, 320, 300)];
        [self.view addSubview:headContent];
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake1(0, 0, 320, 200)];
        image.layer.masksToBounds=YES;
        [image setContentMode:UIViewContentModeScaleAspectFill];
        [image setBackgroundColor:DEFAULTITLECOLOR(221)];
        [image setUserInteractionEnabled:YES];
        [headContent addSubview:image];
        //关闭
        UIButton *bClose = [[UIButton alloc]init];
        [bClose setFrame:CGRectMake1(5, 20, 30, 30)];
        [bClose setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
        [bClose setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateHighlighted];
        [bClose addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        [image addSubview:bClose];
        //分享
        UIButton *bShare = [[UIButton alloc]init];
        [bShare setFrame:CGRectMake1(285, 20, 30, 30)];
        [bShare setImage:[UIImage imageNamed:@"icon-top-share"] forState:UIControlStateNormal];
        [bShare addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        [image addSubview:bShare];
        //播放
        self.bPlayer=[[PlayerButton alloc]initWithFrame:CGRectMake1(140, 60, 40, 40)];
        [self.bPlayer addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
        [image addSubview:self.bPlayer];
        //内容
        self.lblContent=[[CLabel alloc]initWithFrame:CGRectMake1(10, 130, 300, 40)];
        [self.lblContent setFont:[UIFont systemFontOfSize:15]];
        [self.lblContent setTextColor:[UIColor whiteColor]];
        [self.lblContent setNumberOfLines:2];
        [self.lblContent setUserInteractionEnabled:YES];
        [self.lblContent addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goWordsDetail:)]];
        [image addSubview:self.lblContent];
        
        UIView *contentView=[[UIView alloc]initWithFrame:CGRectMake1(0, 200, 320, 60)];
        [headContent addSubview:contentView];
        UIView *topView=[[UIView alloc]initWithFrame:CGRectMake1(0, 0, 320, 60)];
        topView.layer.borderWidth=1;
        topView.layer.borderColor=DEFAULTITLECOLOR(221).CGColor;
        [contentView addSubview:topView];
        self.meHeader=[[ImageViewHeader alloc]initWithFrame:CGRectMake1(10, 10, 40, 40)];
        [topView addSubview:self.meHeader];
        self.lblName=[[CLabel alloc]initWithFrame:CGRectMake1(60, 10, 90, 20) Text:@""];
        [self.lblName setFont:[UIFont systemFontOfSize:18]];
        [self.lblName setTextColor:DEFAULTITLECOLORRGB(242, 82, 159)];
        [topView addSubview:self.lblName];
        self.lblTime=[[CLabel alloc]initWithFrame:CGRectMake1(60, 30, 40, 20) Text:@""];
        [self.lblTime setFont:[UIFont systemFontOfSize:14]];
        [self.lblTime setTextColor:DEFAULTITLECOLOR(150)];
        [topView addSubview:self.lblTime];
        self.lblValue=[[CLabel alloc]initWithFrame:CGRectMake1(100, 30, 60, 20) Text:@""];
        [self.lblValue setFont:[UIFont systemFontOfSize:14]];
        [self.lblValue setTextColor:DEFAULTITLECOLOR(150)];
        [topView addSubview:self.lblValue];
        self.mFelationship=[[UIImageView alloc]initWithFrame:CGRectMake1(160, 10, 90, 40)];
        [self.mFelationship setImage:[UIImage imageNamed:@"icon-match"]];
        [topView addSubview:self.mFelationship];
        self.youHeader=[[ImageViewHeader alloc]initWithFrame:CGRectMake1(270, 10, 40, 40)];
        [topView addSubview:self.youHeader];
        UIView *titleHead=[[UIView alloc]initWithFrame:CGRectMake1(0, 60, 320, 40)];
        [titleHead setBackgroundColor:DEFAULTITLECOLOR(245)];
        [topView addSubview:titleHead];
        //总数
        self.lblCount=[[CLabel alloc]initWithFrame:CGRectMake1(10, 0, 150, 40) Text:@""];
        [self.lblCount setFont:[UIFont systemFontOfSize:14]];
        [self.lblCount setTextColor:DEFAULTITLECOLOR(100)];
        [titleHead addSubview:self.lblCount];
        
        wordViewFrame=[[UIView alloc]initWithFrame:self.view.bounds];
        [wordViewFrame setBackgroundColor:DEFAULTITLECOLOR(200)];
        [wordViewFrame setUserInteractionEnabled:YES];
        [wordViewFrame setHidden:YES];
        [self.view addSubview:wordViewFrame];
        //关闭
        bClose = [[UIButton alloc]init];
        [bClose setFrame:CGRectMake1(5, 20, 30, 30)];
        [bClose setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
        [bClose setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateHighlighted];
        [bClose addTarget:self action:@selector(goWordsDetail:) forControlEvents:UIControlEventTouchUpInside];
        [wordViewFrame addSubview:bClose];
        //分享
        bShare = [[UIButton alloc]init];
        [bShare setFrame:CGRectMake1(285, 20, 30, 30)];
        [bShare setImage:[UIImage imageNamed:@"icon-top-share"] forState:UIControlStateNormal];
        [bShare addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        [wordViewFrame addSubview:bShare];
        //播放
        self.bBGPlayer=[[PlayerButton alloc]initWithFrame:CGRectMake1(140, 60, 40, 40)];
        [self.bBGPlayer addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
        [wordViewFrame addSubview:self.bBGPlayer];
        //内容
        self.lblBGContent=[[CLabel alloc]initWithFrame:CGRectMake1(10, 130, 300, 100)];
        [self.lblBGContent setFont:[UIFont systemFontOfSize:15]];
        [self.lblBGContent setTextColor:[UIColor whiteColor]];
        [self.lblBGContent setNumberOfLines:0];
        [self.lblBGContent setUserInteractionEnabled:YES];
        [self.lblBGContent addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goWordsDetail:)]];
        [wordViewFrame addSubview:self.lblBGContent];
        //底部
        CGFloat height=40;
        UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-CGHeight(height), CGWidth(320), CGHeight(height))];
        [bottomView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:bottomView];
        //私信
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake1(0, 0, 159, height)];
        [button setTitle:@"私信" forState:UIControlStateNormal];
        [button setTitleColor:DEFAULTITLECOLOR(50) forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon-sx-black"] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, CGWidth(-10), 0, 0)];
        [button setBackgroundColor:COLOR2552160];
        [bottomView addSubview:button];
        //你最懂我
        button=[[UIButton alloc]initWithFrame:CGRectMake1(160, 0, 160, height)];
        [button setTitle:@"你最懂我" forState:UIControlStateNormal];
        [button setTitleColor:DEFAULTITLECOLOR(50) forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon-dw-black"] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, CGWidth(-10), 0, 0)];
        [button setBackgroundColor:COLOR2552160];
        [button addTarget:self action:@selector(goDW:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:button];
        [self.tableView setTableHeaderView:headContent];
        
        self.hDownload=[[HttpDownload alloc]initWithDelegate:self];
        //背景
        NSString *backgroupUrl=[data objectForKey:@"backgroupUrl"];
        [self.hDownload AsynchronousDownloadWithUrl:backgroupUrl RequestCode:500 Object:image];
        //内容
        NSString *content=[data objectForKey:@"content"];
        [self.lblContent setText:content];
        [self.lblContent sizeToFit];
        [self.lblBGContent setText:content];
        [self.lblBGContent sizeToFit];
//        [self.meHeader setImage:[UIImage imageNamed:@"img_boy"]];
        [self.lblName setText:@"Jackywell"];
        [self.lblTime setText:@"15:22"];
        [self.lblValue setText:@"开心70%"];
        [self.lblCount setText:@"所有懂你(12)"];
//        [self.youHeader setImage:[UIImage imageNamed:@"img_girl"]];
        
        height=220;
        //评论
        bgFrame=[[UIView alloc]initWithFrame:self.view.bounds];
        [bgFrame setBackgroundColor:DEFAULTITLECOLORA(100,0.5)];
        [bgFrame setUserInteractionEnabled:YES];
        [bgFrame addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgHidden:)]];
        [self.view addSubview:bgFrame];
        [bgFrame setHidden:YES];
        UIView *commentFrame=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-CGHeight(height), CGWidth(320), CGHeight(height))];
        [commentFrame setBackgroundColor:DEFAULTITLECOLOR(250)];
        [bgFrame addSubview:commentFrame];
        //
        bSendVoice=[[UIButton alloc]initWithFrame:CGRectMake1(0, 0, 60, 35)];
        [bSendVoice setTitle:@"发语音" forState:UIControlStateNormal];
        [bSendVoice setTitleColor:DEFAULTITLECOLOR(150) forState:UIControlStateNormal];
        [bSendVoice setTitleColor:COLOR2552160 forState:UIControlStateSelected];
        [bSendVoice setTag:1];
        [bSendVoice addTarget:self action:@selector(setSendFrame:) forControlEvents:UIControlEventTouchUpInside];
        [commentFrame addSubview:bSendVoice];
        //
        bSendImage=[[UIButton alloc]initWithFrame:CGRectMake1(60, 0, 60, 35)];
        [bSendImage setTitle:@"发图片" forState:UIControlStateNormal];
        [bSendImage setTitleColor:DEFAULTITLECOLOR(150) forState:UIControlStateNormal];
        [bSendImage setTitleColor:COLOR2552160 forState:UIControlStateSelected];
        [bSendImage setTag:2];
        [bSendImage addTarget:self action:@selector(setSendFrame:) forControlEvents:UIControlEventTouchUpInside];
        [commentFrame addSubview:bSendImage];
        //
        bAtUser=[[UIButton alloc]initWithFrame:CGRectMake1(120, 0, 60, 35)];
        [bAtUser setTitle:@"@某人" forState:UIControlStateNormal];
        [bAtUser setTitleColor:DEFAULTITLECOLOR(150) forState:UIControlStateNormal];
        [bAtUser setTitleColor:COLOR2552160 forState:UIControlStateSelected];
        [bAtUser setTag:3];
        [bAtUser addTarget:self action:@selector(setSendFrame:) forControlEvents:UIControlEventTouchUpInside];
        [commentFrame addSubview:bAtUser];
        
        CButton *bSubmit=[[CButton alloc]initWithFrame:CGRectMake1(260, 3, 50, 29) Name:@"提交" Type:2];
        [bSubmit.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [bSubmit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        [commentFrame addSubview:bSubmit];
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake1(10, 35, 300, 0.5)];
        [line setBackgroundColor:DEFAULTITLECOLOR(230)];
        [commentFrame addSubview:line];
        
        mRecordingPlayerView=[[RecordingPlayerView alloc]initWithFrame:CGRectMake1(75, 40, 170, 170)];
        [commentFrame addSubview:mRecordingPlayerView];
        
        mSelectedImageView=[[SelectedImageView alloc]initWithFrame:CGRectMake1(10, 40, 300, 170)];
        [mSelectedImageView setCurrentController:self];
        [commentFrame addSubview:mSelectedImageView];
        
        mAtUserView=[[AtUserView alloc]initWithFrame:CGRectMake1(10, 40, 300, 170)];
        [mAtUserView.mAddatUser addTarget:self action:@selector(goAddAtUser:) forControlEvents:UIControlEventTouchUpInside];
        [commentFrame addSubview:mAtUserView];
        
        //设置默认值
        [self setSendFrame:bSendVoice];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[self dataItemArray] count]>0){
        return CGHeight(130);
    }else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[self dataItemArray] count]>0){
        static NSString *cellIdentifier = @"SAMPLECell";
        ReplyMDCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell) {
            cell = [[ReplyMDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell setCurrentViewController:self];
        NSInteger row=[indexPath row];
        //        NSDictionary *data=[[self dataItemArray]objectAtIndex:[indexPath row]];
        //        [cell setData:data];
        //        [cell.meHeader setImage:[UIImage imageNamed:@"img_boy"]];
        //        [cell.youHeader setImage:[UIImage imageNamed:@"img_girl"]];
        //        [cell.lblName setText:@"Jackywell"];
        //        [cell.lblTime setText:@"15:22"];
        //        [cell.bDM setTitle:[NSString stringWithFormat:@"%@懂我",@"21"] forState:UIControlStateNormal];
        ////        NSString *backgroupUrl=[data objectForKey:@"backgroupUrl"];
        ////        [httpDownload AsynchronousDownloadImageWithUrl:backgroupUrl ShowImageView:cell.mBackground];
        //        NSString *content=[data objectForKey:@"content"];
        //        [cell.lblContent setText:content];
        //        [cell.lblContent sizeToFit];
        
        [cell.lblPCount addTarget:self action:@selector(goComment:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.player.tag=row;
        [cell.player addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)loadHttp
{
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:@"1" forKey:@"type"];//筛选1最新 2最热 3离我最近 4只看美女
    [params setObject:@"getPublish" forKey:@"act"];
    self.hRequest=[[HttpRequest alloc]init];
    [self.hRequest setRequestCode:500];
    [self.hRequest setDelegate:self];
    [self.hRequest setController:self];
    [self.hRequest handle:nil requestParams:params];
}

- (void)playAudio:(UIButton*)button
{
    if(currentPlayerButton){
        if(currentPlayerButton==button){
            [self stopAudioPlayer];
            [self stopPlayerAnimating];
            return;
        }else{
            [self stopPlayerAnimating];
        }
    }
    currentPlayerButton=button;
    if(self.bPlayer==button){
        button.tag=-1;
        [currentPlayerButton.imageView startAnimating];
        NSString *urlStr = [self.data objectForKey:@"recordUrl"];
        [self.hDownload AsynchronousDownloadWithUrl:urlStr RequestCode:501 Object:nil];
    }else{
        NSInteger currentPlayerRow = currentPlayerButton.tag;
        NSMutableDictionary *item = [self.dataItemArray objectAtIndex:currentPlayerRow];
        [item setObject:@"1" forKey:@"pstatus"];
        [currentPlayerButton.imageView startAnimating];
        NSString *urlStr = [item objectForKey:@"recordUrl"];
        [self.hDownload AsynchronousDownloadWithUrl:urlStr RequestCode:501 Object:nil];
    }
}

- (void)requestFinishedByRequestCode:(NSInteger)reqCode Path:(NSString*)path Object:(id)sender
{
    if(reqCode==501){
        //播放本地音乐
        [self stopAudioPlayer];
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
        [self.audioPlayer setDelegate:self];
        [self.audioPlayer setVolume:1.0];
        if([self.audioPlayer prepareToPlay]){
            [self.audioPlayer play];
        }
    }else if(reqCode==500){
        UIImageView *imageView=(UIImageView*)sender;
        if(imageView){
            UIImage *image=[[UIImage alloc] initWithContentsOfFile:path];
            if(image){
                [imageView setImage:image];
            }
        }
    }
}

//播放结束时执行的动作
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(currentPlayerButton){
        [self stopPlayerAnimating];
    }
    [self stopAudioPlayer];
}

- (void)stopAudioPlayer
{
    if(self.audioPlayer){
        [self.audioPlayer stop];
        self.audioPlayer=nil;
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
    }
}

- (void)stopPlayerAnimating
{
    NSInteger currentPlayerRow = currentPlayerButton.tag;
    if(currentPlayerRow!=-1){
        NSMutableDictionary *item = [self.dataItemArray objectAtIndex:currentPlayerRow];
        [item setObject:@"0" forKey:@"pstatus"];
    }
    [currentPlayerButton.imageView stopAnimating];
    currentPlayerButton=nil;
}

- (void)goDW:(id)sender
{
    [bgFrame setHidden:!bgFrame.isHidden];
}

- (void)bgHidden:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"您确定要放弃发布吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)setSendFrame:(UIButton*)sender
{
    NSInteger tag=sender.tag;
    [bSendVoice setSelected:tag==1?YES:NO];
    [bSendImage setSelected:tag==2?YES:NO];
    [bAtUser setSelected:tag==3?YES:NO];
    [mRecordingPlayerView setHidden:!bSendVoice.isSelected];
    [mSelectedImageView setHidden:!bSendImage.isSelected];
    [mAtUserView setHidden:!bAtUser.isSelected];
}

- (void)goAddAtUser:(id)sender
{
    ContactViewController *mContactViewController=[[ContactViewController alloc]init];
    [mContactViewController setDelegate:self];
    [self.navigationController pushViewController:mContactViewController animated:YES];
}

- (void)atContactFinisih:(NSArray*)friendsArray
{
    [mAtUserView setAtUserLayout:friendsArray];
}

- (void)goWordsDetail:(id)sender
{
//    WordsDetailViewController *mWordsDetailViewController=[[WordsDetailViewController alloc]initWithData:nil];
//    [self.navigationController pushViewController:mWordsDetailViewController animated:YES];
    [wordViewFrame setHidden:!wordViewFrame.isHidden];
}

- (void)goComment:(id)sender
{
    CommentViewController *mCommentViewController=[[CommentViewController alloc]initWithData:nil];
    [mCommentViewController setDelegate:self];
    [self.navigationController pushViewController:mCommentViewController animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //退出评论确定
    if(buttonIndex==1){
        [mRecordingPlayerView clear];
        [mSelectedImageView clear];
        [mAtUserView clear];
        [bgFrame setHidden:YES];
    }
}

- (void)CommentFinisih:(NSArray*)friendsArray
{
    //重置评论信息并显示
    [bgFrame setHidden:NO];
}

- (void)submit:(id)sender
{
    NSLog(@"文件:%@",mRecordingPlayerView.docRecordedFilePath);
    NSLog(@"图片:%@",mSelectedImageView.showImageView.image);
}

@end