//
//  AViewController.h
//  涂绘坊
//
//  Created by home on 2019/10/5.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQSmallWindowVideoViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AViewController : UIViewController
@property(nonatomic,readwrite,strong) UIImage *televisionOutImage;

@property(nonatomic, strong) NSURL *storyURL;

@property(nonatomic, strong) UIView *superFrameView;

@property(nonatomic, strong) AVPlayerViewController *playerVC;
@end

NS_ASSUME_NONNULL_END
