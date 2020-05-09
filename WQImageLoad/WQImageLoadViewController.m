//
//  WQImageLoadViewController.m
//  WQImageLoad
//
//  Created by chenweiqiang on 2018/8/22.
//  Copyright © 2018年 chenweiqiang. All rights reserved.
//

#import "WQImageLoadViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GoodsTableViewCell.h"
#import "SDWebImagePrefetcher.h"
@interface WQImageLoadViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSOperationQueue *queue;

@property (nonatomic,strong) dispatch_semaphore_t sema;

@property (nonatomic,strong) dispatch_queue_t serialQueue;
@property (nonatomic,strong) dispatch_semaphore_t semaphore;

@end

@implementation WQImageLoadViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.queue = [[NSOperationQueue alloc] init];
    self.queue.maxConcurrentOperationCount = 1;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清缓存" style:UIBarButtonItemStylePlain target:self action:@selector(clearMemory)];
    [self.view addSubview:self.tableView];
    
    
    self.serialQueue = dispatch_queue_create("WQLoadImageViewController_loadImage",DISPATCH_QUEUE_SERIAL);
    self.semaphore = dispatch_semaphore_create(1);
    // Do any additional setup after loading the view.
}
- (void)clearMemory
{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
//cell
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *kCell = @"kCell";
    GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell];
    if (cell == nil) {
        cell = [[GoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCell];
    }
    //1.
//    self.sema = dispatch_semaphore_create(0);
//    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
////        NSLog(@"%ld行的进度%f",indexPath.row,receivedSize*1.0/expectedSize);
//    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        NSLog(@"完成%ld",indexPath.row);
//        dispatch_semaphore_signal(self.sema);
//    }];
//    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    
    
    //2.不能控制的方法
//    NSBlockOperation *eocOperation = [[NSBlockOperation alloc] init];
//    [eocOperation addExecutionBlock:^{
//        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//    //        NSLog(@"%ld行的进度%f",indexPath.row,receivedSize*1.0/expectedSize);
//        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            NSLog(@"完成%ld",indexPath.row);
//        }];
//    }];
//    [self.queue addOperation:eocOperation];
  
    //3.
//    NSString *rowString = [NSString stringWithFormat:@"%ld",indexPath.row];
//    NSMethodSignature *signture = [self methodSignatureForSelector:@selector(loadImage:andIndexPath:)];
//    NSInvocation *invation = [NSInvocation invocationWithMethodSignature:signture];
//    invation.target = self;
//    invation.selector = @selector(loadImage:andIndexPath:); //和签名的seletor要对应起来
//    [invation setArgument:(__bridge void *)cell.headImageView atIndex:2];
//    [invation setArgument:&rowString atIndex:3];
//
//    NSInvocationOperation* invocationOperation = [[NSInvocationOperation alloc] initWithInvocation:invation];
//    [self.queue addOperation:invocationOperation];
    
    //4.
    dispatch_async(self.serialQueue, ^{
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    //        NSLog(@"%ld行的进度%f",indexPath.row,receivedSize*1.0/expectedSize);
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            NSLog(@"完成%ld",indexPath.row);
            dispatch_semaphore_signal(self.semaphore);
            
        }];
        
    });
    
    cell.titleLabel.text = [NSString stringWithFormat:@"行%ld",indexPath.row];
    return cell;
}

//- (void)loadImage:(UIImageView*)imgView andIndexPath:(NSString*)indexPath
//{
//    NSUInteger row = [indexPath integerValue];
//    NSURL *url = [NSURL URLWithString:self.dataArray[row]];
//    [imgView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
////        NSLog(@"%ld行的进度%f",indexPath.row,receivedSize*1.0/expectedSize);
//    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        NSLog(@"完成%ld",row);
//    }];
//}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
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
