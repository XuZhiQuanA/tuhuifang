//
//  XZQMoveBtn.m
//  涂绘坊
//
//  Created by dmt312 on 2019/8/5.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQMoveBtn.h"

@implementation XZQMoveBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    self = [super init];
    
    if (self) {
        
        //调用拖动的方法
        [self moveBtn];
    }
    
    return self;
}

- (void)moveBtn{
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    
    CGPoint curPoint = [pan translationInView:pan.view];
    pan.view.transform = CGAffineTransformTranslate(pan.view.transform, curPoint.x, curPoint.y);
    
    [pan setTranslation:CGPointZero inView:pan.view];
    
}

@end
