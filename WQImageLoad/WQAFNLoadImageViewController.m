//
//  WQAFNLoadImageViewController.m
//  WQImageLoad
//
//  Created by chenweiqiang on 2018/8/23.
//  Copyright © 2018年 chenweiqiang. All rights reserved.
//

#import "WQAFNLoadImageViewController.h"
#import "WQAFNManager.h"

@interface WQAFNLoadImageViewController ()

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) dispatch_semaphore_t sema;

@end

@implementation WQAFNLoadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清缓存" style:UIBarButtonItemStylePlain target:self action:@selector(clearMemory)];
    
    [self test15];
//    [self test2];
    
    // Do any additional setup after loading the view.
}
- (void)test1
{
    NSString *documentsPath =[self getDocumentPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * folderDirectory = [documentsPath stringByAppendingPathComponent:@"image"];
    BOOL res = [fileManager createDirectoryAtPath:folderDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (res) {
        NSString *fileDirectory = [folderDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",0]];
        if ([fileManager fileExistsAtPath:fileDirectory]) {
            NSLog(@"%d==已存在",0);
        }else
        {
            //self.sema = dispatch_semaphore_create(0);
            NSString *str = @"http://m6.pc6.com/xuh6/sogou5207056.zip";
            [WQAFNManager downloadFileWithURLString:str cachePath:fileDirectory progress:^(NSProgress *progress) {
                NSLog(@"进度%f",progress);
            } success:^(NSURLSessionDownloadTask *task, id responseObject) {
                NSLog(@"%d==下载完成",0);
            } failure:^(NSURLSessionDownloadTask *task, NSError *error) {
                NSLog(@"%d==下载失败",0);
            }];
//            [WQAFNManager downloadFileBackgroundWithURLString:str cachePath:fileDirectory progress:^(CGFloat progress) {
//
//                NSLog(@"进度%f",progress);
//
//            } success:^(AFURLSessionManager *task, id responseObject) {
//
//                NSLog(@"%d==下载完成",0);
//                //dispatch_semaphore_signal(self.sema);
//
//            } failure:^(AFURLSessionManager *task, NSError *error) {
//
//                NSLog(@"%d==下载失败",0);
//
//            }];
            //dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
        }

    }

}

- (void)test2
{
    NSString *documentsPath =[self getDocumentPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * folderDirectory = [documentsPath stringByAppendingPathComponent:@"image"];
    BOOL res = [fileManager createDirectoryAtPath:folderDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (res) {
        NSString *fileDirectory = [folderDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",0]];
        if ([fileManager fileExistsAtPath:fileDirectory]) {
            NSLog(@"%d==已存在",0);
        }else
        {
            //self.sema = dispatch_semaphore_create(0);
            NSString *str = @"http://m6.pc6.com/xuh6/sogou5207056.zip";
            [WQAFNManager downloadFileWithURLString:str cachePath:fileDirectory progress:^(NSProgress *progress) {
                
                NSLog(@"进度%f",progress.completedUnitCount* 1.0/progress.totalUnitCount);
                
            } success:^(NSURLSessionDownloadTask *task, id responseObject) {
                
                NSLog(@"%d==下载完成",0);
                //dispatch_semaphore_signal(self.sema);
                
            } failure:^(NSURLSessionDownloadTask *task, NSError *error) {
                
                NSLog(@"%d==下载失败",0);
                
            }];
            //dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
        }

    }
    NSLog(@"方法执行完");
}
#pragma mark ---- 按顺序下载图片 ------
- (void)test15
{
    NSString *documentsPath =[self getDocumentPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * folderDirectory = [documentsPath stringByAppendingPathComponent:@"image"];
    BOOL res = [fileManager createDirectoryAtPath:folderDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (res) {
        
        //dispatch_queue_t workConcurrentQueue = dispatch_queue_create("cccccccc", DISPATCH_QUEUE_CONCURRENT);
        dispatch_queue_t serialQueue = dispatch_queue_create("WQAFNLoadImageViewController_loadImage",DISPATCH_QUEUE_SERIAL);
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        
        for (int i = 0; i <self.dataArray.count; i++) {
            NSString *fileDirectory = [folderDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",i]];
            if ([fileManager fileExistsAtPath:fileDirectory]) {
                NSLog(@"%d==已存在",i);
                continue;
            }
            
            dispatch_async(serialQueue, ^{
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                
                [WQAFNManager downloadFileWithURLString:self.dataArray[i] cachePath:fileDirectory progress:^(NSProgress *progress) {
                    
                    //NSLog(@"进度%f",progress.completedUnitCount* 1.0/progress.totalUnitCount);
                    
                } success:^(NSURLSessionDownloadTask *task, id responseObject) {
                    
                    NSLog(@"%d==下载完成",i);
                    dispatch_semaphore_signal(semaphore);
                    
                } failure:^(NSURLSessionDownloadTask *task, NSError *error) {
                    
                    NSLog(@"%d==下载失败",i);
                    dispatch_semaphore_signal(semaphore);
                }];
                
                
            });
            
        }
        
    }
}
- (void)clearMemory
{
    NSString *documentsPath =[self getDocumentPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * folderDirectory = [documentsPath stringByAppendingPathComponent:@"image"];
    
    BOOL isOK = [fileManager removeItemAtPath:folderDirectory error:nil];
    if (isOK) {
        NSLog(@"-- 成功删除---");
    }
}
// 拿到沙盒路径
-(NSString*)getDocumentPath
{
    // @expandTilde 是否覆盖
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
    
}

- (void)createFile
{
    NSString *documentsPath =[self getDocumentPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];// NSFileManager 是 Foundation 框架中用来管理和操作文件、目录等文件系统相关联内容的类。
    NSString * testDirectory = [documentsPath stringByAppendingPathComponent:@"日记"];
    BOOL res = [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (res) {
        NSLog(@"文件夹创建成功");
    }else
    {
        NSLog(@"文件夹创建失败");
    }
    
    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"test.txt"];
    BOOL res1 = [fileManager createFileAtPath:testPath contents:nil attributes:nil];
    if (res1) {
        NSLog(@"文件创建成功: %@" ,testPath);
    }else
    {
        NSLog(@"文件创建失败");
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataArray
{
    //大图片 https://link.juejin.im/?target=http%3A%2F%2Fnote.youdao.com%2Fyws%2Fapi%2Fpersonal%2Ffile%2FWEB81c817dffdac83857628791991eace95%3Fmethod%3Ddownload%26shareKey%3Dc7e5d448aefbd359b7ad13d54bd206a1
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534918376192&di=4b36a6605d3c5d17959b199429775f4e&imgtype=0&src=http%3A%2F%2Fpic23.photophoto.cn%2F20120503%2F0034034456597026_b.jpg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534922390841&di=da6bb554b76f440e89c917f89b71d4fa&imgtype=0&src=http%3A%2F%2Ffile06.16sucai.com%2F2016%2F0715%2Fb60faf820303a54e9226dcbf4429cf3f.jpg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534921222921&di=5a4a3753a8932dd0556c0ceff8bb5a19&imgtype=0&src=http%3A%2F%2Fpic5.photophoto.cn%2F20071228%2F0034034901778224_b.jpg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534921222921&di=d1f999f381093ae10c324cf0176d8d23&imgtype=0&src=http%3A%2F%2Fimg18.3lian.com%2Fd%2Ffile%2F201706%2F09%2Feb84aab0b8ad42cd4b6cc9bbf70ec5a7.jpg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534921222921&di=daeece36a7f9a7d5424b40750393adbb&imgtype=0&src=http%3A%2F%2Fpic9.photophoto.cn%2F20081229%2F0034034829945374_b.jpg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534921222920&di=0cc95bc3f65a04953ccc5b488d1ad5ee&imgtype=0&src=http%3A%2F%2Fpic32.photophoto.cn%2F20140817%2F0034034463193076_b.jpg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534921222920&di=f7ac6321f38aedd30379832438779718&imgtype=0&src=http%3A%2F%2Ffile06.16sucai.com%2F2016%2F0518%2F8afcf55356494abfda0537fd5ccf8696.jpg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534921222920&di=ed7577bc9c3e95454953387c8f348522&imgtype=0&src=http%3A%2F%2Fpic7.photophoto.cn%2F20080407%2F0034034859692813_b.jpg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534921222919&di=410dc75450804f7b7571029f02478027&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F7%2F53bce10032f18.jpg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534921222919&di=d5eb940aae2ca5621a8b375f1767a1c6&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F14%2F20%2F58%2F73z58PIC5MR_1024.jpg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534921222919&di=48e4894dbf63cf602ea6953c95d218f1&imgtype=0&src=http%3A%2F%2Fpic23.photophoto.cn%2F20120505%2F0034034818753393_b.jpg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534921222918&di=a09ae39f5de5efc96edadcacee6d21c3&imgtype=0&src=http%3A%2F%2Fpic9.photophoto.cn%2F20081229%2F0034034503916142_b.jpg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534921222917&di=8d15aebc34397967b36972f9407e5e36&imgtype=0&src=http%3A%2F%2Fpic35.photophoto.cn%2F20150623%2F0020032845149140_b.jpg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534921354328&di=a3ebd3aaf40d2a57f7abcb96d8f5a5df&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F14%2F14%2F07%2F97b58PICEn4_1024.jpg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534921354326&di=28d861f087ff6d4893dc4e12408fbb3d&imgtype=0&src=http%3A%2F%2Fpic1.nipic.com%2F2009-02-27%2F200922782410435_2.jpg",nil];
    }
    return _dataArray;
}


@end
