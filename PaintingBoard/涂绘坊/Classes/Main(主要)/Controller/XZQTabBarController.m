//
//  XZQTabBarController.m
//  涂绘坊
//
//  Created by dmt312 on 2019/5/11.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQTabBarController.h"
#import "XZQAlbumViewController.h"
#import "XZQStoryViewController.h"
#import "XZQPacksackViewController.h"
#import "XZQSceneViewController.h"
#import "XZQHomePageViewController.h"
#import "XZQDrawingBoardViewController.h"
#import "XZQPopViewController.h"
#import "MainFuncViewController.h"



@interface XZQTabBarController ()<XZQPopViewControllerDelegate>

/**<#备注#> */
@property(nonatomic,strong) XZQPopViewController *popVC;

/**文件管理者 */
@property(nonatomic,readwrite,strong) NSFileManager *manager;

/**PHouse文件夹 */
@property(nonatomic,readwrite,strong) NSString *phousePath;

/**视频文件夹路径 */
@property(nonatomic,readwrite,strong) NSString *videoFolderPath;

/**图片文件夹路径 */
@property(nonatomic,readwrite,strong) NSString *pictureFolderPath;

/**音频文件夹路径 */
@property(nonatomic,readwrite,strong) NSString *soundFolderPath;


@end

@implementation XZQTabBarController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UIImage *image = [UIImage imageNamed:@"backGround_paintBoard"];

    //没有解决的问题 - 就是点击popView中的按钮 发送对应的通知 然后这个控制器是截获通知 切换控制器 一直在发送通知的时候报错 - 换用代理了
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchChildViewController:) name:@"toDrawingBoard" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchChildViewController:) name:@"toPhotoAlbum" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchChildViewController:) name:@"toStory" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchChildViewController:) name:@"toBackSack" object:nil];
    
    
    /**
     手动导入视频
     
     //到时候得删除了 - 现在视频播放:不从相册中找了 从文件中找 方便
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
     
     NSLog(@"-----------------------------------------");
     //关于文件的操作 - 使用到文件管理者 NSFileManager
     self.manager = [NSFileManager defaultManager];
     
     //指定一个需要创建的文件夹的路径
     
     //先获得Caches文件目录/路径
     NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
     
     //PaintingHouse
     NSString *name = @"PHouse";
     
     //文件夹全路径
     NSString *folder = [caches stringByAppendingPathComponent:name];
     
     
     self.phousePath = folder;
     
     //视频文件夹
     NSString *videoName = @"video";
     
     //图片文件夹
     NSString *pictureName = @"picture";
     
     //音频文件夹
     NSString *soundName = @"sound";
     
     //视频文件夹路径
     NSString *videoFolder = [folder stringByAppendingPathComponent:videoName];
     self.videoFolderPath = videoFolder;
     self.videoFolder = videoFolder;
     
     //视频文件1
     NSString *video1 = @"haizei_1.mp4";
     
     //1路径
     NSString *video11 = [videoFolder stringByAppendingPathComponent:video1];
     
     //视频文件2
     NSString *video2 = @"yaowei_1.mp4";
     
     //2路径
     NSString *video22 = [videoFolder stringByAppendingPathComponent:video2];
     
     //视频文件3
     NSString *video3 = @"video_1.mp4";
     
     //3路径
     NSString *video33 = [videoFolder stringByAppendingPathComponent:video3];
     
     //图片文件夹路径
     NSString *pictureFolder = [folder stringByAppendingPathComponent:pictureName];
     self.pictureFolderPath = pictureFolder;
     
     //音频文件夹路径
     NSString *soundFolder = [folder stringByAppendingPathComponent:soundName];
     self.videoFolderPath = soundFolder;
     
     
     //创建文件夹 - 保存全部app的资源
     [self.manager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
     [self.manager createDirectoryAtPath:videoFolder withIntermediateDirectories:YES attributes:nil error:nil];
     [self.manager createDirectoryAtPath:pictureFolder withIntermediateDirectories:YES attributes:nil error:nil];
     [self.manager createDirectoryAtPath:soundFolder withIntermediateDirectories:YES attributes:nil error:nil];
     
     
     
     //将桌面的视频文件复制到视频文件夹中
     
     //源文件路径
     [self.manager copyItemAtPath:@"/Users/dmt312/Desktop/haizei_1.mp4" toPath:video11 error:nil];
     [self.manager copyItemAtPath:@"/Users/dmt312/Desktop/yaowei_1.mp4" toPath:video22 error:nil];
     [self.manager copyItemAtPath:@"/Users/dmt312/Desktop/video_1.mp4" toPath:video33 error:nil];
     
     
     
     [self.videoPathDict setObject:video11 forKey:@"haizei_1.mp4"];
     [self.videoPathDict setObject:video22 forKey:@"yaowei_1.mp4"];
     [self.videoPathDict setObject:video33 forKey:@"video_1.mp4"];
     
     NSLog(@"heizei_1-------------");
     
     });
     
     //将之前手动导入的文件删除掉
     [self.manager removeItemAtPath:self.phousePath error:nil];
     
     if (![self.manager isExecutableFileAtPath:self.phousePath]) {
     NSLog(@"删除成功！");
     }

     
     */
    
    
    
    //通过点击主页中的按钮切换页面
    self.popVC = [XZQPopViewController shareXZQPopViewController];
    self.popVC.delegate = self;
    
    //0
    XZQDrawingBoardViewController *drawing = [[XZQDrawingBoardViewController alloc] init];
    drawing.title = @"画板";
    [self addChildViewController:drawing];
    
    //1
    XZQAlbumViewController *album = [[XZQAlbumViewController alloc] init];
    album.title = @"画册";
    [self addChildViewController:album];
    
    //2
    XZQStoryViewController *story = [[XZQStoryViewController alloc] init];
    story.title = @"故事";
    [self addChildViewController:story];
    
    //3
    XZQPacksackViewController *packSack = [[XZQPacksackViewController alloc] init];
    packSack.title = @"背包";
    [self addChildViewController:packSack];
    
    
    //4
    XZQSceneViewController *scene = [[XZQSceneViewController alloc] init];
    scene.title = @"场景";
    [self addChildViewController:scene];
    
    //5
    XZQHomePageViewController *home = [[XZQHomePageViewController alloc] init];
    home.title = @"主页";
    [self addChildViewController:home];
    
    //6
    //主功能区
    MainFuncViewController *func = [[MainFuncViewController alloc] init];
    func.title = @"主功能区";
    [self addChildViewController:func];
    
    [self.tabBar setHidden:YES];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //需要加载出来给情节界面传递 caf路径 否则 有 录音文件地址无效问题
        self.selectedIndex = 0;
        
        self.selectedIndex = 5;
        
        self.selectedIndex = 6;
        
        //写视频
        [self writeVideoToSettledPath];
    });
    
    
    
}

#pragma 将视频写入对应文件夹
- (void)writeVideoToSettledPath{
    
}

- (void)switchChildViewController:(NSString *)str{
    
    NSInteger i = [str integerValue];
    
    self.tabBarController.selectedIndex = i;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)switchChildViewController:(XZQPopViewController *)popVC btn:(UIButton *)btn{


    self.selectedIndex = btn.tag;

}




@end
