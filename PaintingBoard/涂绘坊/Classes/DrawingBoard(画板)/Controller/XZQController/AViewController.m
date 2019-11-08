//
//  AViewController.m
//  涂绘坊
//
//  Created by home on 2019/10/5.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "AViewController.h"

#define Width self.view.bounds.size.width
#define Height self.view.bounds.size.height

@interface AViewController ()
@property(nonatomic,readwrite,weak) UIImageView *televisionImageView;
@end

@implementation AViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //corner radius
    self.view.layer.cornerRadius = 10;
    
    
    //apply to parent view
    self.view.clipsToBounds = YES;
    
    //设置电视机和外面的框
    [self setTelevisionAndSuperItsSuperView];
    
    self.playerVC.entersFullScreenWhenPlaybackBegins = YES;
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
        [self.view bringSubviewToFront:self.superFrameView];
    }
    
    return _televisionImageView;
}

- (void)setTelevisionAndSuperItsSuperView{
        
    //view用来存放self.playerVC 将view添加到self.view中 self.playerVC 添加到view中
    
    UIView *view = [[UIView alloc] init];
//    view.frame = CGRectMake(Width*0.0215, Height*0.095, Width*0.4768, Height*0.42);
    view.frame = CGRectMake(Width*0.016, Height*0.0716, Width*0.3547, Height*0.314);//1.1765
    
    
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
    
    view.layer.cornerRadius = 15.22;
    view.clipsToBounds = YES;
    
    
    [view addSubview:self.playerVC.view];
        
    self.superFrameView = view;
}

@end
