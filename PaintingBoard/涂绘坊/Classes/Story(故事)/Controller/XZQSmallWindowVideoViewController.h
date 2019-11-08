//
//  XZQSmallWindowVideoViewController.h
//  涂绘坊
//
//  Created by home on 2019/10/5.
//  Copyright © 2019 xzq. All rights reserved.
//
#import <UIKit/UIKit.h>

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQSmallWindowVideoViewController : UIViewController

@property(nonatomic,readwrite,strong) UIImage *televisionOutImage;

@property(nonatomic, strong) NSURL *storyURL;

@property(nonatomic, strong) UIView *superFrameView;

@property(nonatomic, strong) AVPlayerViewController *playerVC;

@property(nonatomic, assign) BOOL isColorBackgroundPopBox;

@end

NS_ASSUME_NONNULL_END
