//
//  XZQSnowCoverView.m
//  涂绘坊
//
//  Created by dmt312 on 2019/7/18.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQSnowCoverView.h"
#import "SnowView.h"

@interface XZQSnowCoverView()


@property (nonatomic, strong) SnowView *snow;

@end

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation XZQSnowCoverView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)snowCoverView{
    XZQSnowCoverView *snow = [[XZQSnowCoverView alloc] init];
    
    [snow setupCAEmitterLayer];
    
    return snow;
}




#pragma mark -----------------------  CAEmitterLayer 粒子动画

- (void)setupCAEmitterLayer
{
    self.snow = [[SnowView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth + kScreenWidth*0.195313, kScreenWidth + kScreenWidth*0.195313)];
    //    self.snow.backgroundColor = [UIColor grayColor];
    [self addSubview:self.snow];
//    self.snow.snowImage  = [UIImage imageNamed:@"snow"];
    
    
    
    
//    self.snow.snowImage  = [UIImage imageNamed:@"pencil_1"];//PackSack_1
    self.snow.snowImage = [self smallerImage:[UIImage imageNamed:@"snow"]];

    self.snow.birthRate  = 200.f;
    self.snow.gravity    = 2.f;
    self.snow.snowColor  = [UIColor whiteColor];
    
    CALayer *layer    = [CALayer layer];
    layer.anchorPoint = CGPointMake(0, 0);                          // 重置锚点
    //    layer.bounds      = CGRectMake(0, 0, kScreenWidth / 2.f, kScreenWidth / 2.f);  // 设置尺寸
    layer.frame = CGRectMake(-kScreenWidth*0.585948,-kScreenHeight*0.520833, kScreenWidth+kScreenWidth *1.074219, kScreenHeight+kScreenWidth*0.683594);
    //    layer.bounds      = CGRectMake(0, 0, kScreenWidth  , kScreenHeight );  // 设置尺寸
    UIImage *image = [UIImage imageNamed:@"alpha"];
    if (image) {
        layer.contents = (__bridge id)(image.CGImage);
    }
    
    self.snow.layer.mask = layer;
    [self.snow showSnow];
}



/**
 改变一张图的大小

 @param image 指定的图片
 @return 返回一张30*30的图片大小
 */
- (UIImage *)smallerImage:(UIImage *)image{
    
    
    UIGraphicsBeginImageContext(CGSizeMake(30, 30));
    [image drawInRect: CGRectMake(0.0f, 0.0f, 30, 30)];
    UIImage *newImage = [[UIImage alloc] init];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



@end
