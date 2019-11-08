//
//  XZQVideoPlayerController.h
//  涂绘坊
//
//  Created by dmt312 on 2019/5/12.
//  Copyright © 2019 xzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
@class AVPlayerItem;

NS_ASSUME_NONNULL_BEGIN

@interface XZQVideoPlayerController : UIViewController
/**视频外面的绿色的框 */
//@property(nonatomic,strong) UIView *backView;

@property (nonatomic , strong) AVPlayerItem *playerItem;

/**视频url */
@property(nonatomic,strong) NSURL *videoUrl;

//+ (instancetype)shareXZQVideoPlayerController;

@property(nonatomic,strong) NSMutableDictionary *videoPathDict;

//视频播放器
@property (nonatomic,strong)AVPlayer *player;

/**视频播放控制器 */
@property(nonatomic,strong) AVPlayerViewController *playerVC;

@property(nonatomic,strong) NSString *videoName;

@property(nonatomic,readwrite,strong) UIImage *televisionOutImage;

- (void)setView;

@end

NS_ASSUME_NONNULL_END
