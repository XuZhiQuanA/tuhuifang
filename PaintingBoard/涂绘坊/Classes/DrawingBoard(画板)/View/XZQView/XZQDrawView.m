//
//  XZQDrawView.m
//  涂绘坊
//
//  Created by dmt312 on 2019/5/11.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQDrawView.h"

@interface XZQDrawView ()


@end

@implementation XZQDrawView



- (void)drawRect:(CGRect)rect {
//    NSLog(@"drawRect");
    
    // Drawing code
    
    
    //Point
    CGFloat point1X = self.frame.size.width * 0.1;
    
    CGFloat point1Y = self.frame.size.height * 0.0549;
    
    CGFloat point2X = self.frame.size.width * 0.36;//0.26
    CGFloat point2Y = self.frame.size.height * 0.0302;
    
    CGFloat point3X = self.frame.size.width * 0.62;
    CGFloat point3Y = self.frame.size.height * 0.0549;
    
    CGFloat point4X = self.frame.size.width * 0.88;
    CGFloat point4Y = self.frame.size.height * 0.0274;
    
    //第一个控制点 controllPoint
    CGFloat controlPoint1X = (point2X - point1X) * 2 / 4 + point1X;
    CGFloat controlPoint1Y = point1Y - (point2Y - point1Y) * 1 / 4 ;//按钮的问题 - 将小黑点的坐标传到drawingBoard中 然后进行坐标系转换 然后 设置按钮
    
    
    //1.取得图形上下文对象
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    
    //绘制贝塞尔曲线  设置移动的起始点
    CGContextMoveToPoint(context, point1X, point1Y);
    
    //绘制二次贝塞尔曲线 - 还有三次的
    /**
     第一个参数：控制点位置
     第二个参数：终止点位置
     */
    CGContextAddQuadCurveToPoint(context, controlPoint1X, controlPoint1Y, point2X, point2Y);
    
    //第二个控制点 - point2 x不变y加1/4
    CGFloat controlPoint2X = point2X + (point3X - point2X) * 3 / 4;
    CGFloat controlPoint2Y = point2Y;
    
    CGContextMoveToPoint(context, point2X, point2Y);
    CGContextAddQuadCurveToPoint(context, controlPoint2X, controlPoint2Y, point3X, point3Y);
    
    //第三个控制点 point3 x加1/3 y加1/4
    CGFloat controlPoint3X = point3X + (point4X - point3X) * 1 / 3;
    CGFloat controlPoint3Y = point3Y - (point4Y - point3Y) * 1 / 6;//point1Y - (point2Y - point1Y) * 1 / 4
    
    CGContextMoveToPoint(context, point3X, point3Y);
    CGContextAddQuadCurveToPoint(context, controlPoint3X, controlPoint3Y, point4X, point4Y);
    
    
    //设置颜色
    [[UIColor blackColor] setStroke];
    
    //绘制路径
//    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextDrawPath(context, kCGPathStroke);
    
    self.point1 = CGPointMake(point1X, point1Y);
    self.point2 = CGPointMake(point2X, point2Y);
    self.point3 = CGPointMake(point3X, point3Y);
    self.point4 = CGPointMake(point4X, point4Y);
    

    
    
}







@end
