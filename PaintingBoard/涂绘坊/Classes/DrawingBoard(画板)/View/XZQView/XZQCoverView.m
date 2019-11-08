//
//  XZQCoverView.m
//  涂绘坊
//
//  Created by dmt312 on 2019/5/13.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQCoverView.h"

@implementation XZQCoverView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //当点击了遮罩之后 发送通知移除遮罩
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeCoverViewAndMoveBackPopView" object:nil];
//    NSLog(@"点击了遮罩");
    self.isSmaller = true;
}

- (void)setIsSmaller:(BOOL)isSmaller{
    _isSmaller = isSmaller;
    
    if (isSmaller) {
//        NSLog(@"发出缩小的通知");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"toNarrowStoryPlot" object:nil];
        
        
        //点击遮罩发出让录音停止的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recordPause" object:nil];
    }
}

-(void)dealloc{
    //第一种方法.这里可以移除该控制器下的所有通知
    // 移除当前所有通知
//    NSLog(@"移除了所有的通知");
    
    //第一种方法
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //第二种方法.这里可以移除该控制器下名称为tongzhi的通知
    //移除名称为tongzhi的那个通知
//    NSLog(@"移除了名称为tongzhi的通知");
    
    //第二种方法
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeCoverView" object:nil];
}

@end
