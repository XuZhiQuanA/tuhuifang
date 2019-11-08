//
//  XZQNameButton.m
//  涂绘坊
//
//  Created by dmt312 on 2019/5/21.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQNameButton.h"

@implementation XZQNameButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    self.isBigger = !self.isBigger;
    self.playAll = YES;
    
}

- (void)setIsBigger:(BOOL)isBigger{
    _isBigger = isBigger;
    
    if (isBigger) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.originRect = self.frame;
        }];
        
    }
}

- (AVPlayer *)pauseTimePlayer{
    if (!_pauseTimePlayer) {
        _pauseTimePlayer = [[AVPlayer alloc] init];
    }
    
    return _pauseTimePlayer;
}

@end
