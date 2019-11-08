//
//  XZQSmallWindowVideoViewController.m
//  涂绘坊
//
//  Created by home on 2019/10/5.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQSmallWindowVideoViewController.h"

#define Width self.view.bounds.size.width
#define Height self.view.bounds.size.height

@interface XZQSmallWindowVideoViewController ()
@property(nonatomic,readwrite,weak) UIImageView *televisionImageView;
@end

@implementation XZQSmallWindowVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if (self.isColorBackgroundPopBox == false) {//有小电视机外框
        [self loadParameterForHaveSmallTelevision];
    }else{//无小电视机外框 弹框背景是彩色的
        [self loadParameterForColorBackgroundPopBox];
    }
    
    
}

- (void)setStoryURL:(NSURL *)storyURL{
    _storyURL = storyURL;
    
    self.playerVC.player = [AVPlayer playerWithURL:_storyURL];
    [self.playerVC.player play];
    
    [self.view bringSubviewToFront:self.superFrameView];
}

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

- (void)setTelevisionAndSuperItsSuperView{
        
    //view用来存放self.playerVC 将view添加到self.view中 self.playerVC 添加到view中
    
    UIView *view = [[UIView alloc] init];
//    view.frame = CGRectMake(Width*0.0215, Height*0.095, Width*0.4768, Height*0.42);
    view.frame = CGRectMake(Width*0.0215, Height*0.095, Width*0.4768, Height*0.42);
    
    
    //2.创建带view的播放控制器
    self.playerVC = [[AVPlayerViewController alloc] init];
    
    //3.player基本上什么操作都要使用它
    self.playerVC.player = [AVPlayer playerWithURL:self.storyURL];
    
    self.playerVC.view.frame = view.bounds;
    
    //显示控制条
//    self.playerVC.showsPlaybackControls = YES;
    
    
    
    //        self.playerVC.view.backgroundColor = [UIColor redColor];
    
    //5.展示播放器的操作,设置代理
    //        [self presentViewController:self.playerVC animated:YES completion:nil];
    
    
    //        [self.view addSubview:self.playerVC.view];
    
    [view addSubview:self.playerVC.view];
    [self.view addSubview:view];
    [self.view bringSubviewToFront: view];
    
    view.layer.cornerRadius = 22.22;
    view.clipsToBounds = YES;
    
    
    [view addSubview:self.playerVC.view];
        
    self.superFrameView = view;
}

#pragma 有小电视机外框
- (void)loadParameterForHaveSmallTelevision{
    
    //corner radius
    self.view.layer.cornerRadius = 10;
    
    
    //apply to parent view
    self.view.clipsToBounds = YES;
    
    //设置电视机和外面的框
    [self setTelevisionAndSuperItsSuperView];
    
}

#pragma 无电视机外框 弹框背景是彩色的
- (void)loadParameterForColorBackgroundPopBox{
 
    //设置播放器的frame
    
    //2.创建带view的播放控制器
    self.playerVC = [[AVPlayerViewController alloc] init];
    
    //3.player基本上什么操作都要使用它
    if (self.storyURL != nil) {
        self.playerVC.player = [AVPlayer playerWithURL:self.storyURL];
    }
    
    self.playerVC.view.frame = self.view.bounds;
    
    [self.view addSubview:self.playerVC.view];
    [self.view bringSubviewToFront:self.playerVC.view];
    
}
@end
