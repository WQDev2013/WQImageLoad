//
//  WQAFNManager.h
//  WQImageLoad
//
//  Created by chenweiqiang on 2018/8/23.
//  Copyright © 2018年 chenweiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^DownloadProgressBlock)(NSProgress* progress);
typedef void(^DownloadSuccessBlock)(NSURLSessionDownloadTask *task, id responseObject);
typedef void(^DownloadFailureBlock)(NSURLSessionDownloadTask *task, NSError *error);

typedef void(^DownloadProgressBlock2)(CGFloat progress);
typedef void(^DownloadSuccessBlock2)(AFURLSessionManager *task, id responseObject);
typedef void(^DownloadFailureBlock2)(AFURLSessionManager *task, NSError *error);


@interface WQAFNManager : NSObject

#pragma mark -- 下载
+ (AFURLSessionManager *)downloadFileBackgroundWithURLString:(NSString *)URLString cachePath:(NSString *)cachePath progress:(DownloadProgressBlock2)progressBlock success:(DownloadSuccessBlock2)successBlock failure:(DownloadFailureBlock2)failureBlock;
+ (NSURLSessionDownloadTask *)downloadFileWithURLString:(NSString *)URLString
                                              cachePath:(NSString *)cachePath
                                               progress:(DownloadProgressBlock)progressBlock
                                                success:(DownloadSuccessBlock)successBlock
                                                failure:(DownloadFailureBlock)failureBlock;


+ (void)pauseWithOperation:(NSURLSessionDownloadTask *)manager;




@end
