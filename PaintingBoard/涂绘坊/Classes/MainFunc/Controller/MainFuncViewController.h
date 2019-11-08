//
//  MainFuncViewController.h
//  涂绘坊
//
//  Created by dmt312 on 2019/9/3.
//  Copyright © 2019 xzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainFuncViewController : UIViewController



/**圆形的头像 */
@property(nonatomic,readwrite,strong) UIImage *roundImage;

/**昵称 */
@property(nonatomic,readwrite,strong) NSString *name;

/**年龄 */
@property(nonatomic,readwrite,strong) NSString *age;
@end

NS_ASSUME_NONNULL_END
