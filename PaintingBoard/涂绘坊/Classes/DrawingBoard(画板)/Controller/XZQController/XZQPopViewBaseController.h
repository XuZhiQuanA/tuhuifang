//
//  XZQPopViewBaseController.h
//  涂绘坊
//
//  Created by dmt312 on 2019/5/20.
//  Copyright © 2019 xzq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZQCoverView;
@class XZQPopViewController;
NS_ASSUME_NONNULL_BEGIN

@interface XZQPopViewBaseController : UIViewController
/**popVc菜单 */
@property(nonatomic,strong) XZQPopViewController *popVc;

/**遮罩 */
@property(nonatomic,strong) XZQCoverView *coverView;
@end

NS_ASSUME_NONNULL_END
