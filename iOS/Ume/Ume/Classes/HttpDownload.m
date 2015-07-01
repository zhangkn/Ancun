//
//  HttpDownload.m
//  Ume
//
//  Created by Start on 15/7/1.
//  Copyright (c) 2015年 Ancun. All rights reserved.
//

#import "HttpDownload.h"
#import "NSString+Utils.h"

@implementation HttpDownload{
    NSFileManager* fileManager;
    NSString* docDir;
}


- (id)init
{
    self=[super init];
    if(self){
        //创建文件管理器
        fileManager = [NSFileManager defaultManager];
        //获取Documents主目录
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        //得到相应的Documents的路径
        docDir = [paths objectAtIndex:0];
        //更改到待操作的目录下
        [fileManager changeCurrentDirectoryPath:[docDir stringByExpandingTildeInPath]];
    }
    return self;
}

- (void)AsynchronousDownloadImageWithUrl:(NSString *)u ShowImageView:(UIImageView*)showImage
{
    //生成唯一文件夹名
    NSString *fName=[u md5];
    NSString *path = [docDir stringByAppendingPathComponent:fName];
    if(![fileManager fileExistsAtPath:path]){
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:u]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (data) {
                    //获取临时目录
                    NSString* tmpDir=NSTemporaryDirectory();
                    //更改到待操作的临时目录
                    [fileManager changeCurrentDirectoryPath:[tmpDir stringByExpandingTildeInPath]];
                    NSString *tmpPath = [tmpDir stringByAppendingPathComponent:fName];
                    //创建数据缓冲区
                    NSMutableData* writer = [[NSMutableData alloc] init];
                    //将字符串添加到缓冲中
                    [writer appendData: data];
                    //将其他数据添加到缓冲中
                    //将缓冲的数据写入到临时文件中
                    [writer writeToFile:tmpPath atomically:YES];
                    //把临时下载好的文件移动到主文档目录下
                    [fileManager moveItemAtPath:tmpPath toPath:path error:nil];
                    if(showImage){
                        [showImage setImage:[[UIImage alloc] initWithContentsOfFile:path]];
                    }
                }
            });
            
        });
        
    }else{
        if(showImage){
            [showImage setImage:[[UIImage alloc] initWithContentsOfFile:path]];
        }
    }
}

@end