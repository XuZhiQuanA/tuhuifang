//
//  XZQStoryViewController.m
//  涂绘坊
//
//  Created by dmt312 on 2019/5/11.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQStoryViewController.h"
#import "XZQStoryBackgroundView.h"
#import "XZQPopViewController.h"
#import "XZQCoverView.h"
#import "XZQVideoPlayerController.h"
#import "XZQNameButton.h"
#import "XZQTabBarController.h"
#import "XZQSnowCoverView.h"
#import "SYAudio.h"

//弹框框架
#import "ZJAnimationPopView.h"
#import "SlideSelectCardView.h"

#import "XZQDrawingBoardViewController.h"

#import "UIImage+OriginalImage.h"

//#import <AVKit/AVKit.h>
//#import <AVFoundation/AVFoundation.h>

#import "XZQSmallWindowVideoViewController.h"


#define KeyWindow [UIApplication sharedApplication].keyWindow
#define Width self.view.frame.size.width
#define Height self.view.frame.size.height

/**
 录音音频：
 
 /var/mobile/Containers/Data/Application/8078E151-B453-47DD-AD78-106A2B76E370/Library/Caches/PHouse/recordSound
 listenToSelfAndWatchVideoFromXib方法中的 actuallName = threeBoys_2_selfRecord.mp3
 
 按钮名称：
 threeBoys_1
 
 mp3文件名称：
 threeBoys_1_selfRecord.mp3
 
 mp3文件路径:
 /var/mobile/Containers/Data/Application/0B76AB60-8F61-49EC-B659-0EE3E295990D/Library/Caches/PHouse/recordSound/threeBoys_1_selfRecord.mp3
 
 */

@interface XZQStoryViewController ()<AVPlayerViewControllerDelegate,NSURLSessionDataDelegate,SYAudioDelegate,ZJXibFoctoryDelegate,XZQDrawingBoardViewDelegate>
/**<#备注#> */
@property(nonatomic,strong) UIImageView *imageV;

/**最上面的透明部分 */
@property(nonatomic,strong) XZQStoryBackgroundView *view1;

/**父控制器 */
@property(nonatomic,weak) XZQTabBarController *tabBarVC;

/**详情按钮 */
@property(nonatomic,strong) XZQNameButton *returnToStory;

@property(nonatomic, weak) XZQNameButton *returnToMainFunc;

/**播放按钮 */
@property(nonatomic,strong) XZQNameButton *playBtn;

/**主页 */
//@property(nonatomic,strong) UIButton *mainBtn;

//跳转到主功能界面
@property(nonatomic, strong) UIButton *jumpToMainFuncIBButton;
/**文字 */
@property(nonatomic,strong) UILabel *storyName;

/**故事框数组 */
@property(nonatomic,strong) NSMutableArray *blankArray;

/**情节按钮外面的框数组 */
@property(nonatomic,readwrite,strong) NSMutableArray *detailsBtnArray;

/**情节按钮数组 */
@property(nonatomic,readwrite,strong) NSMutableArray *detailsPlotBtnArray;

@property(nonatomic,strong) XZQPopViewController *popVc;

//@property(nonatomic,strong) XZQCoverView *coverView;
@property(nonatomic,strong) XZQSnowCoverView *coverView;

/**视频播放器 */
@property(nonatomic,strong) XZQVideoPlayerController *videoPlayerController;


/**文件管理者 */
@property(nonatomic,strong) NSFileManager *manager;


/**视频左上角的退出按钮 透明了 看不到 但是和叉叉一样可以点击 */
@property(nonatomic,strong) UIButton *exitBtn;

/**根据exitFlag的值将退出按钮放在最上面 方便用户点击*/
@property(nonatomic,assign) BOOL exitFlag;

/**播放控制器 */
@property(nonatomic,strong) AVPlayerViewController *playerVC;

/**videoname */
@property(nonatomic,strong) NSString *videoName;

/**recordName */
@property(nonatomic,readwrite,strong) NSString *recordName;

/**<#备注#> */
@property(nonatomic,strong) UIView *playerVCView;

/**<#备注#>*/
@property(nonatomic,assign) BOOL startPictureInPicture;

//下载相关

/**PHouse文件夹 */
@property(nonatomic,readwrite,strong) NSString *phousePath;

/**视频文件夹路径 */
@property(nonatomic,readwrite,strong) NSString *videoFolderPath;

/**图片文件夹路径 */
@property(nonatomic,readwrite,strong) NSString *pictureFolderPath;

/**音频文件夹路径 */
@property(nonatomic,readwrite,strong) NSString *soundFolderPath;

/**画板文件夹路径 */
@property(nonatomic,readwrite,strong) NSString *paintingBoardFolderPath ;

/**文件句柄 */
@property(nonatomic,strong) NSFileHandle *handle;

/**音频文件句柄 */
@property(nonatomic,readwrite,strong) NSFileHandle *handleRecord;

/**下载文件的总大小 */
@property(nonatomic,assign) NSInteger totalSize;

/**下载音频文件的总大小*/
@property(nonatomic,assign) NSInteger totalRecordSize;

/**当前下载文件的大小*/
@property(atomic,assign) NSInteger currentSize;

/**当前音频文件的大小*/
@property(atomic,assign) NSInteger currentRecordSize;

/**下载视频任务 */
@property(nonatomic,strong) NSURLSessionDataTask *dataTask;

/**下载音频任务 */
@property(nonatomic,readwrite,strong) NSURLSessionDataTask *recordDataTask;

/**文件全路径 */
@property(nonatomic,strong) NSString *fullPath;//这个是视频文件的路径 - 点击完播放哪个视频之后 将btn.name 作为url的最后一部分 下载 拼接处完整的路径给fullPath

/**音频文件全路径 */
@property(nonatomic,readwrite,strong) NSString *fullRecordPath;

/**session */
@property(nonatomic,strong) NSURLSession *session;

/**Recordsession */
@property(nonatomic,readwrite,strong) NSURLSession *recordSession;

/**基础的URL */
@property(nonatomic,readwrite,strong) NSString *baseURL;

/**是否在下载中*/
@property(nonatomic,strong) NSMutableArray *downloadingArray;
//搞个数组 将正在下载的放进去 如果正在下载 就不调用下载方法了 下载完毕再移除

/**音频是否在下载中 */
@property(nonatomic,readwrite,strong) NSMutableArray *downloadingRecordArray;

/**视频加载百分比-添加到弹出框中 */
@property(nonatomic,readwrite,strong) UILabel *loadPersent;

/**音频加载百分比 */
@property(nonatomic,readwrite,strong) UILabel *loadRecordPersent;

/**弹出框控制器 */
@property(nonatomic,readwrite,strong) UIAlertController *alert;

/**弹出框控制器 - 里面有暂停下载等等内容 */
@property(nonatomic,readwrite,strong) UIAlertController *alert2;

/**下载音频时的弹框 */
@property(nonatomic,readwrite,strong) UIAlertController *downloadRecordAlert;

/**下载音频时的弹框2 */
@property(nonatomic,readwrite,strong) UIAlertController *downloadRecordAlert2;

/**是否在线还是缓存录音 */
@property(nonatomic,readwrite,strong) UIAlertController *alertRecord;

/**弹出选项 */
@property(nonatomic,readwrite,strong) UIAlertAction *knowAction;

/**暂停 */
@property(nonatomic,readwrite,strong) UIAlertAction *pauseAction;

/**取消 */
@property(nonatomic,readwrite,strong) UIAlertAction *cancelAction;

/** 继续 */
@property(nonatomic,readwrite,strong) UIAlertAction *continueAction;

/**字典 保存视频文件的总大小 */
@property(nonatomic,readwrite,strong) NSMutableDictionary *videoTotalSizeDict;

/**保存音频文件的总大小 */
@property(nonatomic,readwrite,strong)  NSMutableDictionary *recordTotalSizeDict ;

/**plist文件路径 */
@property(nonatomic,readwrite,strong) NSString *videoTotalSizePlistPath;

/**音频文件plist文件路径 */
@property(nonatomic,readwrite,strong) NSString *recordTotalSizePlistPath;

/**正在下载中的视频名称 */
@property(nonatomic,readwrite,strong) NSString *loadingVideoName;

/**正在下载的音频名称 */
@property(nonatomic,readwrite,strong) NSString *loadingRecordName;

/**弹框是否处于可见状态*/
@property(nonatomic,assign) BOOL popVisible;//因为如果在下载完毕的时候需要弹出弹框 但是用户没有将之前打开的弹框关闭 会引发错误 当一个弹框处于打开状态时 系统无法弹出第二个弹框

/**成功跳转到故事情节界面*/
@property(nonatomic,assign) BOOL alreadySkip;

/**当前点击的情节按钮 */
@property(nonatomic,readwrite,strong) XZQNameButton *currentNameBtn;

/**录音文件夹路径字典 */
@property(nonatomic,readwrite,strong) NSMutableDictionary *recordDict;

/**用于播放声音的AVPlayer */
@property(nonatomic,readwrite,strong) AVPlayer *recordPlayer;


/**在线播放界面的播放和暂停按钮 */
@property(nonatomic,readwrite,strong) XZQNameButton *playOrPauseBtn;

/**保存情节按钮外框的originRect */
@property(nonatomic,readwrite,strong) NSMutableDictionary *superRectDict;

/**保存情节按钮内部按钮的originRect */
@property(nonatomic,readwrite,strong) NSMutableDictionary *innerRectDict;



/**保存录音文件路径 */
@property(nonatomic,readwrite,strong) NSString *recordSoundFilePath;

/**录音文件夹路径 */
@property(nonatomic,readwrite,strong) NSString *recordSoundFolderPath;

/**caf文件夹路径 */
@property(nonatomic,readwrite,strong) NSString *cafFolderPath;
/**保存转换为mp3文件之后的路径 */
@property(nonatomic,readwrite,strong) NSString *recordSoundFilePathMP3;


/**是否录音限制时长*/
@property(nonatomic,assign) BOOL isLimitTime;
/**录音音量图像父视图 */
@property(nonatomic,readwrite,strong) UIView *imgView;
/**录音音量图像 */
@property(nonatomic,readwrite,strong) UIImageView *audioRecorderVoiceImgView;


/**自定义弹框内容 */
@property(nonatomic,readwrite,strong) SlideSelectCardView *customView;

/**自定义弹框 */
@property(nonatomic,readwrite,strong) ZJAnimationPopView *ZJAPopView;


/**存放录音文件的总数组 使用到此数组就直接从mp3文件中读取 */
@property(nonatomic,readwrite,strong) NSMutableArray *recordArray;

/**标注已经下载的视频 */
@property(nonatomic,readwrite,assign) BOOL alreadyDownloadVideo;

/**是否点击了右下角的录音按钮*/
@property(nonatomic,assign) BOOL isClickRightBottomBtn;

/**情节滚动条 */
@property(nonatomic,readwrite,strong) UIScrollView *plotScrollView;

//播放小窗口动画
@property(nonatomic, strong) XZQSmallWindowVideoViewController *smallStoryVideoVC;

//有电视机外框的 但是弹框背景是彩色的其中的播放器
@property(nonatomic, strong) XZQSmallWindowVideoViewController *colorBackgroundPopBoxVC;

@property(nonatomic, strong) XZQNameButton *nextPlot;

@property(nonatomic, strong) XZQNameButton *lastPlot;

/**录音按钮 */
@property(nonatomic,readwrite,strong) XZQNameButton *recordBtn;
//播放录音的按钮 放在遮罩里面的
@property(nonatomic, strong) XZQNameButton *recordSoundBtn;

//遮罩中的去学习画画按钮
@property(nonatomic, strong) XZQNameButton *toStudyPaintingBtn;

/**录音文件按钮 点击弹出录音文件列表 先留着 不删除 */
@property(nonatomic,readwrite,strong) XZQNameButton *recordFileBtn;

//判断听系统的音频还是自己录音
@property(nonatomic, assign) NSInteger listentoLocalOrSelfRecord;

//包含自定义情节图片的数组
@property(nonatomic, strong) NSMutableArray *containsSelfPlusPlotPictureArray;

//点击的加号次数
@property(nonatomic, assign) NSInteger plusClickCount;


/**
 效果1：
 将故事界面和情节界面的namebutton 故事和情节按钮放在滚动条中 只能竖直方向滚动 不能水平方向滚动(可以有弹簧效果)
 效果2：
 在情节界面点击加号 添加自定义情节 如果高度超过 增加滚动条的高度
 */

@end

@implementation XZQStoryViewController

#pragma lazy initialization
- (NSMutableArray *)containsSelfPlusPlotPictureArray{
    if(_containsSelfPlusPlotPictureArray == nil){
        _containsSelfPlusPlotPictureArray = [NSMutableArray array];
    }
    
    return _containsSelfPlusPlotPictureArray;
}



- (XZQSmallWindowVideoViewController *)smallStoryVideoVC{
    if (_smallStoryVideoVC == nil) {
        
        _smallStoryVideoVC = [[XZQSmallWindowVideoViewController alloc] init];
        _smallStoryVideoVC.view.frame = CGRectMake(10, -5, 550, 467);//1.1765
        _smallStoryVideoVC.televisionOutImage = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"drawboard_televisionOutFrame"]];
        _smallStoryVideoVC.view.backgroundColor = [UIColor clearColor];
//        [self addChildViewController:_smallStoryVideoVC];
        
    }
    
    [self.customView addSubview:_smallStoryVideoVC.view];
    
    return _smallStoryVideoVC;
}

- (XZQSmallWindowVideoViewController *)colorBackgroundPopBoxVC{
    if (_colorBackgroundPopBoxVC == nil) {
        _colorBackgroundPopBoxVC = [[XZQSmallWindowVideoViewController alloc] init];
        _colorBackgroundPopBoxVC.isColorBackgroundPopBox = true;
        _colorBackgroundPopBoxVC.view.frame = CGRectMake(10, 100, 537, 353);//557 373
        _colorBackgroundPopBoxVC.view.backgroundColor = [UIColor clearColor];
    }
    
    [self.customView addSubview:_colorBackgroundPopBoxVC.view];
    
    return _colorBackgroundPopBoxVC;
}

- (UIScrollView *)plotScrollView{
    
    if (_plotScrollView == nil) {
        
        _plotScrollView = [[UIScrollView alloc] init];
        _plotScrollView.frame = CGRectMake(60, 140, 900, 500);
//        _plotScrollView.alpha = 0.5;
        //scroll content
        _plotScrollView.contentSize = CGSizeMake(0, 600);
        _plotScrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_plotScrollView];
        
    }
    
    return _plotScrollView;
}

- (NSMutableArray *)recordArray{
    
    _recordArray = [NSMutableArray array];
    
    
    if (self.recordSoundFolderPath != nil) {
        
        NSArray *soundArray = [self.manager contentsOfDirectoryAtPath:self.recordSoundFolderPath error:nil];
        
        for (NSString *temp in soundArray) {
            
            if ([temp containsString:@"mp3"]) {
                
                NSString *mp3FilePath = [self.recordSoundFolderPath stringByAppendingPathComponent:temp];
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                
                [dict setValue:mp3FilePath forKey:@"FilePath"];
                NSString *fileName = [SYAudioFile SYAudioGetFileNameWithFilePath:mp3FilePath type:YES];
                [dict setValue:fileName forKey:@"FileName"];
                long long fileSize = [SYAudioFile SYAudioGetFileSizeWithFilePath:mp3FilePath];
                [dict setValue:@(fileSize) forKey:@"FileSize"];
                NSTimeInterval fileTime = [[SYAudio shareAudio].audioRecorder recorderDurationWithFilePath:mp3FilePath];
                [dict setValue:@(fileTime) forKey:@"FileTime"];
                
                [_recordArray addObject:dict];
            }
        }
        
    }else{
        NSLog(@"self.recordSoundFolderPath 是空的");
    }
    
    return _recordArray;
    
}

- (SlideSelectCardView *)customView{
    if (!_customView) {
        _customView = _customView = [SlideSelectCardView xib5];
    }
    
    return _customView;
}

- (UIView *)imgView{
    if (!_imgView) {
        _imgView = [[UIView alloc] init];
    }
    
    return _imgView;
}

- (UIImageView *)audioRecorderVoiceImgView{
    if (!_audioRecorderVoiceImgView) {
        _audioRecorderVoiceImgView = [[UIImageView alloc] init];
    }
    
    return _audioRecorderVoiceImgView;
}

- (NSMutableDictionary *)innerRectDict{
    if (!_innerRectDict) {
        _innerRectDict = [NSMutableDictionary dictionary];
    }
    
    return _innerRectDict;
}

- (NSMutableDictionary *)superRectDict{
    if (!_superRectDict) {
        _superRectDict = [NSMutableDictionary dictionary];
    }
    
    return _superRectDict;
}

- (XZQNameButton *)playOrPauseBtn{
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [[XZQNameButton alloc] init];
        
//        _playOrPauseBtn.frame = CGRectMake(Width *0.06,Height*0.229167,Width* 0.0698 ,Width* 0.0698);
        _playOrPauseBtn.frame = CGRectMake(Width *0.19,Height*0.8035,Width* 0.0723 ,Width* 0.0723);
        //        [self.view addSubview:_playOrPauseBtn];
        
//        [self.coverView addSubview:_playOrPauseBtn];
        //
        [self.view addSubview:_playOrPauseBtn];
        
        [_playOrPauseBtn addTarget:self action:@selector(playOrPauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    if (_playOrPauseBtn.isBigger) {
//        [_playOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_playOrPauseBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"storyPlot_playBtn"]] forState:UIControlStateNormal];
    }else{
        [_playOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"storyPlot_pauseBtn"] forState:UIControlStateNormal];
    }
    
    return _playOrPauseBtn;
}

- (XZQNameButton *)nextPlot{
    if (_nextPlot == nil) {
//        _nextPlot = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextPlot = [[XZQNameButton alloc] init];
        
        
        _nextPlot.frame = CGRectMake(Width *0.87,Height*0.429167,Width* 0.0698 ,Width* 0.12464);
                
        [self.view addSubview:_nextPlot];
        
        [_nextPlot addTarget:self action:@selector(toNextPlot) forControlEvents:UIControlEventTouchUpInside];
        
        [_nextPlot setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"main_rightArrow"]] forState:UIControlStateNormal];
    }
    
    return _nextPlot;
}

- (XZQNameButton *)lastPlot{
    if (_lastPlot == nil) {
        _lastPlot = [XZQNameButton buttonWithType:UIButtonTypeCustom];
        
//        _lastPlot.frame = CGRectMake(Width *0.06,Height*0.429167,Width* 0.0698 ,Width* 0.0698);
        _lastPlot.frame = CGRectMake(Width *0.06,Height*0.429167,Width* 0.0698 ,Width* 0.12464);
                
        [self.view addSubview:_lastPlot];
        
        [_lastPlot addTarget:self action:@selector(toLastPlot) forControlEvents:UIControlEventTouchUpInside];
        
        [_lastPlot setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"main_leftArrow"]] forState:UIControlStateNormal];
    }
    
    return _lastPlot;
}

- (XZQNameButton *)recordBtn{
    if (_recordBtn == nil) {
     
        CGFloat detailsX = Width * 0.37;
        CGFloat detailsY = Height*0.8035;
        CGFloat detailsW = Width * 0.0723;
        CGFloat detailsH = Width * 0.0723;
        
        //录音按钮右下角
        XZQNameButton *recordBtn = [[XZQNameButton alloc] init];
        recordBtn.tag = 11;
        recordBtn.frame = CGRectMake(detailsX, detailsY, detailsW, detailsH);
//        [recordBtn setBackgroundImage:[UIImage imageNamed:@"sound_12.png"] forState:UIControlStateNormal];
        [recordBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"storyPlot_recordBtn"]] forState:UIControlStateNormal];
        [recordBtn addTarget:self action:@selector(rightBottomBtnPop:) forControlEvents:UIControlEventTouchUpInside];
       
        
        [self.view addSubview:recordBtn];
        _recordBtn = recordBtn;
    }
    
    return _recordBtn;
}

- (XZQNameButton *)recordSoundBtn{
    if (_recordSoundBtn == nil) {
        CGFloat detailsX = Width * 0.55;
        CGFloat detailsY = Height*0.8035;
        CGFloat detailsW = Width * 0.0723;
        CGFloat detailsH = Width * 0.0723;
        
        //遮罩中的播放录音按钮
        XZQNameButton *recordSoundBtn = [[XZQNameButton alloc] init];
        recordSoundBtn.tag = 12;
        recordSoundBtn.frame = CGRectMake(detailsX, detailsY, detailsW, detailsH);
//        [recordBtn setBackgroundImage:[UIImage imageNamed:@"sound_12.png"] forState:UIControlStateNormal];
        [recordSoundBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"storyPlot_recordSoundBtn"]] forState:UIControlStateNormal];
//        [recordSoundBtn addTarget:self action:@selector(rightBottomBtnPop:) forControlEvents:UIControlEventTouchUpInside];
        
        //播放录音按钮 - 保存的时候是以 按钮的名字 + Self... 保存的
        //先查找缓存中有没有对应的录音文件 没有直接弹框 告诉没有对应的录音 有则立即播放这个录音
        [recordSoundBtn addTarget:self action:@selector(playSelfRecord) forControlEvents:UIControlEventTouchUpInside];
        
       
        
        [self.view addSubview:recordSoundBtn];
        _recordSoundBtn = recordSoundBtn;
    }
    
    return _recordSoundBtn;
}

- (XZQNameButton *)toStudyPaintingBtn{
    if (_toStudyPaintingBtn == nil) {
            CGFloat detailsX = Width * 0.73;
            CGFloat detailsY = Height*0.8035;
            CGFloat detailsW = Width * 0.0723;
            CGFloat detailsH = Width * 0.0723;
            
            //遮罩中的播放录音按钮
            XZQNameButton *toStudyPaintingBtn = [[XZQNameButton alloc] init];
            toStudyPaintingBtn.tag = 13;
            toStudyPaintingBtn.frame = CGRectMake(detailsX, detailsY, detailsW, detailsH);
    //        [recordBtn setBackgroundImage:[UIImage imageNamed:@"sound_12.png"] forState:UIControlStateNormal];
            [toStudyPaintingBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"storyPlot_toStudyBtn"]] forState:UIControlStateNormal];
            [toStudyPaintingBtn addTarget:self action:@selector(toStudyThisFromXib) forControlEvents:UIControlEventTouchUpInside];
           
            
            [self.view addSubview:toStudyPaintingBtn];
            _toStudyPaintingBtn = toStudyPaintingBtn;
        }
        
        return _toStudyPaintingBtn;
}

- (XZQNameButton *)recordFileBtn{
    if (_recordFileBtn == nil) {

        
        //录音文件按钮左下角
        CGFloat recordFileBtnX = self.view.frame.size.width * 0.0523;
        CGFloat recordFileBtnY = self.view.frame.size.height * 0.8498;
        CGFloat recordFileBtnW = self.view.frame.size.width * 0.1;
        CGFloat recordFileBtnH = self.view.frame.size.width * 0.066;//width/height = 1.52
        
        XZQNameButton *recordFileBtn = [[XZQNameButton alloc] init];
        recordFileBtn.tag = 10;
        recordFileBtn.frame = CGRectMake(recordFileBtnX, recordFileBtnY, recordFileBtnW, recordFileBtnH);
        [recordFileBtn setBackgroundImage:[UIImage imageNamed:@"sound_7_new.png"] forState:UIControlStateNormal];
        [recordFileBtn addTarget:self action:@selector(recordFileBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:recordFileBtn];
        _recordFileBtn = recordFileBtn;
        
        
        //先不用这个功能
        _recordFileBtn.alpha = 0;
    }

    return _recordFileBtn;
}

- (AVPlayer *)recordPlayer{
    if (!_recordPlayer) {
        _recordPlayer = [[AVPlayer alloc] init];
    }
    
    return _recordPlayer;
}

- (NSMutableDictionary *)recordDict{
    if (!_recordDict) {
        _recordDict = [NSMutableDictionary dictionary];
        
    }
    
    return _recordDict;
}
- (NSString *)videoTotalSizePlistPath{
    if (!_videoTotalSizePlistPath) {
        _videoTotalSizePlistPath = [self.phousePath stringByAppendingPathComponent:@"videoTotalSizeDictPath.plist"];
    }
    
    return _videoTotalSizePlistPath;
}

- (NSString *)recordTotalSizePlistPath{
    if (!_recordTotalSizePlistPath) {
        _recordTotalSizePlistPath = [self.phousePath stringByAppendingPathComponent:@"recordTotalSizeDictPath.plist"];
    }
    
    return _recordTotalSizePlistPath;
}

- (NSMutableDictionary *)videoTotalSizeDict{
    if (!_videoTotalSizeDict) {
        _videoTotalSizeDict = [NSMutableDictionary dictionary];
    }
    
    return _videoTotalSizeDict;
}

- (NSMutableDictionary *)recordTotalSizeDict{
    if (!_recordTotalSizeDict) {
        _recordTotalSizeDict = [NSMutableDictionary dictionary];
    }
    
    return _recordTotalSizeDict;
}



//下载完毕使用这个alert
- (UIAlertController *)alert{
    
    //    if (!_alert) {
    
    _alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof (_alert) weakAlert = _alert;
    
    UIAlertAction* knowAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           //响应事件
                                                           
                                                           [self dismissViewControllerAnimated:YES completion:nil];
                                                           
                                                           //在这里将loadPersent从_alert中移除或者弄两个label
                                                           
                                                           for (UIView *view in weakAlert.view.subviews) {
                                                               
                                                               if (view.tag == 12) {
                                                                   [view removeFromSuperview];
                                                                   
                                                                   return ;
                                                               }
                                                           }
                                                           
                                                       }];
    
    BOOL flag = false;
    
    for (UIView *view in _alert.view.subviews) {
        
        if (view.tag == 12) {
            flag = true;
        }
    }
    
    if (!flag) {
        [_alert.view addSubview:self.loadPersent];
    }
    
    
    
    [_alert addAction:knowAction];
    
    
    //    }
    
    self.loadPersent.text = @"加载完成";
    
    return _alert;
}

//下载过程中使用这个alert2
- (UIAlertController *)alert2{
    if (!_alert2) {
        
        _alert2 = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* knowAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               //响应事件
                                                               
                                                               [self dismissViewControllerAnimated:YES completion:nil];
                                                               
                                                           }];
        
        
        
        
        
        
        
        //暂停下载
        UIAlertAction* pauseAction = [UIAlertAction actionWithTitle:@"暂停下载" style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {
                                                                //响应事件
                                                                
                                                                NSLog(@"暂停下载");
                                                                
                                                                //暂停
                                                                [self.dataTask suspend];
                                                                
                                                                self.loadPersent.text = [@"暂停中，资源已下载:" stringByAppendingString:[NSString stringWithFormat:@"%.1f%%",(1.0 * self.currentSize / self.totalSize) * 100]];
                                                                
                                                            }];
        
        
        
        //取消下载
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消下载" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                 //响应事件
                                                                 NSLog(@"取消下载");
                                                                 //取消下载
                                                                 [self.dataTask cancel];
                                                                 
                                                                 self.loadPersent.text = nil;
                                                                 self.dataTask = nil;
                                                                 
                                                                 
                                                                 //将对应的视频文件资源删除掉 并且从plist文件中删除
                                                                 Boolean isSuccess = [self.manager removeItemAtPath:self.fullPath error:nil];
                                                                 
                                                                 if (isSuccess) {
                                                                     NSLog(@"删除成功");
                                                                 }else{
                                                                     NSLog(@"删除失败");
                                                                 }
                                                                 
                                                                 //点击取消下载 将正在下载列表中的对应视频删除
                                                                 for (NSString *temp in self.downloadingArray) {
                                                                     
                                                                     if ([temp isEqualToString:self.loadingVideoName]) {
                                                                         
                                                                         [self.downloadingArray removeObject:temp];
                                                                         return ;
                                                                     }
                                                                 }
                                                                 
                                                                 [self dismissViewControllerAnimated:YES completion:nil];
                                                                 
                                                             }];
        
        //继续下载
        UIAlertAction* continueAction = [UIAlertAction actionWithTitle:@"继续下载" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   //响应事件
                                                                   NSLog(@"继续下载");
                                                                   //继续下载
                                                                   [self.dataTask resume];
                                                                   
                                                                   
                                                               }];
        [_alert2 addAction:knowAction];
        [_alert2 addAction:pauseAction];
        [_alert2 addAction:cancelAction];
        [_alert2 addAction:continueAction];
        
        __weak typeof (_alert2) weakAlert2 = _alert2;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakAlert2.view addSubview:self.loadPersent];
        }];
        
        
        
    }
    
    return _alert2;
}


- (UIAlertController *)downloadRecordAlert{
    
    _downloadRecordAlert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof (_downloadRecordAlert) weakAlert = _downloadRecordAlert;
    
    UIAlertAction* knowAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           //响应事件
                                                           
                                                           [self dismissViewControllerAnimated:YES completion:nil];
                                                           
                                                           //在这里将loadPersent从_alert中移除或者弄两个label
                                                           
                                                           for (UIView *view in weakAlert.view.subviews) {
                                                               
                                                               if (view.tag == 12) {
                                                                   [view removeFromSuperview];
                                                                   
                                                                   return ;
                                                               }
                                                           }
                                                           
                                                       }];
    
    BOOL flag = false;
    
    for (UIView *view in _downloadRecordAlert.view.subviews) {
        
        if (view.tag == 12) {
            flag = true;
        }
    }
    
    if (!flag) {
        [_downloadRecordAlert.view addSubview:self.loadRecordPersent];
    }
    
    
    
    [_downloadRecordAlert addAction:knowAction];
    
    self.loadRecordPersent.text = @"加载完成";
    
    return _downloadRecordAlert;
}

//下载过程中使用这个alert2
- (UIAlertController *)downloadRecordAlert2{
    if (!_downloadRecordAlert2) {
        
        _downloadRecordAlert2 = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* knowAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               //响应事件
                                                               
                                                               [self dismissViewControllerAnimated:YES completion:nil];
                                                               
                                                           }];
        
        
        
        
        
        
        
        //暂停下载
        UIAlertAction* pauseAction = [UIAlertAction actionWithTitle:@"暂停下载" style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {
                                                                //响应事件
                                                                
                                                                NSLog(@"暂停下载");
                                                                
                                                                //暂停
                                                                [self.recordDataTask suspend];
                                                                
                                                                self.loadRecordPersent.text = [@"暂停中，资源已下载:" stringByAppendingString:[NSString stringWithFormat:@"%.1f%%",(1.0 * self.currentRecordSize / self.totalRecordSize) * 100]];
                                                                
                                                            }];
        
        
        
        //取消下载
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消下载" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                 //响应事件
                                                                 NSLog(@"取消下载");
                                                                 //取消下载
                                                                 [self.recordDataTask cancel];
                                                                 
                                                                 self.loadRecordPersent.text = nil;
                                                                 self.recordDataTask = nil;
                                                                 
                                                                 
                                                                 //将对应的视频文件资源删除掉 并且从plist文件中删除
                                                                 Boolean isSuccess = [self.manager removeItemAtPath:self.fullRecordPath error:nil];
                                                                 
                                                                 if (isSuccess) {
                                                                     NSLog(@"删除成功");
                                                                 }else{
                                                                     NSLog(@"删除失败");
                                                                 }
                                                                 
                                                                 //点击取消下载 将正在下载列表中的对应视频删除
                                                                 for (NSString *temp in self.downloadingRecordArray) {
                                                                     
                                                                     if ([temp isEqualToString:self.loadingRecordName]) {
                                                                         
                                                                         [self.downloadingRecordArray removeObject:temp];
                                                                         return ;
                                                                     }
                                                                 }
                                                                 
                                                                 [self dismissViewControllerAnimated:YES completion:nil];
                                                                 
                                                             }];
        
        //继续下载
        UIAlertAction* continueAction = [UIAlertAction actionWithTitle:@"继续下载" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   //响应事件
                                                                   NSLog(@"继续下载");
                                                                   //继续下载
                                                                   [self.recordDataTask resume];
                                                                   
                                                                   
                                                               }];
        [_downloadRecordAlert2 addAction:knowAction];
        [_downloadRecordAlert2 addAction:pauseAction];
        [_downloadRecordAlert2 addAction:cancelAction];
        [_downloadRecordAlert2 addAction:continueAction];
        
        __weak typeof (_downloadRecordAlert2) weakAlert2 = _downloadRecordAlert2;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakAlert2.view addSubview:self.loadRecordPersent];
        }];
        
        
        
    }
    
    return _downloadRecordAlert2;
}



- (UIAlertController *)alertRecord{
    
    if (!_alertRecord) {
        _alertRecord = [UIAlertController alertControllerWithTitle:@"音频信息" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *onlineAction = [UIAlertAction actionWithTitle:@"在线听" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //在线听操作 操作放在
            self.currentNameBtn.isOnlineRecord = true;
            NSLog(@"点击了在线听 isOnlineRecord = %d",self.currentNameBtn.isOnlineRecord);
            
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"onlineRecord" object:nil];
            
            //点击在线播放
            //            self.currentNameBtn.userInteractionEnabled = NO;
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        
        UIAlertAction *downloadAction = [UIAlertAction actionWithTitle:@"缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            //点击
            XZQNameButton *superBtn = (XZQNameButton *)self.currentNameBtn.superview;
            
            superBtn.userInteractionEnabled = YES;
            
            self.currentNameBtn.isOnlineRecord = false;
            
            //应该是你点击缓存的时候才去建立对应的文件夹
            [self createRecordFile:self.currentNameBtn];
            
            //缓存操作
            self.currentNameBtn.isBigger = false;
            
            //响应事件
            self.loadingRecordName = self.currentNameBtn.name;
            
            //下载视频到对应文件夹
            [self downloadRecord:self.currentNameBtn];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
        }];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.currentNameBtn.isOnlineRecord = NO;
            //取消操作
            self.currentNameBtn.isBigger = NO;
            self.currentNameBtn.superview.userInteractionEnabled = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertAction *recordAction = [UIAlertAction actionWithTitle:@"听自己的录音" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"听录音");
            self.currentNameBtn.isOnlineRecord = NO;
            //取消操作
//            self.currentNameBtn.isBigger = NO;
//            self.currentNameBtn.superview.userInteractionEnabled = YES;
            
            //调用方法变大并且播放自己的录音
            [self recordBtnClick:self.currentNameBtn];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [self.alertRecord addAction:onlineAction];
        [self.alertRecord addAction:downloadAction];
        [self.alertRecord addAction:cancelAction];
        [self.alertRecord addAction:recordAction];
    }
    
    return _alertRecord;
}

//加入alert2中
- (UILabel *)loadPersent{
    
    if (!_loadPersent) {
        
        
        _loadPersent = [[UILabel alloc] init];
        _loadPersent.textAlignment = NSTextAlignmentCenter;
        _loadPersent.frame = CGRectMake(0, 0, Width * 0.26367, Height * 0.05599);
        _loadPersent.tag = 12;
    }
    
    return _loadPersent;
}

- (UILabel *)loadRecordPersent{
    
    if (!_loadRecordPersent) {
        
        
        _loadRecordPersent = [[UILabel alloc] init];
        _loadRecordPersent.textAlignment = NSTextAlignmentCenter;
        _loadRecordPersent.frame = CGRectMake(0, 0, Width * 0.26367, Height * 0.05599);
        _loadRecordPersent.tag = 12;
    }
    
    return _loadRecordPersent;
    
}


- (NSMutableArray *)downloadingArray{
    
    if (!_downloadingArray) {
        _downloadingArray = [NSMutableArray array];
    }
    
    return _downloadingArray;
}

- (NSMutableArray *)downloadingRecordArray{
    
    if (!_downloadingRecordArray) {
        _downloadingRecordArray = [NSMutableArray array];
    }
    
    return _downloadingRecordArray;
    
}

- (NSFileManager *)manager{
    if (!_manager) {
        _manager = [NSFileManager defaultManager];
    }
    
    return _manager;
}

- (NSString *)baseURL{
    if (!_baseURL) {
//                _baseURL = @"http://2yq4580241.zicp.vip:35683";
        _baseURL = @"http://192.168.43.152:8080";//wangyan.wicp.vip:47693
//        _baseURL = @"http://wangyan.wicp.vip:47693";
    }
    
    return _baseURL;
}

- (NSURLSession *)session{
    if (_session == nil) {
        //3.创建会话对象 - 设置代理
        
        //下载放在子线程中执行
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
        
    }
    
    return _session;
}

- (NSURLSession *)recordSession{
    if (!_recordSession) {
        _recordSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _recordSession;
}

- (UIView *)coverView{
    if (_coverView == nil) {
        
        _coverView = [XZQSnowCoverView snowCoverView];
        
    }
    
    return _coverView;
}

- (NSMutableArray *)blankArray{
    if (_blankArray == nil) {
        _blankArray = [NSMutableArray array];
    }
    return _blankArray;
}

- (NSMutableArray *)detailsBtnArray{
    if (_detailsBtnArray == nil) {
        _detailsBtnArray = [NSMutableArray array];
    }
    return _detailsBtnArray;
    
}

- (NSMutableArray *)detailsPlotBtnArray{
    if (!_detailsPlotBtnArray) {
        _detailsPlotBtnArray = [NSMutableArray array];
    }
    
    return _detailsPlotBtnArray;
}

//- (UIButton *)mainBtn{
//    if (_mainBtn == nil) {
//        _mainBtn = [[UIButton alloc] init];
//        [self.view addSubview:_mainBtn];
//    }
//    return _mainBtn;
//}

- (UIButton *)jumpToMainFuncIBButton{
    if(_jumpToMainFuncIBButton == nil){
        _jumpToMainFuncIBButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_jumpToMainFuncIBButton];
        _jumpToMainFuncIBButton.alpha = 0;
    }
    
    return _jumpToMainFuncIBButton;
}

- (XZQNameButton *)playBtn{
    
    if (_playBtn == nil) {
        
        _playBtn = [[XZQNameButton alloc] init];
//        _playBtn.center = CGPointMake(-Width, -Height);
        [self.view addSubview:_playBtn];
        
    }
    return _playBtn;
}

- (UILabel *)storyName{
    if (_storyName == nil) {
        _storyName = [[UILabel alloc] init];
        //        _storyName.backgroundColor = [UIColor blackColor];
        //        _storyName.alpha = 0.6;
        [self.view addSubview:_storyName];
    }
    return _storyName;
}

- (XZQNameButton *)details{
    if (_returnToStory == nil) {
        _returnToStory = [[XZQNameButton alloc] init];
        _returnToStory.name = @"returnToStory";
        [self.view addSubview:_returnToStory];
    }
    return _returnToStory;
}

- (XZQNameButton *)returnToMainFunc{
    
    if (_returnToMainFunc == nil) {
        
        XZQNameButton *btn = [[XZQNameButton alloc] init];
        btn.name = @"returnToStory";
        [self.view addSubview:btn];
        
        _returnToMainFunc = btn;
        
    }
    
    return _returnToMainFunc;
}

- (UIImageView *)imageV{
    if (_imageV == nil) {
        _imageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.imageV];
    }
    
    return _imageV;
}

- (XZQStoryBackgroundView *)view1{
    if (_view1 == nil) {
        _view1 = [[XZQStoryBackgroundView alloc] init];
        
        [self.view addSubview:_view1];
        
    }
    
    return _view1;
}

- (UIButton *)exitBtn{
    if (_exitBtn == nil) {
        //退出全屏的按钮
        _exitBtn = [[UIButton alloc] init];
        [_exitBtn addTarget:self action:@selector(exitVideo) forControlEvents:UIControlEventTouchUpInside];
        _exitBtn.backgroundColor = [UIColor clearColor];
        _exitBtn.frame = CGRectMake(Width*0.014648, Height*0.032552, Width*0.048828, Height*0.065104);
        _exitBtn.alpha = 0;
    }
    
    return _exitBtn;
}


//点击故事按钮 调用
- (void)playStory:(XZQNameButton *)btn{
    
    NSLog(@"点了按钮%@",btn.name);
    
    self.currentNameBtn = btn;
    
    

    
    
    //点击按钮 给fullPath赋值 查找视频有没有下载完毕 - 请求的时候 建立一个plist文件也行 将文件的大小 保存在里面 读文件就行 - 下载的时候
    //点击按钮进行检查 是否下载完毕
    
    
    //为了补充下载过程中的url
    self.videoName = btn.name;
    
    //建立视频、音频等媒体存储文件夹
    [self createMediaDownloadPath:btn];//点击按钮之后 fullPath就变成了谁的path了
    
    if ([self.downloadingArray containsObject:btn.name]) {//BAD ACCESS 坏访问 访问了一块不存在的内存
        
        //弹出提示框 正在下载 下载完毕 从数组中移除
        NSLog(@"进入了如果downloadingArray如果包含当前按钮 启动alert2");
        [self popUpBoxDownload:btn.name message:@"正在加载中" btnContentOne:@"知道了"];
        return;
        
    }
    
    //按钮没有故事名 - 没有url 返回
    if (!btn.name) {
        [self popUpBoxDownloadVideo:btn alertTitle:@"更多故事" message:@"未知的世界，等待您的探索！" saveAction:@"好的" onlineAction:nil cancelAction:nil skipAction:@"跳过动画，直接看故事情节" alreadyDownload:YES];
        
        return;
    }
    
    if (!self.playerVC) {
        self.playerVC = [[AVPlayerViewController alloc] init];
    }
    
    //现在：点击故事按钮 - 发现没有这个视频 - 然后弹出提示 - 提示下载 - 下载完成 - 自动播放 - 点击更多 - 提示框提示等待
    //没有视频播放文件夹 说明没有下载过视频
    if (!self.videoFolderPath) {
        return;
    }
    
    //自定义一个按钮 - 按钮有个name值 点击了按钮 是要播放视频的 按钮的name值和沙盒中的视频文件名称对比 一样就播放
    
    //遍历文件夹
    NSDirectoryEnumerator *enumerator = [self.manager enumeratorAtPath:self.videoFolderPath];
    
    NSString *filePath = nil;
    
    //开始遍历文件夹 //filePath就是文件的名称
    while (nil != (filePath = [enumerator nextObject])) {
        
        if ([btn.name isEqualToString:filePath]) {
            
            //下载好的和没有下载完的都会调用这个方法
            
            //如果视频没有下载完毕
            //判断有没有视频文件
            NSInteger integer = [self getFileSize];
            
            
            if (integer != 0) {
                
                //遍历字典取出的是key
                
                //如果plist文件存在的话 那么字典中的数据需要从plist文件中读取
                self.videoTotalSizeDict = [[NSMutableDictionary alloc] initWithContentsOfFile:self.videoTotalSizePlistPath];
                
                for (NSString *temp in self.videoTotalSizeDict) {
                    
                    if ([temp isEqualToString:btn.name]) {
                        
                        
                        
                        NSString *currentSize = [NSString stringWithFormat:@"%ld",integer];
                        NSString *totalSize = [self.videoTotalSizeDict objectForKey:temp];
                        
                        //判断大小是否和totalSize相同
                        if ([currentSize isEqualToString:totalSize] == NO) {//没有进if中 !不能用？
                            
                            //不同则代表没有下载完毕 弹出提示框 需要继续 下载 从原来没有下载完的地方开始下载
                            
                            NSLog(@"currentSize=%@ totalSize=%@",currentSize,totalSize);
                            
                            
                            //弹出 继续下载
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:btn.name message:@"没有下载完毕" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *rightAction = [UIAlertAction actionWithTitle:@"继续下载剩余部分" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                                if (![self.downloadingArray containsObject:btn.name]) {
                                    [self.downloadingArray addObject:btn.name];
                                }
                                
                                
                                
                                [self.dataTask resume];
                            }];
                            
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                                
                            }];
                            
                            
                            [alert addAction:rightAction];
                            [alert addAction:cancelAction];
                            
                            [self presentViewController:alert animated:YES completion:nil];
                            
                            return;
                            
                        }
                        
                        
                    }
                    
                    
                    
                }
                
                
                
            }
            
            
            [self popUpBoxDownloadVideo:btn alertTitle:btn.name message:btn.name saveAction:@"马不停蹄地想看～" onlineAction:@"暂时梳理梳理激动的心情，先不看辽～" cancelAction:nil skipAction:@"跳过动画，直接看故事情节" alreadyDownload:YES];
            //下载过程中 文件是否存在文件夹中 存在
            
            
            return;
        }
        
    }
    
    NSLog(@"本地没有该视频!");
    //内存中不存在视频的 来到这里
    
    
    //弹出框进行提示
    [self popUpBoxDownloadVideo:btn alertTitle:btn.name message:[NSString stringWithFormat:@"精彩又刺激的%@故事动画你还没有哦，想要获取它吗？",btn.name] saveAction:@"缓存到本地" onlineAction:@"在线播放" cancelAction:@"取消" skipAction:@"跳过动画，直接看故事情节" alreadyDownload:NO];
}

#pragma 显示加号按钮
- (void)showAddBtn{
    
    if (self.playBtn.playAll) {
        
        for (XZQNameButton *btn in self.detailsPlotBtnArray) {
            
            if ([btn.name isEqualToString:@"plus"]) {
                
                btn.alpha = 1;
                btn.superview.alpha = 1;
                
                return;
            }
        }
    }
    
}


#pragma 情节按钮点击
- (void)detailsBtnClick:(XZQNameButton *)btn{
    
    NSLog(@"detailsBtnClick - tag = %ld",btn.tag);

    //show plus button
    [self showAddBtn];
    
    if (!btn.isInnerBtn) {
        
        return;
    }
    //情节按钮点击之后currentNameBtn有值了
    self.currentNameBtn = btn;
    
    XZQNameButton *superBtn = (XZQNameButton *)btn.superview;
    
    //情节按钮的名称是plus 做响应的操作
    if ([superBtn.name isEqualToString:@"plus"]) {
        
        //弹出跳转画板界面的弹框
        [self popSkipToDrawboard];
        return;
    }
    
    self.recordName = btn.name;
    
    
    if ([self.downloadingRecordArray containsObject:[btn.name stringByAppendingString:@".mp3"]]) {
        [self popUpBoxRecordDownload:btn.name message:@"正在加载中" btnContentOne:@"知道了"];
        
        
        //弹出弹框

        return;
    }
    
    if (!self.soundFolderPath) {
        return;
    }
    
    //遍历音频文件夹
    NSDirectoryEnumerator *enumertator = [self.manager enumeratorAtPath:self.soundFolderPath];
    
    NSString *filePath = nil;
    
    //开始遍历文件夹
    while (nil != (filePath = [enumertator nextObject])) {
        
        NSLog(@"录音文件的名称为 = %@",filePath);
        
        //因为存的时候都是以.mp3结尾的 btn.name 没有.mp3后缀
        NSString *newBtnName = [btn.name stringByAppendingString:@".mp3"];
        
        if ([newBtnName isEqualToString:filePath]) {
            
            
            NSLog(@"btn.name == filePath - filePath=%@",filePath);
            
            
            NSInteger integer = [self getRecordFileSize];
            
            if (integer != 0) {
                
                NSLog(@"integer == %ld",integer);
                
                self.recordTotalSizeDict = [[NSMutableDictionary alloc] initWithContentsOfFile:self.recordTotalSizePlistPath];
                
                
                for (NSString *temp in self.recordTotalSizeDict) {
                    
                    NSLog(@"进入了recordTotalSizeDict内部");
                    NSLog(@"temp = %@ newBtnName = %@",temp,newBtnName);
                    
                    if ([temp isEqualToString:newBtnName]) {
                        
                        NSLog(@"[temp isEqualToString:newBtnName]");
                        
                        NSString *currentSize = [NSString stringWithFormat:@"%ld",integer];
                        NSString *totalSize = [self.recordTotalSizeDict objectForKey:temp];
                        
                        if ([currentSize isEqualToString:totalSize] == NO) {
                            
                            NSLog(@"currentRecordSize = %@ totalRecordSize = %@",currentSize,totalSize);
                            
                            UIAlertController *alertRecord = [UIAlertController alertControllerWithTitle:btn.name message:@"没有下载完毕" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *rightAction = [UIAlertAction actionWithTitle:@"继续下载剩余部分" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                                if (![self.downloadingRecordArray containsObject:newBtnName]) {
                                    
                                    [self.downloadingRecordArray addObject:newBtnName];
                                }
                                
                                [self.recordDataTask resume];
                            }];
                            
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                
                            }];
                            
                            [alertRecord addAction:rightAction];
                            [alertRecord addAction:cancelAction];
                            
                            [self presentViewController:alertRecord animated:YES completion:nil];
                            
                            return;
                        }else{
                            
                            
                            NSLog(@"本地存在对应文件 将要播放");
                            [self recordBaseOperation];
                            
                            return;
                        }
                        
                    }
                }
            }
            
        }
    }
    
    NSLog(@"本地没有%@音频",btn.name);
    
    //情节按钮在缩小状态时弹框
    if (btn.isBigger) {
        
        
        //弹出在线听还是缓存的弹框
        [self popAboutRecord:btn];
        
        superBtn.userInteractionEnabled = NO;
        
    }
    
}

#pragma mark -----------------------------
#pragma mark ZJXibFoctory弹框

//点击plus调用
- (void)popSkipToDrawboard{
    
    self.plusClickCount += 1;
    
    ZJAnimationPopStyle popStyle =  ZJAnimationPopStyleShakeFromTop;
    ZJAnimationDismissStyle dismissStyle = ZJAnimationDismissStyleDropToBottom;
    
    self.customView = nil;
    _customView = [SlideSelectCardView xib4];
    
    self.customView.title = @"天马行空的想象力";
    self.customView.showOperaion = @"使用 画板 画 出一个 你 想要的 故事情节 吧！";
    self.customView.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"main_paintBoard"]];
    
    
//    self.customView.storyOrPlotImage = [UIImage imageNamed:@"logoOfStory7"];
//    self.customView.storyOrPlotImage = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"main_paintBoard"]];
    self.customView.delegate = self;
    
    
    
    
    
    
    //给即将要保存的图片赋值路径
    [self postPathToWillBeSavedPicture];
    
    
    // 1.初始化
    ZJAnimationPopView *popView = [[ZJAnimationPopView alloc] initWithCustomView:self.customView popStyle:popStyle dismissStyle:dismissStyle];
    self.ZJAPopView = popView;
    
    // 2.设置属性，可不设置使用默认值，见注解
    
    // 2.2 显示时背景的透明度
    popView.popBGAlpha = 0.5f;
    // 2.3 显示时是否监听屏幕旋转
    popView.isObserverOrientationChange = YES;
    // 2.4 显示时动画时长
    //    popView.popAnimationDuration = 0.8f;
    // 2.5 移除时动画时长
    //    popView.dismissAnimationDuration = 0.8f;
    
    // 2.6 显示完成回调
    popView.popComplete = ^{
        NSLog(@"显示完成");
    };
    // 2.7 移除完成回调
    popView.dismissComplete = ^{
        NSLog(@"移除完成");
    };
    
    // 4.显示弹框
    [popView pop];
    
}


#pragma 弹出框

- (void)popUpBoxDownloadVideo:(XZQNameButton *)btn alertTitle:(NSString *)title message:(NSString *)message saveAction:(NSString *)save onlineAction:(NSString *)delete cancelAction:(NSString *)cancel skipAction:(NSString *)skip alreadyDownload:(BOOL)flag{
    
//    NSString *originTitle = title;
    
    self.alreadyDownloadVideo = flag;
    
    //转换字符串
    if ([title isEqualToString:@"matchGirl.mp4"]) {
        
        title = @"卖火柴的小女孩";
        
        
    }else if ([title isEqualToString:@"Crazy_little_original_hunter.mp4"]){
        
        title = @"疯狂原始小猎人";
        
    }else if ([title isEqualToString:@"girlOfSea.mp4"]){
        
        title = @"海的女儿";
    }
    
    
    //如果一样的话 说明是已经下载的视频
//    if (flag) {
//
//        NSString *base = @"  即将开始啦～";
//
//        message = [title stringByAppendingString:base];
//
//
//    }else{//本地没有该视频 缓存到本地
//
//        NSString *base1 = @"精彩又刺激的  ";
//        NSString *base2 = @"  故事动画你还没有哦，想看吗？";
//
//        message = [base1 stringByAppendingString:title];
//        message = [message stringByAppendingString:base2];
//
//    }
    
    
    

    
    
    
    
    
    
    
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
//                                                                   message:message
//                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    //之前写的疯狂原始小猎人是没有图片的 所以没有跳过动画情节部分
//    if ([title isEqualToString:@"疯狂原始小猎人"] == NO) {
//        //显示弹出框列表选择
//
//        //    alert.view.alpha = 0;
//
//        //如果已经存在的视频 不要使用
//
//
//
//        //跳过动画部分
//        UIAlertAction* skipAction = [UIAlertAction actionWithTitle:skip style:UIAlertActionStyleDefault
//                                                           handler:^(UIAlertAction * action) {
//                                                               //响应事件
//
//                                                               //                                                           NSLog(@"跳过了动画");
//
//
//                                                               //将故事视图隐藏 - 将情节界面展示出来
//                                                               //隐藏的话 直接将4个按钮隐藏掉 操作blankArray就行
//                                                               for (UIView *view in self.blankArray) {
//                                                                   view.alpha = 0;
//                                                               }
//
//                                                               //建立一个存储录音的文件夹 - 根据btn的name建立不同的录音文件夹
//                                                               //                                                           [self createRecordFile:btn];
//
//                                                               //调用另外的方法显示情节界面
//                                                               [self showStoryDetails];
//
//                                                           }];
//
//        [alert addAction:skipAction];
//
//    }
    
    
//    if (flag) {
//
//        //
//        UIAlertAction* saveAction = [UIAlertAction actionWithTitle:save style:UIAlertActionStyleCancel
//                                                           handler:^(UIAlertAction * action) {
//                                                               //响应事件
//
//                                                               [self videoBaseOperation];
//
//                                                           }];
//
//        [alert addAction:saveAction];
//
//        //如果save是nil - 说明点击了more
//        if (delete) {
//
//            UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:delete style:UIAlertActionStyleDestructive
//                                                                 handler:^(UIAlertAction * action) {
//                                                                     //响应事件
//
//
//
//                                                                     [self dismissViewControllerAnimated:YES completion:nil];
//                                                                 }];
//
//            [alert addAction:deleteAction];
//        }
//
//
//
//
//    }else{//没有缓存
//
//        //下载
//
//        if ([title isEqualToString:@"疯狂原始小猎人"]) {
//
//            UIAlertAction* studyAction = [UIAlertAction actionWithTitle:@"去学习" style:UIAlertActionStyleDefault
//                                                                handler:^(UIAlertAction * action) {
//
//                                                                    //回到画板界面
//
//
//                                                                    self.tabBarController.selectedIndex = 0;
//
//                                                                    NSString *EnglishName = [originTitle stringByReplacingOccurrencesOfString:@".mp4" withString:@""];
//
//                                                                    NSString *path = [self.baseURL stringByAppendingPathComponent:originTitle];
//
//                                                                    NSURL *onlineURL = [NSURL URLWithString:path];
//
//                                                                    //开始播放教学视频
//                                                                    //                                                                   if ([self.delegate respondsToSelector:@selector(playVideoOnline:videoURL:)]) {
//                                                                    //                                                                       [self.delegate playVideoOnline:self videoURL:onlineURL];
//                                                                    //
//                                                                    //                                                                   }
//
//
//                                                                    //开始播放教学视频
//                                                                    //                                                                   if ([self.delegate respondsToSelector:@selector(playVideoOnline:videoURL:ChineseName:EnglishName:)]) {
//                                                                    //                                                                       [self.delegate playVideoOnline:self videoURL:onlineURL ChineseName:title EnglishName:EnglishName];
//                                                                    //                                                                   }
//
//                                                                    //开始播放教学视频
//                                                                    if ([self.delegate respondsToSelector:@selector(playVideoOnline:videoURL:ChineseName:EnglishName:superPath:)]) {
//                                                                        [self.delegate playVideoOnline:self videoURL:onlineURL ChineseName:title EnglishName:EnglishName superPath:self.pictureFolderPath];
//                                                                    }
//
//                                                                    //                                                                   if ([self.delegate respondsToSelector:@selector(playVideoOnline:videoURL:ChineseName:EnglishName:superPath:superPaintingBoardPath:)]) {
//                                                                    //                                                                       [self.delegate playVideoOnline:self videoURL:onlineURL ChineseName:title EnglishName:EnglishName superPath:self.pictureFolderPath superPaintingBoardPath:self.paintingBoardFolderPath];
//                                                                    //                                                                   }
//
//
//
//                                                                }];
//            [alert addAction:studyAction];
//
//        }
//
//
//        UIAlertAction* saveAction = [UIAlertAction actionWithTitle:save style:UIAlertActionStyleCancel
//                                                           handler:^(UIAlertAction * action) {
//
//
//                                                               //响应事件
//                                                               self.loadingVideoName = btn.name;
//
//                                                               //下载视频到对应文件夹
//                                                               [self downloadVideo:btn];
//
//
//                                                           }];
//
//        //不下载
//        UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:delete style:UIAlertActionStyleDestructive
//                                                             handler:^(UIAlertAction * action) {
//
//
//
//                                                                 //调用在线播放功能
//
//                                                                 [self onlinePlayer:btn.name];
//
//
//                                                             }];
//
//        //取消
//        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleDefault
//                                                             handler:^(UIAlertAction * action) {
//
//
//                                                                 [self dismissViewControllerAnimated:YES completion:nil];
//
//
//                                                             }];
//
//        [alert addAction:cancelAction];
//
//        [alert addAction:saveAction];
//
//        [alert addAction:deleteAction];
    
        BOOL flag2 = false;
        
        for (UIView *view in self.alert2.view.subviews) {
            
            if (view.tag == 12) {
                flag2 = true;
            }
        }
        
        if (!flag2) {
            [self.alert2.view addSubview:self.loadPersent];
        }
    
    
    
    
    //点击故事弹出弹框放在这里: 将这里封装的代码放在点击xib按钮调用的方法中 与情节按钮区分的话用tag区分就行了
    //弹出弹框
    ZJAnimationPopStyle popStyle =  ZJAnimationPopStyleShakeFromBottom;
    ZJAnimationDismissStyle dismissStyle = ZJAnimationDismissStyleDropToTop;
    
    self.customView = nil;
    
    if (btn.name != nil) {
        
        //故事情节 在线播放 缓存本地 学习课程 取消
//        _customView = [SlideSelectCardView xib6];
        
        //弹出带有视频播放器的弹框 //有小电视机外框
//        _customView = [SlideSelectCardView xib14];
        
        if ([btn.name isEqualToString:@"matchGirl"]) {
            
            _customView = [SlideSelectCardView xib8];
            self.customView.title = @"《卖火柴的小女孩》";
            self.customView.showOperaion = @"视频和故事情节请耐心等待更新哦";
            
//            self.customView.storyOrPlotImage = [UIImage imageNamed:@"logoOfStory7"];
            self.customView.storyOrPlotImage = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"story_matchGirl"]];
            
        }else if ([btn.name isEqualToString:@"smallRed"]){
            _customView = [SlideSelectCardView xib8];
            self.customView.title = @"《小红帽》";
            self.customView.showOperaion = @"视频和故事情节请耐心等待更新哦";
            
//            self.customView.storyOrPlotImage = [UIImage imageNamed:@"logoOfStory7"];
            self.customView.storyOrPlotImage = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"story_smallRed"]];
        }else if ([btn.name isEqualToString:@"kong"]){
                    _customView = [SlideSelectCardView xib8];
                    self.customView.title = @"《孔融让梨》";
                    self.customView.showOperaion = @"视频和故事情节请耐心等待更新哦";
                    
        //            self.customView.storyOrPlotImage = [UIImage imageNamed:@"logoOfStory7"];
                    self.customView.storyOrPlotImage = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"kong"]];
        }else if ([btn.name isEqualToString:@"wen"]){
                    _customView = [SlideSelectCardView xib8];
                    self.customView.title = @"《闻鸡起舞》";
                    self.customView.showOperaion = @"视频和故事情节请耐心等待更新哦";
                    
        //            self.customView.storyOrPlotImage = [UIImage imageNamed:@"logoOfStory7"];
                    self.customView.storyOrPlotImage = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"wen"]];
        }else if ([btn.name isEqualToString:@"you"]){
                    _customView = [SlideSelectCardView xib8];
                    self.customView.title = @"《游子吟》";
                    self.customView.showOperaion = @"视频和故事情节请耐心等待更新哦";
                    
        //            self.customView.storyOrPlotImage = [UIImage imageNamed:@"logoOfStory7"];
                    self.customView.storyOrPlotImage = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"wen"]];
        }else if ([btn.name isEqualToString:@"zao"]){
                    _customView = [SlideSelectCardView xib8];
                    self.customView.title = @"《凿壁偷光》";
                    self.customView.showOperaion = @"视频和故事情节请耐心等待更新哦";
                    
        //            self.customView.storyOrPlotImage = [UIImage imageNamed:@"logoOfStory7"];
                    self.customView.storyOrPlotImage = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"zao"]];
        }else{
            //无小电视机外框
            _customView = [SlideSelectCardView xib16];
            self.customView.title = title;
        }
        
    }else{
        _customView = [SlideSelectCardView xib8];
        self.customView.title = @"更多故事";
        self.customView.showOperaion = @"更多故事等待你的探索";
        
        self.customView.storyOrPlotImage = [UIImage imageNamed:@"logoOfStory7"];
    }
    
    
    
    
    //    self.customView.showOperaion = @"即将切换到故事界面";
    
    self.customView.delegate = self;
    
    // 1.初始化
    ZJAnimationPopView *popView = [[ZJAnimationPopView alloc] initWithCustomView:self.customView popStyle:popStyle dismissStyle:dismissStyle];
    self.ZJAPopView = popView;
    
    // 2.设置属性，可不设置使用默认值，见注解
    
    // 2.2 显示时背景的透明度
    popView.popBGAlpha = 0.5f;
    // 2.3 显示时是否监听屏幕旋转
    popView.isObserverOrientationChange = YES;
    // 2.4 显示时动画时长
    //    popView.popAnimationDuration = 0.8f;
    // 2.5 移除时动画时长
    //    popView.dismissAnimationDuration = 0.8f;
    
    // 2.6 显示完成回调
    
    
    popView.popComplete = ^{
        NSLog(@"显示完成");
        
        
        
        
    };
    // 2.7 移除完成回调
    popView.dismissComplete = ^{
        NSLog(@"移除完成");
        
        //下载过的
        //        if (flag) {
        //
        //            //移除完成后
        //            [self videoBaseOperation];
        //
        //
        //            if (delete) {
        //
        //            }
        //        }
        
    };
    
    // 4.显示弹框
    [popView pop];
    
    //小窗口视频播放 有电视机外框时

//    if (btn.storyVideoURL != nil) {
//        self.smallStoryVideoVC.view.alpha = 1;
//        self.smallStoryVideoVC.storyURL = btn.storyVideoURL;
//    }else{
//        //点击更多故事 没有提供资源的故事不让弹出电视机
//        self.smallStoryVideoVC.view.alpha = 0;
//    }
    
    //小窗口视频播放 没有电视机外框时
    if (btn.storyVideoURL != nil) {
        self.colorBackgroundPopBoxVC.view.alpha = 1;
        self.colorBackgroundPopBoxVC.storyURL = btn.storyVideoURL;
    }else{
        //点击更多故事 没有提供资源的故事不让弹出电视机
        self.colorBackgroundPopBoxVC.view.alpha = 0;
    }
    
    
    
    
    return;
    
    //    [self presentViewController:alert animated:YES completion:nil];
    
        
    }


//下载中 调用此弹框
- (void)popUpBoxDownload:(NSString *)title message:(NSString *)message btnContentOne:(NSString *)one{
    
    
    //转换字符串
    if ([title isEqualToString:@"yaowei_1.mp4"]) {
        title = @"白雪公主";
        
        //    }else if ([title isEqualToString:@"haizei_1.mp4"]){
        //        title = @"海贼王";
    }else if ([title isEqualToString:@"qingqukatong_05.mp4"]){
        title = @"卖火柴的小女孩";
    }else if ([title isEqualToString:@"video_1.mp4"]){
        title = @"海的女儿";
    }
    
    if (one != nil) {
        
        //下载进度
        
        [self presentViewController:self.alert2 animated:YES completion:^{
            self.popVisible = YES;
        }];
        
        
        
        
        
        //这里涉及到下载进度的显示 新建一个xib 将进度框数据放在里面
        //弹出弹框
        ZJAnimationPopStyle popStyle =  ZJAnimationPopStyleShakeFromTop;
        ZJAnimationDismissStyle dismissStyle = ZJAnimationDismissStyleDropToBottom;
        
        self.customView = nil;
        _customView = [SlideSelectCardView xib10];
        
        self.customView.title = @"视频下载";
        //        self.customView.showOperaion = @"即将切换到故事界面";
        //        self.customView.image = [UIImage imageNamed:@"logoOfStory7"];
        self.customView.storyOrPlotImage = [UIImage imageNamed:@"logoOfStory7"];
        self.customView.delegate = self;
        //        self.customView.recordDownloadPersent.text = self.loadRecordPersent.text;
        self.customView.loadVideoPersent.text = self.loadPersent.text;
        
        // 1.初始化
        ZJAnimationPopView *popView = [[ZJAnimationPopView alloc] initWithCustomView:self.customView popStyle:popStyle dismissStyle:dismissStyle];
        self.ZJAPopView = popView;
        
        // 2.设置属性，可不设置使用默认值，见注解
        
        // 2.2 显示时背景的透明度
        popView.popBGAlpha = 0.5f;
        // 2.3 显示时是否监听屏幕旋转
        popView.isObserverOrientationChange = YES;
        // 2.4 显示时动画时长
        //    popView.popAnimationDuration = 0.8f;
        // 2.5 移除时动画时长
        //    popView.dismissAnimationDuration = 0.8f;
        
        // 2.6 显示完成回调
        popView.popComplete = ^{
            NSLog(@"显示完成");
        };
        // 2.7 移除完成回调
        popView.dismissComplete = ^{
            NSLog(@"移除完成");
        };
        
        // 4.显示弹框
        [popView pop];
        
        self.popVisible = YES;
        
        
        
        
        
        
    }else{
        
        [self presentViewController:self.alert animated:YES completion:^{
            self.popVisible = YES;
        }];
        
        
    }
    
}

//下载音频中 调用此弹框
- (void)popUpBoxRecordDownload:(NSString *)title message:(NSString *)message btnContentOne:(NSString *)one{
    
    
    if (one != nil) {
        
        //下载进度
        
//        [self presentViewController:self.downloadRecordAlert2 animated:YES completion:^{
//            self.popVisible = YES;
//        }];
        
        //这里涉及到下载进度的显示 新建一个xib 将进度框数据放在里面
        //弹出弹框
        ZJAnimationPopStyle popStyle =  ZJAnimationPopStyleShakeFromTop;
        ZJAnimationDismissStyle dismissStyle = ZJAnimationDismissStyleDropToBottom;
        
        self.customView = nil;
        _customView = [SlideSelectCardView xib9];
        
        self.customView.title = @"音频下载";
//        self.customView.showOperaion = @"即将切换到故事界面";
//        self.customView.image = [UIImage imageNamed:@"logoOfStory7"];
        self.customView.storyOrPlotImage = [UIImage imageNamed:@"logoOfStory7"];
        self.customView.delegate = self;

//        self.customView.loadPersent.text = self.loadPersent.text;
        self.customView.loadPersent.text = self.loadRecordPersent.text;
        
        
        
        // 1.初始化
        ZJAnimationPopView *popView = [[ZJAnimationPopView alloc] initWithCustomView:self.customView popStyle:popStyle dismissStyle:dismissStyle];
        self.ZJAPopView = popView;
        
        // 2.设置属性，可不设置使用默认值，见注解
        
        // 2.2 显示时背景的透明度
        popView.popBGAlpha = 0.5f;
        // 2.3 显示时是否监听屏幕旋转
        popView.isObserverOrientationChange = YES;
        // 2.4 显示时动画时长
        //    popView.popAnimationDuration = 0.8f;
        // 2.5 移除时动画时长
        //    popView.dismissAnimationDuration = 0.8f;
        
        // 2.6 显示完成回调
        popView.popComplete = ^{
            NSLog(@"显示完成");
        };
        // 2.7 移除完成回调
        popView.dismissComplete = ^{
            NSLog(@"移除完成");
        };
        
        // 4.显示弹框
        [popView pop];
        
        self.popVisible = YES;
        
    }else{
        
        
        ZJAnimationPopStyle popStyle =  ZJAnimationPopStyleShakeFromTop;
        ZJAnimationDismissStyle dismissStyle = ZJAnimationDismissStyleDropToBottom;
        
        [self.ZJAPopView dismiss];
        self.customView = nil;
        _customView = [SlideSelectCardView xib8];
        
        self.customView.title = @"音频加载完成";
        self.customView.showOperaion = @"";
        //        self.customView.image = [UIImage imageNamed:@"logoOfStory7"];
        self.customView.storyOrPlotImage = [UIImage imageNamed:@"logoOfStory7"];
        self.customView.delegate = self;
//        self.customView.recordDownloadPersent = self.loadPersent;
        
        // 1.初始化
        ZJAnimationPopView *popView = [[ZJAnimationPopView alloc] initWithCustomView:self.customView popStyle:popStyle dismissStyle:dismissStyle];
        self.ZJAPopView = popView;
        
        // 2.设置属性，可不设置使用默认值，见注解
        
        // 2.2 显示时背景的透明度
        popView.popBGAlpha = 0.5f;
        // 2.3 显示时是否监听屏幕旋转
        popView.isObserverOrientationChange = YES;
        // 2.4 显示时动画时长
        //    popView.popAnimationDuration = 0.8f;
        // 2.5 移除时动画时长
        //    popView.dismissAnimationDuration = 0.8f;
        
        // 2.6 显示完成回调
        popView.popComplete = ^{
            NSLog(@"显示完成");
        };
        
//        __weak typeof (_downloadRecordAlert) weakAlert = _downloadRecordAlert;
        
        // 2.7 移除完成回调
        popView.dismissComplete = ^{
            NSLog(@"移除完成");
            
            
            
            
            //在这里将loadPersent从_alert中移除或者弄两个label
            
//            for (UIView *view in weakAlert.view.subviews) {
//
//                if (view.tag == 12) {
//                    [view removeFromSuperview];
//
//                    return ;
//                }
//            }
//
//            BOOL flag = false;
//
//            for (UIView *view in weakAlert.view.subviews) {
//
//                if (view.tag == 12) {
//                    flag = true;
//                }
//            }
//
//            if (!flag) {
//                [weakAlert.view addSubview:self.loadRecordPersent];
//            }
//
//
//
//
//
//            self.loadRecordPersent.text = @"加载完成";
            
        };
        
        // 4.显示弹框
        [popView pop];
        
        self.popVisible = YES;
        
        
        
    }
    
}

#pragma 设置self.fullRecordPath
- (void)createRecordFile:(XZQNameButton *)btn{
    
    //首先看看有没有对应的文件夹
    //没有建立 有直接返回
    
    //判断一下是否已经存在
    NSString *recordFilePath = [self.soundFolderPath stringByAppendingPathComponent:btn.name];
    
    recordFilePath = [recordFilePath stringByAppendingString:@".mp3"];
    
    NSLog(@"createRecordFile:%@",recordFilePath);
    
    self.fullRecordPath = recordFilePath;
    
    
    
    return;
}

#pragma 显示故事情节
- (void)showStoryDetails{
    
    //将之前展示的故事情节全部从容器中清空
    [self removeAllPlotBeforeShow];
    
    self.plotScrollView.alpha = 1;
    for (UIView *view in self.detailsBtnArray) {
        view.alpha = 1;
    }
    
    self.storyName.text = @"故 事 情 节";
    self.alreadySkip = YES;
    self.playBtn.alpha = 1;
    
    NSLog(@"%@",self.storyName.text);
    
    //一次性代码 - 只执行一次 - 解决了重复调用重复添加子控件的问题
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        
        
        //添加情节滚动条
        self.plotScrollView.backgroundColor = [UIColor clearColor];
        
        int columns = 4;
        
        
        
        
        CGFloat blankW = self.view.frame.size.width * 0.1870;
        CGFloat blankH = self.view.frame.size.height * 0.1679;
//        CGFloat blankX = self.view.frame.size.width * 0.0637;
//        CGFloat blankY = self.view.frame.size.height * 0.1919;
        CGFloat blankX = Width *0.005106;
        CGFloat blankY = Height *0.009608;
        
        
//        CGFloat cx = self.plotScrollView.frame.origin.x - blankX;
//        CGFloat cy = self.plotScrollView.frame.origin.y - blankY;
//        NSLog(@"x = %f y = %f persent:%f %f",cx,cy,cx/Width *1.0,cy/Height *1.0);
//
        CGFloat intervalW = self.view.frame.size.width * 0.0389;
        CGFloat intervalH = self.view.frame.size.height *0.028902;
        
        
//        展示卖火柴的小女孩的故事情节
        if ([self.currentNameBtn.name isEqualToString:@"matchGirl"]) {
            
            //故事书的框框
            for (int i = 0; i < 11; i++) {
                
                XZQNameButton *btn = [[XZQNameButton alloc] init];
                
                btn.name = [NSString stringWithFormat:@"details_matchGirl_%d",i+1];
                
                if (i == 10) {
                    btn.name = @"plus";
                }else{
//                    [btn setBackgroundImage:[UIImage imageNamed:@"blank"] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"storyPlot_superViewFrame"]] forState:UIControlStateNormal];
                }
                
                
                
                btn.tag = i+200;
                [btn addTarget:self action:@selector(detailsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.detailsBtnArray addObject:btn];
    //            [self.view addSubview:btn];
                [self.plotScrollView addSubview:btn];
                
                CGFloat x = blankX + (i % columns) * (blankW + intervalW);
                CGFloat y = blankY + (i / columns) * (blankH + intervalH);
                
                btn.frame = CGRectMake(x, y, blankW, blankH);
                
                //            [self.superRectDict setValue:@(btn.frame) forKey:btn.name];
                [self.superRectDict setObject:NSStringFromCGRect(btn.frame) forKey:btn.name];
                
                
            }

            //故事书
            
            //书本加入到框框中
            for (XZQNameButton *btn in self.detailsBtnArray) {
                
                CGFloat innerBtnX = btn.frame.size.width * 0.011;
                CGFloat innerBtnY = btn.frame.size.height * 0.0165;
                CGFloat innerBtnW = btn.frame.size.width * 0.978;
                CGFloat innerBtnH = btn.frame.size.height * 0.97;
                
                
                XZQNameButton *innerBtn = [[XZQNameButton alloc] init];
                innerBtn.isInnerBtn = YES;
                
                [btn addSubview:innerBtn];
                
                //最后一个加号的框不要
    //            if (btn.tag == 210) {
                if (btn.tag == 210) {
                    
                    
                    innerBtn.center = CGPointMake(btn.bounds.size.width *0.5, btn.bounds.size.height *0.5);

                    innerBtn.bounds = CGRectMake(0, 0, btn.bounds.size.width *0.6, btn.bounds.size.width *0.6);
                    
                    
                    
                }else{
                    innerBtn.frame = CGRectMake(innerBtnX, innerBtnY, innerBtnW, innerBtnH);
                }
                
                
                
                [innerBtn addTarget:self action:@selector(detailsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                
                [self.detailsPlotBtnArray addObject:innerBtn];
                
                switch (btn.tag) {
                    case 200:
                        [innerBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
                        
                        btn.name = @"details_matchGirl_1";
                        
                        break;
                        
                    case 201:
                        [innerBtn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
                        
                        btn.name = @"details_matchGirl_2";
                        break;
                        
                    case 202:
                        
                        [innerBtn setBackgroundImage:[UIImage imageNamed:@"3"] forState:UIControlStateNormal];
                        
                        
                        btn.name = @"details_matchGirl_3";
                        break;
                        
                    case 203:
                        [innerBtn setBackgroundImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
                        btn.name = @"details_matchGirl_4";
                        
                        break;
                    case 204:
                        [innerBtn setBackgroundImage:[UIImage imageNamed:@"5"] forState:UIControlStateNormal];
                        btn.name = @"details_matchGirl_5";
                        
                        
                        break;
                        
                    case 205:
                        
                        [innerBtn setBackgroundImage:[UIImage imageNamed:@"6"] forState:UIControlStateNormal];
                        btn.name = @"details_matchGirl_6";
                        
                        
                        break;
                        
                    case 206:
                        [innerBtn setBackgroundImage:[UIImage imageNamed:@"7"] forState:UIControlStateNormal];
                        btn.name = @"details_matchGirl_7";
                        
                        
                        break;
                        
                    case 207:
                        [innerBtn setBackgroundImage:[UIImage imageNamed:@"8"] forState:UIControlStateNormal];
                        btn.name = @"details_matchGirl_8";
                        
                        
                        break;
                        
                        
                    case 208:
                        [innerBtn setBackgroundImage:[UIImage imageNamed:@"9"] forState:UIControlStateNormal];
                        btn.name = @"details_matchGirl_9";
                        
                        
                        break;
                        
                    case 209:
                        [innerBtn setBackgroundImage:[UIImage imageNamed:@"10"] forState:UIControlStateNormal];
                        btn.name = @"details_matchGirl_10";
                        
                        
                        break;
                        
                    case 210:
                        [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"storyPlot_add"]]  forState:UIControlStateNormal];
                        btn.name = @"plus";
                        btn.tag = 1998;
    //                    [innerBtn setImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"storyPlot_add"]] forState:UIControlStateNormal];
                        
                        break;
                        
                    default:
                        break;
                }
                
                innerBtn.name = btn.name;
                innerBtn.tag = btn.tag;
                
                //系统音频url
                btn.storyVideoURL = [self recordWithTag:btn.tag];
                innerBtn.storyVideoURL = [self recordWithTag:innerBtn.tag];
                
                [self.innerRectDict setObject:NSStringFromCGRect(innerBtn.frame) forKey:innerBtn.name];
                
            }
            
            
        }else if ([self.currentNameBtn.name isEqualToString:@"threeBoys"]){
            
            //第5个是plus按钮
            //添加情节父控件
            for (NSInteger i = 0; i < 13; i++) {
                
                XZQNameButton *btn = [[XZQNameButton alloc] init];
                            
                btn.name = [NSString stringWithFormat:@"threeBoys_%ld",i+1];
                
                if (i == 12) {
                    btn.name = @"plus";
                }else{
                    
                    [btn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"storyPlot_superViewFrame"]] forState:UIControlStateNormal];
                }
                
                
                
                btn.tag = i+200;
                [btn addTarget:self action:@selector(detailsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.detailsBtnArray addObject:btn];
    //            [self.view addSubview:btn];
                [self.plotScrollView addSubview:btn];
                
                CGFloat x = blankX + (i % columns) * (blankW + intervalW);
                CGFloat y = blankY + (i / columns) * (blankH + intervalH);
                
                btn.frame = CGRectMake(x, y, blankW, blankH);
                
                //            [self.superRectDict setValue:@(btn.frame) forKey:btn.name];
                [self.superRectDict setObject:NSStringFromCGRect(btn.frame) forKey:btn.name];
                
            }
            
            //添加情节控件
            for (XZQNameButton *btn in self.detailsBtnArray) {
                        
                CGFloat innerBtnX = btn.frame.size.width * 0.011;
                CGFloat innerBtnY = btn.frame.size.height * 0.0165;
                CGFloat innerBtnW = btn.frame.size.width * 0.978;
                CGFloat innerBtnH = btn.frame.size.height * 0.97;
                
                
                XZQNameButton *innerBtn = [[XZQNameButton alloc] init];
                innerBtn.isInnerBtn = YES;
                
                [btn addSubview:innerBtn];
                
                //最后一个加号的框不要
    //            if (btn.tag == 210) {
                if (btn.tag == 212) {
                    
                    
                    innerBtn.center = CGPointMake(btn.bounds.size.width *0.5, btn.bounds.size.height *0.5);

                    innerBtn.bounds = CGRectMake(0, 0, btn.bounds.size.width *0.6, btn.bounds.size.width *0.6);
                    
                    
                    
                }else{
                    innerBtn.frame = CGRectMake(innerBtnX, innerBtnY, innerBtnW, innerBtnH);
                }
                
                
                
                [innerBtn addTarget:self action:@selector(detailsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                
                [self.detailsPlotBtnArray addObject:innerBtn];
                
                
                //threeBoys_plot_1
                
                switch (btn.tag) {
                    case 200:
//                        [innerBtn setBackgroundImage:[UIImage imageNamed:@"teacher_1"] forState:UIControlStateNormal];
                        
                        [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"threeBoys_plot_1"]] forState:UIControlStateNormal];
                        
                        btn.name = @"threeBoys_1";
                        
                        break;
                        
                    case 201:
//                        [innerBtn setBackgroundImage:[UIImage imageNamed:@"teacher_2"] forState:UIControlStateNormal];
                        [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"threeBoys_plot_2"]] forState:UIControlStateNormal];
                        
                        btn.name = @"threeBoys_2";
                        break;
                        
                    case 202:
                        
//                        [innerBtn setBackgroundImage:[UIImage imageNamed:@"teacher_3"] forState:UIControlStateNormal];
                        [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"threeBoys_plot_3"]] forState:UIControlStateNormal];
                        
                        
                        btn.name = @"threeBoys_3";
                        break;
                        
                    case 203:
                        
                        [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"threeBoys_plot_4"]] forState:UIControlStateNormal];
                        btn.name = @"threeBoys_4";
                        
                        break;
                        
                    case 204:
                    
                    [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"threeBoys_plot_5"]] forState:UIControlStateNormal];
                    btn.name = @"threeBoys_5";
                    
                    break;
                        
                    case 205:
                    
                    [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"threeBoys_plot_6"]] forState:UIControlStateNormal];
                    btn.name = @"threeBoys_6";
                    
                    break;
                        
                    case 206:
                    
                    [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"threeBoys_plot_7"]] forState:UIControlStateNormal];
                    btn.name = @"threeBoys_7";
                    
                    break;
                        
                    case 207:
                    
                    [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"threeBoys_plot_8"]] forState:UIControlStateNormal];
                    btn.name = @"threeBoys_8";
                    
                    break;
                        
                    case 208:
                    
                    [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"threeBoys_plot_9"]] forState:UIControlStateNormal];
                    btn.name = @"threeBoys_9";
                    
                    break;
                        
                    case 209:
                    
                    [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"threeBoys_plot_10"]] forState:UIControlStateNormal];
                    btn.name = @"threeBoys_10";
                    
                    break;
                        
                    case 210:
                    
                    [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"threeBoys_plot_11"]] forState:UIControlStateNormal];
                    btn.name = @"threeBoys_11";
                    
                    break;
                        
                    case 211:
                    
                    [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"threeBoys_plot_12"]] forState:UIControlStateNormal];
                    btn.name = @"threeBoys_12";
                    
                    break;
                        
                        
                    case 212:
                        [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"storyPlot_add"]]  forState:UIControlStateNormal];
                        btn.name = @"plus";
                        btn.tag = 1998;
                        break;
                        
                    default:
                        break;
                }
                
                innerBtn.name = btn.name;
                innerBtn.tag = btn.tag;
                
                //系统音频url
                btn.storyVideoURL = [self recordWithTag:btn.tag];
                innerBtn.storyVideoURL = [self recordWithTag:innerBtn.tag];
                
                [self.innerRectDict setObject:NSStringFromCGRect(innerBtn.frame) forKey:innerBtn.name];
                
            }
            
            
        }else if ([self.currentNameBtn.name isEqualToString:@"bamboo"]){//展示竹里馆的故事情节
            
            //第5个是plus按钮
            //添加情节父控件
            for (NSInteger i = 0; i < 5; i++) {
                
                XZQNameButton *btn = [[XZQNameButton alloc] init];
                            
                btn.name = [NSString stringWithFormat:@"bamboo_%ld",i+1];
                
                if (i == 4) {
                    btn.name = @"plus";
                }else{
                    
                    [btn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"storyPlot_superViewFrame"]] forState:UIControlStateNormal];
                }
                
                
                
                btn.tag = i+200;
                [btn addTarget:self action:@selector(detailsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.detailsBtnArray addObject:btn];
    //            [self.view addSubview:btn];
                [self.plotScrollView addSubview:btn];
                
                CGFloat x = blankX + (i % columns) * (blankW + intervalW);
                CGFloat y = blankY + (i / columns) * (blankH + intervalH);
                
                btn.frame = CGRectMake(x, y, blankW, blankH);
                
                //            [self.superRectDict setValue:@(btn.frame) forKey:btn.name];
                [self.superRectDict setObject:NSStringFromCGRect(btn.frame) forKey:btn.name];
                
            }
            
            //添加情节控件
            for (XZQNameButton *btn in self.detailsBtnArray) {
                        
                CGFloat innerBtnX = btn.frame.size.width * 0.011;
                CGFloat innerBtnY = btn.frame.size.height * 0.0165;
                CGFloat innerBtnW = btn.frame.size.width * 0.978;
                CGFloat innerBtnH = btn.frame.size.height * 0.97;
                
                
                XZQNameButton *innerBtn = [[XZQNameButton alloc] init];
                innerBtn.isInnerBtn = YES;
                
                [btn addSubview:innerBtn];
                
                //最后一个加号的框不要
    //            if (btn.tag == 210) {
                if (btn.tag == 204) {
                    
                    
                    innerBtn.center = CGPointMake(btn.bounds.size.width *0.5, btn.bounds.size.height *0.5);

                    innerBtn.bounds = CGRectMake(0, 0, btn.bounds.size.width *0.6, btn.bounds.size.width *0.6);
                    
                    
                    
                }else{
                    innerBtn.frame = CGRectMake(innerBtnX, innerBtnY, innerBtnW, innerBtnH);
                }
                
                
                
                [innerBtn addTarget:self action:@selector(detailsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                
                [self.detailsPlotBtnArray addObject:innerBtn];
                
                switch (btn.tag) {
                    case 200:
//                        [innerBtn setBackgroundImage:[UIImage imageNamed:@"MainFunc_1"] forState:UIControlStateNormal];
                        
                        [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"bamboo_plot_1"]] forState:UIControlStateNormal];
                        
                        btn.name = @"bamboo_1";
                        
                        break;
                        
                    case 201:
                        [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"bamboo_plot_2"]] forState:UIControlStateNormal];
                        
                        btn.name = @"bamboo_2";
                        break;
                        
                    case 202:
                        
                        [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"bamboo_plot_3"]] forState:UIControlStateNormal];
                        
                        
                        btn.name = @"bamboo_3";
                        break;
                        
                    case 203:
                        [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"bamboo_plot_4"]] forState:UIControlStateNormal];
                        btn.name = @"bamboo_4";
                        
                        break;
                    case 204:
                        [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"storyPlot_add"]]  forState:UIControlStateNormal];
                        btn.name = @"plus";
                        btn.tag = 1998;
                        break;
                        
                    default:
                        break;
                }
                
                innerBtn.name = btn.name;
                innerBtn.tag = btn.tag;
                
                //系统音频url
                btn.storyVideoURL = [self recordWithTag:btn.tag];
                innerBtn.storyVideoURL = [self recordWithTag:innerBtn.tag];
                
                [self.innerRectDict setObject:NSStringFromCGRect(innerBtn.frame) forKey:innerBtn.name];
                
            }
            
            
        }
        
        
        
        
//        [recordBtn addTarget:self action:@selector(recordStartButtonDown:) forControlEvents:UIControlEventTouchDown];
//        [recordBtn addTarget:self action:@selector(recordStopButtonUp:) forControlEvents:UIControlEventTouchUpInside];
//        [recordBtn addTarget:self action:@selector(recordStopButtonExit:) forControlEvents:UIControlEventTouchDragExit];
        
        

        
        
//    });
    
    
}

//点击右下角录音按钮 弹框出现
- (void)rightBottomBtnPop:(XZQNameButton *)recordBtn{
    
    //停止播放录音 点击了暂停按钮 哈哈哈 挺好用的
    self.playOrPauseBtn.isBigger = YES;
    
    [self playOrPauseBtnClick:self.playOrPauseBtn];

//    self.currentNameBtn = recordBtn;
    
    if (!self.isClickRightBottomBtn) {
        ZJAnimationPopStyle popStyle =  ZJAnimationPopStyleShakeFromTop;
        ZJAnimationDismissStyle dismissStyle = ZJAnimationDismissStyleDropToBottom;
        
        self.customView = nil;
        _customView = [SlideSelectCardView xib4];
        
        self.customView.title = @"录音功能";
        self.customView.showOperaion = @"按住不放可以进行录音，请对着麦克风喊话。";
        
//        self.customView.storyOrPlotImage = [UIImage imageNamed:@"sound_12"];
        self.customView.image = [UIImage imageNamed:@"sound_12"];
        self.customView.delegate = self;
        
        // 1.初始化
        ZJAnimationPopView *popView = [[ZJAnimationPopView alloc] initWithCustomView:self.customView popStyle:popStyle dismissStyle:dismissStyle];
        self.ZJAPopView = popView;
        
        // 2.设置属性，可不设置使用默认值，见注解
        
        // 2.2 显示时背景的透明度
        popView.popBGAlpha = 0.5f;
        // 2.3 显示时是否监听屏幕旋转
        popView.isObserverOrientationChange = YES;
        // 2.4 显示时动画时长
        //    popView.popAnimationDuration = 0.8f;
        // 2.5 移除时动画时长
        //    popView.dismissAnimationDuration = 0.8f;
        
        // 2.6 显示完成回调
        popView.popComplete = ^{
            NSLog(@"显示完成");
        };
        // 2.7 移除完成回调
        popView.dismissComplete = ^{
            NSLog(@"移除完成");
        };
        
        // 4.显示弹框
        [popView pop];
        
        self.isClickRightBottomBtn = YES;
        
    }
        
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.recordBtn addTarget:self action:@selector(recordStartButtonDown:) forControlEvents:UIControlEventTouchDown];
        [self.recordBtn addTarget:self action:@selector(recordStopButtonUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.recordBtn addTarget:self action:@selector(recordStopButtonExit:) forControlEvents:UIControlEventTouchDragExit];
    });
        
    
}

#pragma 点击录音文件按钮
- (void)recordFileBtnClick:(XZQNameButton *)btn{
    
    //弹出录音文件弹框
    self.currentNameBtn = btn;
    
    NSString *message = @"录音";
    if (self.recordArray.count == 0) {
        message = @"暂无录音信息";
    }
    
    ZJAnimationPopStyle popStyle =  ZJAnimationPopStyleShakeFromTop;
    ZJAnimationDismissStyle dismissStyle = ZJAnimationDismissStyleDropToTop;
    self.customView = nil;
    
    self.customView.delegate = self;
    self.delegate = (id)self.customView;
    
    self.customView.title = message;
    
    if ([self.delegate respondsToSelector:@selector(showRecordMessage:messageArray:)]) {
        //        [self.delegate showRecordMessage:self messageArray:self.recordSoundArray];
        
        [self.delegate showRecordMessage:self messageArray:self.recordArray];
    }
    
    if ([self.delegate respondsToSelector:@selector(postRecordSoundFolderPath:)]) {
        [self.delegate postRecordSoundFolderPath:self.recordSoundFolderPath];
    }
    
    //左下角按钮的tag是10
    if (btn.tag == 10) {
        //弹出弹框时从右向左到中间
        popStyle = ZJAnimationPopStyleShakeFromRight;
        dismissStyle = ZJAnimationDismissStyleDropToLeft;

        
    }
    
    // 1.初始化
    ZJAnimationPopView *popView = [[ZJAnimationPopView alloc] initWithCustomView:self.customView popStyle:popStyle dismissStyle:dismissStyle];
    self.ZJAPopView = popView;
    
    // 2.设置属性，可不设置使用默认值，见注解
    
    // 2.2 显示时背景的透明度
    popView.popBGAlpha = 0.5f;
    // 2.3 显示时是否监听屏幕旋转
    popView.isObserverOrientationChange = YES;
    // 2.4 显示时动画时长
    //    popView.popAnimationDuration = 0.8f;
    // 2.5 移除时动画时长
    //    popView.dismissAnimationDuration = 0.8f;
    
    // 2.6 显示完成回调
    popView.popComplete = ^{
        NSLog(@"显示完成");
    };
    // 2.7 移除完成回调
    popView.dismissComplete = ^{
        NSLog(@"移除完成");
    };
    
    // 4.显示弹框
    [popView pop];
    
}

//纯移除弹框
- (void)dismissPopView:(ZJXibFoctory *)foctory dismissBtn:(UIButton *)btn{
    
    NSLog(@"dismissPopView");
    self.currentNameBtn.superview.userInteractionEnabled = YES;
    [self.ZJAPopView dismiss];
    
    //暂停故事动画的播放 - 有小电视机外框
//    [self.smallStoryVideoVC.playerVC.player pause];
    
    //无电视机外框
    [self.colorBackgroundPopBoxVC.playerVC.player pause];
}

//移除自定义弹框
- (void)disappearSelfDefinePopView{
    self.currentNameBtn.superview.userInteractionEnabled = YES;
    
    //leftBtnClick
    if (self.currentNameBtn.tag == 99) {
        
        self.storyName.text = @"故 事 汇";
        
        self.currentNameBtn = nil;
        
        //确定返回故事界面调用
            if (self.alreadySkip) {
                
                self.plotScrollView.alpha = 0;
                //将录音按钮隐藏
//                self.recordBtn.alpha = 0;
//                self.recordFileBtn.alpha = 0;
                
                for (UIView *view in self.blankArray) {
                    view.alpha = 1;
                    
                }
                
                //隐藏返回画板界面的按钮
                self.returnToStory.alpha = 0;
                self.returnToMainFunc.alpha = 1;
                
                for (UIView *view in self.detailsBtnArray) {
                    view.alpha = 0;
                    
                    
                }
                
                self.alreadySkip = false;
                self.playBtn.alpha = 0;
                
            }else{
                self.plotScrollView.alpha = 1;
                self.tabBarController.selectedIndex = 0;
            }
    }else if (self.currentNameBtn.tag == 11){//recordBtn
        [self rightBottomBtnPop:self.currentNameBtn];
    }else if ([self.currentNameBtn.name isEqualToString:@"plus"]){
        
        self.tabBarController.selectedIndex = 0;
    }
    
    if (self.currentNameBtn.tag == 100) {
        //返回到主界面
        self.tabBarController.selectedIndex = 6;
    }
    
    
    [self.ZJAPopView dismiss];
}

#pragma 录音相关方法

//录音按钮点击下去开始录音
// 录音时监测音量
- (void)recordStartButtonDown:(UIButton *)button
{
     //停止播放录音 点击了暂停按钮 哈哈哈 挺好用的
    self.playOrPauseBtn.isBigger = YES;
       
    [self playOrPauseBtnClick:self.playOrPauseBtn];
    
    
    
    [SYAudio shareAudio].audioRecorder.monitorVoice = YES;
    
    //caf文件路径
    //原来的以文件数递增的方式命名录音
//    self.recordSoundFilePath = [SYAudioFile SYAudioDefaultFilePath:self.cafFolderPath];
    
    //caf文件路径
    //新的以按钮名称命名的录音
    if (self.currentNameBtn.name != nil) {
        self.recordSoundFilePath = [SYAudioFile SYAudioDefaultFilePath:self.cafFolderPath innerName:self.currentNameBtn.name];
    }else{
        NSLog(@"recordStartButtonDown方法中 self.currentNameBtn.name == nil 录音文件保存地址失败！");
    }
    
    
    [SYAudio shareAudio].audioRecorder.delegate = self;
    
    NSLog(@"recordStartButtonDown 方法 self.cafFolderPath = %@ self.recordSoundFilePath = %@",self.cafFolderPath,self.recordSoundFilePath);
    
    [[SYAudio shareAudio].audioRecorder recorderStart:self.recordSoundFilePath complete:^(BOOL isFailed) {
        if (isFailed) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"音频文件地址无效" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:NULL];
            }]];
            [self presentViewController:alert animated:YES completion:NULL];
        }
    }];
}
//录音按钮手指抬起结束录音并保存
- (void)recordStopButtonUp:(UIButton *)button
{
    [self saveRecorder];
}


///录音按钮手指点击下去之后滑动出窗口结束录音并保存
- (void)recordStopButtonExit:(UIButton *)button
{
    [self saveRecorder];
}

//停止录音并保存
// 停止录音，并保存
- (void)saveRecorder
{
    [[SYAudio shareAudio].audioRecorder recorderStop];

}

#pragma mark - 代理

#pragma mark 录音

/// 开始录音
- (void)recordBegined
{
    NSLog(@"%s", __func__);
//    self.label.text = @"开始录音";
    NSLog(@"开始录音");
    
    if ([SYAudio shareAudio].audioRecorder.monitorVoice) {
        // 录音音量显示 75*111
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        //
        self.imgView = [[UIView alloc] initWithFrame:CGRectMake((window.frame.size.width - 120) / 2, (window.frame.size.height - 120) / 2, 120, 120)];
        [window addSubview:self.imgView];
        [self.imgView.layer setCornerRadius:10.0];
        [self.imgView.layer setBackgroundColor:[UIColor blackColor].CGColor];
        [self.imgView setAlpha:0.8];
        //
        self.audioRecorderVoiceImgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.imgView.frame.size.width - 60) / 2, (self.imgView.frame.size.height - 60 * 111 / 75) / 2, 60, 60 * 111 / 75)];
        [self.imgView addSubview:self.audioRecorderVoiceImgView];
        [self.audioRecorderVoiceImgView setImage:[UIImage imageNamed:@"record_animate_01.png"]];
        [self.audioRecorderVoiceImgView setBackgroundColor:[UIColor clearColor]];
    }
}

/// 停止录音
- (void)recordFinshed
{
    NSLog(@"%s", __func__);
//    self.label.text = @"完成录音";
    NSLog(@"完成录音");
    if (self.isLimitTime) {
        self.isLimitTime = NO;
        [self saveRecorder];
    }
    
    // 移除音量图标
    if (self.audioRecorderVoiceImgView && [SYAudio shareAudio].audioRecorder.monitorVoice)
    {
        [self.audioRecorderVoiceImgView setHidden:YES];
        [self.audioRecorderVoiceImgView setImage:nil];
        [self.audioRecorderVoiceImgView removeFromSuperview];
        self.audioRecorderVoiceImgView = nil;
        
        [self.imgView removeFromSuperview];
        self.imgView = nil;
    }
}

/// 正在录音中，录音音量监测
- (void)recordingUpdateVoice:(double)lowPassResults
{
    NSLog(@"%s", __func__);
//    self.label.text = [NSString stringWithFormat:@"正在录音：%f", lowPassResults];
    NSLog(@"正在录音");
    
    if (0 < lowPassResults <= 0.06)
    {
        [self.audioRecorderVoiceImgView setImage:[UIImage imageNamed:@"record_animate_01.png"]];
    }
    else if (0.06 < lowPassResults <= 0.13)
    {
        [self.audioRecorderVoiceImgView setImage:[UIImage imageNamed:@"record_animate_02.png"]];
    }
    else if (0.13 < lowPassResults <= 0.20)
    {
        [self.audioRecorderVoiceImgView setImage:[UIImage imageNamed:@"record_animate_03.png"]];
    }
    else if (0.20 < lowPassResults <= 0.27)
    {
        [self.audioRecorderVoiceImgView setImage:[UIImage imageNamed:@"record_animate_04.png"]];
    }
    else if (0.27 < lowPassResults <= 0.34)
    {
        [self.audioRecorderVoiceImgView setImage:[UIImage imageNamed:@"record_animate_05.png"]];
    }
    else if (0.34 < lowPassResults <= 0.41)
    {
        [self.audioRecorderVoiceImgView setImage:[UIImage imageNamed:@"record_animate_06.png"]];
    }
    else if (0.41 < lowPassResults <= 0.48)
    {
        [self.audioRecorderVoiceImgView setImage:[UIImage imageNamed:@"record_animate_07.png"]];
    }
    else if (0.48 < lowPassResults <= 0.55)
    {
        [self.audioRecorderVoiceImgView setImage:[UIImage imageNamed:@"record_animate_08.png"]];
    }
    else if (0.55 < lowPassResults <= 0.62)
    {
        [self.audioRecorderVoiceImgView setImage:[UIImage imageNamed:@"record_animate_09.png"]];
    }
    else if (0.62 < lowPassResults <= 0.69)
    {
        [self.audioRecorderVoiceImgView setImage:[UIImage imageNamed:@"record_animate_10.png"]];
    }
    else if (0.69 < lowPassResults <= 0.76)
    {
        [self.audioRecorderVoiceImgView setImage:[UIImage imageNamed:@"record_animate_11.png"]];
    }
    else if (0.76 < lowPassResults <= 0.83)
    {
        [self.audioRecorderVoiceImgView setImage:[UIImage imageNamed:@"record_animate_12.png"]];
    }
    else if (0.83 < lowPassResults <= 0.9)
    {
        [self.audioRecorderVoiceImgView setImage:[UIImage imageNamed:@"record_animate_13.png"]];
    }
    else
    {
        [self.audioRecorderVoiceImgView setImage:[UIImage imageNamed:@"record_animate_14.png"]];
    }
}

/// 正中录音中，是否录音倒计时、录音剩余时长
- (void)recordingWithResidualTime:(NSTimeInterval)time timer:(BOOL)isTimer
{
    NSLog(@"%s", __func__);
    NSLog(@"录音倒计时：%f, 是否录音倒计时：%d", time, isTimer);
//    self.label.text = [NSString stringWithFormat:@"录音倒计时：%f, 是否录音倒计时：%d", time, isTimer];
    
}

#pragma mark 压缩

/// 开始压缩录音
- (void)recordBeginConvert
{
    NSLog(@"%s", __func__);
//    self.label.text = @"正在压缩文件";
    NSLog(@"正在压缩文件");
}

/// 结束压缩录音
- (void)recordFinshConvert:(NSString *)filePath
{
    NSLog(@"%s", __func__);
    NSLog(@"%@", filePath);
    self.recordSoundFilePathMP3 = filePath;
//    self.label.text = @"完成文件压缩";
    NSLog(@"完成文件压缩");
    NSLog(@"filePath = %@",filePath);
}

#pragma mark 播放

/// 开始播放音频
- (void)audioPlayBegined:(AVPlayerItemStatus)state
{
    NSLog(@"%s", __func__);
    NSLog(@"state = %@", @(state));
//    self.label.text = [NSString stringWithFormat:@"准备播放 state = %@", @(state)];
    NSLog(@"准备播放");
}

/// 正在播放音频（总时长，当前时长）
- (void)audioPlaying:(NSTimeInterval)totalTime time:(NSTimeInterval)currentTime
{
    NSLog(@"%s", __func__);
    NSLog(@"播放总时长：%f, 当前播放时间：%f", totalTime, currentTime);
//    self.label.text = [NSString stringWithFormat:@"正在播放\n播放总时长：%f, 当前播放时间：%f", totalTime, currentTime];
//    NSLog(@"");
}

/// 结束播放音频
- (void)audioPlayFinished
{
    NSLog(@"%s", __func__);
//    self.label.text = [NSString stringWithFormat:@"播放完成"];
    NSLog(@"播放完成");
}

#pragma 录音方法结束


#pragma 情节按钮点击弹框
- (void)popAboutRecord:(XZQNameButton *)btn{
    
    //在线听图片放大 缓存和取消不放大 点击的时候去找找是否已经下载完毕 没有下载完毕 弹出在线听这个弹框 下载完毕弹出另外一个框 直接播放
    
    //弹出提示框
//    [self presentViewController:self.alertRecord animated:YES completion:nil];
    
    
    //弹出在线听 缓存听 听录音 等等...
    //弹出弹框
    ZJAnimationPopStyle popStyle =  ZJAnimationPopStyleShakeFromTop;
    ZJAnimationDismissStyle dismissStyle = ZJAnimationDismissStyleDropToBottom;
    
    self.customView = nil;
    
    
//    _customView = [SlideSelectCardView xib7];
    
    //1998是plus的tag
    if (btn.tag < 210 || [btn.name rangeOfString:@"threeBoys"].location != NSNotFound) {
        _customView = [SlideSelectCardView xib15];
    }else{
        _customView = [SlideSelectCardView xib17];
    }
    
    
    
//    self.customView.title = @"音频信息";
//    self.customView.showOperaion = @"即将切换到故事界面";
//    self.customView.image = [UIImage imageNamed:@"logoOfStory7"];
    
//    self.customView.storyOrPlotImage = [UIImage imageNamed:@"logoOfStory7"];
    
    if (btn.currentBackgroundImage != nil) {
        self.customView.storyOrPlotImage = [UIImage OriginalImageWithImage:btn.currentBackgroundImage];
    }else{
        self.customView.storyOrPlotImage = [UIImage imageNamed:@"logoOfStory7"];
    }
    
    
    self.customView.delegate = self;
    
    // 1.初始化
    ZJAnimationPopView *popView = [[ZJAnimationPopView alloc] initWithCustomView:self.customView popStyle:popStyle dismissStyle:dismissStyle];
    self.ZJAPopView = popView;
    
    // 2.设置属性，可不设置使用默认值，见注解
    
    // 2.2 显示时背景的透明度
    popView.popBGAlpha = 0.5f;
    // 2.3 显示时是否监听屏幕旋转
    popView.isObserverOrientationChange = YES;
    // 2.4 显示时动画时长
    //    popView.popAnimationDuration = 0.8f;
    // 2.5 移除时动画时长
    //    popView.dismissAnimationDuration = 0.8f;
    
    // 2.6 显示完成回调
    popView.popComplete = ^{
        NSLog(@"显示完成");
    };
    // 2.7 移除完成回调
    popView.dismissComplete = ^{
        NSLog(@"移除完成");
    };
    
    // 4.显示弹框
    [popView pop];
    
}

#pragma 在线播放功能
- (void)onlinePlayer:(NSString *)fileName{
    
    NSURL *url = [NSURL URLWithString:[self.baseURL stringByAppendingPathComponent:fileName]];
    
    NSLog(@"在线播放");
    
    self.playerVC.player = [AVPlayer playerWithURL:url];
    [self.playerVC.player play];
    self.playerVC.allowsPictureInPicturePlayback = YES;
    //显示出视频退出按钮 - 要加 - 不加的话 退出播放画面有卡顿 - 加这个是手动进行退出视频播放
    [self showUpExitBtn];
    
    [self presentViewController:self.playerVC animated:YES completion:nil];
    
    
}



#pragma 普通方法

//播放视频
- (void)videoBaseOperation{
    
    //画中画模式 - 以窗口的形式浮在界面上 在其他界面也可以画中画视频播放就将视频播放窗口化，然后浮动在屏幕上，此时你可以使用其他APP。但是有限制：1、iOS9 2、iPad
    
    //将AVPlayer的View的背景颜色设置成透明的
    self.view.backgroundColor = [UIColor clearColor];
    
    if (!self.videoName) {
        return;
    }
    
    if (!self.fullPath) {
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:self.fullPath];
    
    //3.player基本上什么操作都要使用它
    self.playerVC.player = [AVPlayer playerWithURL:url];
    
    
    //4.播放视频 - 一开始先暂停
    [self.playerVC.player pause];
    
    //5.展示播放器的操作,设置代理 - 问题在这里 - 就是presentViewController之后 window窗口的界面就是这个播放器的界面了 程序的界面消失了 - 调用dismiss方法就行了
    [self presentViewController:self.playerVC animated:YES completion:nil];
    
    //显示出视频退出按钮
    [self showUpExitBtn];
    
    //画中画模式
    self.playerVC.allowsPictureInPicturePlayback = YES;
    
    
    //拖动手势 缩放手势
    //    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    //    [self.view addGestureRecognizer:pan];
    
    
    //缩放手势 - 捏合手势
    //    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    //    [self.view addGestureRecognizer:pinch];
    
    self.playerVC.delegate = self;
    
    //解决视频播放器旁边有黑框的问题
    self.playerVC.view.backgroundColor = [UIColor clearColor];
}




#pragma 播放音频
//有播放按钮的时候调用的方法 - 播放按钮：有 在线听全部 缓存听全部功能 后来去掉了这个按钮
- (void)recordBaseOperation{
    
    self.currentNameBtn.isOnlineRecord = false;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        
        
        self.view.backgroundColor = [UIColor clearColor];
        
        
        if (!self.recordName) {
            return;
        }
        
        if (!self.fullRecordPath) {
            return;
        }
        
        //播放音频的时候得把情节图片放大
        if (self.playBtn.enjoyAfterDownload) {
            CGRect rect = self.currentNameBtn.originRect;
            self.currentNameBtn.isBigger = YES;
            self.currentNameBtn.originRect = rect;
            
            
            
            XZQNameButton *superBtn = (XZQNameButton *)self.currentNameBtn.superview;
            rect = superBtn.frame;
            superBtn.isBigger = YES;
            superBtn.originRect = rect;
            
            NSLog(@"btnRect == %@ superRect=%@" ,NSStringFromCGRect(rect),NSStringFromCGRect(superBtn.originRect));
            
        }
        
        NSLog(@"全部音频都已经加载完毕 播放第一个音频");//这里没有播放音频 下面播放
        [self onlineRecord];
        
        
    }];
    
    
    
    
    //播放音频之前要确保url是对的
    NSString *recordFilePath = [self.soundFolderPath stringByAppendingPathComponent:self.currentNameBtn.name];
    
    recordFilePath = [recordFilePath stringByAppendingString:@".mp3"];
    
    self.fullRecordPath = recordFilePath;
    
    NSURL *url = [NSURL fileURLWithPath:self.fullRecordPath];
    
    NSLog(@"recordBaseOperation fullRecordPath = %@",self.fullRecordPath);
    NSLog(@"currentRecordSize = %ld",self.currentRecordSize);
    NSLog(@"totalRecordSize = %ld",[self getRecordFileSize]);
    
    self.recordPlayer = [AVPlayer playerWithURL:url];
    
    //4.播放视频 - 一开始先暂停
    
    if (self.currentNameBtn.isBigger) {
        [self.recordPlayer play];//播放
    }else{
        [self.recordPlayer pause];
    }
    
    
    
}

#pragma 删除了播放按钮后 某一个系统音频播放完毕调用 继续下一个音频播放
- (void)playSystemLocalRecord{
    
    self.currentNameBtn.isOnlineRecord = false;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        self.view.backgroundColor = [UIColor clearColor];
        
        
        if (!self.recordName) {
            return;
        }
        
        if (!self.fullRecordPath) {
            return;
        }
        
        //播放音频的时候得把情节图片放大
        
        CGRect rect = self.currentNameBtn.originRect;
        self.currentNameBtn.isBigger = YES;
        self.currentNameBtn.originRect = rect;
        
        
        
        XZQNameButton *superBtn = (XZQNameButton *)self.currentNameBtn.superview;
        rect = superBtn.frame;
        superBtn.isBigger = YES;
        superBtn.originRect = rect;
        
        NSLog(@"btnRect == %@ superRect=%@" ,NSStringFromCGRect(rect),NSStringFromCGRect(superBtn.originRect));
        
    
    
        NSLog(@"全部音频都已经加载完毕 播放第一个音频");//这里没有播放音频 下面播放
        [self onlineRecord];
        
        
    }];
    
    
    //播放音频之前要确保url是对的
    
    if (self.currentNameBtn.storyVideoURL != nil) {
        
        if (self.listentoLocalOrSelfRecord == 1) {
            self.recordPlayer = [AVPlayer playerWithURL:self.currentNameBtn.storyVideoURL];
        }else if(self.currentNameBtn.selfRecordURL != nil && self.listentoLocalOrSelfRecord ==2){
            self.recordPlayer = [AVPlayer playerWithURL:self.currentNameBtn.selfRecordURL];
        }else if(self.currentNameBtn.selfRecordURL == nil && self.listentoLocalOrSelfRecord == 2){
            self.listentoLocalOrSelfRecord = 1;
            self.recordPlayer = [AVPlayer playerWithURL:self.currentNameBtn.storyVideoURL];
        }
        
    }else{
        NSLog(@"playSystemLocalRecord 中的self.currentNameBtn.storyVideoURL == nil 因此无法播放系统音频");
    }
    
    //4.播放视频 - 一开始先暂停
    
    if (self.currentNameBtn.isBigger) {
        [self.recordPlayer play];//播放
    }else{
        [self.recordPlayer pause];
    }
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"viewDidLoad");
    
    //监听通知
    [self addAllObserver];
    
    //背景
    self.imageV.image = [UIImage imageNamed:@"drawboard_backGroundImage"];
    
    //主页
    XZQPopViewController *popVc = [XZQPopViewController shareXZQPopViewController];
    //    XZQPopViewController *popVc = [[XZQPopViewController alloc] init];
    self.popVc = popVc;
    
    self.playerVC.delegate = self;
    
    //当程序退出时 停止下载 再次进入时 恢复下载
    self.currentSize = [self getFileSize];
    self.currentRecordSize = [self getRecordFileSize];
    
    //代理是画板
    self.delegate2 = self.tabBarController.childViewControllers[0];
    
    //设置SlideSelectCardView成为self的代理
    self.delegate = self.customView;
}

#pragma 点击xib中的按钮调用的方法

- (void)suspendVideoDownload{
    
    //暂停
    [self.dataTask suspend];
    
    self.loadPersent.text = [@"暂停中，资源已下载:" stringByAppendingString:[NSString stringWithFormat:@"%.1f%%",(1.0 * self.currentSize / self.totalSize) * 100]];
}

- (void)goOnVideoDownload{
    
    
    //继续下载
    [self.dataTask resume];
    
    
    
}

- (void)cancelVideoDownload{
    
    
    //取消下载
    [self.dataTask cancel];
    
    self.loadPersent.text = nil;
    self.dataTask = nil;
    
    
    //将对应的视频文件资源删除掉 并且从plist文件中删除
    Boolean isSuccess = [self.manager removeItemAtPath:self.fullPath error:nil];
    
    if (isSuccess) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
    
    //点击取消下载 将正在下载列表中的对应视频删除
    for (NSString *temp in self.downloadingArray) {
        
        if ([temp isEqualToString:self.loadingVideoName]) {
            
            [self.downloadingArray removeObject:temp];
            return ;
        }
    }
    
    [self.ZJAPopView dismiss];
    
}



- (void)onlinePlayFromXib{
    NSLog(@"onlinePlayFromXib");
    
    [self.ZJAPopView dismiss];
    //调用在线播放功能
    
    [self onlinePlayer:self.currentNameBtn.name];
    
}

- (void)downloadPlayFromXib{
    NSLog(@"downloadPlayFromXib");
    
    [self.ZJAPopView dismiss];
    
    if (self.alreadyDownloadVideo) {
        //如果已经下载完毕 点击缓存到本地 直接播放
        [self videoBaseOperation];
        return;
    }
    
    //响应事件
    self.loadingVideoName = self.currentNameBtn.name;
    
    //下载视频到对应文件夹
    [self downloadVideo:self.currentNameBtn];
    
}

- (void)studyClassFromXib{
    
    NSLog(@"studyClassFromXib");
    
    [self.ZJAPopView dismiss];
    
    
    //暂停故事动画的播放
//    [self.smallStoryVideoVC.playerVC.player pause];
    
    [self.colorBackgroundPopBoxVC.playerVC.player pause];
    
    NSString *originTitle = self.currentNameBtn.name;
    
    NSString *title = originTitle;
    
    //转换字符串
    if ([title isEqualToString:@"matchGirl.mp4"]) {
        
        title = @"卖火柴的小女孩";
        
        
    }else if ([title isEqualToString:@"Crazy_little_original_hunter.mp4"]){
        
        title = @"疯狂原始小猎人";
        
    }else if ([title isEqualToString:@"girlOfSea.mp4"]){
        
        title = @"海的女儿";
    }
    
    self.tabBarController.selectedIndex = 0;
    
    //网络功能屏蔽掉了 现在
    
//    NSString *EnglishName = [originTitle stringByReplacingOccurrencesOfString:@".mp4" withString:@""];
    
//    NSString *path = [self.baseURL stringByAppendingPathComponent:originTitle];
    
//    NSURL *onlineURL = [NSURL URLWithString:path];
    
    
    
    //开始播放教学视频 - 网络状态
//    if ([self.delegate2 respondsToSelector:@selector(playVideoOnline:videoURL:ChineseName:EnglishName:superPath:)]) {
//        [self.delegate2 playVideoOnline:self videoURL:onlineURL ChineseName:title EnglishName:EnglishName superPath:self.pictureFolderPath];
//
//    }
    
    if ([self.delegate2 respondsToSelector:@selector(postStoryVideoURL:videoURL:)]) {
          [self.delegate2 postStoryVideoURL:self videoURL:self.currentNameBtn.storyVideoURL];
      }
    
    
    
    
}


- (void)storyPlotFromXib{
    
    NSLog(@"storyPlotFromXib");
    
    
    
    
    
    
    [self.ZJAPopView dismiss];
    
    //将故事视图隐藏 - 将情节界面展示出来
    //隐藏的话 直接将4个按钮隐藏掉 操作blankArray就行
    for (UIView *view in self.blankArray) {
        view.alpha = 0;
    }
    
    //显示返回到故事界面的按钮
    self.returnToStory.alpha = 1;
    self.returnToMainFunc.alpha = 0;
    
    //暂停故事动画的播放
    [self.colorBackgroundPopBoxVC.playerVC.player pause];
    
    //调用另外的方法显示情节界面
    [self showStoryDetails];
    
    //显示自定义情节
    [self showSelfDefinePlot];
    
}



- (void)suspendDownloadFromXib{
    
    NSLog(@"暂停下载");
    
    //暂停
    [self.recordDataTask suspend];
    
    self.loadRecordPersent.text = [@"暂停中，资源已下载:" stringByAppendingString:[NSString stringWithFormat:@"%.1f%%",(1.0 * self.currentRecordSize / self.totalRecordSize) * 100]];
}

- (void)goOnDownloadFromXib{
    
    NSLog(@"继续下载");
    //继续下载
    [self.recordDataTask resume];
}

- (void)cancelDownloadFromXib{
    
    NSLog(@"取消下载");
    //取消下载
    [self.recordDataTask cancel];
    
    self.loadRecordPersent.text = nil;
    self.recordDataTask = nil;
    
    
    //将对应的视频文件资源删除掉 并且从plist文件中删除
    Boolean isSuccess = [self.manager removeItemAtPath:self.fullRecordPath error:nil];
    
    if (isSuccess) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
    
    //点击取消下载 将正在下载列表中的对应视频删除
    for (NSString *temp in self.downloadingRecordArray) {
        
        if ([temp isEqualToString:self.loadingRecordName]) {
            
            [self.downloadingRecordArray removeObject:temp];
            return ;
        }
    }
}

//xib中点击在线播放音频
- (void)onlinePlayRecordFromXib{
    
    
//    NSLog(@"点击了在线听 isOnlineRecord = %d",self.currentNameBtn.isOnlineRecord);
    [self.ZJAPopView dismiss];
    
    self.currentNameBtn.isOnlineRecord = YES;
    self.currentNameBtn.isBigger = YES;
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onlineRecord" object:nil];
    
}

//听自己的录音
- (void)listenSelfRecordFromXib{
    
    NSLog(@"听自己的录音");
    [self.ZJAPopView dismiss];
    
    self.currentNameBtn.isOnlineRecord = NO;
    //取消操作
    //            self.currentNameBtn.isBigger = NO;
    //            self.currentNameBtn.superview.userInteractionEnabled = YES;
    
    //调用方法变大并且播放自己的录音
    [self recordBtnClick:self.currentNameBtn];
    
}

//点击了缓存音频
- (void)downloadRecordFromXib{
    
    [self.ZJAPopView dismiss];
    //点击
    XZQNameButton *superBtn = (XZQNameButton *)self.currentNameBtn.superview;
    
    superBtn.userInteractionEnabled = YES;
    
    self.currentNameBtn.isOnlineRecord = false;
    
    //应该是你点击缓存的时候才去建立对应的文件夹
    [self createRecordFile:self.currentNameBtn];
    
    //缓存操作
    self.currentNameBtn.isBigger = false;
    
    //响应事件
    self.loadingRecordName = self.currentNameBtn.name;
    
    //下载视频到对应文件夹
    [self downloadRecord:self.currentNameBtn];
}

- (void)cancelRecordFromXib{
    
    NSLog(@"点击了点击了点击了cancelRecordFromXib");
    [self.ZJAPopView dismiss];
    
    self.currentNameBtn.isOnlineRecord = NO;
    //取消操作
    self.currentNameBtn.isBigger = NO;
    self.currentNameBtn.superview.userInteractionEnabled = YES;
    
//    [self.ZJAPopView dismiss];
}

- (void)dismissZJPopView{
    
    if (self.currentNameBtn.tag == 99) {
        
    }else{
        self.currentNameBtn.isOnlineRecord = NO;
        //取消操作
        self.currentNameBtn.isBigger = NO;
    }
    
    
    
    self.currentNameBtn.superview.userInteractionEnabled = YES;
    
    //将故事动画停止播放
//    [self.smallStoryVideoVC.playerVC.player pause];
    
    [self.colorBackgroundPopBoxVC.playerVC.player pause];
}

#pragma 点击在线听录音按钮
- (void)onlineRecord{
    
    //点击第二次听录音才开始在线播放录音
    
    NSLog(@"在线听录音");
    
    XZQNameButton *btn = self.currentNameBtn;
    
    XZQNameButton *superBtn = (XZQNameButton *)btn.superview;
    
//    UIView *superView = superBtn.superview;
    
//    btn.isBigger = YES;
//    btn.isOnlineRecord = YES;
    
    //将图片放大 并且将系统给定的录音播放出来 播放 再次点击 缩小到原来的形状
    if (btn.isBigger) {
        
        
        //enjoyAfterDownload 缓存听录音
        if (self.playBtn.enjoyAfterDownload) {
            
            superBtn.isBigger = YES;
            
            //这个时候superBtn的originRect不正常了 放大状态的 还有btn的 也是很大
            NSLog(@"放大前:%@",NSStringFromCGRect(superBtn.originRect));
            
        }else{
            superBtn.isBigger = YES;
        }
        
        //置于父控件最上层
        [self.plotScrollView bringSubviewToFront:superBtn];
        
        //这个时候superBtn的originRect不正常了 放大状态的 还有btn的 也是很大
//        NSLog(@"superBtn == %@ btn == %@",NSStringFromCGRect(superBtn.originRect),NSStringFromCGRect(btn.originRect));
        
        //点击使用动画
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
//            superBtn.frame = CGRectMake(Width* 0.146484,Height* 0.104167,Width* 0.681152,Height* 0.625000);
            
            //让情节放大之后处于屏幕中间
            superBtn.center = self.view.center;
            superBtn.bounds = CGRectMake(0, 0, Width* 0.621152, Height* 0.555000);
            [self.view addSubview:superBtn];
            
            [superBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"storyPlot_superViewShadow"]] forState:UIControlStateNormal];
            
//            [self.view bringSubviewToFront:superBtn];
            
            //这里btn 的originRect 600多了
            CGRect rect = btn.frame;
            
            rect.origin.x = superBtn.frame.size.width *0.011200;
            rect.origin.y = superBtn.frame.size.height *0.017200;
            rect.size.width = superBtn.frame.size.width *0.977600;
            rect.size.height = superBtn.frame.size.height *0.966333;
            
            btn.frame = rect;
            
            
            //添加遮罩
            self.coverView.frame = self.view.bounds;
            self.coverView.alpha = 0;
            self.coverView.backgroundColor = [UIColor blackColor];
            self.coverView.tag = 666;
            [self.view addSubview:self.coverView];
            
            [self.view bringSubviewToFront:self.coverView];
            
            
            self.coverView.alpha = 0.5;
            
//            NSLog(@"isOnlineRecord - %d",self.currentNameBtn.isOnlineRecord);
            
            if (self.currentNameBtn.isOnlineRecord) {
                
                //在线播放音频
                [self playRecord:btn];
                
            }else{
                //点击了缓存 听本地录音
                [self localRecordPlay];
                
            }
            
            
            
            //在 在线听界面上显示 暂停和继续 按钮 //点击情节按钮显示播放按钮
            self.playOrPauseBtn.alpha = 1;
            self.nextPlot.alpha = 1;
            self.lastPlot.alpha = 1;
            self.recordBtn.alpha = 1;
            self.recordSoundBtn.alpha = 1;
            self.toStudyPaintingBtn.alpha = 1;
            
            self.playOrPauseBtn.isBigger = false;
            self.nextPlot.isBigger = false;
            self.lastPlot.isBigger = false;
            self.recordBtn.isBigger = false;
            self.recordSoundBtn.isBigger = false;
            self.toStudyPaintingBtn.isBigger = false;
            
            [self.view bringSubviewToFront:self.playOrPauseBtn];
            [self.view bringSubviewToFront:self.nextPlot];
            [self.view bringSubviewToFront:self.lastPlot];
            [self.view bringSubviewToFront:self.recordBtn];
            [self.view bringSubviewToFront:self.recordSoundBtn];
            [self.view bringSubviewToFront:self.toStudyPaintingBtn];
            [self.view bringSubviewToFront:superBtn];
            
            
            //情节图片放大后不可与用户交互
            superBtn.userInteractionEnabled = NO;
            
            
        } completion:^(BOOL finished) {
            
            //询问在线听情节还是缓存下来听情节
            
            
        }];
        
        
        
        
    }else{
        
        
        NSLog(@"isBigger = no");
        
        for (UIView *view in self.view.subviews) {

//            if (view.tag >= 200 && view.tag <= 210) {修改前
            if (view.tag >= 200 && view.tag != 666) {//修改了不知道有没有什么影响

                 [self.plotScrollView addSubview:view];
                
            }
        }
        
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            superBtn.frame = superBtn.originRect;
            
            if (superBtn.tag != 1998) {
                  [superBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"storyPlot_superViewFrame"]] forState:UIControlStateNormal];
            }
          
            
            CGRect rect = btn.frame;
            
            /**
             CGFloat innerBtnX = btn.frame.size.width * 0.011;
             CGFloat innerBtnY = btn.frame.size.height * 0.0165;
             CGFloat innerBtnW = btn.frame.size.width * 0.978;
             CGFloat innerBtnH = btn.frame.size.height * 0.97;
             */

            rect.origin.x = superBtn.frame.size.width *0.011;
            rect.origin.y = superBtn.frame.size.height *0.0165;
            rect.size.width = superBtn.frame.size.width *0.978;
            rect.size.height = superBtn.frame.size.height *0.97;

//            if (btn.tag == 210) {
            if (btn.tag == 1998) {

                btn.center = CGPointMake(superBtn.bounds.size.width *0.5, superBtn.bounds.size.height *0.5);

                btn.bounds = CGRectMake(0, 0, superBtn.bounds.size.width *0.6, superBtn.bounds.size.width *0.6);
            }else{
                btn.frame = rect;
            }
            
            
            
            [self removeCoverView];
            
            [self.recordPlayer pause];
            
            //隐藏界面上的在听 按钮
            self.playOrPauseBtn.alpha = 0;
            self.nextPlot.alpha = 0;
            self.lastPlot.alpha = 0;
            self.recordBtn.alpha = 0;
            self.recordSoundBtn.alpha = 0;
            self.toStudyPaintingBtn.alpha = 0;
            
            self.playOrPauseBtn.isBigger = NO;
            self.nextPlot.isBigger = NO;
            self.lastPlot.isBigger = NO;
            self.recordBtn.isBigger = NO;
            self.recordSoundBtn.isBigger = NO;
            self.toStudyPaintingBtn.isBigger = NO;
            
            
        } completion:^(BOOL finished) {
            
            //从self.view中移除情节 - 因为情节是添加到滚动视图中的 添加到self.view中是为了让情节显示在中间
            
//            NSLog(@"view - count == %ld scrollview - count == %ld",self.view.subviews.count,self.plotScrollView.subviews.count);
            
            
            
        }];
        
    }
    
}

#pragma 点击 听录音 选项 调用
- (void)recordBtnClick:(XZQNameButton *)btn{
 
    //点击了听录音之后 再弹出一个录音列表 选择
    
    //弹出录音列表 选择完录音之后 发出通知 情节放大 播放录音
    [self recordFileBtnClick:btn];
    
    //发出通知 变大
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"biggerPlot" object:nil];
    
    
}

#pragma 点击录音列表中的cell调用
- (void)biggerPlot{
    
    NSLog(@"biggerPlot");
    
    //不是左下角的录音按钮 才可以放大故事情节
    if (self.currentNameBtn.tag != 10) {
        
        [self.ZJAPopView dismiss];
        
        XZQNameButton *btn = self.currentNameBtn;
        
        XZQNameButton *superBtn = (XZQNameButton *)btn.superview;
        
        btn.isBigger = YES;
        
        //将图片放大 并且将系统给定的录音播放出来 播放 再次点击 缩小到原来的形状
        if (btn.isBigger) {
            
            if (self.playBtn.enjoyAfterDownload) {
                
                superBtn.isBigger = YES;
                
                //这个时候superBtn的originRect不正常了 放大状态的 还有btn的 也是很大
                NSLog(@"放大前:%@",NSStringFromCGRect(superBtn.originRect));
                
            }else{
                superBtn.isBigger = YES;
            }
            
            //这个时候superBtn的originRect不正常了 放大状态的 还有btn的 也是很大
            NSLog(@"superBtn == %@ btn == %@",NSStringFromCGRect(superBtn.originRect),NSStringFromCGRect(btn.originRect));
            
            //点击使用动画
            
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                
                superBtn.frame = CGRectMake(Width* 0.146484,Height* 0.104167,Width* 0.681152,Height* 0.625000);
                
                [self.view bringSubviewToFront:superBtn];
                
                //这里btn 的originRect 600多了
                CGRect rect = btn.frame;
                
                rect.origin.x = superBtn.frame.size.width *0.046000;
                rect.origin.y = superBtn.frame.size.height *0.045000;
                rect.size.width = superBtn.frame.size.width *0.900300;
                rect.size.height = superBtn.frame.size.height *0.868333;
                
                btn.frame = rect;
                
                
                //添加遮罩
                self.coverView.frame = self.view.bounds;
                self.coverView.alpha = 0;
                self.coverView.backgroundColor = [UIColor blackColor];
                self.coverView.tag = 666;
                [self.view addSubview:self.coverView];
                
                [self.view bringSubviewToFront:self.coverView];
                
                
                self.coverView.alpha = 0.5;
                
                NSLog(@"isOnlineRecord - %d",self.currentNameBtn.isOnlineRecord);
                
//                if (self.currentNameBtn.isOnlineRecord) {
//
//                    //在线播放音频
//                    [self playRecord:btn];
//
//                }else{
//                    //点击了缓存 听本地录音
//
//                }
                
                
                
                //在 在线听界面上显示 暂停和继续 按钮 //点击情节按钮显示播放按钮
                self.playOrPauseBtn.alpha = 1;
                self.nextPlot.alpha = 1;
                self.lastPlot.alpha = 1;
                self.recordBtn.alpha = 1;
                self.recordSoundBtn.alpha = 1;
                self.toStudyPaintingBtn.alpha = 1;
                
                self.playOrPauseBtn.isBigger = false;
                self.nextPlot.isBigger = false;
                self.lastPlot.isBigger = false;
                self.recordBtn.isBigger = false;
                self.recordSoundBtn.isBigger = false;
                self.toStudyPaintingBtn.isBigger = false;
                
                
            } completion:^(BOOL finished) {
                
                //询问在线听情节还是缓存下来听情节
            }];
            
            
            
            
        }else{
            
            NSLog(@"isBigger = no");
            
            
            
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                
                superBtn.frame = superBtn.originRect;
                
                NSLog(@"superBtn.originRect == %@",NSStringFromCGRect(superBtn.originRect));
                
                CGRect rect = btn.frame;
                
                rect.origin.x = superBtn.frame.size.width *0.049000;
                rect.origin.y = superBtn.frame.size.height *0.050000;
                rect.size.width = superBtn.frame.size.width *0.894488;
                rect.size.height = superBtn.frame.size.height *0.860333;
                
                btn.frame = rect;
                
                [self removeCoverView];
                
                [self.recordPlayer pause];
                
                //隐藏界面上的在听 按钮
                self.playOrPauseBtn.alpha = 0;
                self.nextPlot.alpha = 0;
                self.lastPlot.alpha = 0;
                self.recordBtn.alpha = 0;
                self.recordSoundBtn.alpha = 0;
                self.toStudyPaintingBtn.alpha = 0;
                
                self.playOrPauseBtn.isBigger = NO;
                self.nextPlot.isBigger = NO;
                self.lastPlot.isBigger = NO;
                self.recordBtn.isBigger = NO;
                self.recordSoundBtn.isBigger = NO;
                self.toStudyPaintingBtn.isBigger = NO;
                
                
            } completion:^(BOOL finished) {
                
            }];
            
        }
        
    }else{
        NSLog(@"tag == 10");
    }
    
}



#pragma 在线播放按钮点击事件
- (void)playOrPauseBtnClick:(XZQNameButton *)btn{
    
    
    if (!btn.isBigger) {
        
        //播放
        
        //        [self.playOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        self.playOrPauseBtn.isBigger = NO;
        self.nextPlot.isBigger = NO;
        self.lastPlot.isBigger = NO;
        self.recordBtn.isBigger = NO;
        self.recordSoundBtn.isBigger = NO;
        self.toStudyPaintingBtn.isBigger = NO;
        
        [self.recordPlayer play];
        
        //发出通知让录音开始播放
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recordPlay" object:nil];
        
        
    }else{
        
        //暂停
        //        [self.playOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        self.playOrPauseBtn.isBigger = YES;
        self.nextPlot.isBigger = YES;
        self.lastPlot.isBigger = YES;
        self.recordBtn.isBigger = YES;
        self.recordSoundBtn.isBigger = YES;
        self.toStudyPaintingBtn.isBigger = YES;
        
        [self.recordPlayer pause];
        
        //发出通知让录音暂停
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recordPause" object:nil];
        
        
    }
    
}


#pragma 播放录音(在线播放或者播放本地录音)
- (void)playRecord:(XZQNameButton *)btn{
    
    //超时了 15s
    
    NSLog(@"开始在线播放 playRecord");
    
    //在线播放
    NSString *recordPath = [self.baseURL stringByAppendingPathComponent:[NSString stringWithFormat:@"video/matchGirl/%@.mp3",btn.name]];
    
    NSURL *onlineRecordURL = [NSURL URLWithString:recordPath];
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:onlineRecordURL];
    [self.recordPlayer replaceCurrentItemWithPlayerItem:playerItem];
    [self.recordPlayer play];
    self.recordPlayer.rate = 1.0;
    
}


//退出视频播放
- (void)exitVideo{
    
    NSLog(@"exitVideo");
    
    self.exitFlag = YES;
    
    [self viewWillLayoutSubviews];
    
}

#pragma 缩小故事情节
- (void)narrowPlot{
    
    //需要缩小故事情节
    NSLog(@"准备缩小--------");
    
    XZQNameButton *temp = self.currentNameBtn;
    
    if (self.playBtn.playAll) {
        
        NSLog(@"在线播放过程中点击了遮罩");
        
        //退出播放 记得将 + 号
        XZQNameButton *superBtn = nil;
        
        for (XZQNameButton *btn in self.detailsPlotBtnArray) {
            
            btn.alpha = 1;
            superBtn = (XZQNameButton *)btn.superview;
            superBtn.alpha = 1;
            
            self.currentNameBtn = btn;
            
            
            superBtn.userInteractionEnabled = YES;
            self.currentNameBtn.isBigger = NO;
            
            //缩小
            for (NSString *superName in self.superRectDict) {
                
               
                
                if ([superName isEqualToString:superBtn.name]) {
                    
                    
                    CGRect superOriginRect = CGRectFromString([self.superRectDict objectForKey:superName]);
                    superBtn.originRect = superOriginRect;
                    
                    NSLog(@"%@设置了originRect的值",superName);
                    NSLog(@"%@调用缩小之前",btn.name);
                    [self onlineRecord];
                }
                
            }
            
            
            
            
        }
        self.playBtn.playAll = NO;
        
        return;
        
    }
    
    self.currentNameBtn = temp;
    
    XZQNameButton *superBtn = (XZQNameButton *)self.currentNameBtn.superview;
    superBtn.userInteractionEnabled = YES;
    
    self.currentNameBtn.isBigger = NO;
    
//    [self.currentNameBtn addTarget:self action:@selector(playStory:) forControlEvents:UIControlEventTouchUpInside];
    
    for (NSString *superName in self.superRectDict) {
        
        //recordBtn 其父控件无name属性
        if (self.currentNameBtn.tag == 11) {
            continue;
        }
        
        NSLog(@"superName = %@",superName);
        NSLog(@"superBtn.name = %@",superBtn.name);
        
        if ([superName isEqualToString:superBtn.name]) {
            
            
            CGRect superOriginRect = CGRectFromString([self.superRectDict objectForKey:superName]);
            superBtn.originRect = superOriginRect;
            
            NSLog(@"narrowPlot方法 -  superOriginRect%@",NSStringFromCGRect(superOriginRect));
            
            [self onlineRecord];
        }
        
    }
    

}

- (void)toStory{
    self.tabBarController.selectedIndex = 1;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

//布局子控件 - 会重复调用的 - 后期完善代码的时候注意
- (void)viewWillLayoutSubviews{
    
    //一整块背景
    CGFloat view1X = self.view.frame.size.width * 0.0208;
    CGFloat view1Y = self.view.frame.size.height * 0.0314;
    CGFloat view1W = self.view.frame.size.width * 0.9571;
    CGFloat view1H = self.view.frame.size.height * 0.9391;
    
    self.view1.frame = CGRectMake(view1X, view1Y, view1W, view1H);
    self.view1.image = [UIImage imageNamed:@"story_backgroundFrame"];
    [self.details setBackgroundImage:[UIImage imageNamed:@"story_backgroundFrame"] forState:UIControlStateNormal];
    
    //详情按钮
    CGFloat detailsX = self.view.frame.size.width * 0.0623;
    CGFloat detailsY = self.view.frame.size.height * 0.06;
    CGFloat detailsW = self.view.frame.size.width * 0.0498;
    CGFloat detailsH = self.view.frame.size.width * 0.0498;
    
    self.returnToStory.frame = CGRectMake(detailsX, detailsY, detailsW, detailsH);
    self.returnToStory.tag = 99;
    [self.returnToStory setBackgroundImage:[UIImage imageNamed:@"drawboard_lastStepBtn"] forState:UIControlStateNormal];
    [self.returnToStory addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.returnToMainFunc.frame = CGRectMake(detailsX, detailsY, detailsW, detailsH);
    self.returnToMainFunc.tag = 100;
    [self.returnToMainFunc setBackgroundImage:[UIImage imageNamed:@"drawboard_lastStepBtn"] forState:UIControlStateNormal];
    [self.returnToMainFunc addTarget:self action:@selector(toMainFuncIB:) forControlEvents:UIControlEventTouchUpInside];

    
    
    //播放按钮
    CGFloat playBtnX = self.view.frame.size.width * 0.7839;
    CGFloat playBtnY = -Height;
    
    self.playBtn.frame = CGRectMake(playBtnX, playBtnY, detailsW, detailsH);
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(playAllPlot) forControlEvents:UIControlEventTouchUpInside];
    
    //主页按钮
    CGFloat jumpToMainFuncIBButtonX = self.view.frame.size.width * 0.8823;
    
//    self.mainBtn.frame = CGRectMake(mainBtnX, detailsY, detailsW, detailsH);
//    [self.mainBtn setBackgroundImage:[UIImage imageNamed:@"main"] forState:UIControlStateNormal];
//    [self.mainBtn addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
    self.jumpToMainFuncIBButton.frame = CGRectMake(jumpToMainFuncIBButtonX, detailsY, detailsW, detailsH);
//    [self.jumpToMainFuncIBButton setBackgroundImage:[UIImage imageNamed:@"drawboard_returnBtn"] forState:UIControlStateNormal];
    [self.jumpToMainFuncIBButton setBackgroundImage:[UIImage imageNamed:@"patingAlbum_returnToMainFuncIB"] forState:UIControlStateNormal];
    [self.jumpToMainFuncIBButton addTarget:self action:@selector(jumpToMainFuncIB) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.alreadySkip) {
        //故事名称
        
        self.playBtn.alpha = 0;
        
        CGFloat storyNameX = self.view.frame.size.width * 0.2715;
        CGFloat storyNameY = self.view.frame.size.height * 0.0366;
        CGFloat storyNameW = self.view.frame.size.width * 0.4488;
        CGFloat storyNameH = self.view.frame.size.height * 0.0942;
        
        self.storyName.alpha = 1;
        self.storyName.frame = CGRectMake(storyNameX, storyNameY, storyNameW, storyNameH);
        self.storyName.text = @"故  事 汇";
        self.storyName.textColor = [UIColor colorWithRed:255/255.0 green:173/255.0 blue:61/255.0 alpha:1];
        self.storyName.font = [UIFont systemFontOfSize:30];
        
        self.storyName.textAlignment = NSTextAlignmentCenter;
    }
    
    
    
    
    
    
    //故事矩形框
    //列数
    
    //一次性代码 - 只执行一次 - 解决了重复调用重复添加子控件的问题
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
 
        
        int columns = 4;
        
        
        CGFloat blankW = self.view.frame.size.width * 0.1861;//0.1861    0.3064
        CGFloat blankH = self.view.frame.size.height * 0.3064;
        CGFloat blankX = self.view.frame.size.width * 0.0637;
        CGFloat blankY = self.view.frame.size.height * 0.1919;
        
        CGFloat intervalW = self.view.frame.size.width * 0.0389;
        
        //故事书的框框
        for (int i = 0; i < 8; i++) {
            
            XZQNameButton *btn = [[XZQNameButton alloc] init];
//            [btn setBackgroundImage:[UIImage imageNamed:@"blank"] forState:UIControlStateNormal];//storyPlot_superViewFrame
            
            btn.tag = i;
            [btn addTarget:self action:@selector(playStory:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.blankArray addObject:btn];
            [self.view addSubview:btn];
            
            CGFloat x = blankX + (i % columns) * (blankW + intervalW);
            CGFloat y = blankY + (i / columns) * (blankW + intervalW);
            
            btn.frame = CGRectMake(x, y, blankW, blankH);
            btn.backgroundColor = [UIColor clearColor];
            
//            [btn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"storyPlot_superViewFrame"]] forState:UIControlStateNormal];
        }
        
        //故事书
        
        
        //书本加入到框框中
        for (XZQNameButton *btn in self.blankArray) {
            
            CGFloat bookX = btn.frame.size.width * 0.0889;
            CGFloat bookY = btn.frame.size.height * 0.0440;
            CGFloat bookW = btn.frame.size.width * 0.8370;
            CGFloat bookH = btn.frame.size.height * 0.8501;//486 629 0.7727
            
            XZQNameButton *innerBtn = [[XZQNameButton alloc] init];
            [btn addSubview:innerBtn];
            innerBtn.tag = btn.tag;
            innerBtn.frame = CGRectMake(bookX, bookY, bookW, bookH);
            [innerBtn addTarget:self action:@selector(playStory:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *label = [[UILabel alloc] init];//frame - 计算 - 书本宽度的90% - 高度的30%
            [innerBtn addSubview:label];
            
            CGFloat labelX = innerBtn.frame.size.width * 0.0796;
            CGFloat labelY = innerBtn.frame.size.height * 0.4938;
            CGFloat labelW = innerBtn.frame.size.width * 0.8496;
            CGFloat labelH = innerBtn.frame.size.height * 0.1358;
            
            label.frame = CGRectMake(labelX, labelY, labelW, labelH);
            label.textAlignment = NSTextAlignmentCenter;
            
            switch (btn.tag) {
                case 0:
//                    [innerBtn setBackgroundImage:[UIImage imageNamed:@"greenbook"] forState:UIControlStateNormal];
                    [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"story_threeBoys"]] forState:UIControlStateNormal];
                    //搞个label标识书名 - 计算label的frame - label加入到innnerBtn中
                    //                    label.text = @"《海贼王》";
                    label.font = [UIFont systemFontOfSize:14];
                    label.textAlignment = NSTextAlignmentLeft;
//                    label.text = @"《三个和尚的故事》";
                    label.textColor = [UIColor colorWithRed:109/255.0 green:159/255.0 blue:36/255.0 alpha:1];
                    //                    btn.name = @"qingqukatong_05.mp4";
                    btn.name = @"threeBoys";
                    
                    //三个和尚的故事动画url
                    btn.storyVideoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"三个和尚的故事" ofType:@"mp4"]];
                    
                    break;
                case 1:
//                    [innerBtn setBackgroundImage:[UIImage imageNamed:@"redbook"] forState:UIControlStateNormal];
                    [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"story_bamboo"]] forState:UIControlStateNormal];
                    label.font = [UIFont systemFontOfSize:14];
//                    label.text = @"《竹里馆》";
                    label.textColor = [UIColor colorWithRed:196/255.0 green:72/255.0 blue:119/255.0 alpha:1];
                    btn.name = @"bamboo";
                    
                    btn.storyVideoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"竹里馆" ofType:@"mp4"]];
                    break;
                case 2:
//                    [innerBtn setBackgroundImage:[UIImage imageNamed:@"bluebook"] forState:UIControlStateNormal];
                    [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"story_matchGirl"]] forState:UIControlStateNormal];//story_bamboo
                    label.font = [UIFont systemFontOfSize:14];
//                    label.text = @"《海的女儿》";
                    label.textColor = [UIColor colorWithRed:112/255.0 green:237/255.0 blue:190/255.0 alpha:1];
                    //                    btn.name = @"girlOfSea.mp4";
                    btn.name = @"matchGirl";
                    break;
                case 3:
//                    [innerBtn setBackgroundImage:[UIImage imageNamed:@"bluebook"] forState:UIControlStateNormal];
                    [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"story_smallRed"]] forState:UIControlStateNormal];
                    label.font = [UIFont systemFontOfSize:14];
//                    label.text = @"敬请期待";
                    btn.name = @"smallRed";
                    break;
                
                case 4:
                //                    [innerBtn setBackgroundImage:[UIImage imageNamed:@"bluebook"] forState:UIControlStateNormal];
                                    [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"kong"]] forState:UIControlStateNormal];
                                    label.font = [UIFont systemFontOfSize:14];
                //                    label.text = @"敬请期待";
                                    btn.name = @"kong";
                                    break;
                
                
                case 5:
                //                    [innerBtn setBackgroundImage:[UIImage imageNamed:@"bluebook"] forState:UIControlStateNormal];
                                    [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"wen"]] forState:UIControlStateNormal];
                                    label.font = [UIFont systemFontOfSize:14];
                //                    label.text = @"敬请期待";
                                    btn.name = @"wen";
                                    break;
                    
                
                case 6:
                //                    [innerBtn setBackgroundImage:[UIImage imageNamed:@"bluebook"] forState:UIControlStateNormal];
                                    [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"you"]] forState:UIControlStateNormal];
                                    label.font = [UIFont systemFontOfSize:14];
                //                    label.text = @"敬请期待";
                                    btn.name = @"you";
                                    break;
                
                case 7:
                //                    [innerBtn setBackgroundImage:[UIImage imageNamed:@"bluebook"] forState:UIControlStateNormal];
                                    [innerBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"zao"]] forState:UIControlStateNormal];
                                    label.font = [UIFont systemFontOfSize:14];
                //                    label.text = @"敬请期待";
                                    btn.name = @"zao";
                                    break;
                    
                
                default:
                    break;
            }
            
            innerBtn.name = btn.name;
            if (btn.storyVideoURL != nil) {
                innerBtn.storyVideoURL = btn.storyVideoURL;
            }
            
            
        }
    });
    
    if (!self.exitFlag) {
        
        self.playerVC.view.frame = self.view.bounds;
        
        
        
        [KeyWindow bringSubviewToFront:self.exitBtn];
        
    }else{
        
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [self.exitBtn removeFromSuperview];
        
    }
    
    
    //隐藏掉故事界面的返回到画板界面的按钮
    if (!self.alreadySkip) {
       self.returnToStory.alpha = 0;
    }
}

#pragma 点击播放全部情节
static NSInteger i = 0;

- (void)playAllPlot{
    
    //点击弹出在线播放全部 缓存全部 取消
    [self alertAllPlot];
}

#pragma 情节全部放大
- (void)biggerAllPlot{
    
    
    if (self.playBtn.enjoyAfterDownload) {
        i = 0;
    }
    
    XZQNameButton *currentPlotPlay = self.detailsPlotBtnArray[i];
    self.currentNameBtn = currentPlotPlay;
    BOOL repeatAdd = true;
    
    for (XZQNameButton *btn in self.detailsPlotBtnArray) {
        
        if ([btn.name isEqualToString:self.currentNameBtn.name]) {
            repeatAdd = false;
        }
        
        //让每情节按钮变大
        [self biggerOperation:btn repeatAdd:repeatAdd];
        
        
        NSLog(@"btnName=%@ originRect=%@",btn.name,NSStringFromCGRect(btn.originRect));
    }
    
    
    
    if (self.playBtn.enjoyAfterDownload) {
        
        //按顺序播放已经缓存的当前情节
        [self recordBaseOperation];
        
    }else{
        //按顺序在线播放当前情节
        [self playByOrder];
    }
    
    
    
    
}


#pragma 情节按钮放大计算
- (void)biggerOperation:(XZQNameButton *)btn repeatAdd:(BOOL)repeatAdd{
    
    NSLog(@"biggerOperation");
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        XZQNameButton *superBtn = (XZQNameButton *)btn.superview;
        
        if ([btn.name isEqualToString:@"plus"]) {
            
            superBtn.alpha = 0;
            btn.alpha = 0;
            
        }else{
            
            superBtn.isBigger = YES;
            btn.isBigger = YES;
            
            
            NSLog(@"biggerOperation :superBtn = %@ btn = %@ btnName =%@",NSStringFromCGRect(superBtn.originRect),NSStringFromCGRect(btn.originRect),btn.name);
            
            [self.view addSubview:superBtn];
            [self.view bringSubviewToFront:self.coverView];
            
            //点击使用动画
            
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                
                superBtn.frame = CGRectMake(Width* 0.146484,Height* 0.104167,Width* 0.681152,Height* 0.625000);
                
                [self.view bringSubviewToFront:superBtn];
                
                
                
                
                CGRect rect = btn.frame;
                
                
                rect.origin.x = superBtn.frame.size.width *0.046000;
                rect.origin.y = superBtn.frame.size.height *0.045000;
                rect.size.width = superBtn.frame.size.width *0.900300;
                rect.size.height = superBtn.frame.size.height *0.868333;
                
                btn.frame = rect;
                
                //防止重复添加
                if (!repeatAdd) {
                    
                    //添加遮罩
                    self.coverView.frame = self.view.bounds;
                    self.coverView.alpha = 0;
                    self.coverView.backgroundColor = [UIColor blackColor];
                    self.coverView.tag = 666;
                    [self.view addSubview:self.coverView];
                    
                    [self.view bringSubviewToFront:self.coverView];
                    
                    
                    self.coverView.alpha = 0.5;
                    
                    self.playOrPauseBtn.alpha = 1;
                    self.nextPlot.alpha = 1;
                    self.lastPlot.alpha = 1;
                    self.recordBtn.alpha = 1;
                    self.recordSoundBtn.alpha = 1;
                    self.toStudyPaintingBtn.alpha = 1;
                    
                    self.playOrPauseBtn.isBigger = false;
                    self.nextPlot.isBigger = false;
                    self.lastPlot.isBigger = false;
                    self.recordBtn.isBigger = false;
                    self.recordSoundBtn.isBigger = false;
                    self.toStudyPaintingBtn.isBigger = false;
                }
                
                //在 在线听界面上显示 暂停和继续 按钮 //点击情节按钮显示播放按钮
                
                
                
            } completion:^(BOOL finished) {
                
                
                if ([btn.name isEqualToString:self.currentNameBtn.name]) {
                    NSLog(@"biggerAllPlot");
                    NSLog(@"btnName = %@ btnAlpha = 1  currentNameBtn = %@",btn.name,self.currentNameBtn.name);
                    superBtn.alpha = 1;
                    btn.alpha = 1;
                    
                }else{
                    superBtn.alpha = 0;
                    btn.alpha = 0;
                }
                
            }];
        }
        
        
        
        
    }];
    
    
    
}

#pragma 按顺序播放当前情节
- (void)playByOrder{
    
    //让第一个在线播放
    
    //在线播放了
    [self playRecord:self.currentNameBtn];
    
}

#pragma 播放完毕
//原来的有播放按钮的方法
//- (void)playbackFinished{
//
//    NSLog(@"音频已经播放完毕");
//
//    if (self.playBtn.playAll) {
//
//        i++;
//        self.currentNameBtn = self.detailsPlotBtnArray[i];
//
//        if ([self.currentNameBtn.name isEqualToString:@"plus"]) {
//            i = 0;
//            self.playBtn.enjoyAfterDownload = NO;
//            [self narrowPlot];
//
//            /**
//
//             //            XZQNameButton *superBtn = nil;
//             //            for (XZQNameButton *btn in self.detailsPlotBtnArray) {
//             //                btn.alpha = 1;
//             //                superBtn = (XZQNameButton *)btn.superview;
//             //                superBtn.alpha = 1;
//             //
//             //                self.currentNameBtn = btn;
//             //                NSLog(@"播放结束你调用了吗");
//             //
//             //
//             //                if ([btn.name isEqualToString:@"plus"]) {
//             //                    btn.alpha = 1;
//             //                    superBtn.alpha = 1;
//             //                    continue;
//             //                }
//             //
//             //                [self narrowPlot];
//             //            }
//             //
//             //            self.playBtn.playAll = NO;
//             //退出播放 记得将 + 号
//             */
//
//
//
//            return;
//        }
//
//        //翻页...
//        [self transitionWithType:@"pageCurl" WithSubtype:kCATransitionFromRight ForView:self.currentNameBtn];
//
//        for (XZQNameButton *btn in self.detailsPlotBtnArray) {
//
//            XZQNameButton *superBtn = (XZQNameButton *)btn.superview;
//
//            if ([btn.name isEqualToString:self.currentNameBtn.name]) {
//
//                [UIView animateWithDuration:0.5 animations:^{
//                    superBtn.alpha = 1;
//                    btn.alpha = 1;
//                }];
//
//            }else{
//                [UIView animateWithDuration:0.5 animations:^{
//                    superBtn.alpha = 0;
//                    btn.alpha = 0;
//                }];
//            }
//
//            NSLog(@"btnName = %@ alpha = %f",btn.name,btn.alpha);
//        }
//
//
//        //enjoyAfterDownload 点击了缓存听
//        if (self.playBtn.enjoyAfterDownload) {
//
//            [self recordBaseOperation];
//
//        }else{
//            //在线播放下一个
//            [self playByOrder];
//        }
//
//
//
//    }else{
//
//        //普通的点击某一个具体的情节按钮播放完毕
//        if (self.currentNameBtn.tag != 10) {
//
//            NSLog(@"调用了playbackFinished 音频播放完毕");
//
//            //播放完毕 缩小情节图片 暂停声音播放
//            [self narrowPlot];
//
//        }
//
//
//    }
//}

#pragma 删除了播放按钮的监听播放完毕的方法
//只播放系统音频
- (void)playFinishedBeingCalled{
    
    NSLog(@"音频已经播放完毕");
    
    //将刚刚播放完毕的情节缩小
    [self narrowPlot];
    
    //延时0.5s执行 等到缩小完毕 再放大另一个
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        
        i++;
        
        NSLog(@"%s %ld",__func__,i);
//        if (self.currentNameBtn.isSelfStoryPlotBtn == true) {
//
//        }else{
            
            self.currentNameBtn = self.detailsPlotBtnArray[i];
//        }
        
        NSLog(@"playFinishedBeingCalled i = %ld - self.currentNameButton = %@",i,self.currentNameBtn.name);
        
        
        if ([self.currentNameBtn.name isEqualToString:@"plus"]) {
            i = 0;
            self.playBtn.enjoyAfterDownload = NO;
            [self narrowPlot];
            
            NSLog(@"playFinishedBeingCalled -- 播放结束啦");
            
            return;
        }
        
        __weak typeof(XZQStoryViewController *)weakSelf = self;
        
        [UIView animateWithDuration:0.5 animations:^{
            //翻页... 在新的图片上面翻页 边翻边放大
            [weakSelf transitionWithType:@"pageCurl" WithSubtype:kCATransitionFromRight ForView:self.currentNameBtn];
            
            //等会这里可以判断一下 是继续播放系统的还是自己的声音
            if (self.listentoLocalOrSelfRecord == 1) {
                [self watchStoryVideoFromXib];
            }else if (self.listentoLocalOrSelfRecord == 2){
                [self listenToSelfAndWatchVideoFromXib];
            }
            
            
        }];
        
        [self playSystemLocalRecord];
        
    });
    
    
    
    
}


#pragma CATransition动画实现
/**
 *  动画效果实现
 *
 *  @param type    动画的类型 在开头的枚举中有列举,比如 CurlDown//下翻页,CurlUp//上翻页
 ,FlipFromLeft//左翻转,FlipFromRight//右翻转 等...
 *  @param subtype 动画执行的起始位置,上下左右
 *  @param view    哪个view执行的动画
 */
- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view {
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0f;
    animation.type = type;
    if (subtype != nil) {
        animation.subtype = subtype;
    }
    
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    [view.layer addAnimation:animation forKey:@"animation"];
    
    //翻页结束将情节图片更换掉 - 一次性放大两张情节图片 等到第一张结束了 隐藏第一张 然后第二张出现 而且翻页效果就有了 紧接着将第三张图片也放大 放在下面一层
    
    
}





- (void)alertAllPlot{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"连续播放" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *online = [UIAlertAction actionWithTitle:@"在线听" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //在线听全部内容
        //遍历detailsBtnArray数组 将所有的情节按钮放大 按顺序叠放 点击任何一个按钮 所有的全部缩小
        [self biggerAllPlot];
        
        
    }];
    UIAlertAction *download = [UIAlertAction actionWithTitle:@"缓存听" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //先检测 没有就下载 弹出下载进度框 有不下载 全部下载完毕 下载完毕也弹框 下载完毕开始播放
        self.playBtn.playAll = YES;
        self.playBtn.enjoyAfterDownload = YES;
        [self enjoyAfterDownload];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:online];
    [alert addAction:download];
    [alert addAction:cancel];
    
    if (self.popVisible) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma 缓存听
static NSInteger k = 0;
- (void)enjoyAfterDownload{
    
    //当全部下载完毕
    if (k == self.detailsPlotBtnArray.count - 1) {
        
        k = 0;
        //将所有的放大 - 按循序播放播放
        [self biggerAllPlot];
        
        return;
    }
    //先检测内存中有没有对应下载好的文件
    XZQNameButton *btn = self.detailsPlotBtnArray[k];
    btn.isBigger = YES;
    
    NSLog(@"%@",NSStringFromCGRect(btn.originRect));
    
    if ([btn.name isEqualToString:@"plus"]) {
        return;
    }
    
    self.currentNameBtn = btn;
    [self containsDownloadCompletedFile:btn];
    
}

#pragma 检测内存中有没有下载好的文件
- (BOOL)containsDownloadCompletedFile:(XZQNameButton *)btn{
    
    //检测内存中有没有
    self.recordName = btn.name;
    
    if ([self.downloadingRecordArray containsObject:btn.name]) {
        [self popUpBoxRecordDownload:btn.name message:@"正在加载中" btnContentOne:@"知道了"];
        return false;
    }
    
    //检测
    //遍历音频文件夹
    NSDirectoryEnumerator *enumertator = [self.manager enumeratorAtPath:self.soundFolderPath];
    
    NSString *filePath = nil;
    
    //开始遍历文件夹
    while (nil != (filePath = [enumertator nextObject])) {
        
        NSLog(@"录音文件的名称为 = %@",filePath);
        
        //因为存的时候都是以.mp3结尾的 btn.name 没有.mp3后缀
        NSString *newBtnName = [btn.name stringByAppendingString:@".mp3"];
        
        if ([newBtnName isEqualToString:filePath]) {
            
            
            NSInteger integer = [self getRecordFileSize];
            
            if (integer != 0) {
                
                self.recordTotalSizeDict = [[NSMutableDictionary alloc] initWithContentsOfFile:self.recordTotalSizePlistPath];
                
                
                for (NSString *temp in self.recordTotalSizeDict) {
                    
                    
                    if ([temp isEqualToString:newBtnName]) {
                        
                        
                        
                        NSString *currentSize = [NSString stringWithFormat:@"%ld",integer];
                        NSString *totalSize = [self.recordTotalSizeDict objectForKey:temp];
                        
                        if ([currentSize isEqualToString:totalSize] == NO) {
                            
                            
                            
                            UIAlertController *alertRecord = [UIAlertController alertControllerWithTitle:btn.name message:@"没有下载完毕" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *rightAction = [UIAlertAction actionWithTitle:@"继续下载剩余部分" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                                if (![self.downloadingRecordArray containsObject:newBtnName]) {
                                    
                                    [self.downloadingRecordArray addObject:newBtnName];
                                }
                                
                                [self.recordDataTask resume];
                            }];
                            
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                
                            }];
                            
                            [alertRecord addAction:rightAction];
                            [alertRecord addAction:cancelAction];
                            
                            [self presentViewController:alertRecord animated:YES completion:nil];
                            
                            return false;
                        }else{
                            
                            k++;
                            [self enjoyAfterDownload];
                            return true;
                        }
                        
                    }
                }
            }
            
        }
    }
    
    
    //音频文件夹是空的
    
    //音频文件夹不是空的 但是现在没有对应的音频 需要下载
    
    [self goOnDownload];
    
    NSLog(@"本地没有%@音频",btn.name);
    
    return false;
}

#pragma 继续下载
- (void)goOnDownload{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        XZQNameButton *superBtn = (XZQNameButton *)self.currentNameBtn.superview;
        
        superBtn.userInteractionEnabled = YES;
        
    }];
    
    self.currentNameBtn.isOnlineRecord = false;
    
    //应该是你点击缓存的时候才去建立对应的文件夹
    [self createRecordFile:self.currentNameBtn];
    
    //缓存操作
    self.currentNameBtn.isBigger = NO;
    
    //响应事件
    self.loadingRecordName = self.currentNameBtn.name;
    
    //下载视频到对应文件夹
    self.recordDataTask = nil;
    
    [self downloadRecord:self.currentNameBtn];
}

#pragma 返回故事界面
- (void)leftBtnClick:(XZQNameButton *)btn{
    
    self.plusClickCount = 0;
    
    XZQNameButton *temp;
    
    if (self.detailsBtnArray.count != 0) {
        temp = self.detailsBtnArray[0];
    }
    
    self.currentNameBtn = btn;
    
    
    //弹出弹框
    ZJAnimationPopStyle popStyle =  ZJAnimationPopStyleShakeFromTop;
    ZJAnimationDismissStyle dismissStyle = ZJAnimationDismissStyleDropToBottom;
    
    self.customView = nil;
    _customView = [SlideSelectCardView xib4];
    
    self.customView.title = @"切换界面";
    self.customView.showOperaion = @"即将切换到故事界面";
    
    
    if ([temp.name rangeOfString:@"matchGirl"].location != NSNotFound) {
//        self.customView.image = [UIImage imageNamed:@"logoOfStory7"];//story_matchGirl
        self.customView.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"story_matchGirl"]];
    }else if ([temp.name rangeOfString:@"threeBoys"].location != NSNotFound){
//        self.customView.image = [UIImage imageNamed:@"logoOfStory7"];//story_threeBoys
        self.customView.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"story_threeBoys"]];
    }else if ([temp.name rangeOfString:@"bamboo"].location != NSNotFound){
//        self.customView.image = [UIImage imageNamed:@"logoOfStory7"];//story_bamboo
        self.customView.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"story_bamboo"]];
    }else{
        self.customView.image = [UIImage imageNamed:@"logoOfStory7"];
    }
    
    self.customView.delegate = self;
    
   
    
    if (!self.alreadySkip) {
        
        btn.alpha = 0;
        
        //弹出弹框时从右向左到中间
        popStyle = ZJAnimationPopStyleShakeFromLeft;
        dismissStyle = ZJAnimationDismissStyleDropToRight;
        
        self.customView.showOperaion = @"即将切换到画板界面";
        
        
        // 1.初始化
        ZJAnimationPopView *popView = [[ZJAnimationPopView alloc] initWithCustomView:self.customView popStyle:popStyle dismissStyle:dismissStyle];
        self.ZJAPopView = popView;
        
        // 2.设置属性，可不设置使用默认值，见注解
        
        // 2.2 显示时背景的透明度
        popView.popBGAlpha = 0.5f;
        // 2.3 显示时是否监听屏幕旋转
        popView.isObserverOrientationChange = YES;
        // 2.4 显示时动画时长
        //    popView.popAnimationDuration = 0.8f;
        // 2.5 移除时动画时长
        //    popView.dismissAnimationDuration = 0.8f;
        
        // 2.6 显示完成回调
        popView.popComplete = ^{
            NSLog(@"显示完成");
        };
        // 2.7 移除完成回调
        popView.dismissComplete = ^{
            NSLog(@"移除完成");
        };
        
        
        // 4.显示弹框
        [popView pop];
        
        //回到画板界面
        
        return;
    }
    
    // 1.初始化
    ZJAnimationPopView *popView = [[ZJAnimationPopView alloc] initWithCustomView:self.customView popStyle:popStyle dismissStyle:dismissStyle];
    self.ZJAPopView = popView;
    
    // 2.设置属性，可不设置使用默认值，见注解
    
    // 2.2 显示时背景的透明度
    popView.popBGAlpha = 0.5f;
    // 2.3 显示时是否监听屏幕旋转
    popView.isObserverOrientationChange = YES;
    // 2.4 显示时动画时长
    //    popView.popAnimationDuration = 0.8f;
    // 2.5 移除时动画时长
    //    popView.dismissAnimationDuration = 0.8f;
    
    // 2.6 显示完成回调
    popView.popComplete = ^{
        NSLog(@"显示完成");
    };
    
    
    
    // 2.7 移除完成回调
    popView.dismissComplete = ^{
        NSLog(@"移除完成");
        
    };
    
    // 4.显示弹框
    [popView pop];
    
    NSLog(@"返回故事界面");//还有些问题 self.currentNamebtn的问题 放在alreadySkip括号里面还是外面 还有将下面的代码放在点击弹框的确定按钮之后调用的方法中 和skip区分开
    
    
    
    
    
}

#pragma 点击跳转到主功能界面
- (void)toMainFuncIB:(XZQNameButton *)btn{
    self.plusClickCount = 0;
        
        self.currentNameBtn = btn;
        
        
        //弹出弹框
        ZJAnimationPopStyle popStyle =  ZJAnimationPopStyleShakeFromTop;
        ZJAnimationDismissStyle dismissStyle = ZJAnimationDismissStyleDropToBottom;
        
        self.customView = nil;
        _customView = [SlideSelectCardView xib4];
        
        self.customView.title = @"切换界面";
        self.customView.showOperaion = @"即将切换到故事界面";
        
        
        //加入customView中一张imageView 放一张图进入
        self.customView.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"main_story"]];
        
        self.customView.delegate = self;
        
        
        // 1.初始化
        ZJAnimationPopView *popView = [[ZJAnimationPopView alloc] initWithCustomView:self.customView popStyle:popStyle dismissStyle:dismissStyle];
        self.ZJAPopView = popView;
        
        // 2.设置属性，可不设置使用默认值，见注解
        
        // 2.2 显示时背景的透明度
        popView.popBGAlpha = 0.5f;
        // 2.3 显示时是否监听屏幕旋转
        popView.isObserverOrientationChange = YES;
        // 2.4 显示时动画时长
        //    popView.popAnimationDuration = 0.8f;
        // 2.5 移除时动画时长
        //    popView.dismissAnimationDuration = 0.8f;
        
        // 2.6 显示完成回调
        popView.popComplete = ^{
            NSLog(@"显示完成");
        };
        
        
        
        // 2.7 移除完成回调
        popView.dismissComplete = ^{
            NSLog(@"移除完成");
            
        };
        
        // 4.显示弹框
        [popView pop];
        
        NSLog(@"返回故事界面");//还有些问题 self.currentNamebtn的问题 放在alreadySkip括号里面还是外面 还有将下面的代码放在点击弹框的确定按钮之后调用的方法中 和skip区分开
}

//弹出视频退出按钮
- (void)showUpExitBtn{
    
    [KeyWindow addSubview:self.exitBtn];
    [KeyWindow bringSubviewToFront:self.exitBtn];
    
    self.exitBtn.alpha = 1;
    
    self.exitFlag = NO;
}

- (void)popView{
    
    self.coverView.frame = self.view.bounds;
    self.coverView.alpha = 0;
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.tag = 666;
    
    CGFloat popVcW = self.view.bounds.size.width * 0.2950;
    CGFloat popVcH = self.view.bounds.size.height;
    CGFloat popVcX = self.view.bounds.size.width * 0.7049 + popVcW;
    CGFloat popVcY = 0;
    
    self.popVc.view.frame = CGRectMake(popVcX, popVcY, popVcW, popVcH);
    self.popVc.image = [UIImage imageNamed: @"navigation_big"];
    self.popVc.view.tag = 1;
    
    [self.view addSubview:self.coverView];
    
    [self.view addSubview:self.popVc.view];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.popVc.view.frame = CGRectMake(popVcX - popVcW, popVcY, popVcW, popVcH);
        
        
        //遮罩
        
        self.coverView.alpha = 0.7;
        
    }];
    
    //每次都要监听！！
    //利用KVO监听PopView的frame改变
    [self.popVc.view addObserver:self forKeyPath:@"tag" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)removeCoverView{
    
    NSLog(@"%s",__func__);
    
    for (UIView *view in self.view.subviews) {
        
        if (view.tag == 666) {
            
            
            //            view.backgroundColor = [UIColor redColor];//没有变成红色 - 不从父控件中移除的话 -就变成红色的了 - 为什么从父控件中移除就没有慢慢黑色退去的效果
            
            [UIView animateWithDuration:1.0 animations:^{
                
                view.alpha = 0;//没有变黑
                //                [self.popVc removeFromParentViewController];//不行 - 画板界面点击主页按钮 出现在故事界面
                
                
            } completion:^(BOOL finished) {
                
                //延迟执行 - 解决遮罩向右弹回去黑色view移除后立即消失而不是慢慢消失问题 - 点击频繁还是不行 - 不移除了
                //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                    [view removeFromSuperview];
                //                });
                
            }];
            
            
            return;
        }
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    
    [self removeCoverView];
}

- (void)removeCoverViewAndMoveBackPopView{
    
    
    [self removeCoverView];
    
    //暂停故事动画的播放
//    [self.smallStoryVideoVC.playerVC.player pause];
    
    NSLog(@"removeCoverViewAndMoveBackPopView");//点击遮罩没有调用这里
}



#pragma mark -----------------------------
#pragma mark AVPlayerViewController代理方法

//将要开始画中画时调用的方法
- (void)playerViewControllerWillStartPictureInPicture:(AVPlayerViewController *)playerViewController{
    NSLog(@"将要开始画中画");
    
    self.startPictureInPicture = YES;
    
    
    
    
}

#pragma 网络下载

//建立存储介质文件夹
- (void)createMediaDownloadPath:(XZQNameButton *)btn{
    
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        
        //指定一个需要创建的文件夹的路径
        
        //先获得Caches文件目录/路径
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        //PaintingHouse
        NSString *name = @"PHouse";
        
        //文件夹全路径
        self.phousePath = [caches stringByAppendingPathComponent:name];
        
        
        //下次程序运行的时候 如果已经存在了文件夹 说明已经建立了文件夹 不需要再次建立
        if (!self.phousePath) {
            return ;
        }
        
        //视频文件夹
        NSString *videoName = @"video";
        
        //图片文件夹
        NSString *pictureName = @"picture";
        
        //音频文件夹
        NSString *soundName = @"sound";
        
        //画板文件夹
        NSString *paintingBoardName = @"paintingBoard";
        
        
        //视频文件夹路径
        self.videoFolderPath = [self.phousePath stringByAppendingPathComponent:videoName];
        
        //图片文件夹路径
        self.pictureFolderPath = [self.phousePath stringByAppendingPathComponent:pictureName];
        
        //音频文件夹路径
        self.soundFolderPath = [self.phousePath stringByAppendingPathComponent:soundName];
        
        //画板文件夹路径
        self.paintingBoardFolderPath = [self.phousePath stringByAppendingPathComponent:paintingBoardName];
        
        
        //创建文件夹 - 保存全部app的资源
        [self.manager createDirectoryAtPath:self.phousePath withIntermediateDirectories:YES attributes:nil error:nil];
        [self.manager createDirectoryAtPath:self.videoFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        [self.manager createDirectoryAtPath:self.pictureFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        [self.manager createDirectoryAtPath:self.soundFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        [self.manager createDirectoryAtPath:self.paintingBoardFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    });
    
    //给fullPath赋值 - fullPath是最小的文件路径
    self.fullPath = [self.videoFolderPath stringByAppendingPathComponent:btn.name];
    
    
    
    //建立对应的录音文件夹
    
    //    [self createRecordFile:btn];
    
    
    
}

//下载视频
- (void)downloadVideo:(XZQNameButton *)btn{
    
    
    //如果对应文件夹不存在
    if (!self.phousePath) {
        NSLog(@"没有建立成功媒体文件夹");
        return;
    }
    
    //给fullPath赋值 - fullPath是最小的文件路径
    self.fullPath = [self.videoFolderPath stringByAppendingPathComponent:btn.name];
    
    if (![self.downloadingArray containsObject:btn.name]) {
        [self.downloadingArray addObject:btn.name];
    }
    
    //5.执行Task
    [self.dataTask resume];
    
    //弹出进度条
    [self popUpBoxDownload:nil message:nil btnContentOne:@"f"];
    //如果本地已经下载了该视频 那么不下载了 直接播放就行
    
}

//下载音频
- (void)downloadRecord:(XZQNameButton *)btn{
    
    //如果对应文件夹不存在
    if (!self.phousePath) {
        NSLog(@"没有建立成功媒体文件夹");
        return;
    }
    
    //给fullPath赋值 - fullPath是最小的文件路径
    //    self.fullRecordPath = [self.soundFolderPath stringByAppendingPathComponent:btn.name];
    
    NSString *name = [btn.name stringByAppendingString:@".mp3"];
    
    if (![self.downloadingRecordArray containsObject:name]) {
        [self.downloadingRecordArray addObject:name];
    }
    
    //5.执行Task
    [self.recordDataTask resume];
    
}

//下载视频 -
- (NSURLSessionDataTask *)dataTask{
    if (_dataTask == nil) {
        
        NSLog(@"启动下载");
        
        //拼接url
        NSString *path = [self.baseURL stringByAppendingPathComponent:self.videoName];
        
        //1.url
        NSURL *url = [NSURL URLWithString:path];
        
        //2.创建请求对象
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        //设置请求超时
        [request setTimeoutInterval:1000000];
        
        
        //2.1 设置请求头信息 告诉服务器请求哪一部分数据 - 就从当前的部分继续往后面下载
        //        //获得指定文件路径对应文件的数据大小
        //        NSDictionary *fileInfoDict = [[NSFileManager defaultManager] attributesOfItemAtPath:self.fullPath error:nil];
        //
        //        //fileInfoDict[@"NSFileSize"] 取出来的是一个对象 - integerValue 转换为integer数值
        //        self.currentSize = [fileInfoDict[@"NSFileSize"] integerValue];//
        
        //3.设置请求头信息 告诉服务器请求哪一部分数据
        self.currentSize = [self getFileSize];
        
        
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-",self.currentSize];
        //key - Range - 要大写
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        //3.创建会话对象 - 设置代理
        //
        //        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        
        
        //4.创建task
        _dataTask = [self.session dataTaskWithRequest:request];
    }
    
    return _dataTask;
}

- (NSURLSessionDataTask *)recordDataTask{
    
    if (!_recordDataTask) {
        
        NSLog(@"启动音频下载");
        
        NSString *recordPath = [self.baseURL stringByAppendingPathComponent:[NSString stringWithFormat:@"video/matchGirl/%@.mp3",self.currentNameBtn.name]];
        
        NSURL *onlineRecordURL = [NSURL URLWithString:recordPath];
        
        //2.创建请求对象
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:onlineRecordURL];
        
        //设置请求超时
        [request setTimeoutInterval:1000000];
        
        
        //3.设置请求头信息 告诉服务器请求哪一部分数据
        self.currentRecordSize = [self getRecordFileSize];
        
        
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-",self.currentRecordSize];
        //key - Range - 要大写
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        //3.创建会话对象 - 设置代理
        //
        //        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        //4.创建task
        _recordDataTask = [self.recordSession dataTaskWithRequest:request];
        
    }
    
    return _recordDataTask;
}

//获取已经下载的视频文件的大小
- (NSInteger)getFileSize{
    //获得指定文件路径对应文件的数据大小
    NSDictionary *fileInfoDict = [[NSFileManager defaultManager] attributesOfItemAtPath:self.fullPath error:nil];
    
    //fileInfoDict[@"NSFileSize"] 取出来的是一个对象 - integerValue 转换为integer数值
    NSInteger currentSize = [fileInfoDict[@"NSFileSize"] integerValue];
    
    return currentSize;
}

#pragma 获取指定文件的大小
- (NSInteger)getFileSize:(NSString *)filePath{
    //获得指定文件路径对应文件的数据大小
    NSDictionary *fileInfoDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    
    //fileInfoDict[@"NSFileSize"] 取出来的是一个对象 - integerValue 转换为integer数值
    NSInteger currentSize = [fileInfoDict[@"NSFileSize"] integerValue];
    
    return currentSize;
}

- (NSInteger)getRecordFileSize{
    
    //在获取到文件大小之前 保证self.fullRecordPath是对的
    NSString *recordFilePath = [self.soundFolderPath stringByAppendingPathComponent:self.currentNameBtn.name];
    
    recordFilePath = [recordFilePath stringByAppendingString:@".mp3"];
    
    self.fullRecordPath = recordFilePath;
    
    
    //获得指定文件路径对应文件的数据大小
    NSDictionary *fileInfoDict = [[NSFileManager defaultManager] attributesOfItemAtPath:self.fullRecordPath error:nil];
    
    //fileInfoDict[@"NSFileSize"] 取出来的是一个对象 - integerValue 转换为integer数值
    NSInteger currentSize = [fileInfoDict[@"NSFileSize"] integerValue];
    
    NSLog(@"getRecordFileSize : %ld -- path:%@",currentSize,self.fullRecordPath);
    
    return currentSize;
    
}

//按钮点击 获取某个视频文件的大小
//- (NSInteger)getFileSize:(NSString *)filePath{
//    //获得指定文件路径对应文件的数据大小
//    NSDictionary *fileInfoDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
//
//    //fileInfoDict[@"NSFileSize"] 取出来的是一个对象 - integerValue 转换为integer数值
//    NSInteger currentSize = [fileInfoDict[@"NSFileSize"] integerValue];
//
//    return currentSize;
//}


#pragma mark NSURLSessionDataDelegate
//1.接收到服务器的响应 - 接收到服务器的响应之后 并不会接收服务器返回给我们的数据 而是直接取消 默认会取消该请求 - 我们可以通过block块告诉系统 你不要取消请求 你要接收数据 这个就是block的作用
/**
 第一个参数：会话对象
 第二个参数：请求任务
 第三个参数：响应头信息
 第四个参数：回调 block块 和之前见到的不太一样
 之前的是：06-1 之前的block是有类型 有值 现在这个block有传参数给我们吗 没有 传参数应该怎么传 前面有类型有值 这里只有类型没有值 这里的completionHandler并不是它传给我们的 是要求我们传给系统的
 
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    
    NSLog(@"是否接受服务器的响应阶段");
    
    NSString *mediaType = [dataTask.currentRequest.URL lastPathComponent];
    
    if ([mediaType rangeOfString:@"mp4"].location != NSNotFound) {
        
        //视频下载
        
        //获得文件的总大小 -
        self.totalSize = response.expectedContentLength + self.currentSize;
        
        NSLog(@"文件的总大小为:%ld",self.totalSize);
        
        if (self.currentSize == 0) {
            //创建一个空的文件
            [[NSFileManager defaultManager] createFileAtPath:self.fullPath contents:nil attributes:nil];
        }
        
        //在这里建立一个plist文件
        
        //plist文件是否存在
        if (![self.manager fileExistsAtPath:self.videoTotalSizePlistPath]) {
            
            [self.videoTotalSizeDict setObject:[NSString stringWithFormat:@"%ld",self.totalSize] forKey:[dataTask.currentRequest.URL lastPathComponent]];
            
            [self.videoTotalSizeDict writeToFile:self.videoTotalSizePlistPath atomically:YES];
            [self.videoTotalSizeDict writeToFile:@"/Users/dmt312/Desktop/hhh6666666.plist" atomically:YES];
            
        }else{//下载的时候
            
            self.videoTotalSizeDict = [[NSMutableDictionary alloc] initWithContentsOfFile:self.videoTotalSizePlistPath];
            
            BOOL flag = false;
            
            //遍历一个字典的时候同时给它增加元素 容易导致程序崩溃
            for (NSString *temp in self.videoTotalSizeDict) {
                
                if (![temp isEqualToString:[dataTask.currentRequest.URL lastPathComponent]]) {//如果字典中没有相同的key 加入就行
                    //建立一个plist文件 保存视频文件的总大小 - 便于下次进入程序的时候检查有没有加载完毕视频
                    
                    flag = true;
                    
                }
            }
            
            if (flag) {
                [self.videoTotalSizeDict setObject:[NSString stringWithFormat:@"%ld",self.totalSize] forKey:[dataTask.currentRequest.URL lastPathComponent]];
            }
            
        }
        
        
        
        //创建一个文件句柄 -fileHandleForWritingAtPath 文件句柄指向哪里
        self.handle = [NSFileHandle fileHandleForWritingAtPath:self.fullPath];//有了指向的handle之后就可以向指向的文件中写入数据 以追加的方式
        
        //移动指针 - 在服务器响应一次 移动一次指针
        [self.handle seekToEndOfFile];
        
    }else if ([mediaType rangeOfString:@"mp3"].location != NSNotFound){
        
        //音频下载
        //获得文件的总大小 -
        self.totalRecordSize = response.expectedContentLength + self.currentRecordSize;//self.currentRecordSize一开始就取值 反正对比就行
        
        
        
        //音频下载和视频一样吧 现在刚刚新建一个属性 fullRecordPath 然后其他的都没有写 记得点击故事就新建一个关于情节的plist文件 不用了 下载就完完全全和视频下载一样就行了 搞两套差不多的代码就行了
        
        
        
        NSLog(@"文件的总大小为:%ld",self.totalRecordSize);
        
        if (self.currentRecordSize == 0) {
            //创建一个空的文件
            [[NSFileManager defaultManager] createFileAtPath:self.fullRecordPath contents:nil attributes:nil];
        }
        
        //plist文件是否存在
        if (![self.manager fileExistsAtPath:self.recordTotalSizePlistPath]) {
            
            [self.recordTotalSizeDict setObject:[NSString stringWithFormat:@"%ld",self.totalRecordSize] forKey:[dataTask.currentRequest.URL lastPathComponent]];
            
            [self.recordTotalSizeDict writeToFile:self.recordTotalSizePlistPath atomically:YES];
            [self.recordTotalSizeDict writeToFile:@"/Users/dmt312/Desktop/hhhRecord.plist" atomically:YES];
            
        }else{//下载的时候
            
            self.recordTotalSizeDict = [[NSMutableDictionary alloc] initWithContentsOfFile:self.recordTotalSizePlistPath];
            [self.recordTotalSizeDict writeToFile:@"/Users/dmt312/Desktop/hhhRecord.plist" atomically:YES];
            
            BOOL flag = false;
            
            //遍历一个字典的时候同时给它增加元素 容易导致程序崩溃
            for (NSString *temp in self.recordTotalSizeDict) {
                
                if (![temp isEqualToString:[dataTask.currentRequest.URL lastPathComponent]]) {//如果字典中没有相同的key 加入就行
                    //建立一个plist文件 保存视频文件的总大小 - 便于下次进入程序的时候检查有没有加载完毕视频
                    
                    flag = true;
                    
                }
            }
            
            if (flag) {
                [self.recordTotalSizeDict setObject:[NSString stringWithFormat:@"%ld",self.totalRecordSize] forKey:[dataTask.currentRequest.URL lastPathComponent]];
                [self.recordTotalSizeDict writeToFile:self.recordTotalSizePlistPath atomically:YES];
            }
            
        }
        
        
        
        //创建一个文件句柄 -fileHandleForWritingAtPath 文件句柄指向哪里
        self.handleRecord = [NSFileHandle fileHandleForWritingAtPath:self.fullRecordPath];//有了指向的handle之后就可以向指向的文件中写入数据 以追加的方式
        
        //移动指针 - 在服务器响应一次 移动一次指针
        [self.handleRecord seekToEndOfFile];
        
    }
    
    
    
    /**
     NSURLSessionResponseCancel = 0,            取消请求 - 默认的
     NSURLSessionResponseAllow = 1,             接收
     NSURLSessionResponseBecomeDownload = 2,    变成下载任务
     NSURLSessionResponseBecomeStream NS_ENUM_AVAILABLE(10_11,9.0) = 3,  NS_ENUM_AVAILABLE(10_11,9.0)是条件 表示 9.0 之后才能用 我们发送一个网络请求 是不是要服务器返回数据给我们 肯定是要服务器返回给我们数据
     */
    completionHandler(NSURLSessionResponseAllow);//block块需要接收一个参数 - 枚举类型 06-2  -告诉服务器我要接收服务器传递的数据 - 进行登录的时候 - 我得知道我登录是否成功 - 在哪里可以拿到呢 在2方法中拿到
}

//2.接收到服务器返回的数据 - 调用多次(如果文件很大的话)
/**
 第一个参数：会话对象
 第二个参数：请求任务
 第三个参数：本次下载的数据
 
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    NSLog(@"下载中");
    
    NSString *mediaType = [dataTask.currentRequest.URL lastPathComponent];
    
    if ([mediaType rangeOfString:@"mp4"].location != NSNotFound) {
        
        //写入数据到文件 -
        [self.handle writeData:data];
        
        //计算文件的下载进度
        self.currentSize += data.length;
        
        
        
        //涉及到界面上的操作 只能由主线程来做
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            self.loadPersent.text = [@"加载中 :" stringByAppendingString:[NSString stringWithFormat:@"%.1f%%",(1.0 * self.currentSize / self.totalSize) * 100]];
            self.customView.loadVideoPersent.text = self.loadPersent.text;
            
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int i = 0;
                
                for (UIView *view in self.alert2.view.subviews) {
                    
                    if (view.tag == 12) {
                        i = 1;
                    }
                }
                
                if (i == 0) {
                    [self.alert2.view addSubview:self.loadPersent];
                }
            });
            
        }];
        
    }else if ([mediaType rangeOfString:@"mp3"].location != NSNotFound){
        
        NSLog(@"mp3");
        
        [self.handleRecord writeData:data];
        
        //计算文件的下载进度
        self.currentRecordSize += data.length;
        
        //涉及到界面上的操作 只能由主线程来做
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            self.loadRecordPersent.text = [@"加载中 :" stringByAppendingString:[NSString stringWithFormat:@"%.1f%%",(1.0 * self.currentRecordSize / self.totalRecordSize) * 100]];
            self.customView.loadPersent.text = self.loadRecordPersent.text;
            
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int i = 0;
                
                for (UIView *view in self.downloadRecordAlert2.view.subviews) {
                    
                    if (view.tag == 12) {
                        i = 1;
                    }
                }
                
                if (i == 0) {
                    [self.downloadRecordAlert2.view addSubview:self.loadRecordPersent];
                }
            });
            
        }];
        
        
        
        
    }
    
    
    
    
}

//3.请求结束（）或者是失败的时候调用
/**
 NSURLSessionTaskDelegate方法实现.
 任务完成加载数据之后调用的代理方法.
 
 第一个参数：会话对象
 第二个参数：请求任务
 第三个参数：错误信息
 
 plist文件中的东西可以复制的
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    
    
    NSLog(@"请求完成之后调用");
    
    NSString *mediaType = [task.currentRequest.URL lastPathComponent];
    
    if ([mediaType rangeOfString:@"mp4"].location != NSNotFound) {
        
        //不需要使用文件句柄的时候一定要关闭 - 关闭之后再清空
        [self.handle closeFile];
        self.handle = nil;
        
        
        //下载完成将处于下载数组中的名称删除
        NSURLRequest *request = task.currentRequest;
        NSURL *url = request.URL;
        
        NSString *name = [url lastPathComponent];
        NSLog(@"打印请求的视频名称:%@",name);
        
        
        for (NSString *btnName in self.downloadingArray) {
            
            NSLog(@"1");
            
            if ([name isEqualToString:btnName]) {
                
                NSLog(@"2");
                
                [self.downloadingArray removeObject:btnName];
                
                if (self.popVisible) {
                    NSLog(@"3");
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                
                if (self.currentSize == self.totalSize) {
                    NSLog(@"4");
                    NSLog(@"%@",[NSThread currentThread]);
                    //下载完成弹框
                    
                    //涉及到界面上的操作 只能由主线程来做
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        [self popUpBoxDownload:name message:@"加载完成" btnContentOne:nil];
                        self.currentSize = 0;
                        //为了每次下载都使用懒加载
                        self.dataTask = nil;
                        
                    }];
                    
                    
                }
                
                return;
            }
            
        }
        
        
    }else if ([mediaType rangeOfString:@"mp3"].location != NSNotFound){
        
        
        //不需要使用文件句柄的时候一定要关闭 - 关闭之后再清空
        [self.handleRecord closeFile];
        self.handleRecord = nil;
        
        //下载完成将处于下载数组中的名称删除
        NSURLRequest *request = task.currentRequest;
        NSURL *url = request.URL;
        
        NSString *name = [url lastPathComponent];
        
        NSLog(@"打印请求的视频名称:%@",name);
        
        for (NSString *btnName in self.downloadingRecordArray) {
            
            NSLog(@"btnName = %@",btnName);
            
            
            if ([name isEqualToString:btnName]) {
                
                NSLog(@"2");
                
                [self.downloadingRecordArray removeObject:btnName];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
                if (self.currentRecordSize == self.totalRecordSize) {
                    NSLog(@"4");
                    //下载完成弹框
                    
                    
                    self.currentRecordSize = 0;
                    //为了每次下载都使用懒加载
                    self.recordDataTask = nil;
                    
                    //涉及到界面上的操作 只能由主线程来做
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        if (self.playBtn.playAll) {
                            
                            if ([name isEqualToString:@"details_matchGirl_10"]) {
                                [self popUpBoxRecordDownload:@"全部音频" message:@"加载完成" btnContentOne:nil];
                            }
                            
                        }else{
                            [self popUpBoxRecordDownload:name message:@"加载完成" btnContentOne:nil];
                        }
                        
                    }];
                    
                    if (self.playBtn.playAll) {
                        
                        k++;
                        [self enjoyAfterDownload];
                    }
                    
                }
                
                return;
            }
            
        }
        
        
    }
    
}

#pragma XZQDrawingBoardViewControllerDelegate


- (void)postRecordSoundFolderPath:(XZQDrawingBoardViewController *)drawingBoardView recordSoundPath:(NSString *)recordSoundPath cafPath:(NSString *)cafPath{
    
    self.recordSoundFolderPath = recordSoundPath;
    self.cafFolderPath = cafPath;
//    [SYAudioFile SYAudioRecordSoundFilePath:self.recordSoundFolderPath];
    [SYAudio shareAudio].audioRecorder.recordSoundPath = self.recordSoundFolderPath;
//    NSLog(@"postRecordSoundFolderPath self.recordSoundFolderPath : %@",recordSoundPath);
}

#pragma 跳转到主功能界面
- (void)jumpToMainFuncIB{
    self.plusClickCount = 0;
    self.tabBarController.selectedIndex = 6;
}


#pragma dealloc方法
- (void)dealloc{
    
    //清理工作   finishTasksAndInvalidate 方法也是一样的 按住option键 查看官方文档 - 14-1 - 这个session对象会有一个强引用 如果你设置代理的话 这个强引用是不会被释放掉的 当你不用这个线程的时候 需要主动地调用finishTasksAndInvalidate或者invalidateAndCancel方法 不调用的话 应用程序会有内存泄漏的问题 -
    [self.session invalidateAndCancel];
    
}



//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
////    self.tabBarController.selectedIndex = 6;
//
//}

#pragma 解决按钮无法点击的问题
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSLog(@"viewWillAppear");
    
    for (UIView *view in self.blankArray) {
        view.userInteractionEnabled = YES;
    }
    
    
    
    //展示自定义情节 如果有自定义的情节的话 需要添加按钮
    [self showSelfDefinePlot];
    
    
    
}

#pragma 监听点击情节按钮弹框中的按钮点击事件

//点击查看 听的是系统录音
- (void)watchStoryVideoFromXib{
    NSLog(@"%s",__func__);
    
    //听系统的音频
    self.listentoLocalOrSelfRecord = 1;
    
    //代替的是之前的在线播放功能
    
    //这里面实现什么 放大图片 出现遮罩 出现雪花 画面中有录音按钮 出现声音 左右遍历按钮
    
    //退出弹框
    [self.ZJAPopView dismiss];
    
    self.currentNameBtn.isOnlineRecord = NO;
    self.currentNameBtn.isBigger = YES;
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onlineRecord" object:nil];
    
    //未完成 ：画面中没有录音按钮 没有左右遍历按钮 一个播放完之后没有以动画效果切换到下一个故事
    
    //首先做动画切换效果 完成 在播放完毕里面
    
    //播放了哪一个视频 i就等于几
    i = self.currentNameBtn.tag - 200;
    
//    [self.currentNameBtn addTarget:self action:@selector(innerBtnBiggerToDo) forControlEvents:UIControlEventTouchUpInside];
    
}

//听自己的录音
- (void)listenToSelfAndWatchVideoFromXib{
    NSLog(@"listenToSelfAndWatchVideoFromXib - %@",self.recordSoundFolderPath);//filePath = /var/mobile/Containers/Data/Application/0C62BE40-33B6-40DB-971E-2A86B9E2BC17/Library/Caches/PHouse/recordSound/details_matchGirl_1.mp3
    
    
    //听自己的录音
    self.listentoLocalOrSelfRecord = 2;
    
    //真正的录音文件名称 是 后面加上了_selfRecord 避免和系统mp3文件冲突
    NSString *actuallName = [NSString stringWithFormat:@"%@_selfRecord.mp3",self.currentNameBtn.name];
    
    NSLog(@"listenToSelfAndWatchVideoFromXib方法中的 actuallName = %@",actuallName);
    
    //得拼接路径 不是[NSBundle mainBundle这个里面
    
//    NSString *selfRecordPath = [[NSBundle mainBundle] pathForResource:actuallName ofType:@"mp3"];
    
    NSString *selfRecordPath = [self.recordSoundFolderPath stringByAppendingPathComponent:actuallName];
    
    NSLog(@"listenToSelfAndWatchVideoFromXib - mp3文件size = %ld",[self getFileSize:selfRecordPath]);
    
    NSInteger fileActualSize = [self getFileSize:selfRecordPath];
    
    if (fileActualSize == 0) {//本地没有配音 听系统的
        [self watchStoryVideoFromXib];
        
        return;
    }
    
    
    if (selfRecordPath != nil) {
        NSURL *selfRecordMp3URL = [NSURL fileURLWithPath:selfRecordPath];
        self.currentNameBtn.selfRecordURL = selfRecordMp3URL;
        
    }else{
        NSLog(@"listenToSelfAndWatchVideoFromXib方法中获取的 selfRecordPath为空 没有获取到mp3文件地址 失败");
    }
    
    //self.recordSoundFolderPath 后面拼接上按钮的name加上.mp3就是录音文件的路径了
    
    //这个方法和查看唯一不同的是 播放的是自己的录音
    
    
    
    //播放了哪一个视频 i就等于几
    i = self.currentNameBtn.tag - 200;
    
    
    
    //退出弹框
    [self.ZJAPopView dismiss];
    
    self.currentNameBtn.isOnlineRecord = NO;
    self.currentNameBtn.isBigger = YES;
    
    //发送通知 - 没有播放 只是放大 并且选择 播放的方式
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onlineRecord" object:nil];
    
    //播放完毕
    
    
}

- (void)toStudyThisFromXib{
    
    NSLog(@"%s",__func__);
    
//    去画板界面学习教学视频 传递教学视频的url 直接播放 画完的画保存名称得是这个 plus得做一次区分 因为得加到情节界面中
    
    //移除弹框
    [self.ZJAPopView dismiss];
     
     //切换到画板界面
     self.tabBarController.selectedIndex = 0;
     
     //传递url 开始播放教学视频
     //三个和尚的故事动画url
    if ([self.currentNameBtn.name rangeOfString:@"threeBoys"].location != NSNotFound) {
        self.currentNameBtn.storyVideoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"threeBoysTeach" ofType:@"mp4"]];
    }else if ([self.currentNameBtn.name rangeOfString:@"bamboo"].location != NSNotFound){
        self.currentNameBtn.storyVideoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bambooTeach" ofType:@"mp4"]];
    }
//     self.currentNameBtn.storyVideoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"三个和尚的故事" ofType:@"mp4"]];
     
     //画板界面视频开始播放
     if ([self.delegate2 respondsToSelector:@selector(postStoryVideoURL:videoURL:)]) {
         [self.delegate2 postStoryVideoURL:self videoURL:self.currentNameBtn.storyVideoURL];
     }
    
    NSLog(@"Phouse = %@",self.phousePath);
    //Phouse = /var/mobile/Containers/Data/Application/F32BC9FB-5861-488B-9F7A-B8C92BBBD984/Library/Caches/PHouse
    NSLog(@"pictureFolderPath = %@",self.pictureFolderPath);
    //pictureFolderPath = /var/mobile/Containers/Data/Application/F32BC9FB-5861-488B-9F7A-B8C92BBBD984/Library/Caches/PHouse/picture
    
    
    
    
    
    //给即将要保存的图片赋值路径
    [self postPathToWillBeSavedPicture];
    
    //再次进入故事情节界面记得刷新界面 拿到新的自己画的图片
    
    //进入画册界面 也刷新 - 这个应该做过了
    
    //在plus调用的方法里面也应该给出图片存储路径
    
}

#pragma 听本地录音
- (void)localRecordPlay{
        
    NSLog(@" localRecordPlay 开始本地播放 playRecord");
    
    AVPlayerItem *playerItem;
    
    //存放的是本地系统录音的url
    if (self.listentoLocalOrSelfRecord == 1 || self.currentNameBtn.selfRecordURL == nil) {//系统
        
        
        playerItem = [[AVPlayerItem alloc] initWithURL:self.currentNameBtn.storyVideoURL];
        
        NSLog(@"localRecordPlay 开始本地播放1 selfRecordURL = %@",self.currentNameBtn.selfRecordURL);
        
    }else if(self.listentoLocalOrSelfRecord == 2){//自己
        
        playerItem = [[AVPlayerItem alloc] initWithURL:self.currentNameBtn.selfRecordURL];
        
        NSLog(@"localRecordPlay 开始本地播放2  selfRecordURL = %@",self.currentNameBtn.selfRecordURL);
        
    }
    
    if (playerItem == nil) {
        [self.recordPlayer pause];//当没有系统录音的时候 playItem 也是等于nil的
        return;
    }
    
    [self.recordPlayer replaceCurrentItemWithPlayerItem:playerItem];
    [self.recordPlayer play];
    self.recordPlayer.rate = 1.0;
    
}

#pragma 给出tag 返回对应的系统音频URL
- (NSURL *)recordWithTag:(NSInteger)tag{
    
    if (tag == 1998) {
        return nil;
    }
    
    tag -= 199;
    NSString *filePath = @"";
    
    
        
    if ([self.currentNameBtn.name rangeOfString:@"matchGirl"].location != NSNotFound) {
        NSLog(@"%s - 播放matchGirl音频",__func__);
        
        filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"details_matchGirl_%ld",tag] ofType:@"mp3"];
        
    }else if ([self.currentNameBtn.name rangeOfString:@"threeBoys"].location != NSNotFound){
        NSLog(@"%s - 播放threeBoys音频",__func__);
        
        filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"ThreeBoys_%ld",tag] ofType:@"mp3"];
    }else if ([self.currentNameBtn.name rangeOfString:@"bamboo"].location != NSNotFound){
        NSLog(@"%s - 播放bamboo音频",__func__);
        
        filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"BamBoo_%ld",tag] ofType:@"mp3"];
    }
    
    NSLog(@"filePath = %@",filePath);
    
    
    return [NSURL fileURLWithPath:filePath];
    

    
}


#pragma 上/下一个故事
- (void)toNextPlot{
    [self playFinishedBeingCalled];
}

- (void)toLastPlot{
    
    NSLog(@"%s i = %ld",__func__,i);
    
    i -= 2;
    
    if (i < 0) {
        i = -1;
    }
    
    [self playFinishedBeingCalled];
}

#pragma 给即将要保存的图片赋值路径
- (void)postPathToWillBeSavedPicture{

    NSLog(@"%s",__func__);
    
    //给即将要保存的图片赋值路径
    XZQDrawingBoardViewController *vc = (XZQDrawingBoardViewController *)self.delegate2;
    
    
    XZQNameButton *temp;
    
    if (self.detailsBtnArray.count != 0) {
        temp = self.detailsBtnArray[0];
    }
    
    if ([temp.name rangeOfString:@"threeBoys"].location != NSNotFound) {
        vc.ChineseName = @"三个和尚的故事";
        vc.EnglishName = @"threeBoys";
    }else if ([temp.name rangeOfString:@"bamboo"].location != NSNotFound){
        vc.ChineseName = @"竹里馆";
        vc.EnglishName = @"bamboo";
    }else if ([temp.name rangeOfString:@"details_matchGirl"].location != NSNotFound){
        vc.ChineseName = @"卖火柴的小女孩";
        vc.EnglishName = @"details_matchGirl";
    }
    
    
    
//    if ([self.currentNameBtn.name rangeOfString:@"details_matchGirl"].location != NSNotFound) {
//        vc.ChineseName = @"卖火柴的小女孩";
//        vc.EnglishName = @"details_matchGirl";
//    }else if ([self.currentNameBtn.name rangeOfString:@"threeBoys"].location != NSNotFound){
//        vc.ChineseName = @"三个和尚的故事";
//        vc.EnglishName = @"threeBoys";
//    }else if ([self.currentNameBtn.name rangeOfString:@"bamboo"].location != NSNotFound){
//        vc.ChineseName = @"竹里馆";
//        vc.EnglishName = @"bamboo";
//    }else if([self.currentNameBtn.name rangeOfString:@"plus"].location != NSNotFound){
//
//    }
    
    
    
    NSLog(@"%@",vc.ChineseName);
    
    //点击plus 按钮 对应图片的存储路径 加上SelfPlus
    if ([self.currentNameBtn.name isEqualToString:@"plus"]) {
        vc.isClickPlusBtn = true;
    }else{
        vc.isClickPlusBtn = false;
    }
    
}

#pragma 监听通知
- (void)addAllObserver{
    //该移除遮罩了
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCoverViewAndMoveBackPopView) name:@"removeCoverViewAndMoveBackPopView" object:nil];
        
        //监听跳转到故事界面的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toStory) name:@"toStory" object:nil];
        
        //监听缩小故事情节的通知 - 点击遮罩需要缩小情节
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(narrowPlot) name:@"toNarrowStoryPlot" object:nil];
        
        //    onlineRecord 监听点击了在线听录音的通知
        
        //监听点击在线播放音频
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineRecord) name:@"onlineRecord" object:nil];
        
        //监听音频是否播放完毕 - 有播放按钮的时候
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:@"AVPlayerItemDidPlayToEndTimeNotification" object:self.recordPlayer.currentItem];//playFinishedBeingCalled
        
        
        //监听音频是否播放完毕 - 无播放按钮的时候
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinishedBeingCalled) name:@"AVPlayerItemDidPlayToEndTimeNotification" object:self.recordPlayer.currentItem];//playFinishedBeingCalled
        
        
        //监听弹框点击确定消失
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disappearSelfDefinePopView) name:@"disappearSelfDefinePopView" object:nil];
        
        //监听放大情节的通知 点击录音列表中的cell发出通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(biggerPlot) name:@"biggerPlot" object:nil];
        
        
        //监听点击xib中按钮的通知
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"onlinePlayFromXib" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlinePlayFromXib) name:@"onlinePlayFromXib" object:nil];
        
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadPlayFromXib" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadPlayFromXib) name:@"downloadPlayFromXib" object:nil];
        
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"studyClassFromXib" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(studyClassFromXib) name:@"studyClassFromXib" object:nil];
        
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"storyPlotFromXib" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storyPlotFromXib) name:@"storyPlotFromXib" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suspendDownloadFromXib) name:@"suspendDownloadFromXib" object:nil];
        
        //goOnDownloadFromXib
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goOnDownloadFromXib) name:@"goOnDownloadFromXib" object:nil];
        
        //cancelDownloadFromXib
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelDownloadFromXib) name:@"cancelDownloadFromXib" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlinePlayRecordFromXib) name:@"onlinePlayRecordFromXib" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenSelfRecordFromXib) name:@"listenSelfRecordFromXib" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadRecordFromXib) name:@"downloadRecordFromXib" object:nil];
        
        //cancelRecordFromXib
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRecordFromXib) name:@"cancelRecordFromXib" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissZJPopView) name:@"dismissZJPopView" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suspendVideoDownload) name:@"suspendVideoDownload" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goOnVideoDownload) name:@"goOnVideoDownload" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelVideoDownload) name:@"cancelVideoDownload" object:nil];
        
        
        
        //监听点击情节弹出框的按钮 新改的功能 查看 听自己的录音 学习画画 取消
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(watchStoryVideoFromXib) name:@"watchStoryVideo" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenToSelfAndWatchVideoFromXib) name:@"listenToSelfAndWatchVideo" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toStudyThisFromXib) name:@"toStudyThis" object:nil];
        
        
        
        
        
        //监听点击缓存音频
        //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadRecord) name:@"downloadRecord" object:nil];
}



static NSString *storyNameNow = @"";
#pragma 自定义情节图片展示
//这个应该放在viewWillAppear中的
- (void)showSelfDefinePlot{
    //看看当前是哪个故事 再去内存中找对应存放图片的文件夹 看看里面有没有包含SelfPlus的图片 如果有 展示出来 没有返回
    
    //看看现在在哪个故事中 -
    
    //1.获取按钮的名称
    if (self.detailsPlotBtnArray.count != 0) {
        for (XZQNameButton *btn in self.detailsPlotBtnArray) {
            storyNameNow = btn.name;//storyNameNow - details_matchGirl_1
            break;
        }
    }else{
        NSLog(@"self.detailsPlotBtnArray.count == 0 查看自定义情节失败");
        return;
    }
    

    //2.查看包含的故事名称 并赋值
    if ([storyNameNow rangeOfString:@"details_matchGirl"].location != NSNotFound) {
        storyNameNow = @"details_matchGirl";
    }else if ([storyNameNow rangeOfString:@"threeBoys"].location != NSNotFound){
        storyNameNow = @"threeBoys";
    }else if ([storyNameNow rangeOfString:@"bamboo"].location != NSNotFound){
        storyNameNow = @"bamboo";
    }
    
    //3.拼接路径
    NSLog(@"showSelfDefinePlot pictureFolderPath = %@",self.pictureFolderPath);
    //self.pictureFolderPath - ~/Caches/PHouse/picture
    
    //去内存中找有没有带有SelfPuls的自己画的作品
    storyNameNow = [self.pictureFolderPath stringByAppendingPathComponent:storyNameNow];
    
    //storyNameNow - ~/Caches/PHouse/picture/details_matchGirl
    
    NSLog(@"storyNameNow - %@",storyNameNow);
    
    //4.看看有没有这个文件夹
    if ([self.manager fileExistsAtPath:storyNameNow]) {//说明画过这个故事
        
        //5.获取该目录下的文件 保存到一个数组中
        NSArray *array = [self.manager contentsOfDirectoryAtPath:storyNameNow error:nil];
        
        //带有SelfPlus图片的个数
        NSInteger i = 0;
        
        NSLog(@"showSelfDefinePlot - %@",array);
        
        
        //给array排序
        NSMutableArray *arrayCopy = [NSMutableArray array];
        for (NSString *fileName in array) {
            [arrayCopy addObject:fileName];
        }
        //给array排序
        array = [self sortSelfPlusArray:arrayCopy];
        
        NSLog(@"array排序后 %@",array);
        
        if (self.plusClickCount > 0) {
            //将containsSelfPlusPlotPictureArray清空
                    NSLog(@"showSelfDefinePlot - 增加元素前%@",self.containsSelfPlusPlotPictureArray);
                    [self.containsSelfPlusPlotPictureArray removeAllObjects];
                    
                    
                    
                    
                    
            //        NSInteger tempCount = 0;
            //        self.addCount = self.containsSelfPlusPlotPictureArray.count;
                    
                    
                    NSString *finalString = @"";
                    //6.查找是否有带有SelfPlus命名的图片
                    for (NSString *fileName in array) {
                        
                        if ([fileName rangeOfString:@"SelfPlus"].location != NSNotFound) {
                            
                            //找到最后一个带SelfPlus的就行
                            finalString = fileName;
                            
            //                NSLog(@"showSelfDefinePlot方法中 带有SelfPlus图片的全名是 = %@",fileName);
            //打印：details_matchGirlSelfPlus_5.png
                            
                            //7.将图片的名称添加到数组中
            //                NSString *fileNameInSelfPlusPlotPictureArray = @"";
            //                if (i < self.containsSelfPlusPlotPictureArray.count) {
            //                    fileNameInSelfPlusPlotPictureArray = self.containsSelfPlusPlotPictureArray[i];
            //                }
            //
            //
            //                if ([fileNameInSelfPlusPlotPictureArray isEqualToString:fileName]) {
            //                    [self.containsSelfPlusPlotPictureArray removeObject:self.containsSelfPlusPlotPictureArray[i]];
            //                }else{
            //                    [self.containsSelfPlusPlotPictureArray addObject:fileName];
            //
            //                }
                                
                            i++;
                            
                            
                        }
                    }
                    [self.containsSelfPlusPlotPictureArray addObject:finalString];
                    
                    
        }else{
            
            [self.containsSelfPlusPlotPictureArray removeAllObjects];
            
            for (NSString *fileName in array) {
                [self.containsSelfPlusPlotPictureArray addObject:fileName];
            }
            
        }
        
        i = self.containsSelfPlusPlotPictureArray.count;
        
//        self.addCount = self.containsSelfPlusPlotPictureArray.count;
        
        NSLog(@"showSelfDefinePlot - containsSelfPlusPlotPictureArray 删除增加后 = %@",self.containsSelfPlusPlotPictureArray);
        
        if (i == 0) {//没有SelfPlus
            return;
        }else{//有
            
//            给containsSelfPlusPlotPictureArray 中元素排个序
            self.containsSelfPlusPlotPictureArray = [self sortSelfPlusArray:self.containsSelfPlusPlotPictureArray];
            
            //8.先把plus从各个容器中删除 直到循环结束 再加入进去 就保证了在最后面
            
            //8.1拿到plus按钮
            XZQNameButton *plusBtn;
            XZQNameButton *plusInnerBtn;
            
            for (XZQNameButton *btn in self.detailsBtnArray) {
                if ([btn.name isEqualToString:@"plus"]) {
                    plusBtn = btn;
                    break;
                }
            }
            
            //拿到子控件plus按钮
            for (XZQNameButton *btn in self.detailsPlotBtnArray) {
                if ([btn.name isEqualToString:@"plus"]) {
                    plusInnerBtn = btn;
                    break;
                }
            }
            
            
            if (plusBtn == nil) {
                NSLog(@"showSelfDefinePlot方法- self.detailsBtnArray没有plus按钮 方法结束");
                return;
            }
            
            if (plusInnerBtn == nil) {
                NSLog(@"showSelfDefinePlot方法- self.detailsPlotBtnArray没有plus按钮 方法结束");
                return;
            }
            
            
            NSLog(@"showSelfDefinePlot方法 - self.superRectDict - %ld",self.superRectDict.count);
            
            //8.2 从容器中移除
            [self.detailsBtnArray removeObject:plusBtn];
//            [plusBtn removeFromSuperview];
            [self.superRectDict removeObjectForKey:plusBtn.name];//无序
            
            NSLog(@"showSelfDefinePlot方法 - 删除之后的self.superRectDict - %ld",self.superRectDict.count);
            
            //子控件从数组detailsPlotBtnArray中移除
            [self.detailsPlotBtnArray removeObject:plusInnerBtn];
//
//            if (plusInnerBtn.name != nil) {
//                [self.innerRectDict removeObjectForKey:plusInnerBtn.name];
//            }
            
            
            NSLog(@"showSelfDefinePlot方法 - ");
            
            
            //9.创建情节按钮 显示在界面中  - 让plus按钮处于detailsPlotBtnArray数组的最后一位 不改变plus的210的tag
            
            //9.1 设置布局参数
            int columns = 4;
                    
            CGFloat blankW = self.view.frame.size.width * 0.1870;
            CGFloat blankH = self.view.frame.size.height * 0.1679;
    
            CGFloat blankX = Width *0.005106;
            CGFloat blankY = Height *0.009608;
            
            CGFloat intervalW = self.view.frame.size.width * 0.0389;
            CGFloat intervalH = self.view.frame.size.height *0.028902;
            
            //目前已经到了3行3列 //detailsPlotBtnArray
            NSInteger u = 0;
            u = self.detailsPlotBtnArray.count;
//            NSInteger l = 0;
//            l = self.detailsPlotBtnArray.count / columns;
            
//            NSLog(@" k = %ld l = %ld",k,l);
            
            NSMutableArray *containsNewSuperBtn = [NSMutableArray array];
            
            //9.2布局父控件
            for (NSInteger j = 0; j < i; j++) {
                
//                k = j + k;
//                l = j + l;
                
                BOOL flag = false;
                
//                NSLog(@"打印了几次");//2次
                
                //9.2 创建外框
                XZQNameButton *btn = [[XZQNameButton alloc] init];
                            
                btn.name = self.containsSelfPlusPlotPictureArray[j];
                
                NSLog(@"showSelfDefinePlot - 布局父控件名称%@",btn.name);
                
                [btn setBackgroundImage:[UIImage imageNamed:@"storyPlot_superViewFrame"] forState:UIControlStateNormal];
                if ([btn.name rangeOfString:@"threeBoys"].location != NSNotFound) {
                    btn.tag = j+212;
                }else if ([btn.name rangeOfString:@"bamboo"].location != NSNotFound){
                    btn.tag = j+204;
                }else if([btn.name rangeOfString:@"matchGirl"].location != NSNotFound ){
                    btn.tag = j+210;//210是plus的 从211开始
                }
                
                [btn addTarget:self action:@selector(detailsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                

                for (UIView *subBtn in self.plotScrollView.subviews) {
                    if ([subBtn isKindOfClass:[XZQNameButton class]]) {
                        XZQNameButton *subBtn2 = (XZQNameButton *)subBtn;
                        
                        if ([subBtn2.name isEqualToString:btn.name]) {
                            flag = true;
                        }
                    }
                    
                    if (flag) {
                        break;
                    }
                        
                    
                    
                }
                //防止添加两次
                if (flag == false) {
                    [self.plotScrollView addSubview:btn];
                    [self.detailsBtnArray addObject:btn];
                }
                
                NSLog(@"k = %ld",u);//45710
                
                CGFloat x = blankX + (u % columns) * (blankW + intervalW);
                CGFloat y = blankY + (u / columns) * (blankH + intervalH);
                
                u++;
                btn.frame = CGRectMake(x, y, blankW, blankH);
                
                //是不是自定义情节按钮 属性用于播放完毕时的方法
                btn.isSelfStoryPlotBtn = YES;
                
                if (flag == false) {
                    
                    [self.superRectDict setObject:NSStringFromCGRect(btn.frame) forKey:btn.name];
                    
                    [containsNewSuperBtn addObject:btn];
                }
                
                
                
            }
            
            //9.3需要将plus的父控件添加进去
            [self.detailsBtnArray addObject:plusBtn];

//            [self.plotScrollView addSubview:plusBtn];
            
            
            NSLog(@"plusbtn的k = %ld",u);
            
            u = self.detailsBtnArray.count - 1;
            
            //将plus放在后面的位置上
            CGFloat x = blankX + (u % columns) * (blankW + intervalW);
            CGFloat y = blankY + (u / columns) * (blankH + intervalH);
            
            plusBtn.frame = CGRectMake(x, y, blankW, blankH);
            
            [self.superRectDict setObject:NSStringFromCGRect(plusBtn.frame) forKey:plusBtn.name];//无序
            
            NSLog(@"showSelfDefinePlot方法 -  superOriginRect%@",NSStringFromCGRect(plusBtn.frame));
            
            
            //plusBtn的view里面就有subPlus
//            [containsNewSuperBtn addObject:plusBtn];
            
            //9.4 设置一个值为子控件设置图片
            NSInteger subViewPictureIndex = 0;
            
            
            //9.5布局子控件
            for (XZQNameButton *btn in containsNewSuperBtn) {
                
//                NSLog(@"showSelfDefinePlot - 布局子控件时 父控件的name  - %@",btn.name);
                CGFloat innerBtnX = btn.frame.size.width * 0.049000;
                CGFloat innerBtnY = btn.frame.size.height * 0.050000;
                CGFloat innerBtnW = btn.frame.size.width * 0.894488;
                CGFloat innerBtnH = btn.frame.size.height * 0.860333;
                
                
                XZQNameButton *innerBtn = [[XZQNameButton alloc] init];
                innerBtn.isInnerBtn = YES;
                //是不是自定义情节按钮 属性用于播放完毕时的方法
                innerBtn.isSelfStoryPlotBtn = YES;
                
                [btn addSubview:innerBtn];
                
                //最后一个加号的框不要
//                if (btn.tag == 210) {
                if (btn.tag == 1998) {
                    
                    innerBtn.center = CGPointMake(btn.bounds.size.width *0.5, btn.bounds.size.height *0.5);

                    innerBtn.bounds = CGRectMake(0, 0, btn.bounds.size.width *0.6, btn.bounds.size.width *0.6);
                    
                    
                    
                }else{
                    innerBtn.frame = CGRectMake(innerBtnX, innerBtnY, innerBtnW, innerBtnH);
                }
                
                
                
                [innerBtn addTarget:self action:@selector(detailsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                
                [self.detailsPlotBtnArray addObject:innerBtn];
                
                UIImage *image;
                
                if(subViewPictureIndex < self.containsSelfPlusPlotPictureArray.count){
                    //9.6 innerbtn的图 还有btn和innerbtn的name innerbtn的tag
                   image = [UIImage imageWithContentsOfFile:[storyNameNow stringByAppendingPathComponent:self.containsSelfPlusPlotPictureArray[subViewPictureIndex]]];
                    
                    NSLog(@"showSelfDefinePlot - self.containsSelfPlusPlotPictureArray数组元素:%@",self.containsSelfPlusPlotPictureArray[subViewPictureIndex]);
                    
                }else{
                    NSLog(@"showSelfDefinePlot - subViewPictureIndex索引超过了containsSelfPlusPlotPictureArray数组容量");
                }
                
                subViewPictureIndex++;
                
                if (image != nil) {
                    [innerBtn setBackgroundImage:image forState:UIControlStateNormal];
                }else{
                    NSLog(@"showSelfDefinePlot - 为自定义情节添加图片失败");
                    return;
                }
                
                innerBtn.name = btn.name;//以图片的名称命名按钮
                innerBtn.tag = btn.tag;
                
                NSLog(@"showSelfDefinePlot - 子控件的名称 - %@",innerBtn.name);
                
                
                
                
                //9.7 设置音频信息 - 这部分的按钮不能去学画画 只能听自己的录音 取消 需要重新做一个xib
                //系统音频url 不设置
                
                [self.innerRectDict setObject:NSStringFromCGRect(innerBtn.frame) forKey:innerBtn.name];
                
                
                
//                [self.innerRectDict setObject:NSStringFromCGRect(plusInnerBtn.frame) forKey:plusInnerBtn.name];
                
                
            }
            
            //9.8将之前移除的plus子控件添加回去
            //将子控件plus添加进入对应的数组中
            [self.detailsPlotBtnArray addObject:plusInnerBtn];
            
            plusBtn.alpha = 1;
            plusInnerBtn.alpha = 1;
            NSLog(@"%@",plusBtn);
        }
        
        
        
        
    }else{
        //没有这个文件夹 说明还没有画过这个故事
        NSLog(@"没有这个文件夹 说明还没有画过这个故事");
        return;
        
    }
    
    NSLog(@"showSelfDefinePlot方法 - self.detailsPlotBtnArray.count = %ld",self.detailsPlotBtnArray.count);
    NSLog(@"showSelfDefinePlot方法 - self.detailsBtnArray.count = %ld",self.detailsBtnArray.count);
    
    
    
    //把加号按钮显示出来
//    if (self.returnToStory.alpha == 1) {
//        for (XZQNameButton *btn in self.detailsPlotBtnArray) {
//
//            if ([btn.name rangeOfString:@"plus"].location != NSNotFound) {
//                btn.alpha = 1;
//                btn.superview.alpha = 1;
//                break;
//            }
//
//        }
//    }else{
//        NSLog(@"");
//    }
    
    
}


#pragma 给获取到的自定义的图片数组排序
- (NSMutableArray *)sortSelfPlusArray:(NSMutableArray *)array{
    
    //newArray中只有排好序的数字 数字是从array中截取的
    NSMutableArray *newArray = [self removeStringFromSelfPlusPicture:array];
    
    NSMutableArray *newArray2 = [NSMutableArray array];
    //匹配 返回一个新的数组 包含完整名称
    for (NSString *str in newArray) {
        
        for (NSString *str2 in array) {
            
            if ([str2 rangeOfString:str].location != NSNotFound) {
                [newArray2 addObject:str2];
            }
        }
        
    }
    
    NSLog(@"sortSelfPlusArray 排序前:%@",array);
    NSLog(@"sortSelfPlusArray newArray = %@",newArray);//10000 10000 10000 10000
    NSLog(@"sortSelfPlusArray 排序后:%@",newArray2);
    
    return newArray2;
    
}

#pragma 去掉自定义图片中的字符串 只剩下数字
- (NSMutableArray *)removeStringFromSelfPlusPicture:(NSMutableArray *)array{
    
    NSMutableArray *temp = [NSMutableArray array];
    NSInteger i = 10000;
    NSString *tempString = @"";
    
    for (NSString *fileName in array) {
        
        if ([fileName rangeOfString:@".png"].location != NSNotFound) {
            tempString = [fileName stringByReplacingOccurrencesOfString:@".png" withString:@""];
        }
        
        
        if ([tempString rangeOfString:@"details_matchGirlSelfPlus_"].location != NSNotFound) {
            tempString = [tempString stringByReplacingOccurrencesOfString:@"details_matchGirlSelfPlus_" withString:@""];
            //变成数字放在里面
            [temp addObject:tempString];
        }else if ([tempString rangeOfString:@"threeBoysSelfPlus_"].location != NSNotFound){
            tempString = [tempString stringByReplacingOccurrencesOfString:@"threeBoysSelfPlus_" withString:@""];
            //变成数字放在里面
            [temp addObject:tempString];
        }else if ([tempString rangeOfString:@"bambooSelfPlus_"].location != NSNotFound){
            tempString = [tempString stringByReplacingOccurrencesOfString:@"bambooSelfPlus_" withString:@""];
            //变成数字放在里面
            [temp addObject:tempString];
        }
        
    }
    
    //最后给数组排个序 返回一个新的排好序的数组
    NSMutableArray *newTemp = [NSMutableArray array];
    NSInteger j = 0;
    
    for (int k = 0; k < temp.count; k++) {
        //遍历temp数组
        for (NSString *str in temp) {
            
            //元素转换为数字
            j = [str integerValue];
            
            if (newTemp.count != 0) {
                BOOL flag = [self isHave:str array:newTemp];
                
                if (flag) {
                    continue;
                }
            }
            
            if (j < i) {
                i = j;
            }
            
        }
        
        [newTemp addObject:[NSString stringWithFormat:@"%ld",i]];
        
        i = 10000;
    }
    
    
    return newTemp;
}

#pragma 判断数组中已经有某个元素了
- (BOOL)isHave:(NSString *)str array:(NSMutableArray *)array{
    
    BOOL flag = false;
    
    for (NSString *fileName in array) {
        
        if ([fileName isEqualToString:str]) {
            flag = true;
        }
    }
    
    return flag;
}

#pragma  -----------------------------
#pragma 布局三个和尚的故事的情节
- (void)layoutThreeBoysPlot{
    
}

#pragma  -----------------------------
#pragma 布局竹里馆的故事情节
- (void)layoutBamBooPlot{
    
}

#pragma  -----------------------------
#pragma 显示故事情节之前 将容器中所有的故事情节清空 重来一次
- (void)removeAllPlotBeforeShow{
    
    
    [self.detailsBtnArray removeAllObjects];
    
    //防止将scrollview系统内部的子控件移除
    for (UIView *view in self.plotScrollView.subviews) {
        if (view.tag >= 200) {
            [view removeFromSuperview];
        }
    }
    
    [self.superRectDict removeAllObjects];
    
    //子控件从容器中清空
    [self.detailsPlotBtnArray removeAllObjects];
    [self.innerRectDict removeAllObjects];
}


#pragma ----------------------------------
#pragma 点击弹框中的播放录音按钮调用
- (void)playSelfRecord{
    
    NSLog(@"%s",__func__);
    
    if (self.currentNameBtn.name != nil) {
        NSLog(@"%@",self.currentNameBtn.name);
        
        
        NSString *fileName = [self.currentNameBtn.name stringByAppendingString:@"_selfRecord.mp3"];
        
        NSLog(@"%@",fileName);
        
        NSLog(@"%@",self.recordSoundFolderPath);
        
        BOOL flag = [self.manager fileExistsAtPath:[self.recordSoundFolderPath stringByAppendingPathComponent:fileName]];
        
        if (flag) {//如果存在这个录音文件 播放
            NSLog(@"have");
            
            //播放本地录音
            [self listenToSelfAndWatchVideoFromXib];
            
        }else{
            //否则 弹框提示 没有这个录音
            NSLog(@"don't have");
            
            
            ZJAnimationPopStyle popStyle =  ZJAnimationPopStyleShakeFromTop;
            ZJAnimationDismissStyle dismissStyle = ZJAnimationDismissStyleDropToBottom;
                
            self.customView = nil;
                
                
            _customView = [SlideSelectCardView xib18];
                
                
            self.customView.storyOrPlotImage = [UIImage OriginalImageWithImage:self.currentNameBtn.currentBackgroundImage];
                    
            self.customView.delegate = self;
                
                // 1.初始化
            ZJAnimationPopView *popView = [[ZJAnimationPopView alloc] initWithCustomView:self.customView popStyle:popStyle dismissStyle:dismissStyle];
            self.ZJAPopView = popView;
                
                // 2.设置属性，可不设置使用默认值，见注解
                
                // 2.2 显示时背景的透明度
            popView.popBGAlpha = 0.5f;
                // 2.3 显示时是否监听屏幕旋转
            popView.isObserverOrientationChange = YES;
                // 2.4 显示时动画时长
                //    popView.popAnimationDuration = 0.8f;
                // 2.5 移除时动画时长
                //    popView.dismissAnimationDuration = 0.8f;
                
                // 2.6 显示完成回调
            popView.popComplete = ^{
                    NSLog(@"显示完成");
                };
                // 2.7 移除完成回调
            popView.dismissComplete = ^{
                    NSLog(@"移除完成");
                };
                
                // 4.显示弹框
            [popView pop];
            
        }
        
    }
    
}
@end




