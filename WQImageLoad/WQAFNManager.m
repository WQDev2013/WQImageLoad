//
//  WQAFNManager.m
//  WQImageLoad
//
//  Created by chenweiqiang on 2018/8/23.
//  Copyright © 2018年 chenweiqiang. All rights reserved.
//

#import "WQAFNManager.h"

@implementation WQAFNManager

#pragma mark -- GET or POST 请求


#pragma mark -- 下载
+ (AFURLSessionManager *)downloadFileBackgroundWithURLString:(NSString *)URLString cachePath:(NSString *)cachePath progress:(DownloadProgressBlock2)progressBlock success:(DownloadSuccessBlock2)successBlock failure:(DownloadFailureBlock2)failureBlock {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.deda.cin"];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSData *resumeData = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        
        resumeData = [NSData dataWithContentsOfFile:cachePath];
    }
    if (!resumeData) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
        [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progressBlock) {
                progressBlock(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            }
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:cachePath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {
                failureBlock(nil,error);
            }else
            {
                successBlock(nil,response);
            }
        }];
    }else{
        [manager downloadTaskWithResumeData:resumeData progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progressBlock) {
                progressBlock(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            }
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:cachePath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {
                failureBlock(nil,error);
            }else
            {
                successBlock(nil,response);
            }
        }];
    }
    
    
    
    return manager;
}

+ (NSURLSessionDownloadTask *)downloadFileWithURLString:(NSString *)URLString cachePath:(NSString *)cachePath progress:(DownloadProgressBlock)progressBlock success:(DownloadSuccessBlock)successBlock failure:(DownloadFailureBlock)failureBlock {
    //URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURLSessionConfiguration *config= [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"downInBackground20119"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *mgr          = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    
    NSData *resumeData = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        
        resumeData = [NSData dataWithContentsOfFile:cachePath];
    }
    
    NSURLSessionDownloadTask *downloadTask;
    if (resumeData) {
        
        downloadTask = [mgr downloadTaskWithResumeData:resumeData progress:progressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            return [NSURL fileURLWithPath:cachePath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {
                failureBlock(downloadTask,error);
            }else
            {
                successBlock(downloadTask,response);
            }
        }];
    }else{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
        
        downloadTask = [mgr downloadTaskWithRequest:request progress:progressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:cachePath];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {
                failureBlock(downloadTask,error);
            }else
            {
                successBlock(downloadTask,response);
            }
        }];
        
    }
    
    [downloadTask resume];
    
    return downloadTask;
    
}

+ (void)pauseWithOperation:(NSURLSessionDownloadTask *)task {
    
    [task suspend];
}

@end
