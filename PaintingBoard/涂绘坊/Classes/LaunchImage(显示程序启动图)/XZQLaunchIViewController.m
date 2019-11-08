//
//  XZQLaunchIViewController.m
//  涂绘坊
//
//  Created by home on 2019/10/24.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQLaunchIViewController.h"
#import "UIImage+OriginalImage.h"
#import "XZQTabBarController.h"
@interface XZQLaunchIViewController ()

@property(nonatomic, weak) UIImageView *imageV;

@property(nonatomic, weak) NSTimer *timer;



@end

@implementation XZQLaunchIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageV.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"startImage"]];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(change) userInfo:nil repeats:NO];
}


#pragma lazy initialize
- (UIImageView *)imageV{
    if (_imageV == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [self.view addSubview:imageView];
        _imageV = imageView;
    }
    
    return _imageV;
}

#pragma 切换根控制器
- (void)change{
    
    XZQTabBarController *tabBarVC = [[XZQTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
    
    //干掉定时器
    [_timer invalidate];
}

#pragma 取消状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
