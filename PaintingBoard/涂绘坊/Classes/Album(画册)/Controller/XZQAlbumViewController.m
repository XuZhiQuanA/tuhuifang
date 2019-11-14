//
//  XZQAlbumViewController.m
//  涂绘坊
//
//  Created by dmt312 on 2019/5/11.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQAlbumViewController.h"
#import "MyCollectionViewCell.h"
#import "XZQCoverView.h"
#import "XZQSnowCoverView.h"
#import "XZQPopViewController.h"
#import "XZQDrawingBoardViewController.h"
#import "XZQNameButton.h"

#import "UIImage+OriginalImage.h"


#import "LYCarrouselView.h"
#import "LYSlider.h"
#import "UIButton+Category.h"

//弹框框架

#import "SlideSelectCardView.h"
#import "ZJAnimationPopView.h"

#define paintBtnX self.view.frame.size.width * 0.0173
#define paintBtnY self.view.frame.size.height * 0.0578
#define paintBtnW self.view.frame.size.width * 0.1645
#define paintBtnH self.view.frame.size.height * 0.1503

#define paintBtnSpace self.view.frame.size.height * 0.0116
#define paintBtnSpace2 self.view.frame.size.height * 0.0578

#define Width self.view.frame.size.width
#define Height self.view.frame.size.height

#define kLineSpacing 10
#define kScreenWidth self.view.frame.size.width
#define kLineNum 5
#define kScreenHeight self.view.frame.size.height





@interface XZQAlbumViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,XZQDrawingBoardViewDelegate>
/**背景 */
@property(nonatomic,strong) UIImageView *imageV;

/**背景2 */
@property(nonatomic,strong) UIImageView *imageV2;

/**左边的可滑动的pickerView */
@property(nonatomic,strong) UIPickerView *pickerView;

/**左边的可滑动的pickerView2 用于显示故事的 */
@property(nonatomic,readwrite,strong) UIPickerView *pickerView2;

/**故事描述 */
@property(nonatomic,strong) UILabel *storyDescribition;

/**主页按钮 */
@property(nonatomic,strong) UIButton *mainBtn;

//跳转到主功能界面按钮
@property(nonatomic, strong) UIButton *jumpToMainFuncIBButton;

/**详情按钮 */
@property(nonatomic,readwrite,strong) XZQNameButton *detailsBtn;

/**遮罩 */
@property(nonatomic,strong) XZQCoverView *coverView;

//弹出的控制器
@property(nonatomic,strong) XZQPopViewController *popVc;

/**显示的故事情节图片 */
@property(nonatomic,strong) UIImageView *storyView;

/**存放绘画图片字典的数组 */
@property(nonatomic,readwrite,strong) NSMutableArray *dictArray;

/**文件管理者 */
@property(nonatomic,strong) NSFileManager *manager;

/**当前选中的图集 */
@property(nonatomic,readwrite,strong) NSMutableDictionary *currentSelectedAtlas;

/** 在具体状态下 当前显示在右边的图片 */
@property(nonatomic,readwrite,strong) UIImage *currentImage;

/**在图集状态下 当前选中了第几行 */
@property(nonatomic,readwrite,assign) NSInteger selectedAltasRow;

/**在具体状态下 当前选中了第几行*/
@property(nonatomic,assign) NSInteger selectedConcreateRow;

/**保存具体状态下选中的行数 */
//@property(nonatomic,readwrite,strong) NSMutableDictionary *allSelectedRowDict;

/**在具体状态下 保存某一个故事所有的画作 */
@property(nonatomic,readwrite,strong) NSMutableDictionary *allConcreateDict;

//使里面的图片按顺序存放
@property(nonatomic, strong) NSMutableArray *sortArray;

//键是图片名称 - 值是image
@property(nonatomic, strong) NSMutableDictionary *pathAndImageDict;

//记录当前的行数
@property(nonatomic, assign) NSInteger currentRow;

//用于播放作品动画按钮
@property(nonatomic, weak) UIButton *animateBtn;

//存放一个故事的所有手绘图片
@property(nonatomic, strong) NSMutableArray *oneStoryPictures;

//是否是页面即将出现
@property(nonatomic, assign) BOOL isViewWillAppear;

/**自定义弹框内容 */
@property(nonatomic,readwrite,strong) SlideSelectCardView *customView;

//为系统图片提供弹框
@property(nonatomic,readwrite,strong) SlideSelectCardView *customView2;

/**自定义弹框 */
@property(nonatomic,readwrite,strong) ZJAnimationPopView *ZJAPopView;

@property(nonatomic,readwrite,strong) ZJAnimationPopView *ZJAPopView2;

//控制跑马灯的按钮start
@property(nonatomic, weak) UIButton *start;

//控制跑马灯的按钮stop
@property(nonatomic, weak) UIButton *stop;

//控制跑马灯的滑块slopex
@property(nonatomic, weak) LYSlider *slopex;

//跑马灯属性
@property(nonatomic, strong) LYCarrouselView *carrB;

@property(nonatomic, strong) UIImageView *remindImageView;

@property(nonatomic, weak) UIImageView *systemImageView;

@property(nonatomic, strong) AVPlayer *musicPlayer;

@end

@implementation XZQAlbumViewController

- (AVPlayer *)musicPlayer{
    if (!_musicPlayer) {
        _musicPlayer = [[AVPlayer alloc] init];
        
        NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:@"Deep East Music - Sunny Jim" ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath:musicFilePath];
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
        [_musicPlayer replaceCurrentItemWithPlayerItem:playerItem];
        _musicPlayer.rate = 1.0;
        [_musicPlayer pause];
        
    }
    
    return _musicPlayer;
}

- (UIImageView *)remindImageView{
    
    if (_remindImageView == nil) {
        _remindImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*0.5-150, -100, 300, 100)];
        _remindImageView.clipsToBounds = YES;
        _remindImageView.layer.cornerRadius = 20;
        _remindImageView.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"remindPicture_1"]];
//        _remindImageView.backgroundColor = [UIColor redColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_remindImageView];
    }
    
    return _remindImageView;
}

- (LYCarrouselView *)carrB{
    if (_carrB == nil) {
        
        __weak typeof(XZQAlbumViewController *)weakSelf = self;
        
        LYCarrouselView *carr;
        
        if (self.oneStoryPictures.count != 0) {
            
            //创建新的弹框
            [self popSystemPicture];
            UIImage *image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"remindPicture_2"]];
            
            carr = [[LYCarrouselView alloc] initWithFrame:CGRectMake(0, 0, self.customView.bounds.size.width, self.customView.bounds.size.height) images:self.oneStoryPictures callback:^(NSInteger index, NSInteger event) {

                NSLog(@"%ld %@", index, event == 1 ? @"点击" : @"长按");
                
                
                [weakSelf.ZJAPopView dismiss];
                [weakSelf hiddenBtnAndSlider];
                
                
                [weakSelf.ZJAPopView2 pop];
                //1.2弹出新的弹框 - 点击没有拿到自己画的东西
                
                
                if (index >= weakSelf.oneStoryPictures.count) {
                    weakSelf.systemImageView.image = image;
                }else{
                    weakSelf.systemImageView.image = weakSelf.oneStoryPictures[index];
                }
                
                
                
                
                NSLog(@"weakSelf.systemImageView.image: %@ arrayCount: %ld",weakSelf.systemImageView,weakSelf.oneStoryPictures.count);
            }];
            
            
            
            
            
        }else{
            
            
            NSMutableArray *arrM = [NSMutableArray array];
            for (NSInteger i = 0; i < 10; i++) {
                [arrM addObject:[UIImage OriginalImageWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld",(i+1)]]]];
            }
            
            //创建新的弹框
            [self popSystemPicture];
            
            carr = [[LYCarrouselView alloc] initWithFrame:CGRectMake(0, 0, self.customView.bounds.size.width, self.customView.bounds.size.height) images:arrM callback:^(NSInteger index, NSInteger event) {

                NSLog(@"%ld %@", index, event == 1 ? @"点击" : @"长按");
                
                
                //听系统的录音 -
                
                //1.先dismiss一下 然后再从上面出来一个弹框 里面装的是刚刚点击的图片 然后系统声音出来 可能的话背景有雪 播放完毕 dismiss弹框 将刚刚的跑马灯拉出来
                
                //1.1dismiss当前弹框
                [weakSelf.ZJAPopView dismiss];
                [weakSelf hiddenBtnAndSlider];
                
                
                [weakSelf.ZJAPopView2 pop];//ZJAPopView 包含跑马灯的弹框 ZJAPopView2展示具体点击图片的弹框
                //1.2弹出新的弹框
                weakSelf.systemImageView.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld",index+1]]];
                
                NSLog(@"systemImageView - weakSelf.customView2 =  %@",self.customView2);
                
            }];
            
        }
        
        carr.clipsToBounds = YES;
        carr.layer.cornerRadius = 20;
        
        //以这张图片的宽高设定
//        [carr addImage:[UIImage imageNamed:@"mm8.jpeg"]];
        [carr addImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"remindPicture_2"]]];
        carr.backgroundColor = [UIColor blackColor];
        carr.animationSpeed = 2;
        carr.showReflectLayer = YES;
        
        _carrB = carr;
    }
    
    return _carrB;
}

//storyPlot_recordSoundBtn

/**
 CGFloat detailsBtnX = Width * 0.8196;
 CGFloat detailsBtnY = Height * 0.0983;
 CGFloat detailsBtnW = Height *0.07;
 CGFloat detailsBtnH = Height *0.07;
 
 
 CGFloat mainBtnX = Width * 0.9196;
        CGFloat mainBtnY = Height * 0.0983;
        CGFloat mainBtnW = Height * 0.07;
        CGFloat mainBtnH = Height * 0.07;
 
 
 */

- (UIButton *)start{
    
    if (_start == nil) {
        
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtn setFrame:CGRectMake((self.view.bounds.size.width *0.5)-200,self.view.bounds.size.height + 150, 100, 48)];
        [startBtn setTitle:@"开始" forState:UIControlStateNormal];
        [startBtn setBackgroundColor:[UIColor blueColor]];
        startBtn.clipsToBounds = YES;
        startBtn.layer.cornerRadius = 10;
        __weak typeof(XZQAlbumViewController *)weakSelf = self;
        [startBtn handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIControlEvents events) {
            
            //默认为向左，如果暂停了，修改方向，开始向右
            [weakSelf.carrB startRotateRight:YES];
        }];
        
        [[UIApplication sharedApplication].keyWindow addSubview:startBtn];
        
        _start = startBtn;
    }
    
    return _start;
}

- (UIButton *)stop{
    if (_stop == nil) {
        UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [stopBtn setFrame:CGRectMake((self.view.bounds.size.width *0.5)+100,self.view.bounds.size.height + 100, 150, 48)];
        [stopBtn setTitle:@"停止" forState:UIControlStateNormal];
        [stopBtn setBackgroundColor:[UIColor blueColor]];
        stopBtn.clipsToBounds = YES;
        stopBtn.layer.cornerRadius = 10;
        __weak typeof(XZQAlbumViewController *)weakSelf = self;
        [stopBtn handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIControlEvents events) {
            
            [weakSelf.carrB stopRotate];
        }];
        
        [[UIApplication sharedApplication].keyWindow addSubview:stopBtn];
        _stop = stopBtn;
    }
    
    return _stop;
}

- (LYSlider *)slopex{
    
    if (_slopex == nil) {
        LYSlider *slopexSlider = [[LYSlider alloc] initWithWidth:280 center:CGPointMake(self.view.bounds.size.width + 300, 350) horizontal:NO];
//        slopexSlider.transform = CGAffineTransformMakeRotation(M_PI_2);
        slopexSlider.thumbcolor = [UIColor magentaColor];
        slopexSlider.gradientBackInfo = [self sliderBackGraidentInfo];
        slopexSlider.value = 2 / 6.0;
        __weak typeof(XZQAlbumViewController *)weakSelf = self;
        [slopexSlider handleSliderAction:UIControlEventValueChanged callback:^(LYSlider *slider, UIControlEvents event) {
            
            weakSelf.carrB.animationSpeed = slider.value * 6;
        }];
        
        [[UIApplication sharedApplication].keyWindow addSubview:slopexSlider];
        _slopex = slopexSlider;
    }
    
    return _slopex;
}
- (SlideSelectCardView *)customView{
    if (_customView == nil) {
        _customView = [SlideSelectCardView xib19];
        
    }
    
    return _customView;
}

- (SlideSelectCardView *)customView2{
    if (_customView2 == nil) {
        _customView2 = [SlideSelectCardView xib20];
        _customView2.backgroundColor = [UIColor clearColor];
        
    }
    
    return _customView2;
}



- (NSMutableArray *)oneStoryPictures{
    if (_oneStoryPictures == nil) {
        _oneStoryPictures = [NSMutableArray array];
    }
    
    return _oneStoryPictures;
}

- (UIButton *)animateBtn{
    if (_animateBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(2*Width*0.8196-Width*0.9196, Height * 0.0983, Height * 0.07, Height * 0.07);
        [btn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"animateBtn"]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selfDefineAnimated) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
        _animateBtn = btn;
    }
    
    return _animateBtn;
}

- (NSMutableDictionary *)pathAndImageDict{
    if (_pathAndImageDict == nil) {
        _pathAndImageDict = [NSMutableDictionary dictionary];
    }
    
    return _pathAndImageDict;
}

#pragma lazy initialization
- (NSMutableArray *)sortArray{
    if (_sortArray == nil) {
        _sortArray = [NSMutableArray array];
    }
    
    return _sortArray;
}

//- (NSMutableDictionary *)allSelectedRowDict{
//    if (!_allSelectedRowDict) {
//        _allSelectedRowDict = [NSMutableDictionary dictionary];
//    }
//
//    return _allSelectedRowDict;
//}

- (NSMutableDictionary *)allConcreateDict{
    
    _allConcreateDict = [NSMutableDictionary dictionary];
    
    NSString *fileName = nil;
    NSInteger row = 0;
    
    for (NSString *temp in self.currentSelectedAtlas) {
        
        fileName = temp;//threeBoysSelfPlus_7.png 加入数组 重复不加入 然后排序
        
        //不加入重复的元素 然后排序 这个数组用于和字典进行比对
        
        
        fileName = [self matchingOfStringReturnEnglishName:fileName];
        

        
//        UIImage *image = [UIImage imageWithContentsOfFile:[self.currentSelectedAtlas objectForKey:[NSString stringWithFormat:@"%@_%ld.png",fileName,(row+1)]]];//key不对 取不出来image key是图片的全名
        
        UIImage *image = [UIImage imageWithContentsOfFile:[self.currentSelectedAtlas objectForKey:temp]];
        
//        NSLog(@"allConcreateDict 的get方法中 打印一下self.currentSelectedAtlas = %@",self.currentSelectedAtlas);
//        NSLog(@"allConcreateDict 的get方法中 temp = %@ fileName = %@ image = %@",temp,fileName,image);
        
        [_allConcreateDict setObject:image forKey:[NSString stringWithFormat:@"%ld",row]];
        [_pathAndImageDict setObject:image forKey:temp];
        
//        NSLog(@"allConcreateDict 没有问题");
        row++;
        
        
    }
    
    return _allConcreateDict;
}

- (NSFileManager *)manager{
    if (!_manager) {
        _manager = [NSFileManager defaultManager];
    }
    
    return _manager;
}

- (NSMutableArray *)dictArray{
    
    NSUInteger index = 0;
    BOOL flag = NO;
    if (_dictArray != nil) {
        
        for (NSMutableDictionary *dict in _dictArray) {
            index++;
            if (dict == self.currentSelectedAtlas) {
                flag = YES;
                break;
            }
            
        }
        
        
        
    }
    
    _dictArray = [NSMutableArray array];
    
    //array中保存的是卖火柴的小女孩、疯狂原始小猎人之类的父类的英文故事名称
    NSArray *array = [self.manager contentsOfDirectoryAtPath:self.superPath error:nil];
    
    
    for (NSString *fileName in array) {
        
        
        //fileName 卖火柴的小女孩 self.superPath 是路径 一直到picture  filePath 路径 一直到 details_matchGirl
        
        NSString *filePath = [self.superPath stringByAppendingPathComponent:fileName];
        
        //subArray 里面是自己画的图片的名称
        NSArray *subArray = [self.manager contentsOfDirectoryAtPath:filePath error:nil];
        
//        NSMutableArray *arrM = [NSMutableArray array];
//
//        for (NSString *str in subArray) {
//            [arrM addObject:str];
//        }
//
//        subArray = [self sortSelfPlusArray:arrM];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        for (NSString *fileSubName in subArray) {
            
            
            //最终图片的路径
            NSString *fileSubPath = [filePath stringByAppendingPathComponent:fileSubName];
            
//            NSLog(@"最终图片的路径 == %@",fileSubPath);
            
            [dict setObject:fileSubPath forKey:fileSubName];
            
//            NSLog(@"dictArray 没有问题");
            //每个字典存放的是图片的路径 key也是有.png的
            if ([_dictArray containsObject:dict]) {
                
            }else{
                [_dictArray addObject:dict];
            }
            
            
            
            
        }
    }
    
    if (flag) {
        self.currentSelectedAtlas = _dictArray[index - 1];
    }
    
    return _dictArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //背景
    self.imageV.image = [UIImage imageNamed:@"drawboard_backGroundImage"];
    
//    self.imageV2.image = [UIImage imageNamed:@"paintingAlbumBg"];
    self.imageV2.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"paintingAlbum_frame"]]; 
    
    
    //创建PickerView
    [self createPickerView];
    
    //创建storyName
    //    [self createStoryName];
    
    //创建storyDescribition
    [self createStoryDescribition];
    
    //创建主界面按钮
//    [self createMainBtn];
    
//    创建跳转到主功能界面的按钮
    [self createJumpToMainFuncIBButton];
    
    //创建详情按钮
    [self createDetailsBtn];
    
    //布局大图位置
    [self createStoryView];
    
    //一开始选中第一行
    [self pickerView:self.pickerView2 didSelectRow:0 inComponent:0];
    
    self.selectedAltasRow = 0;
    self.selectedConcreateRow = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenBtnAndSlider) name:@"dismissZJPopView" object:nil];
    
    //监听音频是否播放完毕 - 无播放按钮的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinishedBeingCalled) name:@"AVPlayerItemDidPlayToEndTimeNotification" object:self.musicPlayer.currentItem];
    
}

- (void)postSuperpath:(NSString *)superPath{
    
    self.superPath = superPath;
}

#pragma 接收到图片路径
- (void)receicePircturePath:(NSNotification *)notification{
    
    NSLog(@"接收到了superPath");
    
    self.superPath = (NSString *)[notification object];
}

#pragma 布局故事情节图片位置
- (void)createStoryView{
    if (!self.storyView) {
        self.storyView = [[UIImageView alloc] initWithFrame:CGRectMake(Width * 0.2056, Height * 0.2312, Width * 0.7792, Height *0.6936)];
        [self.view addSubview:self.storyView];
        self.storyView.image = [UIImage imageNamed:@"1"];
        self.storyView.backgroundColor = [UIColor clearColor];
    }
}

#pragma 创建主界面按钮
- (void)createMainBtn{
    
    if (!self.mainBtn) {
        
        CGFloat mainBtnX = Width * 0.9196;
        CGFloat mainBtnY = Height * 0.0983;
        CGFloat mainBtnW = Height * 0.0498;
        CGFloat mainBtnH = Height * 0.0498;
        
        self.mainBtn = [[UIButton alloc] initWithFrame:CGRectMake(mainBtnX, mainBtnY, mainBtnW, mainBtnH)];
        [self.view addSubview:self.mainBtn];
        
        self.mainBtn.tag = 4;
        [self.mainBtn addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
        [self.mainBtn setBackgroundImage:[UIImage imageNamed:@"main"] forState:UIControlStateNormal];
        
        //主页
        XZQPopViewController *popVc = [XZQPopViewController shareXZQPopViewController];
        
        self.popVc = popVc;
        
    }
    
    
    
}

//创建跳转到主功能界面的按钮
- (void)createJumpToMainFuncIBButton{
    if (!self.jumpToMainFuncIBButton) {
        
        CGFloat mainBtnX = Width * 0.9196;
        CGFloat mainBtnY = Height * 0.0983;
        CGFloat mainBtnW = Height * 0.07;
        CGFloat mainBtnH = Height * 0.07;
        
        self.jumpToMainFuncIBButton = [[UIButton alloc] initWithFrame:CGRectMake(mainBtnX, mainBtnY, mainBtnW, mainBtnH)];
        [self.view addSubview:self.jumpToMainFuncIBButton];
        
        [self.jumpToMainFuncIBButton addTarget:self action:@selector(jumpToMainFuncIB) forControlEvents:UIControlEventTouchUpInside];
//        [self.jumpToMainFuncIBButton setBackgroundImage:[UIImage imageNamed:@"patingAlbum_returnToMainFuncIB"] forState:UIControlStateNormal];
        
        [self.jumpToMainFuncIBButton setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"patingAlbum_returnToMainFuncIB"]] forState:UIControlStateNormal];
        
    }
}

#pragma 跳转到主功能界面
- (void)jumpToMainFuncIB{
    self.tabBarController.selectedIndex = 6;
    
    //点击详情按钮
    self.detailsBtn.isBigger = !self.detailsBtn.isBigger;
    [self detailsBtnClick:self.detailsBtn];
}

#pragma 创建详情按钮
- (void)createDetailsBtn{
    
    /**
     
            CGFloat mainBtnX = Width * 0.9196;
            CGFloat mainBtnY = Height * 0.0983;
            CGFloat mainBtnW = Height * 0.07;
            CGFloat mainBtnH = Height * 0.07;
     
     */
    
    if (!_detailsBtn) {
        
        CGFloat detailsBtnX = Width * 0.8196;
        CGFloat detailsBtnY = Height * 0.0983;
        CGFloat detailsBtnW = Height *0.07;
        CGFloat detailsBtnH = Height *0.07;
        
        self.detailsBtn = [[XZQNameButton alloc] initWithFrame:CGRectMake(detailsBtnX, detailsBtnY, detailsBtnW, detailsBtnH)];
        [self.view addSubview:self.detailsBtn];
        
        [self.detailsBtn addTarget:self action:@selector(detailsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.detailsBtn setBackgroundImage:[UIImage imageNamed:@"details"] forState:UIControlStateNormal];
        [self.detailsBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"paintingAlbum_intoDetails"]] forState:UIControlStateNormal];
        
    }
    
    
}




#pragma 主界面按钮调用方法
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

#pragma KVO监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    
    [self removeCoverView];
}

- (void)removeCoverView{
    
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

#pragma 创建storyDescribition
- (void)createStoryDescribition{
    self.storyDescribition = [[UILabel alloc] initWithFrame:CGRectMake(Width * 0.2165, Height * 0.0925, Width * 0.6667, Height * 0.0694)];
    [self.view addSubview:self.storyDescribition];
    self.storyDescribition.textColor = [UIColor colorWithRed:71.0/255.0 green:96.0/255.0 blue:61.0/255.0 alpha:1];
    self.storyDescribition.font = [UIFont systemFontOfSize:25];
    self.storyDescribition.backgroundColor = [UIColor clearColor];
}

#pragma 创建UIPickerView
- (void)createPickerView{
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.tag = 1;
    self.pickerView.frame = CGRectMake(Width * 0.0087, Height * 0.0173, Width * 0.1818, Height * 0.9653);
    self.pickerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.pickerView];
    
    
    //一开始不让具体的故事画作显示出来 pickerView是具体画作
    self.pickerView.alpha = 0;
    
    
    self.pickerView2 = [[UIPickerView alloc] init];
    self.pickerView2.dataSource = self;
    self.pickerView2.delegate = self;
    self.pickerView2.tag = 2;
    self.pickerView2.frame = CGRectMake(Width * 0.0087, Height * 0.0173, Width * 0.1818, Height * 0.9653);
    self.pickerView2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.pickerView2];
    
    self.pickerView2.alpha = 1;
    
    [self.view bringSubviewToFront:self.pickerView2];
    [self.view insertSubview:self.pickerView belowSubview:self.pickerView2];
    
}

#pragma UIPickerView数据源方法
//多少组
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//每一组多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (pickerView.tag == 1) {
        return self.currentSelectedAtlas.count;
    }else if (pickerView.tag == 2){
        
        if (self.dictArray.count != 0) {
            return self.dictArray.count;
        }else{
            return 1;
        }
        
    }
    return 1;
}

//该方法返回的UIView控件将直接作为该UIPickerView控件中指定列的指定列表项。
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    //150 130
    UIImageView* myview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width*0.146484, Height*0.169270)];
    
    if (pickerView.tag == 1) {
        
        if (self.allConcreateDict.count != 0) {
            //给row设置图片

            if (self.currentSelectedAtlas == nil) {
                //allConcreateDict 字典 存储乱序 这里想要按顺序展示 给字典设置个方法 让其顺序展示
                NSInteger i = row + 1;
                UIImage *image;
                
                for (NSString *str in self.pathAndImageDict) {
                    
                    if ([str rangeOfString:[NSString stringWithFormat:@"%ld",i]].location != NSNotFound) {
                        
                        image = [self.pathAndImageDict objectForKey:str];
                        self.currentRow = row;
                        

                        break;
                        
                    }
                }
                

                myview.image = image;
            }else{
                
                [self dataFromDictToArray:self.currentSelectedAtlas array:self.oneStoryPictures];
                myview.image = self.oneStoryPictures[row];
                
                
            }
            
            
            
            
        }else{
            
            myview.image = [UIImage imageNamed:@"logoOfStory1"];
        }
        
        //给sortArray赋值
        
        
    }else if (pickerView.tag == 2){
        
        //给row设置图片
        switch (row) {
            case 0:
                myview.image = [UIImage imageNamed:@"logoOfStory1"];
                break;
            case 1:
                myview.image = [UIImage imageNamed:@"logoOfStory2"];
                break;
            case 2:
                myview.image = [UIImage imageNamed:@"logoOfStory3"];
                break;
            case 3:
                myview.image = [UIImage imageNamed:@"logoOfStory4"];
                break;
            case 4:
                myview.image = [UIImage imageNamed:@"logoOfStory5"];
                break;
            case 5:
                myview.image = [UIImage imageNamed:@"logoOfStory6"];
                break;
            case 6:
                myview.image = [UIImage imageNamed:@"logoOfStory7"];
                break;
            case 7:
                myview.image = [UIImage imageNamed:@"logoOfStory8"];
                break;
            case 8:
                myview.image = [UIImage imageNamed:@"logoOfStory9"];
                break;
                
            default:
                myview.image = [UIImage imageNamed:@"logoOfStory6"];
                break;
        }
        
    }
    
    myview.backgroundColor = [UIColor clearColor];
    
    return myview;
    
}

#pragma 详情按钮点击
- (void)detailsBtnClick:(XZQNameButton *)btn{
    
    
    
    if (btn.isBigger) {
        NSLog(@"detailsBtnClick");
        
        //具体
//        [self.detailsBtn setBackgroundImage:[UIImage imageNamed:@"details2"] forState:UIControlStateNormal];

        [self.detailsBtn setBackgroundImage:[UIImage imageNamed:@"paintingAlbum_returnToStory"] forState:UIControlStateNormal];
        
        //显示具体画作的时候
        self.pickerView2.alpha = 0;
        self.pickerView.alpha = 1;
        
        
        NSString *fileName = nil;
        
        for (NSString *temp in self.currentSelectedAtlas) {
            fileName = temp;
            break;
        }
        
        //第一次运行的时候temp == nil currentSelectedAtlas啥也没有吗?
//        NSLog(@"detailsBtnClick : self.currentSelectedAtlas:%@ count =%ld",self.currentSelectedAtlas,self.currentSelectedAtlas.count);
        
        
//        NSLog(@"detailsBtnClick :fileName = %@",fileName);
        
        
        fileName = [self matchingOfStringReturnEnglishName:fileName];
        
        NSLog(@"之后的fileName %@",fileName);
        
//        if (self.allSelectedRowDict.count != 0) {
//
//            NSLog(@"allSelectedRowDict不是空的");
//
//            for (NSString *temp in self.allSelectedRowDict) {
//
//                NSLog(@"temp = %@",temp);
//
//                if ([fileName isEqualToString:temp]) {
//
//                    self.selectedConcreateRow = [(NSString *)[self.allSelectedRowDict objectForKey:temp] integerValue];
//                    NSLog(@"拿到了字典中的值 selectedConcreateRow:%ld",self.selectedConcreateRow);
//
//                    break;
//                }
//            }
//
//        }
        
        
        //主动选中行数
        [self.pickerView selectRow:self.selectedConcreateRow inComponent:0 animated:YES];
        
        NSLog(@"主动选中行数 %ld",self.selectedConcreateRow);
        
        [self pickerView:self.pickerView didSelectRow:self.selectedConcreateRow inComponent:0];
        
        //设置个方法设置右边的图片和文字
        [self setRightPictureAndLabel:self.selectedConcreateRow];
        
//        [self.pickerView selectRow:0 inComponent:0 animated:YES];
//        [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
//        [self setRightPictureAndLabel:0];
        
        
        
//        [self.pickerView reloadInputViews];
        [self.pickerView reloadAllComponents];
        
        
        
    }else{
        
        //details 两个
        [self.detailsBtn setBackgroundImage:[UIImage imageNamed:@"paintingAlbum_intoDetails"] forState:UIControlStateNormal];
        
        //显示故事的时候 pickerView2 两个
        self.pickerView2.alpha = 1;
        self.pickerView.alpha = 0;
        
        //回到图集状态时 右边的图还是之前选中的图
        [self pickerView:self.pickerView2 didSelectRow:self.selectedAltasRow inComponent:0];
        [self.pickerView2 reloadAllComponents];
        
        //新增
        
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
        [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
//        [self setRightPictureAndLabel:0];
        
        //回到图集状态时 右边的图还是之前选中的图
        [self pickerView:self.pickerView2 didSelectRow:self.selectedAltasRow inComponent:0];
        [self.pickerView2 reloadAllComponents];
        
        
    }
    
    
    [self.view bringSubviewToFront:self.pickerView2];
    [self.view insertSubview:self.pickerView belowSubview:self.pickerView2];
    
    NSLog(@"detailsBtnClick 方法执行完毕");
    
}

#pragma 设置右边的图片和文字
- (void)setRightPictureAndLabel:(NSInteger)row{
    
    NSString *fileName = nil;
    for (NSString *temp in self.currentSelectedAtlas) {
        fileName = temp;
        break;
    }
    
    //去掉.png
//    fileName = [self matchingOfStringReturnEnglishName:fileName];
    
    //右边的图
//    UIImage *image = [UIImage imageWithContentsOfFile:[self.currentSelectedAtlas objectForKey:[NSString stringWithFormat:@"%@_%ld.png",fileName,(row+1)]]];
    
    UIImage *image;
    
    if (self.currentSelectedAtlas == nil) {
        if (self.pathAndImageDict.count != 0) {
            NSInteger i = row + 1;
                
            for (NSString *str in self.pathAndImageDict) {
                
                if ([str rangeOfString:[NSString stringWithFormat:@"%ld",i]].location != NSNotFound) {
                    
                    image = [self.pathAndImageDict objectForKey:str];
                    self.currentRow = row;
        
                    break;
                    
                }
            }
        }else{
            
        }

        self.currentImage = image;
        //设置显示在右边的图片
        self.storyView.image = image;
    }else{
        
        [self dataFromDictToArray:self.currentSelectedAtlas array:self.oneStoryPictures];
        
        self.currentImage = self.oneStoryPictures[row];
        //设置显示在右边的图片
        self.storyView.image = self.oneStoryPictures[row];
        
    }

    NSLog(@"currentSelectedAtlas:%@ oneStoryPictures:%@",self.currentSelectedAtlas,self.oneStoryPictures);
    
    
    //设置上方显示的文字
    if (self.dictArray.count != 0) {
        
        self.storyDescribition.text = [NSString stringWithFormat:@"%@_%ld",[self matchingString:fileName],(row+1)];
        
    }else{
        self.storyDescribition.text = @"还没有开始画画";
    }
    
}

//选择一行就会调用这个方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (pickerView.tag == 1) {
        
//多少组
//        [self numberOfComponentsInPickerView:pickerView];
//        //多少行
//        [self pickerView:pickerView numberOfRowsInComponent:0];
//        //重新加载左边的视图
//        [self pickerView:pickerView viewForRow:row forComponent:component reusingView:nil];
        
        NSString *fileName = @"";
        
        NSInteger i = 0;
        
        for (NSString *temp in self.currentSelectedAtlas) {
            
            fileName = temp;
            
            if (i == row) {
                break;
            }
            
            i++;
            
        }
        
//        NSLog(@"didSelectRow :fileName = %@",fileName);
        
        //去掉.png
//        fileName = [self matchingOfStringReturnEnglishName:fileName];
        
        NSLog(@"fileName = %@",fileName);//fileName == matchGirl
        
//        NSLog(@"之后的fileName :fileName = %@",fileName);
        
        
//        if (self.allSelectedRowDict.count != 0) {
//
//            BOOL flag = NO;
//
//            for (NSString *fileName2 in self.allSelectedRowDict) {
//
//                if ([fileName2 isEqualToString:fileName]) {
//
//                    [self.allSelectedRowDict removeObjectForKey:fileName2];
//
//                    [self.allSelectedRowDict setObject:[NSString stringWithFormat:@"%ld",row] forKey:fileName2];
//
//
//                    flag = NO;
//
//                    break;
//
//                }else{
//
//                    flag = YES;
//
//                }
//            }
//
//            if (flag) {
//
//                [self.allSelectedRowDict setObject:[NSString stringWithFormat:@"%ld",row] forKey:fileName];
//            }
//
//        }else{
            
//            [self.allSelectedRowDict setObject:[NSString stringWithFormat:@"%ld",row] forKey:fileName];
            
//        }
        
        //右边的图
//        UIImage *image = [UIImage imageWithContentsOfFile:[self.currentSelectedAtlas objectForKey:[NSString stringWithFormat:@"%@_%ld.png",fileName,(row+1)]]];
        
        
        
//------
        
//        UIImage *image = [UIImage imageWithContentsOfFile:[self.currentSelectedAtlas objectForKey:fileName]];
        
        UIImage *image;
           
       if (self.pathAndImageDict.count != 0) {
           NSInteger i = row + 1;
               
           for (NSString *str in self.pathAndImageDict) {
               
               if ([str rangeOfString:[NSString stringWithFormat:@"%ld",i]].location != NSNotFound) {
                   
                   image = [self.pathAndImageDict objectForKey:str];
                   self.currentRow = row;
       
                   break;
                   
               }
           }
       }else{
           
       }
        
        self.currentImage = image;
        
        self.selectedConcreateRow = row;
        
        NSLog(@"didSelectRow selectedConcreateRow= %ld",row);
        
        //给帧动画数据清空
        self.storyView.animationImages = nil;
        
        //显示模式:
        self.storyView.contentMode = UIViewContentModeScaleToFill;
        
        
        //设置显示在右边的图片
        self.storyView.image = image;
        
        
        
        
        //设置上方显示的文字
        if (self.dictArray.count != 0) {
            
            //            self.storyDescribition.text = [self matchingString:fileName];
            self.storyDescribition.text = [NSString stringWithFormat:@"%@_%ld",[self matchingString:fileName],(row+1)];
            
        }else{
            self.storyDescribition.text = @"还没有开始画画";
        }
        
        [self setRightPictureAndLabel:row];
        
        
        
    }else if (pickerView.tag == 2){
        
        //首次不是free的文件夹 不显示 点击之后退出详情才显示出来
        //        [pickerView reloadAllComponents];
        
        if (self.dictArray.count != 0) {
            
//            NSLog(@"self.dictArray.count != 0");
            
            self.currentSelectedAtlas = self.dictArray[row];
            
            NSString *text = [self returnStoryName:row];
            
            self.storyDescribition.text = text;
            
        }else{
            self.storyDescribition.text = @"自由画集";
        }
        
        self.selectedAltasRow = row;
        
        //设置显示在右边的图片
        self.storyView.image = [UIImage imageNamed:[NSString stringWithFormat:@"logoOfStory%ld",row+1]];
        
        NSMutableArray *gifArray = [NSMutableArray array];

        if (row % 2 == 0) {
            for (NSInteger i = 1; i < 38; i++) {
                [gifArray addObject:[UIImage OriginalImageWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"gif_%ld",i]]]];
                
                //设置动画的播放次数
                //1s30帧
                self.storyView.animationDuration = 2.468;
//                self.storyView.contentMode = UIViewContentModeCenter;//默认是0
            }
        }else{
            for (NSInteger i = 1; i < 48; i++) {
                [gifArray addObject:[UIImage OriginalImageWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"gif_1_%ld",i]]]];
                //设置动画的播放次数
                //1s30帧
                self.storyView.animationDuration = 3.133;

            }
        }

        //居中显示
        self.storyView.contentMode = UIViewContentModeCenter;//
        NSLog(@"contentMode %ld",self.storyView.contentMode);//4
        
        //帧动画 数据数组
        self.storyView.animationImages = gifArray;
        
        //设置动画的播放次数
        self.storyView.animationRepeatCount = 0;
        
        [self.storyView startAnimating];
        
    }
    
    
    NSLog(@"didSelectRow inComponent 方法执行完毕");
    
    
}

//设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return Height * 0.200521;//154
}

#pragma 滚动到哪行返回对应的故事名称
- (NSString *)returnStoryName:(NSInteger)row{
    
    NSMutableDictionary *dict = self.dictArray[row];
    NSString *fileName2 = @"";
    for (NSString *fileName in dict) {
        fileName2 = fileName;
        break;
    }
    
    fileName2 = [fileName2 stringByReplacingOccurrencesOfString:@".png" withString:@""];
    
    fileName2 = [self matchingString:fileName2];
    
    return fileName2;
}

#pragma 匹配字符串
- (NSString *)matchingString:(NSString *)str{
    
    NSString *matchingStr = @"";
    
    if ([str rangeOfString:@"free"].location != NSNotFound) {
        matchingStr = @"自由画集";
    }else if ([str rangeOfString:@"Crazy_little_original_hunter"].location != NSNotFound){
        matchingStr = @"疯狂原始小猎人画集";
    }else if ([str rangeOfString:@"matchGirl"].location != NSNotFound){
        matchingStr = @"卖火柴的小女孩";
    }else if ([str rangeOfString:@"girlOfSea"].location != NSNotFound){
        matchingStr = @"海的女儿";
    }else if ([str rangeOfString:@"threeBoys"].location != NSNotFound){
        matchingStr = @"三个和尚的故事";
    }else if ([str rangeOfString:@"bamboo"].location != NSNotFound){
        matchingStr = @"竹里馆";
    }
    
    return matchingStr;
}

#pragma 匹配字符串返回故事英文名称
- (NSString *)matchingOfStringReturnEnglishName:(NSString *)str{
    
    NSString *matchingStr = @"";
    
    if (str == nil) {
        return @"";
    }
    if ([str rangeOfString:@"free"].location != NSNotFound) {
        matchingStr = @"free";
    }else if ([str rangeOfString:@"Crazy_little_original_hunter"].location != NSNotFound){
        matchingStr = @"Crazy_little_original_hunter";
    }else if ([str rangeOfString:@"matchGirl"].location != NSNotFound){
        matchingStr = @"matchGirl";
    }else if ([str rangeOfString:@"girlOfSea"].location != NSNotFound){
        matchingStr = @"girlOfSea";
    }
    
    return matchingStr;
    
}

#pragma 懒加载
- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_imageV];
    }
    
    return _imageV;
}

- (UIImageView *)imageV2{
    if (!_imageV2) {
        _imageV2 = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_imageV2];
    }
    
    return _imageV2;
}

- (UIView *)coverView{
    if (_coverView == nil) {
        //        _coverView = [[XZQCoverView alloc] init];
        _coverView = [XZQSnowCoverView snowCoverView];
    }
    
    return _coverView;
}

#pragma 隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.isViewWillAppear = true;
    
    [self.pickerView reloadAllComponents];
    [self.pickerView2 reloadAllComponents];
    
    //界面要显示
    [self pickerView:self.pickerView2 didSelectRow:self.selectedAltasRow inComponent:0];
    
    //显示作品动画按钮
    [self showAnimateOfSelfDefinePicture];
    
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.tabBarController.selectedIndex = 6;
//    
//}


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


#pragma 给sortArray传递图片的名称 不会重复
- (void)addImageNameToSortArray:(NSString *)imageName{
    
    NSInteger count = self.sortArray.count;
    
    if (count != 0) {
        
        NSString *str = @"";
        for (NSInteger i = 0; i < count; i++) {
            
            str = self.sortArray[i];
            
            if ([str isEqualToString:imageName]) {
                continue;
            }else{
                [self.sortArray addObject:imageName];
            }
        }
        
    }else{
        
        [self.sortArray addObject:imageName];
    }
    
    NSLog(@"addImageToSortArray - sortArray = %@",self.sortArray);
    
}

#pragma 自定义动画
- (void)selfDefineAnimated{
    NSLog(@"%s",__func__);
    
    self.isViewWillAppear = false;
    
    NSLog(@"%s : currentSelectedAtlas:%@",__func__,self.currentSelectedAtlas);
    
    [self dataFromDictToArray:self.currentSelectedAtlas array:self.oneStoryPictures];
    
    //将跑马灯动画展示出来
    [self showAnimateOfSelfDefinePicture];
    
    //播放音乐
    [self.musicPlayer play];
}

#pragma 将字典中的所有数据赋值给数组
- (void)dataFromDictToArray:(NSDictionary *)dict array:(NSMutableArray *)arr{
    if (arr.count != 0) {
        [arr removeAllObjects];
    }
    
    //得让数组中装图片 按顺序装
    
    //建立一个临时数组 装路径 然后取出装图片
    NSInteger count = self.currentSelectedAtlas.count;
    NSString *imagePath = @"";
    UIImage *image;
    for (NSInteger i = 0; i < count; i++) {
        
        for (NSString *tempStr in self.currentSelectedAtlas) {
            
            if ([tempStr rangeOfString:[NSString stringWithFormat:@"%ld",i+1]].location != NSNotFound) {
                
                imagePath = [self.currentSelectedAtlas objectForKey:tempStr];
                image = [UIImage imageWithContentsOfFile:imagePath];
                [arr addObject:image];
                break;
            }
        }
    }
    
    NSLog(@"%s -- self.oneStroyPictures = %@",__func__,arr);
}

#pragma 展示作品动画
- (void)showAnimateOfSelfDefinePicture{
    
    //现在可以展示动画了
    if (self.isViewWillAppear == false) {
        
        //弹出弹框
        [self popShowSelfDefinePicture];
        
        //弹框中有图片
        [self testCarrouselView];
        
        //将按钮和滑块置于最前方
        [self makeButtonAndSliderInTheFront];
        
    }else{
        //不展示动画 将其移动到上方
        self.animateBtn.alpha = 1;
    }
}

#pragma 展示作品动画方法用到的方法1
- (void)testCarrouselView
{
    //没有图片可以提供占位图片
    
//    NSMutableArray *array = [NSMutableArray array];
//    for (NSInteger i = 0; i < 8; i ++)
//    {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"mm%ld.jpeg", (long)i]];
//        [array addObject:image];
//    }
    
//    if进行判断有没有图片 没有放占位图片
    
//    LYCarrouselView *carr = [[LYCarrouselView alloc] initWithFrame:CGRectMake(self.customView.bounds.size.width*0.13, self.customView.bounds.size.height*0.13, self.customView.bounds.size.width*0.74, self.customView.bounds.size.height*0.74) images:self.oneStoryPictures callback:^(NSInteger index, NSInteger event) {
//
//        NSLog(@"%ld %@", index, event == 1 ? @"点击" : @"长按");
//    }];
//
//
//
//    carr.clipsToBounds = YES;
//    carr.layer.cornerRadius = 20;
//
//    //以这张图片的宽高设定
//    [carr addImage:[UIImage imageNamed:@"mm8.jpeg"]];
//    carr.backgroundColor = [UIColor blackColor];
//    carr.animationSpeed = 2;
//    carr.showReflectLayer = YES;
    
//    [self makeButtonAndSliderInTheFront];
    
    [self.customView addSubview:self.carrB];
    
    
}

#pragma 展示作品动画方法用到的方法2
- (NSDictionary *)sliderBackGraidentInfo
{
    return @{@"locations" : @[@(0),
                              @(60 / 360.),
                              @(120 / 360.),
                              @(180 / 360.),
                              @(240 / 360.),
                              @(300 / 360.),
                              @(1)],
             @"colors" : @[[UIColor redColor],
                           [UIColor yellowColor],
                           [UIColor greenColor],
                           [UIColor cyanColor],
                           [UIColor blueColor],
                           [UIColor magentaColor],
                           [UIColor redColor]]};
}

#pragma 弹出展示作品动画的弹框
- (void)popShowSelfDefinePicture{
    
    ZJAnimationPopStyle popStyle =  ZJAnimationPopStyleShakeFromTop;
    ZJAnimationDismissStyle dismissStyle = ZJAnimationDismissStyleDropToTop;
    
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
    
    __weak typeof(XZQAlbumViewController *)weakSelf = self;
    
    // 2.6 显示完成回调
    popView.popComplete = ^{
        NSLog(@"显示完成");
        [weakSelf.musicPlayer play];
    };
    // 2.7 移除完成回调
    popView.dismissComplete = ^{
        NSLog(@"移除完成");
        [weakSelf.musicPlayer pause];
    };
    
    // 4.显示弹框
    [popView pop];
    
}

#pragma 将按钮和滑块置于最前方
- (void)makeButtonAndSliderInTheFront{
   
    __weak typeof(XZQAlbumViewController *)weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
       
        [weakSelf.start setFrame:CGRectMake((self.view.bounds.size.width *0.5)-200,self.view.bounds.size.height - 150, 100, 48)];
        [weakSelf.stop setFrame:CGRectMake((self.view.bounds.size.width *0.5)+100,self.view.bounds.size.height - 150, 100, 48)];
       
        weakSelf.slopex.center = CGPointMake(950, 350);
        
        weakSelf.remindImageView.frame = CGRectMake(self.view.bounds.size.width*0.5-140, 70, 300, 100);
        
    }];
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.start];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.stop];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.slopex];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.remindImageView];
    
    
    
}

#pragma 动画方式隐藏按钮和滑块
- (void)hiddenBtnAndSlider{
    
    
    __weak typeof(XZQAlbumViewController *)weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
       
        [weakSelf.start setFrame:CGRectMake((self.view.bounds.size.width *0.5)-200,self.view.bounds.size.height + 150, 100, 48)];
        [weakSelf.stop setFrame:CGRectMake((self.view.bounds.size.width *0.5)+100,self.view.bounds.size.height + 150, 100, 48)];
       
        weakSelf.slopex.center = CGPointMake(self.view.bounds.size.width + 300, 350);
        
        weakSelf.remindImageView.frame = CGRectMake(self.view.bounds.size.width*0.5-150, -100, 300, 100);
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    //原本在画册中第二次点击跑马灯中的元素的时候 就会有问题 这样写 就可以解决问题了
    self.carrB = nil;
    self.customView = nil;
    
}

#pragma 创建一个给系统图片显示的弹框
- (void)popSystemPicture{
    
    ZJAnimationPopStyle popStyle =  ZJAnimationPopStyleShakeFromTop;
    ZJAnimationDismissStyle dismissStyle = ZJAnimationDismissStyleDropToBottom;
    
    ZJAnimationPopView *popView = [[ZJAnimationPopView alloc] initWithCustomView:self.customView2 popStyle:popStyle dismissStyle:dismissStyle];
    self.ZJAPopView2 = popView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.customView2.bounds.size.width, self.customView2.bounds.size.height)];
    [self.customView2 addSubview:imageView];
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = 20;
    self.systemImageView = imageView;
    
    // 2.设置属性，可不设置使用默认值，见注解
    
    // 2.2 显示时背景的透明度
    popView.popBGAlpha = 0.5f;
    // 2.3 显示时是否监听屏幕旋转
    popView.isObserverOrientationChange = YES;
    
    __weak typeof(XZQAlbumViewController *)weakSelf = self;
    
    // 2.6 显示完成回调
    popView.popComplete = ^{
        NSLog(@"显示完成");
        [weakSelf.musicPlayer play];
    };
    // 2.7 移除完成回调
    
    

    popView.dismissComplete = ^{
        NSLog(@"移除完成");
        
        [weakSelf.musicPlayer pause];
    };
    

}


#pragma 监听播放完毕
- (void)playFinishedBeingCalled{
    
    NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:@"Deep East Music - Sunny Jim" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:musicFilePath];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    [self.musicPlayer replaceCurrentItemWithPlayerItem:playerItem];
    
    self.systemImageView == nil ? [self.musicPlayer pause] : [self.musicPlayer play];

    
}
@end
