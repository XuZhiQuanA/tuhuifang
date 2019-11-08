//
//  UIApplication+scanLocalVideo.m
//  LocalVideo
//
//  Created by antvr on 16/8/2.
//  Copyright © 2016年 sunTengFei_family. All rights reserved.
//

#import "UIApplication+scanLocalVideo.h"
@implementation UIApplication (scanLocalVideo)
//相册授权
- (BOOL)authStatus{
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied) {
        return NO;
    }else{
        return YES;
    }
}
//获取搜索的结果 - PHFetchResult - 一般的返回结果都是PHFetchResult 使用它可以像使用数组一样
- (PHFetchResult *)assetsFetchResults{

    //PHAssetMediaTypeVideo - 搜索视频媒体类型  getFetchPhotosOptions - 范围和规则
    return [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:[self getFetchPhotosOptions]];
}

//筛选的规则和范围
- (PHFetchOptions *)getFetchPhotosOptions{
    
   PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc]init];
    
    //扫描的范围为：用户相册，iCloud分享，iTunes同步
    allPhotosOptions.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary | PHAssetSourceTypeCloudShared | PHAssetSourceTypeiTunesSynced;
    
    //排序的方式为：按时间排序
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    return allPhotosOptions;
}

//获取所需要的资源数组,缩略图，时长，视频名称
- (NSArray *)getVideoRelatedAttributesArray:(TFVideoAssetType)type{
    
    NSMutableArray *sourceArray = [NSMutableArray arrayWithCapacity:self.assetsFetchResults.count];
 
    //PHAsset - 表示单个资源  assetsFetchResults - 之前在限定搜索范围内搜索到的资源
    for (PHAsset *asset in self.assetsFetchResults) {
       
        NSString *videoName = [asset valueForKey:@"filename"];
        
        //PHImageManager--提供获取或生成预览缩略图和全尺寸图片，或者视频数据的方法。
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
          //获取视频的缩略图
          UIImage *image = result;
          //视频时长
          NSString *timeLength = [self getVideoDurtion:[self getcalduration:asset]];
          
            switch (type) {
                case TFVideoAssetTypeVideoImageSource:
                    [sourceArray addObject:image];      //UIImage
                    break;
                case TFVideoAssetTypeVideoTimeLength:
                    [sourceArray addObject:timeLength]; //NSString
                    break;
                case TFVideoAssetTypeVideoName:
                    [sourceArray addObject:videoName];  //NSString
                    break;

                default:
                    break;
            }
            
         }];

    }
    
    return sourceArray;
}

- (NSInteger)getcalduration:(PHAsset *)asset{
    
    NSInteger dur;
    
    NSInteger time = asset.duration;
    
    double time2 = (double)(asset.duration - time);
    
    if (time2 < 0.5) {
        dur = asset.duration;
    }else{
        dur = asset.duration + 1;
    }
    
    return dur;
    
}

-(NSString *)getVideoDurtion:(NSInteger)duration{
    
    NSInteger h = (NSInteger)duration/3600; //总小时
    
    NSInteger mT = (NSInteger)duration%3600; //总分钟
    
    NSInteger m = mT/60; //最终分钟
    
    
    NSInteger s = mT%60; //最终秒数
    
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)h,(long)m,(long)s];
    
}

//返回指定名称的video
- (PHAsset *)getVideo:(NSString *)videoName{
    
    for (PHAsset *asset in self.assetsFetchResults) {
     
        NSString *videoName2 = [asset valueForKey:@"filename"];
//        NSString *videoName1 = [asset valueForKey:@"name"];
        
        NSLog(@"getVideo--------------%@",videoName);//IMG_0011.MP4
        
        if ([videoName isEqualToString:videoName2]) {
            NSLog(@"getVideogetVideogetVideo");
            return asset;
        }else{
            return nil;
        }
    }
    
    return nil;
    
}
@end


