//
//  PhotoCell.m
//  XZQCollectionView
//
//  Created by dmt312 on 2019/8/29.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "PhotoCell.h"

@interface PhotoCell ()



@end

@implementation PhotoCell


- (void)setImage:(UIImage *)image{
    
    _image = image;
    
    [self.backgroundBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    [self.backgroundBtn setBackgroundImage:[self resizeUIImage:image toWidth:self.backgroundBtn.bounds.size.width *0.8 height:self.backgroundBtn.bounds.size.height *0.8] forState:UIControlStateHighlighted];
    
//    self.imageV.image = image;
//    self.imageV.backgroundColor = [UIColor blackColor];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UIImage *)resizeUIImage:(UIImage *)image toWidth:(CGFloat)width height:(CGFloat)height{
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0.0f, 0.0f, width, height)];
    UIImage *newImage = [[UIImage alloc] init];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
