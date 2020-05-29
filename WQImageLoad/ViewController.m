//
//  ViewController.m
//  WQImageLoad
//
//  Created by chenweiqiang on 2018/8/22.
//  Copyright © 2018年 chenweiqiang. All rights reserved.
//

#import "ViewController.h"
#import "WQImageLoadViewController.h"
#import "WQAFNLoadImageViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btnClick:(id)sender {
    WQImageLoadViewController *vc = [[WQImageLoadViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)btnAFNTest:(id)sender {
    WQAFNLoadImageViewController *vc=  [[WQAFNLoadImageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)test {
    
}

- (void)test2 {
    
}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//
//{
//
// if (collectionView == self.hotelOrderReviewView.userImageCollectionView)
//
//    {
//
//        SGImagePickerController *picker = [[SGImagePickerController alloc] init];
//
//        picker.maxCount = 6;
//
//        [picker setDidFinishSelectImages:^(NSArray *images) {
//
//            [arr_selectedImage addObjectsFromArray:images];
//
//            [arr_selectedImage addObject:[UIImage imageNamed:@"emailus_photo"]];
//
//            [self updateContentSize];
//
//            [collectionView reloadData];
//
//            dispatch_group_t group = dispatch_group_create();
//
//            semaphore = dispatch_semaphore_create(1);
//
//            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                for (int i = 0; i < arr_selectedImage.count;i++) {
//
//                    dispatch_group_async(group, queue, ^{
//
//                        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//
//
//
//                        dispatch_async(dispatch_get_main_queue(), ^{
//
//                            CTHotelOrderUploadImageCell * cell1 = (CTHotelOrderUploadImageCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
//
//
//
//                            HUD = [[MBProgressHUD alloc] initWithView:cell1];
//
//                            [cell1 addSubview:HUD];
//
//                            //如果设置此属性则当前的view置于后台
//
//                            HUD.dimBackground = YES;
//
//                            //设置对话框文字
//
//                            //            HUD.labelText = @"请稍等";
//
//
//
//                            //显示对话框
//
//                            [HUD showAnimated:YES whileExecutingBlock:^{
//
//                                //对话框显示时需要执行的操作
//
//                                [self upLoadImageToServerWithImage:[arr_selectedImage objectAtIndex:i] andHotelID:_order.hotelId];
//
//
//
//                            } completionBlock:^{
//
//                                //操作执行完后取消对话框
//
//                                [HUD removeFromSuperview];
//
//                                HUD = nil;
//
//                            }];
//                        });
//
//                        //dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//
//                    });
//
//                }
//
//            });
//
//
//        }];
//
//        [self presentViewController:picker animated:YES completion:nil];
//
//    }
//
//}
//
//
//-(void)upLoadImageToServerWithImage:(UIImage* )image andHotelID:(long)hotelID
//
//{
//
//    CTReqHotelCommentUpLoadImage *_request = [CTReqHotelCommentUpLoadImage reqeustEntity];
//
//    _request.fileBytes = UIImageJPEGRepresentation(image,0.1).base64EncodeToString;
//
//    _request.hotelID = hotelID;
//
//
//    [[CTModelAPIStoreManager sharedStoreManager]  postRequest:_request success:^(CTRespHotelCommentUpLoadImage *object) {
//
//        if (CT_CHECK_CLASS(object, CTRespHotelCommentUpLoadImage)) {
//
//            _result = object;
//
//            [self onSuccessful];
//
//            dispatch_semaphore_signal(semaphore);
//
//
//
//        }else{
//
//            [self onFailed];
//
//            [[CTModelAPIStoreManager sharedStoreManager] clearCache:[_request requestHashCode]];
//
//        }
//
//        //        [self setTitleView];
//
//
//
//    } failure:^(NSError *error) {
//
//        //        [self setTitleView];
//
//        [self onFailed];
//
//    } cache:YES];
//
//}



@end
