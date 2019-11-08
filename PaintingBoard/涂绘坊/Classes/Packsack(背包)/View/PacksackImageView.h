//
//  PacksackImageView.h
//  涂绘坊
//
//  Created by dmt312 on 2019/6/5.
//  Copyright © 2019 xzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PacksackImageView : UIImageView

/**记录拖动前的frame */
@property(nonatomic,readwrite,assign) CGRect origionFrame;

@end

NS_ASSUME_NONNULL_END
