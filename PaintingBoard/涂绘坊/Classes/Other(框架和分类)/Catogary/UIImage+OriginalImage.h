//
//  UIImage+OriginalImage.h
//  涂绘坊
//
//  Created by dmt312 on 2019/9/11.
//  Copyright © 2019 xzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (OriginalImage)

+ (UIImage *)OriginalImageWithImage:(UIImage *)image;

+ (UIImage *)resizeUIImage:(UIImage *)image toWidth:(CGFloat)width height:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
