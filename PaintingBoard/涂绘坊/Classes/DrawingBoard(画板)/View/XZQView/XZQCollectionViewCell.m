//
//  XZQCollectionViewCell.m
//  涂绘坊
//
//  Created by dmt312 on 2019/9/8.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQCollectionViewCell.h"

#define Height [UIScreen mainScreen].bounds.size.height

@interface XZQCollectionViewCell()

//@property (weak, nonatomic) IBOutlet UIButton *brushBtn;
@property (weak, nonatomic) IBOutlet UIButton *brushBtn;




@end

@implementation XZQCollectionViewCell

#pragma mark -----------------------------
#pragma mark lazy load

- (void)setBrushTag:(NSInteger)brushTag{
    _brushTag = brushTag;
    self.brushBtn.tag = _brushTag;
    
}


//显示对号
- (UIImageView *)imageV{
    if (_imageV == nil) {
        _imageV = [[UIImageView alloc] init];
        _imageV.bounds = CGRectMake(0, 0, self.bounds.size.width *0.4, self.bounds.size.height *0.17);
        _imageV.center = CGPointMake(23, 9);
        _imageV.image = [UIImage imageNamed:@"drawboard_selected"];
        
        [self addSubview:_imageV];
    }
    
    return _imageV;
}


- (void)setImage:(UIImage *)image{
    _image = image;
    
    [self.brushBtn setImage:image forState:UIControlStateNormal];
    
    [self.brushBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)click:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(hideCellSelected)]) {
        [self.delegate hideCellSelected];
    }
    
    self.imageV.alpha = 1;
    NSLog(@"%ld",btn.tag);
    
//    UIImage *image = [UIImage imageNamed:@"brush"];
//
//    [self.brushBtn setImage:image forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(throwSelectedCell:tag:)]) {
        [self.delegate throwSelectedCell:self tag:btn.tag];
    }
    
    if ([self.delegate respondsToSelector:@selector(cellClickChangeColor:)]) {
        [self.delegate cellClickChangeColor:self.brushBtn];
    }

}

//旋转图片
- (UIImage *)rotateImage:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;


    
    return image;
}


@end
