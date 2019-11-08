//
//  MyCollectionViewCell.m
//  UICollectionViewPractice
//
//  Created by dmt312 on 2019/5/31.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "MyCollectionViewCell.h"

@interface MyCollectionViewCell()
/**<#备注#> */
@property(nonatomic,strong) UIImageView *imageV;

@end


@implementation MyCollectionViewCell



- (void)setImageStr:(UIImage *)imageStr{
    _imageStr = imageStr;
    
    _imageV.image = imageStr;
}

#pragma 懒加载
- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    
    return _imageV;
}


@end
