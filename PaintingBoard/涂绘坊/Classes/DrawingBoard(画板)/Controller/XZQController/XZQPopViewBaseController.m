//
//  XZQPopViewBaseController.m
//  涂绘坊
//
//  Created by dmt312 on 2019/5/20.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQPopViewBaseController.h"
#import "XZQPopViewController.h"
#import "XZQCoverView.h"
#import "XZQSnowCoverView.h"

@interface XZQPopViewBaseController ()
///**popVc菜单 */
//@property(nonatomic,strong) XZQPopViewController *popVc;
//
///**遮罩 */
//@property(nonatomic,strong) XZQCoverView *coverView;
@end

@implementation XZQPopViewBaseController

- (UIView *)coverView{
    if (_coverView == nil) {
//        _coverView = [[XZQCoverView alloc] init];
        _coverView = [XZQSnowCoverView snowCoverView];
    }
    
    return _coverView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


//来到画板界面隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}

//
- (void)popVcBtn{
//    NSLog(@"popVcBtn");
    
    
    //发送弹出popView的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popView" object:nil];
    
}

- (void)popView{
    
    self.coverView.frame = self.view.bounds;
    self.coverView.alpha = 0;
    self.coverView.backgroundColor = [UIColor blackColor];
    
    
    self.coverView.tag = 666;
    
    CGFloat popVcW = self.view.bounds.size.width * 0.2950;
    CGFloat popVcH = self.view.bounds.size.height;
    CGFloat popVcX = self.view.bounds.size.width * 0.7049 + popVcW;
    CGFloat popVcY = 0;
    
    self.popVc.view.frame = CGRectMake(popVcX, popVcY, popVcW, popVcH);
    self.popVc.image = [UIImage imageNamed: @"navigation_big"];
    self.popVc.view.tag = 1;
    
    
    [self.view addSubview:self.coverView];
    
    [self.view addSubview:self.popVc.view];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.popVc.view.frame = CGRectMake(popVcX - popVcW, popVcY, popVcW, popVcH);
        
        
        //遮罩
        
        self.coverView.alpha = 0.7;
        
    }];
    
    //每次都要监听！！
    //利用KVO监听PopView的frame改变
    [self.popVc.view addObserver:self forKeyPath:@"tag" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)removeCoverView{
    
    for (UIView *view in self.view.subviews) {
        
        if (view.tag == 666) {
            
            
            //            view.backgroundColor = [UIColor redColor];//没有变成红色 - 不从父控件中移除的话 -就变成红色的了 - 为什么从父控件中移除就没有慢慢黑色退去的效果
            
            [UIView animateWithDuration:1.0 animations:^{
                
                view.alpha = 0;//没有变黑
                
                
            } completion:^(BOOL finished) {
                
                //延迟执行 - 解决遮罩向右弹回去黑色view移除后立即消失而不是慢慢消失问题 - 点击频繁还是不行 - 不移除了
                //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                    [view removeFromSuperview];
                //                });
                
            }];
            
            
            return;
        }
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
//    NSLog(@"observeValueForKeyPath");
    
    [self removeCoverView];
}


- (void)removeCoverViewAndMoveBackPopView{
    
    
    [self removeCoverView];
}


@end
