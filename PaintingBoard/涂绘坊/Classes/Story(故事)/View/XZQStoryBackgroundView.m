//
//  XZQStoryBackgroundView.m
//  涂绘坊
//
//  Created by dmt312 on 2019/5/14.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQStoryBackgroundView.h"
@interface XZQStoryBackgroundView()
/**<#备注#> */
@property(nonatomic,strong) UIImageView *imageV;
@end

@implementation XZQStoryBackgroundView

- (UIImageView *)imageV{
    if (_imageV == nil) {
        _imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageV];
        
    }
    return _imageV;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageV.image = image;
}

@end
