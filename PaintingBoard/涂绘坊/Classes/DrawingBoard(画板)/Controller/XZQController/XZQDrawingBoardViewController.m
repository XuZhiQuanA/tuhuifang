//
//  XZQDrawingBoardViewController.m
//  涂绘坊
//
//  Created by dmt312 on 2019/5/11.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQDrawingBoardViewController.h"
//#import "XZQDrawView.h"
#import "XZQDrawingBoard.h"
#import "XZQVideoView.h"
#import "XZQPopViewController.h"
#import "XZQVideoPlayerController.h"
#import "XZQCoverView.h"
#import "XZQSnowCoverView.h"
#import "XZQTabBarController.h"
#import "XZQStoryViewController.h"

//框架
#import "ZJAnimationPopView.h"


#import "SlideSelectCardView.h"

#import "HandleImageView.h"

#import "XZQMoveBtn.h"

#import "XZQFlowLayout.h"
#import "XZQCollectionViewCell.h"

#import "XZQNameButton.h"

#import "UIImage+OriginalImage.h"

#import "XZQSmallWindowVideoViewController.h"
#import "AViewController.h"

#define Width self.view.frame.size.width
#define Height self.view.frame.size.height

@interface XZQDrawingBoardViewController ()<XZQDrawingBoardViewDelegate,ZJXibFoctoryDelegate,XZQCollectionViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,handleImageViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

/**背景图 */
@property(nonatomic,strong) UIImageView *imageV;

/** 画板及画板上面的颜色框*/
@property(nonatomic,readwrite,weak) UIImageView *drawBackImageV;

/**改变画笔颜色按钮数组 */
@property(nonatomic,strong) NSMutableArray *colorBtn;

/**功能按钮数组 */
@property(nonatomic,strong) NSMutableArray *funcBtn;

/**画笔数组 */
@property(nonatomic,strong) NSMutableArray *groupOfPaint;

/**画板 */
@property(nonatomic,strong) XZQDrawingBoard *drawBoard;


/**视频 */
@property(nonatomic,strong) XZQVideoView *videoView;

/**popVc菜单 */
@property(nonatomic,strong) XZQPopViewController *popVc;

/**视频播放 */
//@property(nonatomic,strong) XZQVideoPlayerController *videoPlayer;

@property(nonatomic,strong) AViewController *videoPlayer;

/**遮罩 */
@property(nonatomic,strong) XZQCoverView *coverView;


/**文件管理者 */
@property(nonatomic,strong) NSFileManager *manager;


//下载相关

/**PHouse文件夹 */
@property(nonatomic,readwrite,strong) NSString *phousePath;

/**视频文件夹路径 */
@property(nonatomic,readwrite,strong) NSString *videoFolderPath;

/**图片文件夹路径 */
@property(nonatomic,readwrite,strong) NSString *pictureFolderPath;

/**音频文件夹路径 */
@property(nonatomic,readwrite,strong) NSString *soundFolderPath;

/**录音文件夹路径 */
@property(nonatomic,readwrite,strong) NSString *recordSoundFolderPath;

/**caf文件夹路径 */
@property(nonatomic,readwrite,strong) NSString *cafFolderPath;

/**画板文件夹路径 */
@property(nonatomic,readwrite,strong) NSString *paintingBoardFolderPath;

/**当前的画板应该保存在哪个目录下 */
@property(nonatomic,readwrite,strong) NSString *currentPatingBoardPath;

/**自定义弹框内容 */
@property(nonatomic,readwrite,strong) SlideSelectCardView *customView;

/**自定义弹框 */
@property(nonatomic,readwrite,strong) ZJAnimationPopView *ZJAPopView;

/**当前点击的按钮 */
@property(nonatomic,readwrite,strong) UIButton *currentBtn;

/**导入视频还是图片*/
@property(nonatomic,assign) BOOL isVideo;

/**画板颜色改变*/
@property(nonatomic,assign) BOOL boardColorSwitchIsOn;

/** 电视机按钮*/
@property(nonatomic,readwrite,weak) XZQNameButton *televisionBtn;


@property(nonatomic,readwrite,weak) XZQFlowLayout *flowLayout;

@property(nonatomic,readwrite,weak) UICollectionView *collectionView;

@property(nonatomic,readwrite,assign) NSInteger selectedCellTag;

@property(nonatomic,readwrite,weak) XZQCollectionViewCell *selectedCell;

@end

@implementation XZQDrawingBoardViewController

#pragma mark -----------------------------
#pragma mark lazt initialization



- (SlideSelectCardView *)customView{
    if (!_customView) {
        _customView = _customView = [SlideSelectCardView xib4];
    }
    
    return _customView;
}


- (NSFileManager *)manager{
    if (!_manager) {
        _manager = [NSFileManager defaultManager];
    }
    
    return _manager;
}



- (UIView *)coverView{
    if (_coverView == nil) {
        
        _coverView = [XZQSnowCoverView snowCoverView];
    }
    
    return _coverView;
}

- (NSMutableArray *)groupOfPaint{
    if (_groupOfPaint == nil) {
        _groupOfPaint = [NSMutableArray array];
    }
    
    return _groupOfPaint;
}

- (NSMutableArray *)funcBtn{
    if (_funcBtn == nil) {
        _funcBtn = [NSMutableArray array];
    }
    
    return _funcBtn;
}


- (NSMutableArray *)colorBtn{
    if (_colorBtn == nil) {
        _colorBtn = [NSMutableArray array];
    }

    return _colorBtn;
}


#pragma mark -----------------------------
#pragma mark viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"viewdidload");
    
    //注册通知 用于通知self 点击了遮罩 该移除遮罩了
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCoverViewAndMoveBackPopView) name:@"removeCoverViewAndMoveBackPopView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disappearSelfDefinePopView) name:@"disappearSelfDefinePopView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(externalPicture) name:@"externalPicture" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(externalVideo) name:@"externalVideo" object:nil];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //画板界面背景
    UIImageView *imageV = [[UIImageView alloc] init];
    self.imageV = imageV;
    [self.view addSubview:imageV];
    
    
//    画板及画板上面的颜色框
    UIImageView *drawBackImageV = [[UIImageView alloc] init];
    [self.view addSubview:drawBackImageV];
    _drawBackImageV = drawBackImageV;
    
    
    //画板
    XZQDrawingBoard *drawBoard = [[XZQDrawingBoard alloc] init];
    [self.view addSubview:drawBoard];
    self.drawBoard = drawBoard;
    self.drawBoard.index = 0;
    self.drawBoard.backgroundColor = [UIColor whiteColor];
    
    //强指针直接赋值给弱指针有警告 type不一样
    __weak id weakSelf = drawBoard;
    
    self.delegate = weakSelf;
    
    //PopView
    //单例
    XZQPopViewController *popVc = [XZQPopViewController shareXZQPopViewController];
    self.popVc = popVc;
    
    //视频播放控制器
//    XZQVideoPlayerController *videoPlayer = [[XZQVideoPlayerController alloc] init];
    AViewController *videoPlayer = [[AViewController alloc] init];
    
    
    [self.view addSubview:videoPlayer.view];
//    self.videoPlayer.videoName = @"qingqukatong_05.mp4";
    self.videoPlayer = videoPlayer;
    
    
    //显示视频的控制条
    
    
    
    //查看本地视频
    if ([self loadVideoResource]) {
        
//        self.videoPlayer.videoUrl = [self loadVideoResource];
        self.videoPlayer.storyURL = [self loadVideoResource];
    }
    
    [self.view bringSubviewToFront:self.videoPlayer.view];
    
    //界面加载完毕 搜索是否有已经下载完毕的视频 有则返回资源url 无则返回null
    
    //给视频框添加手势
    //拖动手势 缩放手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [videoPlayer.view addGestureRecognizer:pan];
    
    
    //缩放手势 - 捏合手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [videoPlayer.view addGestureRecognizer:pinch];
    
    [self.view bringSubviewToFront:videoPlayer.view];
    
    //建立存储介质文件夹
    [self createMediaDownloadPath];
    
    //故事
    self.delegate3 = self.tabBarController.childViewControllers[2];
    
    if ([self.delegate3 respondsToSelector:@selector(postRecordSoundFolderPath:recordSoundPath:cafPath:)]) {
        [self.delegate3 postRecordSoundFolderPath:self recordSoundPath:self.recordSoundFolderPath cafPath:self.cafFolderPath];
    }
    
    self.delegate4 = self.tabBarController.childViewControllers[5];
    if ([self.delegate4 respondsToSelector:@selector(postPicturePath:picturePath:)]) {
        [self.delegate4 postPicturePath:self picturePath:self.pictureFolderPath];
    }
    
    
    
    self.ChineseName = @"自由画";
    self.EnglishName = @"free";
    self.superPath = self.pictureFolderPath;
    
//    NSLog(@"superPath = %@",self.superPath);
    self.currentPatingBoardPath = self.paintingBoardFolderPath;
    
    __weak id weak2 = self.tabBarController.childViewControllers[1];
    self.delegate2 = weak2;
    
    //设置画册控制器是此类的代理
    //    self.delegate2 = self.tabBarController.childViewControllers[1];
    
    if ([self.delegate2 respondsToSelector:@selector(postSuperpath:)]) {
        [self.delegate2 postSuperpath:self.superPath];
    }
    
    self.switchCount = 0;
    
    if ([self.delegate respondsToSelector:@selector(saveFreeFolderWithEnglishName:superPath:)]) {
        [self.delegate saveFreeFolderWithEnglishName:@"free" superPath:self.superPath];
    }
    
    drawBoard.picturePath = self.pictureFolderPath;
    
    //创建一个可以外部导入视频到按钮
    [self createExternalBtn];
    
    
    
    //创建一个可以缩放电视机的按钮
    [self createSmallOrBiggerTelevision];
    
    
    //创建一个滚动条 选择颜色
    [self setupColorBtnCollectionView];
    
    //一开始默认selectedCellTag == -1
    self.selectedCellTag = -1;
    
    //创建一个上一步/撤销的按钮
//    [self createLastStepBtn];
    
    //创建一个下一步的按钮
//    [self createNextStepBtn];
    
    
    //创建改变大小的按钮
//    [self setupChangeWidthBtn];
    
    NSLog(@"viewdidload %@",NSStringFromCGPoint(self.videoPlayer.view.center));//512 384
    
    //默认一开始隐藏电视机
//    [self showTelevisionCenterOfView];
    
    
}

#pragma mark -----------------------------
#pragma mark 创建滚动条 选择颜色
static NSString * const ID = @"cell";
- (void)setupColorBtnCollectionView{
    
    
    CGFloat collectionW = Width *0.049;
//    CGFloat collectionH = Height *0.1186;
    CGFloat collectionH = Height *0.16;
    
    XZQFlowLayout *flowLayout = ({
        
        XZQFlowLayout *flowLayout = [[XZQFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(collectionW, collectionH);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGFloat marginBottom = 35;
        flowLayout.sectionInset = UIEdgeInsetsMake(-20, 0, -marginBottom, 0);
        
        flowLayout.minimumLineSpacing = Width *0.026;
        
        flowLayout;
        
    });
    
    _flowLayout = flowLayout;
    
    UICollectionView *collectionView = ({
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];

        //        collectionView.center = self.view.center;
        collectionView.frame = CGRectMake(Width *0.102, Height *0.032, Width *0.675, Height *0.136);
        collectionView.showsHorizontalScrollIndicator = NO;
        
        [self.view addSubview:collectionView];
        
        //设置数据源
        collectionView.dataSource = self;
        //设置代理
        collectionView.delegate = self;
        
        //注册cell
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XZQCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
        
        collectionView;
        
    });
    
    _collectionView = collectionView;
    
    
}




#pragma mark -----------------------------
#pragma mark 缩放电视机的按钮
- (void)createSmallOrBiggerTelevision{
    
    CGFloat x = Width *0.0216;
    
    CGFloat width = Width *0.0519;
    
    CGFloat y = Height *0.1098 + width;
    
    XZQNameButton *televisionBtn = [[XZQNameButton alloc] initWithFrame:CGRectMake(x, y, width, width)];
    [televisionBtn setBackgroundImage:[UIImage imageNamed:@"drawboard_television"] forState:UIControlStateNormal];
    [televisionBtn addTarget:self action:@selector(hideTelevision) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:televisionBtn];
    
    _televisionBtn = televisionBtn;
    
    
    
}

#pragma mark -----------------------------
#pragma mark 隐藏电视机
- (void)hideTelevision{
    
    //暂停
    [self.videoPlayer.playerVC.player pause];
    
    //水平位移
    CGFloat changeX = 0;
    
    //用isBigger代表是否隐藏 一开始是NO的
    
    //隐藏
//    if (self.televisionBtn.isBigger) {
//
//        if (self.videoPlayer.view.center.x > self.view.center.x) {
//            //右移
//            changeX += Width;
//        }else{
//            //左移
//            changeX -= Width;
//        }
//
//    }else{//显示出来
//
//        if (self.videoPlayer.view.center.x > self.view.center.x) {
//            //左移
//            changeX -= Width;
//        }else{
//            //右移
//            changeX += Width;
//        }
//
//    }
    
    if (self.videoPlayer.view.center.x >= self.view.center.x) {
        //左移
        changeX -= Width;
    }else{
        //右移
        changeX += Width;
    }
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.videoPlayer.view.center = CGPointMake(self.videoPlayer.view.center.x + changeX, self.videoPlayer.view.center.y);
        
        //hide
        if (self.videoPlayer.view.center.x > Width || self.videoPlayer.view.center.x < 0) {
            self.videoPlayer.view.alpha = 0;
        }else{
            self.videoPlayer.view.alpha = 1;
        }
        
    }];
    
    
    NSLog(@"hideTelevision %@",NSStringFromCGPoint(self.videoPlayer.view.center));
}

#pragma 一开始将电视机显示在中间
- (void)showTelevisionCenterOfView{
    
    NSLog(@"showTelevisionCenterOfView before%@",NSStringFromCGPoint(self.videoPlayer.view.center));
    //暂停
    [self.videoPlayer.playerVC.player pause];
    
    //水平位移
    CGFloat changeX = 0;
    
    if (self.videoPlayer.view.center.x >= self.view.center.x) {
        //左移
        changeX -= Width;
        
        
    }else{//一开始向右移动原因 一开始视频的x 是 0
        //右移
        changeX += Width;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.videoPlayer.view.center = CGPointMake(self.videoPlayer.view.center.x + changeX, self.videoPlayer.view.center.y);
        
        self.videoPlayer.view.alpha = 1;
        
        
        
    }];
    
    NSLog(@"showTelevisionCenterOfView After animateBlock %@",NSStringFromCGPoint(self.videoPlayer.view.center));
}



#pragma mark -----------------------------
#pragma mark 创建改变宽度的按钮

- (void)setupChangeWidthBtn{
    
    UIButton *smallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [smallBtn setTitle:@"减小" forState:UIControlStateNormal];
    [smallBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [smallBtn addTarget:self action:@selector(changeWidth:) forControlEvents:UIControlEventTouchUpInside];
    smallBtn.frame = CGRectMake(0, 180, 100, 100);
    smallBtn.tag = 88;
    [self.view addSubview:smallBtn];
    
    UIButton *bigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bigBtn setTitle:@"增大" forState:UIControlStateNormal];
    [bigBtn addTarget:self action:@selector(changeWidth:) forControlEvents:UIControlEventTouchUpInside];
    bigBtn.tag = 89;
    [bigBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bigBtn.frame = CGRectMake(90, 180, 100, 100);
    [self.view addSubview:bigBtn];
    
}

#pragma mark -----------------------------
#pragma mark 按钮的点击

- (void)changeWidth:(UIButton *)btn{
    
    if (btn.tag == 88) {
        NSLog(@"88");
    }else{
        NSLog(@"89");
    }
        
}


//创建一个上一步/撤销的按钮
- (void)createLastStepBtn{
    
    CGFloat funcBtn5X = self.view.frame.size.width * 0.9296;
    
    XZQMoveBtn *btn = [[XZQMoveBtn alloc] init];
    btn.frame = CGRectMake(funcBtn5X, 200, 60, 60);
//    [btn setTitle:@"上一步" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"top"] forState:UIControlStateNormal];
//    btn.tintColor = [UIColor blackColor];

    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(lastStep) forControlEvents:UIControlEventTouchUpInside];

}

//调用撤销方法
- (void)lastStep{
    
    if ([self.delegate respondsToSelector:@selector(returnLastStep:)]) {
        [self.delegate returnLastStep:self];
    }
    
    NSLog(@"lastStep");
}

//创建一个下一步的按钮
- (void)createNextStepBtn{
    
    CGFloat funcBtn5X = self.view.frame.size.width * 0.9296;
    
    XZQMoveBtn *btn = [[XZQMoveBtn alloc] init];
    btn.frame = CGRectMake(funcBtn5X, 690, 60, 60);
//    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"bottom"] forState:UIControlStateNormal];
//    btn.tintColor = [UIColor blackColor];

    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
}

//调用下一步方法
- (void)nextStep{
    
    if ([self.delegate respondsToSelector:@selector(returnNextStep:)]) {
        [self.delegate returnNextStep:self];
    }
    NSLog(@"nextStep");
}


//创建一个可以外部导入视频到按钮
- (void)createExternalBtn{
    
    UIButton *btn = [[UIButton alloc] init];

    [btn setBackgroundImage:[UIImage imageNamed:@"drawboard_externalBtn"] forState:UIControlStateNormal];


    btn.frame = CGRectMake(Width *0.0216, Height*0.0751, Width *0.0519, Width *0.0519);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(popExternalBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)popExternalBtn{
    
    ZJAnimationPopStyle popStyle =  ZJAnimationPopStyleShakeFromTop;
    ZJAnimationDismissStyle dismissStyle = ZJAnimationDismissStyleDropToTop;
    
    self.customView = nil;
    _customView = [SlideSelectCardView xib11];
    
    self.customView.storyOrPlotImage = [UIImage imageNamed:@"external"];
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


/**
 支持外部导入视频到app内部进行观看

 @param externalVideoURL 外部视频到url
 */
- (void)supportExternalVideoURL:(NSURL *)externalVideoURL{
    self.videoPlayer.storyURL = externalVideoURL;
    [self.view bringSubviewToFront: self.videoPlayer.view];
}


/**
 点击弹出相册 选择视频 媒体类型为视频
 */
- (void)externalVideo{
    
    [self.ZJAPopView dismiss];
    
    self.isVideo = YES;
    
    NSLog(@"从相册选择");
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    
    //横屏弹出
    picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    picker.delegate = self;
    picker.allowsEditing=NO;
    //    picker.videoMaximumDuration = 1.0;//视频最长长度
    picker.videoQuality = UIImagePickerControllerQualityTypeMedium;//视频质量
    
    //媒体类型：@"public.movie" 为视频  @"public.image" 为图片
    //这里只选择展示视频
    picker.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
    
    picker.sourceType= UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:^{
        NSLog(@"调用完成");
    }];
    
}


/**
 点击弹出相册 选择图片 媒体类型为图片
 */
- (void)externalPicture{
    
    [self.ZJAPopView dismiss];
    
    self.isVideo = NO;
    
    //从系统相册当中选择一张图片
    //1.弹出系统相册
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    
    //横屏弹出
    pickerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    //设置照片的来源
    pickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pickerVC.delegate = self;
    //modal出系统相册
    [self presentViewController:pickerVC animated:YES completion:nil];
    
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    if (self.isVideo) {
        
        //点击了导入视频
        
        NSLog(@"点击了视频");
        
        NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:@"public.movie"]){
            //如果是视频
            NSURL *url = info[UIImagePickerControllerMediaURL];//获得视频的URL
            
            NSLog(@"url %@",url);
            //        self.videoUrl = url;
            [self supportExternalVideoURL:url];
            
            
        }
        
    }else{
        
        //点击了导入图片
        NSLog(@"%@",info);
        UIImage *image  = info[UIImagePickerControllerOriginalImage];
        
        //NSData *data = UIImageJPEGRepresentation(image, 1);
        
//        NSData *data = UIImagePNGRepresentation(image);
        
        //[data writeToFile:@"/Users/xiaomage/Desktop/photo.jpg" atomically:YES];
        
//        [data writeToFile:@"/Users/xiaomage/Desktop/photo.png" atomically:YES];
        
        HandleImageView *handleV = [[HandleImageView alloc] init];
        handleV.backgroundColor = [UIColor clearColor];
        handleV.frame = self.drawBoard.frame;
        handleV.image = image;
        handleV.delegate = self;
        handleV.clipsToBounds = YES;
        [self.view addSubview:handleV];
    }
    
    
    
    //明天参考这个代码 先在左上角放一个按钮 点击是可以从相册中选取一段视频 并且在app内部进行播放的 这样就拓展了一个新的功能 从相册选取视频进行教学操作
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




//这个功能还没有写好
//如果视频文件的大小和原大小不同 那么则是没有下载完毕的视频 我们需要播放的是已经下载完毕的视频 如果没有下载完毕的 就不给视频播放器加载资源
- (NSURL *)loadVideoResource{
    //先获得Caches文件目录/路径
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    //PaintingHouse
    NSString *name = @"PHouse";
    
    NSString *phousePath = [caches stringByAppendingPathComponent:name];
    
    //视频文件夹
    NSString *videoName = @"video";
    
    //视频文件夹路径
    NSString *videoFolderPath = [phousePath stringByAppendingPathComponent:videoName];
    
    //qingqukatong_05.mp4
    NSString *name2 = @"qingqukatong_05.mp4";
    
    NSString *storyName = [videoFolderPath stringByAppendingPathComponent:name2];
    
    
    if ([self.manager fileExistsAtPath:storyName]) {
        
        //url不对
        //        NSURL *url = [NSURL URLWithString:storyName];
        NSURL *url = [NSURL fileURLWithPath:storyName];
        NSLog(@"url---%@",storyName);
        return url;
        
    }
    
    
    return nil;
    
}

//子控件位置大小
- (void)viewWillLayoutSubviews{
//    NSLog(@"viewWillLayoutSubviews");
    
    //背景
    self.imageV.frame = self.view.bounds;
    self.imageV.image = [UIImage imageNamed:@"drawboard_backGroundImage"];
    
//    设置画板及上面的颜色框的尺寸
    CGFloat x = Width *0.0736;
    CGFloat y = Height *0.0231;
    CGFloat width = Width *0.9091;
    CGFloat height = Height *0.9538;
    
    self.drawBackImageV.frame = CGRectMake(x, y, width, height);
    self.drawBackImageV.image = [UIImage imageNamed:@"drawboard_andTopFrameBackGroundImage"];
    
    //画板
    //有弹框的尺寸
//    CGFloat drawBoardX = self.view.bounds.size.width * 0.0146;
//    CGFloat drawBoardY = self.view.bounds.size.height * 0.26;
//    CGFloat drawBoardW = self.view.bounds.size.width * 0.9776;
//    CGFloat drawBoardH = self.view.bounds.size.height * 0.7164;
    
    
    CGFloat drawBoardX = Width * 0.089;
    CGFloat drawBoardY = Height * 0.173;
    CGFloat drawBoardW = Width * 0.885;
    CGFloat drawBoardH = Height * 0.7856;
    
    self.drawBoard.frame = CGRectMake(drawBoardX, drawBoardY, drawBoardW, drawBoardH);
    
}

//来到画板界面隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}

//布局按钮
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSLog(@"viewDidAppear");
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        
        
        //加载改变颜色的 按钮
        //spaceW - 左右间隙
//        CGFloat spaceW = self.view.bounds.size.width * 0.0110;
//
//        //spaceH 上下间隙
//        CGFloat spaceH = self.view.bounds.size.height * 0.0164;
//
//        //spaceX - 第一个按钮的x
//        CGFloat btnX = self.view.bounds.size.width * 0.0318;
//
//        //spaceY - 第一个按钮的y
//        CGFloat btnY = self.view.bounds.size.height * 0.3419;
//
//        //按钮的宽度
//        CGFloat btnW = self.view.bounds.size.width * 0.0318;
//
//        //按钮的高度
//        CGFloat btnH = self.view.bounds.size.height * 0.0351;
//
//        CGRect rect = CGRectMake(0, 0, btnW, btnH);
//
//        //12行 - r 3列 - l - 使用button.tag -
//        for (int i = 0; i < 36; i++) {
//
//            UIButton *btn = [[UIButton alloc] init];
//
//            rect.origin.x = btnX + (i % 3) * (btnW + spaceW)  + 150;
//            rect.origin.y = btnY + (i / 3) * (btnH + spaceH);
//
//            btn.frame = rect;
//            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"colorBlock%d",i+1]] forState:UIControlStateNormal];
//
//            btn.tag = i;
//            [btn addTarget:self action:@selector(colorBtn:) forControlEvents:UIControlEventTouchUpInside];
//            [self.view addSubview:btn];
//            [self.colorBtn addObject:btn];
//
//
//        }
        
        //功能按钮
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        //向左
//        CGFloat funcBtn1X = self.view.frame.size.width * 0.2908;
//        CGFloat funcBtn1Y = self.view.frame.size.height * 0.0221;
        
        CGFloat funcBtn1X = Width * 0.0216;
        CGFloat funcBtn1Y = CGRectGetMaxY(self.televisionBtn.frame) + Height *0.1214;
        CGFloat funcBtn1W = Width *0.0519;
        CGFloat funcBtn1H = Width *0.0519;
        
        UIButton *funcBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(funcBtn1X, funcBtn1Y, funcBtn1W, funcBtn1H)];
        funcBtn1.tag = 0;
//        [funcBtn1 addTarget:self action:@selector(popLeftView:) forControlEvents:UIControlEventTouchUpInside];
        [funcBtn1 addTarget:self action:@selector(lastStep) forControlEvents:UIControlEventTouchUpInside];
        [funcBtn1 setBackgroundImage:[UIImage imageNamed:@"drawboard_lastStepBtn"] forState:UIControlStateNormal];
        
        //向右
        CGFloat funcBtn2Y = CGRectGetMaxY(funcBtn1.frame) + Height *0.0347;
        
        
        UIButton *funcBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(funcBtn1X, funcBtn2Y, funcBtn1W, funcBtn1H)];
        funcBtn2.tag = 1;
//        [funcBtn2 addTarget:self action:@selector(popRightView:) forControlEvents:UIControlEventTouchUpInside];
        [funcBtn2 addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
        [funcBtn2 setBackgroundImage:[UIImage imageNamed:@"drawboard_nextStepBtn"] forState:UIControlStateNormal];
        
        //对号
        CGFloat funcBtn3Y = CGRectGetMaxY(funcBtn2.frame) + Height *0.0347;
        
        
        UIButton *funcBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(funcBtn1X, funcBtn3Y, funcBtn1W, funcBtn1H)];
        funcBtn3.tag = 2;
        [funcBtn3 addTarget:self action:@selector(popYesView:) forControlEvents:UIControlEventTouchUpInside];
        [funcBtn3 setBackgroundImage:[UIImage imageNamed:@"drawboard_saveBtn"] forState:UIControlStateNormal];
        
        //叉
        CGFloat funcBtn4Y = CGRectGetMaxY(funcBtn3.frame) + Height *0.0347;
        
        UIButton *funcBtn4 = [[UIButton alloc] initWithFrame:CGRectMake(funcBtn1X, funcBtn4Y, funcBtn1W, funcBtn1H)];
        funcBtn4.tag = 3;
        [funcBtn4 addTarget:self action:@selector(popClearView:) forControlEvents:UIControlEventTouchUpInside];
        [funcBtn4 setBackgroundImage:[UIImage imageNamed:@"drawboard_resetBtn"] forState:UIControlStateNormal];
        
        //主
        CGFloat funcBtn5Y = CGRectGetMaxY(funcBtn3.frame) + Height *0.1445;
        
        UIButton *funcBtn5 = [[UIButton alloc] initWithFrame:CGRectMake(funcBtn1X, funcBtn5Y, funcBtn1W, funcBtn1H)];
        funcBtn5.tag = 4;
//        [funcBtn5 addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
        [funcBtn5 addTarget:self action:@selector(goBackMainFunc) forControlEvents:UIControlEventTouchUpInside];
        [funcBtn5 setBackgroundImage:[UIImage imageNamed:@"drawboard_returnBtn"] forState:UIControlStateNormal];
        
        [self.funcBtn addObject:funcBtn1];
        [self.funcBtn addObject:funcBtn2];
        [self.funcBtn addObject:funcBtn3];
        [self.funcBtn addObject:funcBtn4];
        [self.funcBtn addObject:funcBtn5];
        
        [self.view addSubview:funcBtn1];
        [self.view addSubview:funcBtn2];
        [self.view addSubview:funcBtn3];
        [self.view addSubview:funcBtn4];
        [self.view addSubview:funcBtn5];
        
    
//        CGFloat brushX = self.view.frame.size.width * 0.3736;
//        CGFloat brushY = self.view.frame.size.height * 0.1404;
//        CGFloat brushW = self.view.frame.size.width * 0.0360;
//        CGFloat brushH = self.view.frame.size.height * 0.1146;
//
//        UIButton *brush = [[UIButton alloc]initWithFrame:CGRectMake(brushX, brushY, brushW, brushH)];
//        brush.tag = 40;
        //这个是有弹框的
//        [brush addTarget:self action:@selector(popBrushView:) forControlEvents:UIControlEventTouchUpInside];
        //换回原来的UI 没有弹框
//        [brush addTarget:self action:@selector(colorBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [brush setBackgroundImage:[UIImage imageNamed:@"brush"] forState:UIControlStateNormal];
        
        //eraser
//        CGFloat eraserX = self.view.frame.size.width * 0.3518;
        CGFloat eraserX = Width * 0.8136;
        CGFloat eraserY = Height * 0.0785;
        CGFloat eraserW = Width * 0.0526;
        CGFloat eraserH = Height * 0.0887;
        
        UIButton *eraser = [[UIButton alloc]initWithFrame:CGRectMake(eraserX, eraserY, eraserW, eraserH)];
        eraser.tag = 41;
        //这个是有弹框的
        [eraser addTarget:self action:@selector(popPenAndEraser:) forControlEvents:UIControlEventTouchUpInside];
        //换回原来的UI 没有弹框
//        [eraser addTarget:self action:@selector(colorBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [eraser setBackgroundImage:[UIImage imageNamed:@"drawboard_eraser"] forState:UIControlStateNormal];
//        [eraser setBackgroundImage:[UIImage imageNamed:@"eraser"] forState:UIControlStateNormal];
        
        //pencil
//        CGFloat pencilX = self.view.frame.size.width * 0.4252;
        CGFloat pencilX = Width * 0.9004;
        CGFloat pencilY = Height * 0.05;
        CGFloat pencilW = Width * 0.0469;
        CGFloat pencilH = Width * 0.089;//width/height = 0.52
        
        UIButton *pencil = [[UIButton alloc]initWithFrame:CGRectMake(pencilX, pencilY, pencilW, pencilH)];
        pencil.tag = 42;
        
        //这个是有弹框的
        [pencil addTarget:self action:@selector(popPenAndEraser:) forControlEvents:UIControlEventTouchUpInside];
        
        //换回原来的UI 没有弹框
//        [pencil addTarget:self action:@selector(colorBtn:) forControlEvents:UIControlEventTouchUpInside];
        [pencil setBackgroundImage:[UIImage imageNamed:@"drawboard_changeSizeBtn"] forState:UIControlStateNormal];
        
//        [self.groupOfPaint addObject:brush];
        [self.groupOfPaint addObject:eraser];
        [self.groupOfPaint addObject:pencil];
        
//        [self.view addSubview:brush];
        [self.view addSubview:eraser];
        [self.view addSubview:pencil];
        
        
        
        //视频框
//        CGFloat videoPlayerX = self.view.bounds.size.width * 0.0193;
//        CGFloat videoPlayerY = self.view.bounds.size.height * 0.0221;
        
        //show in center
        CGFloat videoPlayerX = self.view.bounds.size.width * 0.5;
        CGFloat videoPlayerY = self.view.bounds.size.height * 0.5;
        CGFloat videoPlayerW = self.view.bounds.size.width * 0.4;
//        CGFloat videoPlayerH = self.view.bounds.size.height * 0.2088;//宽高比 1.1765
        CGFloat videoPlayerH = self.view.bounds.size.width * 0.34;
        
        
        [UIView animateWithDuration:0.5 animations:^{
            self.videoPlayer.view.bounds = CGRectMake(0, 0, videoPlayerW, videoPlayerH);
            self.videoPlayer.view.center = CGPointMake(videoPlayerX, videoPlayerY);
                
            self.videoPlayer.view.alpha = 1;
        }];
        
        
//        self.videoPlayer.view.backgroundColor = [UIColor redColor];
        self.videoPlayer.televisionOutImage = [UIImage imageNamed:@"drawboard_televisionOutFrame"];
//        [self.videoPlayer setView];
        
        

    });
        self.videoPlayer.view.center = CGPointMake(self.view.center.x - Width, self.view.center.y);
    
        [UIView animateWithDuration:0.5 animations:^{
            self.videoPlayer.view.center = CGPointMake(self.videoPlayer.view.center.x + Width, self.view.center.y);
            self.videoPlayer.view.alpha = 1;
        }];
            
            
            
            
        
            
    
    
}

#pragma mark -----------------------------
#pragma mark 返回主功能区
- (void)goBackMainFunc{
    self.currentBtn = nil;
    self.tabBarController.selectedIndex = 6;
}


//之前的点击小黑点设置笔的宽度
- (void)blackPointBtn:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(setPaintWidth:tagOfButton:)]) {
        [self.delegate setPaintWidth:self tagOfButton:sender.tag];
    }
}

//现在点击弹框中的按钮设置笔的宽度
- (void)setPenWidth:(NSInteger)count{
    if ([self.delegate respondsToSelector:@selector(setPaintWidth:tagOfButton:)]) {
        [self.delegate setPaintWidth:self tagOfButton:count];
        NSLog(@"调用了setPenWidth");
    }
}

- (void)colorBtn:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(setPaintColor:tagOfButton:)]) {
        [self.delegate setPaintColor:self tagOfButton:sender.tag];
    }
}

- (void)clearBtn:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(clearAllPath)]) {
        [self.delegate clearAllPath];
    }
}

- (void)saveBtn:(UIButton *)sender{
    //    if ([self.delegate respondsToSelector:@selector(saveBtn:)]) {
    //        [self.delegate saveBtn:sender];
    //    }
    NSLog(@"saveBtn:");
    XZQDrawingBoard *vc = (XZQDrawingBoard *)self.delegate;
    vc.isClickPlusBtn = self.isClickPlusBtn;
    if ([self.delegate respondsToSelector:@selector(saveBtn:ChineseName:EnglishName:superPath:)]) {
        [self.delegate saveBtn:sender ChineseName:self.ChineseName EnglishName:self.EnglishName superPath:self.superPath];
    }
    
    self.isClickPlusBtn = false;
    //    if ([self.delegate respondsToSelector:@selector(saveBtn:ChineseName:EnglishName:superPath:superPaintingBoardPath:)]) {
    //        [self.delegate saveBtn:sender ChineseName:self.ChineseName EnglishName:self.EnglishName superPath:self.superPath superPaintingBoardPath:self.currentPatingBoardPath];
    //    }
    
    
    //防止点击一次视频教学 然后画画 然后再自由画还是之前的name 点击去学习之后 画画就保存在对应的文件夹下 只有一开始的不点击去学习的按钮的时候是自由画
    //    self.ChineseName = @"自由画";
    //    self.EnglishName = @"free";
    
}




//弹出popView和遮罩
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
    
    //KVO监听的属性 - 当点击popView的画板的时候 改变tag
    self.popVc.view.tag = 0;
    
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

//移除遮罩
- (void)removeCoverView{
    
    for (UIView *view in self.view.subviews) {
        
        if (view.tag == 666) {
            
            
            //            view.backgroundColor = [UIColor redColor];//没有变成红色 - 不从父控件中移除的话 -就变成红色的了 - 为什么从父控件中移除就没有慢慢黑色退去的效果
            
            [UIView animateWithDuration:1.0 animations:^{
                
                view.alpha = 0;//没有变黑
                //                [self.popVc removeFromParentViewController];//不行
                
                
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

//KVO的监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    //    NSLog(@"observeValueForKeyPath");
    
    [self removeCoverView];
    
    
}


- (void)dealloc{
    [self.popVc.view removeObserver:self forKeyPath:@"tag"];
}

//手势拖动调用
- (void)pan:(UIPanGestureRecognizer *)pan{
    
    CGPoint curPoint = [pan translationInView:pan.view];
    pan.view.transform = CGAffineTransformTranslate(pan.view.transform, curPoint.x, curPoint.y);
    
    [pan setTranslation:CGPointZero inView:pan.view];
    
    
    //视频在拖动的时候被画笔按钮和其他一些个控件挡住 只要在视频移动的过程中始终让视频处于最上层就行
    [self.view bringSubviewToFront:self.videoPlayer.view];
}

//缩放手势调用
- (void)pinch:(UIPinchGestureRecognizer *)pinch{
    
    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
    pinch.scale = 1;
    
    [self.view bringSubviewToFront:self.videoPlayer.view];
}

//移除遮罩和popView
- (void)removeCoverViewAndMoveBackPopView{
    
    //    NSLog(@"++++++++++++++++++++++++++++removeCoverViewAndMoveBackPopView");
    
    [self removeCoverView];
    
    
    
}

//前往故事界面
- (void)toStoryViewController{
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"toStoryViewController" object:nil];
    
    //    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    self.tabBarController.selectedIndex = 2;//翻页过去效果也不错的
    
}


//点击主按钮 先发送一个移除popView的通知 - 这个控制器监听popView通知 - 调用popView的方法-  将popView弹出还有遮罩 - 利用KVO监听遮罩tag值 - 点击屏幕或者是弹出的控制器中的画板 - 一样的效果 - 遮罩透明度为0 - popView移动到另一边


#pragma XZQStoryViewControllerDelegate

/**
 
 问题：
 画画的类型：
 一种是自己随便画的 没有看视频
 一种是跟着视频一起学的画
 
 
 想保存的是一个故事一个图集
 每个图集都在UIPickerView中 点击图集 显示出具体的情节图片
 然后自己随便画的都保存在一个 自由画 图集中
 
 那种点击了视频之后跳转到画板界面画的画设置个标志 有那个标志 表示是跟着视频画的 那个标志可以是一个字符串 以它为图集的名称 每画一张 保存一下 点击左右切换 切换的时候自动保存 还可以切换回来
 
 
 
 */

//点击去学习的时候 将视频的名称 中文和英文 传递过来 以视频的英文名称作为图集的名称 然后存在里面的图片就以图集名后面加1234.png 点击一下保存 判断有没有标志 没有标志 保存在自由画图集中 有的话 以标志值为父目录 建立具体的图片
//



/**
 只传递了在线播放教学视频的url
 
 @param story 控制器本身
 @param url 在线视频url
 */
- (void)playVideoOnline:(XZQStoryViewController *)story videoURL:(NSURL *)url{
    
    //    self.videoPlayer.view.frame = CGRectMake(100, 100, 100, 100);
    [self.view bringSubviewToFront:self.videoPlayer.view];
    self.videoPlayer.storyURL = url;
    
}

/**
 传递在线播放视频的url还有视频的中文和英文名称
 
 @param story 控制器本身
 @param url 在线视频url
 @param chineseName 中文名
 @param englishName 英文名
 */
- (void)playVideoOnline:(XZQStoryViewController *)story videoURL:(NSURL *)url ChineseName:(NSString *)chineseName EnglishName:(NSString *)englishName{
    
    [self.view bringSubviewToFront:self.videoPlayer.view];
    self.videoPlayer.storyURL = url;
    
}



/**
 传递在线播放视频的url还有视频的中文和英文名称
 
 @param story 控制器本身
 @param url 在线视频url
 @param chineseName 中文名
 @param englishName 英文名
 @param superPath 存储的父目录
 */
- (void)playVideoOnline:(XZQStoryViewController *)story videoURL:(NSURL *)url ChineseName:(NSString *)chineseName EnglishName:(NSString *)englishName superPath:(NSString *)superPath{
    
    
    [self playVideoOnline:story videoURL:url ChineseName:chineseName EnglishName:englishName];
    
    self.superPath = superPath;
    self.EnglishName = englishName;
    self.ChineseName = chineseName;
}


/**
 传递在线播放视频的url还有视频的中文和英文名称
 
 @param story 控制器本身
 @param url 在线视频url
 @param chineseName 中文名
 @param englishName 英文名
 @param superPath 存储图片的父目录
 @param superPaintingBoardPath 存储画板对象的父目录
 */
- (void)playVideoOnline:(XZQStoryViewController *)story videoURL:(NSURL *)url ChineseName:(NSString *)chineseName EnglishName:(NSString *)englishName superPath:(NSString *)superPath superPaintingBoardPath:(NSString *)superPaintingBoardPath{
    
    //在线播放视频  并设置存储图片的相应参数
    [self playVideoOnline:story videoURL:url ChineseName:chineseName EnglishName:englishName superPath:superPath];
    
    //存储画板到内存中 设置相应参数
    self.currentPatingBoardPath = superPaintingBoardPath;
    
}

- (void)postStoryVideoURL:(XZQStoryViewController *)story videoURL:(NSURL *)url{
    
    self.videoPlayer.storyURL = url;
    
}



//建立存储介质文件夹
- (void)createMediaDownloadPath{
    
//    NSLog(@"createMediaDownloadPath");
    
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
        
        //录音文件夹
        NSString *recordSoundName = @"recordSound";
        
        //caf文件夹
        NSString *cafName = @"caf";
        
        //画板文件夹
        //        NSString *paintingBoardName = @"paintingBoard";
        
        //视频文件夹路径
        self.videoFolderPath = [self.phousePath stringByAppendingPathComponent:videoName];
        
        //图片文件夹路径
        self.pictureFolderPath = [self.phousePath stringByAppendingPathComponent:pictureName];
        
        //音频文件夹路径
        self.soundFolderPath = [self.phousePath stringByAppendingPathComponent:soundName];
        
        //录音文件夹路径
        self.recordSoundFolderPath = [self.phousePath stringByAppendingPathComponent:recordSoundName];
//        self.recordSoundFolderPath = @"/Users/dmt312/Desktop/recordSound";
        
        //caf文件夹路径
        self.cafFolderPath = [self.phousePath stringByAppendingPathComponent:cafName];
//        self.cafFolderPath = @"/Users/dmt312/Desktop/caf";
        
        //画板文件夹路径
        //        self.paintingBoardFolderPath = [self.phousePath stringByAppendingPathComponent:paintingBoardName];
        
        
        //创建文件夹 - 保存全部app的资源
        [self.manager createDirectoryAtPath:self.phousePath withIntermediateDirectories:YES attributes:nil error:nil];
        [self.manager createDirectoryAtPath:self.videoFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        [self.manager createDirectoryAtPath:self.pictureFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        [self.manager createDirectoryAtPath:self.soundFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        [self.manager createDirectoryAtPath:self.recordSoundFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        [self.manager createDirectoryAtPath:self.cafFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        //        [self.manager createDirectoryAtPath:self.paintingBoardFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    });
    
    
    //发出带参数的通知 给画册界面发送self.pictureFolderPath的值
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"pictureFolderPath" object:self.pictureFolderPath userInfo:nil];
    
    
}



//先弹框 再切换背景图
- (void)popLeftView:(UIButton *)btn{
    
    
    self.currentBtn = btn;
    
    
    ZJAnimationPopStyle popStyle =  ZJAnimationPopStyleCardDropFromLeft;
    ZJAnimationDismissStyle dismissStyle = ZJAnimationDismissStyleDropToTop;
    
    if (btn.tag == 0) {
        //弹出弹框时从右向左到中间
        popStyle = ZJAnimationPopStyleShakeFromRight;
        dismissStyle = ZJAnimationDismissStyleDropToLeft;
        self.customView = nil;
        self.customView.delegate = self;
        self.customView.title = @"切换图片";
        self.customView.showOperaion = @"即将切换到下一张图片";
        self.customView.image = [UIImage imageNamed:@"logoOfStory4"];
        
    }else if (btn.tag == 1){
        popStyle = ZJAnimationPopStyleShakeFromLeft;
        dismissStyle = ZJAnimationDismissStyleDropToRight;
        self.customView = nil;
        self.customView.delegate = self;
        self.customView.title = @"切换图片";
        self.customView.showOperaion = @"即将切换到下一张图片";
        self.customView.image = [UIImage imageNamed:@"logoOfStory5"];
        
    }else if (btn.tag == 2){
        self.customView = nil;
        self.customView.delegate = self;
        self.customView.title = @"保存图片至相册和画册中";
        self.customView.showOperaion = @"即将保存";
        self.customView.image = [UIImage imageNamed:@"logoOfStory3"];
        
    }else if (btn.tag == 3){
        
        popStyle = ZJAnimationPopStyleShakeFromBottom;
        dismissStyle = ZJAnimationDismissStyleDropToBottom;
        self.customView = nil;
        self.customView.delegate = self;
        self.customView.title = @"重新绘画";
        self.customView.showOperaion = @"即将删除当前的绘画";
        self.customView.image = [UIImage imageNamed:@"logoOfStory8"];
        
    }else if(btn.tag == 39){
        
//        popStyle = ZJAnimationPopStyleShakeFromLeft;
//        dismissStyle = ZJAnimationDismissStyleDropToLeft;
//        self.customView = nil;
//        _customView = [SlideSelectCardView xib2];//改造成说明书!!!!!!!
//        self.customView.title = @"hello world";
////        self.customView.showOperaion = @"调整笔的颜色大小和橡皮擦的大小";
//        self.customView.image = [UIImage imageNamed:@"logoOfStory9"];
//        self.customView.delegate = self;
        
    }else if (btn.tag == 40){
//        popStyle = ZJAnimationPopStyleScale;
//        dismissStyle = ZJAnimationDismissStyleScale;
//        self.customView = nil;
//        _customView = [SlideSelectCardView xib3];
//        self.customView.title = @"彩色画笔";
//        self.customView.delegate = self;
////        self.customView.showOperaion = @"选择彩色画笔才能够涂彩色";
//        self.customView.image = [UIImage imageNamed:@"brush"];
        
    }else if (btn.tag == 41){
        popStyle = ZJAnimationPopStyleScale;
        dismissStyle = ZJAnimationDismissStyleScale;
        self.customView = nil;
        _customView = [SlideSelectCardView xib13];
//        self.customView.title = @"橡皮擦";
//        self.customView.showOperaion = @"橡皮擦可以擦掉不想要的部分";
        self.customView.eraserImage = [UIImage imageNamed:@"eraser"];
        
        self.customView.delegate = self;
        
        [self colorBtn:btn];
        
        //将对勾指在白色
        self.selectedCellTag = 0;
        
        //刷新collection
        [self.collectionView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [self.ZJAPopView dismiss];
            
        });
        
        
        
    }else if (btn.tag == 42){
        popStyle = ZJAnimationPopStyleScale;
        dismissStyle = ZJAnimationDismissStyleScale;
        self.customView = nil;
        _customView = [SlideSelectCardView xib12];
//        self.customView.title = @"铅笔";
//        self.customView.showOperaion = @"改变画笔和橡皮的大小";
//        self.customView.image = [UIImage imageNamed:@"pencil"];
        self.customView.widthImage = [UIImage imageNamed:@"drawboard_changeSizeBtn_2"];
        self.customView.delegate = self;
    }else if (btn.tag == 50){
        popStyle = ZJAnimationPopStyleShakeFromRight;
        dismissStyle = ZJAnimationDismissStyleDropToLeft;
        self.customView = nil;
        self.customView.delegate = self;
        self.customView.title = @"切换界面";
        self.customView.showOperaion = @"即将切换到故事界面";
        self.customView.image = [UIImage imageNamed:@"logoOfStory7"];
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

- (void)popRightView:(UIButton *)btn{
    
    [self popLeftView:btn];
    
}

- (void)popYesView:(UIButton *)btn{
    
    [self popLeftView:btn];
}

- (void)popClearView:(UIButton *)btn{
    
    [self popLeftView:btn];
}

- (void)popPenAndEraser:(UIButton *)btn{
    [self popLeftView:btn];
}

//- (void)popColorAndSize:(UIButton *)btn{
//    [self popLeftView:btn];
//}

//- (void)popBrushView:(UIButton *)btn{
//    [self popLeftView:btn];
//}

- (void)popToStoryViewController:(UIButton *)btn{
    [self popLeftView:btn];
}

#pragma 自定义弹框代理方法
- (void)getCountFromZJXibFoctory:(ZJXibFoctory *)foctory count:(NSInteger)count{
    
//    [self blackPointBtn:self.currentBtn];
    
    [self setPenWidth:count];
    
    NSLog(@"调用了代理方法");
    self.customView = nil;
    
}

- (void)setColorOfPencil:(ZJXibFoctory *)foctory colorBtn:(UIButton *)btn{
    [self colorBtn:btn];
    self.customView = nil;
}

/**
 切换背景图
 */
- (void)switchImage:(UIButton *)btn{
    
    if (btn.tag == 0) {
        self.switchCount--;
    }else if (btn.tag == 1){
        self.switchCount++;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(setBackImage:)]) {
        
        self.switchCount = [self.delegate setBackImage:self.switchCount];
    }
    
    
}

//移除自定义弹框
- (void)disappearSelfDefinePopView{
    
    [self.ZJAPopView dismiss];
    
    if (self.currentBtn.tag == 0 || self.currentBtn.tag == 1) {
        [self switchImage:self.currentBtn];
    }else if (self.currentBtn.tag == 2){
        [self saveBtn:self.currentBtn];
    }else if (self.currentBtn.tag == 3){
        [self clearBtn:self.currentBtn];
    }else if (self.currentBtn.tag == 39){
        self.customView = nil;
        //调用方法改变笔和橡皮的状态 //调用代理方法设置彩色笔的颜色 已经在SlideSelectCardView中调用了代理方法
        
    }else if (self.currentBtn.tag == 40){
        //调用代理方法设置彩色笔的颜色 已经在SlideSelectCardView中调用了代理方法
        
        NSLog(@"画板颜色改变");
        
        

        
//    }else if ( self.currentBtn.tag == 41 || self.currentBtn.tag == 42){
    }else if ( self.currentBtn.tag == 41){
        [self colorBtn:self.currentBtn];
    }else if (self.currentBtn.tag == 50){
        [self toStoryViewController];
    }
    
}


//纯移除弹框
- (void)dismissPopView:(SlideSelectCardView *)foctory dismissBtn:(UIButton *)btn{
    [self.ZJAPopView dismiss];
    
//    [self hideWidthLabel:foctory widthLabel:foctory.widthLabel widthCountLabel:foctory.widthCountLabel];
}

//- (void)hideWidthLabel:(ZJXibFoctory *)foctory widthLabel:(UILabel *)label widthCountLabel:(UILabel *)widthCountLabel{
//
//    [label removeFromSuperview];
//    [widthCountLabel removeFromSuperview];
//}








//没有用到
- (void)showPaintingBoard:(UIButton *)btn{
    
    
    
    NSUInteger row = self.drawBoard.index;
    
    if (btn.tag == 0) {
        row--;
    }else if (btn.tag == 1){
        row++;
    }
    
    NSLog(@"点击了showPaintingBoard index = %ld row = %ld",self.drawBoard.index,row);
    
    if ([self.delegate respondsToSelector:@selector(getPaintingBoard:)]) {
        
        NSLog(@"代理实现了showPaintingBoard方法");
        
        if ([self.delegate getPaintingBoard:row] != nil) {
            
            NSLog(@"更新画板 : 之前 :%@ index = %ld",self.drawBoard,self.drawBoard.index);
            
            self.drawBoard = [self.delegate getPaintingBoard:row];
            
            NSLog(@"之后%@ index = %ld",self.drawBoard,self.drawBoard.index);
        }
        
        
    }
    
}


//是否改变画板的背景颜色
- (void)boardColorSwitchIsOn:(ZJXibFoctory *)foctory on:(BOOL)on{
    self.boardColorSwitchIsOn = on;
    
    if (self.boardColorSwitchIsOn) {
        
        self.drawBoard.backgroundColor = self.drawBoard.currentColor;
    }
    
}

#pragma HandleImageViewDelegate

- (void)handleImageView:(HandleImageView *)handleImageView newImage:(UIImage *)newImage{
    
    self.drawBoard.externalPicture = newImage;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.tabBarController.selectedIndex = 6;
    
}







#pragma mark -----------------------------
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 31;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XZQCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
//    cell.backgroundColor = [UIColor grayColor];
    
    cell.brushTag = indexPath.row;

    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"drawboard_brush_%ld",indexPath.row]];
    
    cell.image = [UIImage OriginalImageWithImage:image];
    
    cell.delegate = self;
    
//    if (indexPath.row == 0) {
//        self.selectedCell = cell;
//    }
    
    if (self.selectedCellTag == indexPath.row) {
        cell.imageV.alpha = 1;
        self.selectedCell = cell;
        NSLog(@"showedCell%@",cell);
    }else{
        cell.imageV.alpha = 0;
    }
    
    return cell;
    
}

#pragma mark -----------------------------
#pragma mark XZQCollectionViewCellDelegate
- (void)throwSelectedCell:(XZQCollectionViewCell *)cell tag:(NSInteger)tag{
    self.selectedCellTag = tag;
    self.selectedCell = cell;
}


- (void)hideCellSelected{
    
    self.selectedCell.imageV.alpha = 0;
    [self.collectionView reloadData];
//    NSLog(@"sel %@",self.selectedCell);
}

- (void)cellClickChangeColor:(UIButton *)btn{
    
    [self colorBtn:btn];
    
}



@end
