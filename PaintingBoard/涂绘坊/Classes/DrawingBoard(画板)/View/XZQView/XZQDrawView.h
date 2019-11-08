//
//  XZQDrawView.h
//  涂绘坊
//
//  Created by dmt312 on 2019/5/11.
//  Copyright © 2019 xzq. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class XZQDrawView;
//@protocol XZQDrawViewDelegate <NSObject>
//
//- (void)setUpBtnWithPoint:(XZQDrawView *)drawView point1:(CGPoint)point1 point2:(CGPoint)point2 point3:(CGPoint)point3 point4:(CGPoint)point4;
//
//@end

NS_ASSUME_NONNULL_BEGIN

@interface XZQDrawView : UIView
///**屏幕宽度 */
//@property(nonatomic,assign) CGFloat viewWidth;
//
///**屏幕高度 */
//@property(nonatomic,assign) CGFloat viewHeight;

/**<#备注#> */
@property(nonatomic,assign) CGPoint point1;
/**<#备注#> */
@property(nonatomic,assign) CGPoint point2;
/**<#备注#> */
@property(nonatomic,assign) CGPoint point3;
/**<#备注#> */
@property(nonatomic,assign) CGPoint point4;

/**<#备注#>*/
//@property(nonatomic,assign) id<XZQDrawViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
