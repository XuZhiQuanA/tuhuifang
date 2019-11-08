//
//  XZQVideoView.m
//  涂绘坊
//
//  Created by dmt312 on 2019/5/12.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQVideoView.h"
@interface XZQVideoView ()
/**<#备注#> */
@property(nonatomic,strong) UIImageView *videoFrame;
@end




@implementation XZQVideoView

- (UIImageView *)videoFrame{
    if (_videoFrame == nil) {
        _videoFrame = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_videoFrame];
        [self insertSubview:_videoFrame atIndex:0];
    }
    
    return _videoFrame;
}

- (void)setImage:(UIImage *)image{
    self.videoFrame.image = image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
