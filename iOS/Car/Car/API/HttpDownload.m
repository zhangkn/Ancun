#import "HttpDownload.h"
#import "NSString+Utils.h"

@implementation HttpDownload{
    NSString* docDir;
    NSFileManager* fileManager;
    NSMutableDictionary *cacheData;
    NSOperationQueue *queue;
}

- (id)initWithDelegate:(NSObject<HttpDownloadDelegate>*)delegate
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
        [self setDelegate:delegate];
        cacheData=[[NSMutableDictionary alloc]initWithCapacity:10];
        
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 8;
    }
    return self;
}

- (void)AsynchronousDownloadWithUrl:(NSString *)url RequestCode:(NSInteger)reqCode Object:(id)sender
{
    if([url isEmpty]){
        return;
    }
    //生成唯一文件夹名
    NSString *fName=[NSString stringWithFormat:@"%@",[url md5]];
    NSString *path = [docDir stringByAppendingPathComponent:fName];
    if(![fileManager fileExistsAtPath:path]) {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            if (data) {
                //获取临时目录
                NSString *tmpDir=NSTemporaryDirectory();
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
            }
            if([self.delegate respondsToSelector:@selector(requestFinishedByRequestCode:Path:Object:)]){
                [self.delegate requestFinishedByRequestCode:reqCode Path:path Object:sender];
            }
        }];
        [queue addOperation:operation];
    } else {
        if([self.delegate respondsToSelector:@selector(requestFinishedByRequestCode:Path:Object:)]){
            [self.delegate requestFinishedByRequestCode:reqCode Path:path Object:sender];
        }
    }
}


//dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
//dispatch_async(queue, ^{
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        if (data) {
//            //获取临时目录
//            NSString *tmpDir=NSTemporaryDirectory();
//            //更改到待操作的临时目录
//            [fileManager changeCurrentDirectoryPath:[tmpDir stringByExpandingTildeInPath]];
//            NSString *tmpPath = [tmpDir stringByAppendingPathComponent:fName];
//            //创建数据缓冲区
//            NSMutableData* writer = [[NSMutableData alloc] init];
//            //将字符串添加到缓冲中
//            [writer appendData: data];
//            //将其他数据添加到缓冲中
//            //将缓冲的数据写入到临时文件中
//            [writer writeToFile:tmpPath atomically:YES];
//            //把临时下载好的文件移动到主文档目录下
//            [fileManager moveItemAtPath:tmpPath toPath:path error:nil];
//        }
//        if([self.delegate respondsToSelector:@selector(requestFinishedByRequestCode:Path:Object:)]){
//            [self.delegate requestFinishedByRequestCode:reqCode Path:path Object:sender];
//        }
//    });
//});


@end