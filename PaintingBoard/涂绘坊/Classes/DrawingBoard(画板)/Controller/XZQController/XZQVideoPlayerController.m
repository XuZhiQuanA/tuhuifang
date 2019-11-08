//
//  XZQVideoPlayerController.m
//  涂绘坊
//
//  Created by dmt312 on 2019/5/12.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQVideoPlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "UIApplication+scanLocalVideo.h"//UIApplication分类
#import "TFVideoCell.h"//cell
#import "playerViewController.h"//播放视频
#import "XZQVideoView.h"

#define Width self.view.bounds.size.width
#define Height self.view.bounds.size.height


@interface XZQVideoPlayerController ()<AVPlayerViewControllerDelegate>

/**视频文件路径 */
@property(nonatomic,strong) NSString *videoPath;

@property(nonatomic,readwrite,weak) UIImageView *televisionImageView;


@property(nonatomic,strong) NSArray *sourceArray;


//@property(nonatomic,strong) XZQVideoView *videoView;
@end

@implementation XZQVideoPlayerController

- (void)setTelevisionOutImage:(UIImage *)televisionOutImage{
    _televisionOutImage = televisionOutImage;
    
    self.televisionImageView.image = televisionOutImage;
}

- (UIImageView *)televisionImageView{
    if (_televisionImageView == nil) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:imageV];
        
        _televisionImageView = imageV;
    }
    
    return _televisionImageView;
}

- (void)setVideoPathDict:(NSMutableDictionary *)videoPathDict{
    _videoPathDict = videoPathDict;

    [self videoBaseOperation];
}

- (void)setVideoUrl:(NSURL *)videoUrl{
    _videoUrl = videoUrl;
    
    //这里：
//    self.playerVC.player = [AVPlayer playerWithURL:videoUrl];
//    [self.playerVC.player play];
    
    //全屏
    [self videoBaseOperation];
}




- (NSArray *)sourceArray{
    if (_sourceArray == nil) {
        //拿到视频资源数组
        _sourceArray = [[UIApplication sharedApplication]getVideoRelatedAttributesArray:TFVideoAssetTypeVideoName];
        
    }
    
    return _sourceArray;
}

/**采用的是从相册中加载视频 下面的viewDidLoad是从沙盒中加载视频
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 // Do any additional setup after loading the view.
 
 
 //画中画模式 - 以窗口的形式浮在界面上 在其他界面也可以画中画视频播放就将视频播放窗口化，然后浮动在屏幕上，此时你可以使用其他APP。但是有限制：1、iOS9 2、iPad
 
 //将AVPlayer的View的背景颜色设置成透明的
 self.view.backgroundColor = [UIColor clearColor];
 
 //视频播放器上面和下面多出了黑色的部分 - 播放界面和黑色部分属于UIVisualEffectBackdropView 所以设置一下UIVisualEffectBackdropView的颜色为透明的就行
 
 //如果没有拿到访问相册的权限 - 第二次运行的时候弹框提示设置一下权限
 if (![[UIApplication sharedApplication]authStatus]) {
 
 NSLog(@"无权限访问相册---------------");
 
 //弹框
 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请求访问相册" message:@"前往设置->LocalVideo->允许访问照片" preferredStyle:UIAlertControllerStyleAlert];
 UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
 UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 
 //??
 //            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"prefs:root=com.antvr.LocalVideo"]];
 
 //??
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=com.antvr.LocalVideo"] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:^(BOOL success) {
 
 }];
 
 }];
 
 [alert addAction:cancel];
 [alert addAction:sure];
 [self presentViewController:alert animated:YES completion:nil];
 
 }
 
 
 //创建带view的播放器
 AVPlayerViewController *playVC = [[AVPlayerViewController alloc] init];
 self.playerVC = playVC;
 
 self.playerVC.allowsPictureInPicturePlayback = YES;
 
 
 
 
 __weak typeof (self) wekaSelf = self;
 
 //新的视频播放方式: 在视频资源数组中找到对应名称的视频再播放
 //    PHAsset *asset = [[[UIApplication sharedApplication]assetsFetchResults] firstObject];
 
 //result可以像数组一样使用 在result中获取的是所有的相册中的视频 -assetsFetchResults方法是自己写的分类 以后可以限定一下搜索范围 - 只在一个文件夹中搜索
 PHFetchResult *result = [[UIApplication sharedApplication] assetsFetchResults];
 
 PHAsset *asset1 = [[UIApplication sharedApplication] getVideo:@"yaowei_1.mp4"];
 
 NSLog(@"asset1--------%@",asset1);
 
 //将asset放在下面的方法中就可以播放了 - 在result中利用视频名称不同赋值给asset就行
 PHAsset *asset = [[[UIApplication sharedApplication]assetsFetchResults] lastObject];
 
 [[PHImageManager defaultManager] requestPlayerItemForVideo:asset1 options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
 
 dispatch_async(dispatch_get_main_queue(), ^{
 //            playerViewController *MD = [[playerViewController alloc]init];
 //            MD.playerItem = playerItem;
 
 
 
 
 //block中使用self 可以会产生循环应用的问题 - 将self转化为weak的变量
 wekaSelf.player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
 
 wekaSelf.playerVC.player = wekaSelf.player;
 
 //            [wekaSelf.navigationController pushViewController:wekaSelf.playerVC animated:YES];
 });
 
 }];


//    1.创建url
//    NSString *path = @"/Users/dmt312/Desktop/酷酷的滕我爱你语录.mp4";
//    NSURL *url = [NSURL fileURLWithPath:path];

//拖动手势 缩放手势
UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
[self.view addGestureRecognizer:pan];


//缩放手势 - 捏合手势
UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
[self.view addGestureRecognizer:pinch];

//2.创建带view的播放器
//    AVPlayerViewController *playVC = [[AVPlayerViewController alloc] init];

playVC.delegate = self;

//解决视频播放器旁边有黑框的问题
playVC.view.backgroundColor = [UIColor clearColor];
self.playerVC = playVC;

//3.player基本上什么操作都要使用它
//    playVC.player = [AVPlayer playerWithURL:url];


//4.播放视频
//一开始暂停
[playVC.player pause];

//5.展示播放器的操作,设置代理
[self presentViewController:playVC animated:YES completion:nil];
playVC.view.frame = self.view.bounds;

[self.view addSubview:playVC.view];






}
 */

- (void)viewDidLoad{
    
    //初始化操作
//    [self videoBaseOperation];
    
    //corner radius
    self.view.layer.cornerRadius = 10;
    
    
    //apply to parent view
    self.view.clipsToBounds = YES;
    
    //设置电视机背景
    NSLog(@"XZQVideoPlayerController view %@",self.view);
    
}

#pragma 在线播放
//- (void)playOnline:(NSURL *)url{
//
//    self.view.backgroundColor = [UIColor clearColor];
//
//}

//- (void)prepareAboutPlay{
//
//
//    self.view.backgroundColor = [UIColor clearColor];
//
//
//
//}

//用于测试将self.playerVc放在一个view中 显示在电视机中
- (void)setView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(Width*0.0395, Height*0.1575, Width*0.888, Height*0.688)];
    view.backgroundColor = [UIColor redColor];
    view.alpha = 0.5;
    [self.view addSubview:view];
    [self.view bringSubviewToFront: view];
    
    UIView *subView = [[UIView alloc] initWithFrame:view.bounds];
    subView.backgroundColor = [UIColor blackColor];
    [view addSubview:subView];
    
    view.layer.cornerRadius = 9.22;
    view.clipsToBounds = YES;
}

//设置电视机和外面的框
- (void)setTelevisionAndSuperItsSuperView{
    
    NSURL *url = self.videoUrl;
    
    //view用来存放self.playerVC 将view添加到self.view中 self.playerVC 添加到view中
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(Width*0.0395, Height*0.1575, Width*0.888, Height*0.688);
    
    
    
    
    //2.创建带view的播放控制器
    self.playerVC = [[AVPlayerViewController alloc] init];
    
    //3.player基本上什么操作都要使用它
    self.playerVC.player = [AVPlayer playerWithURL:url];
    
    
    //4.播放视频 - 一开始先暂停
    [self.playerVC.player pause];
    
    self.playerVC.view.frame = view.bounds;
    
    //        self.playerVC.view.backgroundColor = [UIColor redColor];
    
    //5.展示播放器的操作,设置代理
    //        [self presentViewController:self.playerVC animated:YES completion:nil];
    
    
    //        [self.view addSubview:self.playerVC.view];
    
    [view addSubview:self.playerVC.view];
    [self.view addSubview:view];
    [self.view bringSubviewToFront: view];
    
    view.layer.cornerRadius = 9.22;
    view.clipsToBounds = YES;
    
    [view addSubview:self.playerVC.view];
    
}

#pragma 本地播放
- (void)videoBaseOperation{
    

        
        //画中画模式 - 以窗口的形式浮在界面上 在其他界面也可以画中画视频播放就将视频播放窗口化，然后浮动在屏幕上，此时你可以使用其他APP。但是有限制：1、iOS9 2、iPad
        
        //将AVPlayer的View的背景颜色设置成透明的
        self.view.backgroundColor = [UIColor clearColor];
        
        /**
         //视频播放器上面和下面多出了黑色的部分 - 播放界面和黑色部分属于UIVisualEffectBackdropView 所以设置一下UIVisualEffectBackdropView的颜色为透明的就行
         
         //    1.创建url
         //        self.videoPath = @"/Users/dmt312/Desktop/haizei_1.mp4";//转化为url file:///Users/dmt312/Desktop/haizei_1.mp4
         //        self.videoPath = @"/Users/dmt312/Library/Developer/CoreSimulator/Devices/54A0E78D-A3EA-4B04-9A2F-85BCAB3BE8BA/data/Containers/Data/Application/3BFA1061-5DF5-4409-8FD0-E604530BCFA0/Library/Caches/PHouse/video/haizei_1.mp4";//file:///Users/dmt312/Library/Developer/CoreSimulator/Devices/54A0E78D-A3EA-4B04-9A2F-85BCAB3BE8BA/data/Containers/Data/Application/3BFA1061-5DF5-4409-8FD0-E604530BCFA0/Library/Caches/PHouse/video/haizei_1.mp4
         
         //每次存入的路径在变
         //        self.videoPath = @"/Users/dmt312/Library/Developer/CoreSimulator/Devices/54A0E78D-A3EA-4B04-9A2F-85BCAB3BE8BA/data/Containers/Data/Application/8D19D976-F53F-4FA5-AB8C-43399AD8107B/Library/Caches/PHouse/video/haizei_1.mp4";
         */
    
        [self setTelevisionAndSuperItsSuperView];
    
        
        //画中画模式
        self.playerVC.allowsPictureInPicturePlayback = YES;

        //拖动手势 缩放手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self.view addGestureRecognizer:pan];
        
        
        //缩放手势 - 捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        [self.view addGestureRecognizer:pinch];
        
        self.playerVC.delegate = self;
        
        //解决视频播放器旁边有黑框的问题
        self.playerVC.view.backgroundColor = [UIColor clearColor];
        self.playerVC.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
 
    
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    
    CGPoint curPoint = [pan translationInView:pan.view];
    pan.view.transform = CGAffineTransformTranslate(pan.view.transform, curPoint.x, curPoint.y);
    
    [pan setTranslation:CGPointZero inView:pan.view];
    
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch{
    
    //    pinch.view.transform = CGAffineTransformMakeScale(pinch.scale, pinch.scale);
    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
    pinch.scale = 1;
    
//    NSLog(@"cornerRadius - %f",self.view.layer.cornerRadius);
}

//
- (BOOL)playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart:(AVPlayerViewController *)playerViewController{
    return YES;
}

//将要开始画中画时调用 - 这两个方法是为了给视频加个框
- (void)playerViewControllerWillStartPictureInPicture:(AVPlayerViewController *)playerViewController{
    
    for (UIView *view in playerViewController.view.subviews) {
        view.alpha = 0;
    }
    
//    self.backView.alpha = 0;
    
    
}

//已经停止画中画时调用
- (void)playerViewControllerDidStopPictureInPicture:(AVPlayerViewController *)playerViewController{
    
    for (UIView *view in playerViewController.view.subviews) {
        view.alpha = 1;
    }
    
//    self.backView.alpha = 1;
}

#pragma mark -----------------------------
#pragma mark 单例模式

//static XZQVideoPlayerController *_videoPlayer;
//
//+ (instancetype)shareXZQVideoPlayerController{
//    return [[self alloc] init];
//}
//
//+ (instancetype)allocWithZone:(struct _NSZone *)zone{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _videoPlayer = [super allocWithZone:zone];
//    });
//
//    return _videoPlayer;
//}
//
//- (instancetype)copyWithZone:(NSZone *)zone{
//    return _videoPlayer;
//}
//
//- (instancetype)mutableCopyWithZone:(NSZone *)zone{
//    return _videoPlayer;
//}




@end
