//
//  SlideSelectCardView.h
//  ZJAnimationPopViewDemo
//
//  Created by abner on 2017/8/16.
//  Copyright © 2017年 Abnerzj. All rights reserved.
//

#import "ZJXibFoctory.h"

@protocol ZJXibFoctoryDelegate <NSObject>

@optional
/**
 通过弹框设置笔的粗细

 @param foctory ZJXibFoctory本身
 @param count 设置的宽度
 */
- (void)getCountFromZJXibFoctory:(ZJXibFoctory *)foctory count:(NSInteger)count;


/**
 通过弹框设置笔的颜色

 @param foctory ZJXibFoctory本身
 @param btn 颜色按钮
 */
- (void)setColorOfPencil:(ZJXibFoctory *)foctory colorBtn:(UIButton *)btn;



/**
 点击去除弹框

 @param foctory ZJXibFoctory本身
 @param btn 点击的取消按钮
 */
- (void)dismissPopView:(ZJXibFoctory *)foctory dismissBtn:(UIButton *)btn;


/**
 是否改变画板的颜色

 @param foctory self
 @param on 状态
 */
- (void)boardColorSwitchIsOn:(ZJXibFoctory *)foctory on:(BOOL)on;


/**
 隐藏两个关于描述笔触宽度的label

 @param foctory self
 @param label 文字
 @param widthCountLabel 数字
 */
- (void)hideWidthLabel:(ZJXibFoctory *)foctory widthLabel:(UILabel *)label widthCountLabel:(UILabel *)widthCountLabel;

@end

@interface SlideSelectCardView : ZJXibFoctory

@property (nonatomic, copy) void(^selectActionBlock)(NSUInteger currentPage);

/**标题文字 */
@property(nonatomic,readwrite,strong) NSString *title;

/**介绍文字 */
@property(nonatomic,readwrite,strong) NSString *showOperaion;

/**图片 */
@property(nonatomic,readwrite,strong) UIImage *image;

/** 代理*/
@property(nonatomic,readwrite,weak) id<ZJXibFoctoryDelegate> delegate;

/**录音文件夹recordSound路径 */
@property(nonatomic,readwrite,strong) NSString *recordSoundFolderPath;


/**给故事和情节配图 */
@property(nonatomic,readwrite,strong) UIImage *storyOrPlotImage;

/**保存音频下载进度 */
@property(nonatomic,readwrite,strong) UILabel *recordDownloadPersent;

@property (weak, nonatomic) IBOutlet UILabel *loadPersent;

@property (weak, nonatomic) IBOutlet UILabel *loadVideoPersent;

@property(nonatomic,readwrite,strong) UIImage *widthImage;

@property(nonatomic,readwrite,strong) UIImage *eraserImage;

//@property(nonatomic,readwrite,weak) UILabel *widthLabel;

//@property(nonatomic,readwrite,weak) UILabel *widthCountLabel;

//用于接收画册传递过来的系统的图片
@property(nonatomic, strong) UIImage *systemPicture;

@end
