//
//  UIImage+OriginalImage.m
//  涂绘坊
//
//  Created by dmt312 on 2019/9/11.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "UIImage+OriginalImage.h"

@implementation UIImage (OriginalImage)

+ (UIImage *)OriginalImageWithImage:(UIImage *)image{
    
    UIImage *originalImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return originalImage;
    
}

+ (UIImage *)resizeUIImage:(UIImage *)image toWidth:(CGFloat)width height:(CGFloat)height{

    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0.0f, 0.0f, width, height)];
    UIImage *newImage = [[UIImage alloc] init];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
