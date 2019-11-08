//
//  XZQPopViewController.h
//  涂绘坊
//
//  Created by dmt312 on 2019/5/12.
//  Copyright © 2019 xzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class XZQPopViewController;

@protocol XZQPopViewControllerDelegate <NSObject>

- (void)switchChildViewController:(XZQPopViewController *)popVC btn:(UIButton *)btn;

@end

//单例模式

@interface XZQPopViewController : UIViewController
/**<#备注#> */
@property(nonatomic,strong) UIImage *image;

/**名称 */
@property(nonatomic,readwrite,strong) NSString *name;

/**年龄 */
@property(nonatomic,readwrite,strong) NSString *age;

/**头像 */
@property(nonatomic,readwrite,strong) UIImage *accountImage2;

+ (instancetype)shareXZQPopViewController;

/**<#备注#>*/
@property(nonatomic,assign) id<XZQPopViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
