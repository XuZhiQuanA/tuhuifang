//
//  XZQNameButton.h
//  涂绘坊
//
//  Created by dmt312 on 2019/5/21.
//  Copyright © 2019 xzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQNameButton : UIButton
/**按钮的名称 */
@property(nonatomic,strong) NSString *name;

/**是否放大*/
@property(nonatomic,assign) BOOL isBigger;

/**变大之前的原始尺寸 用于恢复大小*/
@property(nonatomic,assign) CGRect originRect;

/**判断是否是innerBtn*/
@property(nonatomic,assign) BOOL isInnerBtn;


/**用于保存在线听录音暂停的CMTIme */
@property(nonatomic,readwrite,strong) AVPlayer *pauseTimePlayer;

/**是否在线听录音*/
@property(nonatomic,assign) BOOL isOnlineRecord;

/**是否点击了全部播放 - 对应与情节界面的全部播放*/
@property(nonatomic,assign) BOOL playAll;

/**点击了缓存听*/
@property(nonatomic,assign) BOOL enjoyAfterDownload;

/**画板中有个属性需要用到 增加了一个属性 记录原来的x*/
//@property(nonatomic,assign) CGFloat originX;

//用于故事界面传递故事动画的url - 或者用于存储系统音频URL
@property(nonatomic, strong) NSURL *storyVideoURL;

//自己的录音的url
@property(nonatomic, strong) NSURL *selfRecordURL;

//是不是自定义情节按钮
@property(nonatomic, assign) BOOL isSelfStoryPlotBtn;
@end

NS_ASSUME_NONNULL_END
