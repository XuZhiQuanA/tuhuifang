//
//  PacksackImageView.m
//  涂绘坊
//
//  Created by dmt312 on 2019/6/5.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "PacksackImageView.h"

@interface PacksackImageView()<UIGestureRecognizerDelegate>


@end

@implementation PacksackImageView

- (instancetype)init{
 
    if (self = [super init]) {
        

        
        
        
        self.userInteractionEnabled = YES;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];
        
        
        
        
    }
    
    return self;
}

- (instancetype)PacksackImageView{
    
    PacksackImageView *packSackImageView = [[PacksackImageView alloc] init];
    
    packSackImageView.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [packSackImageView addGestureRecognizer:pan];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [packSackImageView addGestureRecognizer:longPress];
    
    
    return packSackImageView;
    
}

//长按手势调用
- (void)longPress:(UILongPressGestureRecognizer *)longPress{
    
}

//拖动手势调用
- (void)pan:(UIPanGestureRecognizer *)pan{
    
    CGPoint curPoint = [pan translationInView:pan.view];
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pan.view.frame = CGRectMake(
                                    pan.view.frame.origin.x - 5,
                                    pan.view.frame.origin.y - 5,
                                    pan.view.frame.size.width + 10,
                                    pan.view.frame.size.height + 10
                                    );
        
        pan.view.alpha = 0.8;
    });
    
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        pan.view.transform = CGAffineTransformTranslate(pan.view.transform, curPoint.x, curPoint.y);
        
    }else if (pan.state == UIGestureRecognizerStateEnded){
        
        [UIView animateWithDuration:0.5 animations:^{
                self.frame = self.origionFrame;
        }];
        
        
    }
    
    
    
    
    [pan setTranslation:CGPointZero inView:pan.view];
    
    
    
    
}

@end
