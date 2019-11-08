//
//  XZQPopViewController.m
//  涂绘坊
//
//  Created by dmt312 on 2019/5/12.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQPopViewController.h"
#import "XZQHomePageViewController.h"

@interface XZQPopViewController ()
/**<#备注#> */
@property(nonatomic,strong) UIImageView *backGroundImageV;
/**<#备注#> */
@property(nonatomic,strong) UIImageView *accountFrame;
/**<#备注#> */
@property(nonatomic,strong) UILabel *accountName;
/**<#备注#> */
@property(nonatomic,strong) UILabel *accountLevel;
/**头像按钮 点击跳转 */
@property(nonatomic,strong) UIButton *accountImage;
/** 主页按钮*/
@property(nonatomic,readwrite,weak) XZQHomePageViewController *homePageVC;

@end

#define Width self.view.frame.size.width
#define Height self.view.frame.size.height

@implementation XZQPopViewController

#pragma mark -----------------------------
#pragma mark lazyload

- (void)setName:(NSString *)name{
    _name = name;
    
    self.accountName.text = name;
}

- (void)setAge:(NSString *)age{
    
    
    _age = age;
    
    if (![age containsString:@"岁"]) {
        
        self.accountLevel.text = [age stringByAppendingString:@"岁"];
        
    }else{
        self.accountLevel.text = age;
    }
    
    
}

- (void)setAccountImage2:(UIImage *)accountImage2{
    _accountImage2 = accountImage2;
    
    [self.accountImage setBackgroundImage:accountImage2 forState:UIControlStateNormal];
}

- (UILabel *)accountName {
    if (_accountName == nil) {
        _accountName = [[UILabel alloc] init];
    }
    
    return _accountName;
}

- (UILabel *)accountLevel{
    if (_accountLevel == nil) {
        _accountLevel = [[UILabel alloc] init];
    }
    return _accountLevel;
}

- (UIButton *)accountImage{
    if (_accountImage == nil) {
        _accountImage = [[UIButton alloc] init];
        [self.view addSubview:_accountImage];
    }
    return _accountImage;
}


- (UIImageView *)backGroundImageV{
    if (_backGroundImageV == nil) {
        _backGroundImageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_backGroundImageV];
        
    }
    
    return _backGroundImageV;
}

- (UIImageView *)accountFrame{
    if (_accountFrame == nil) {
        _accountFrame = [[UIImageView alloc] init];
        [self.view addSubview:_accountFrame];
    }
    
    return _accountFrame;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveBackWithNotification) name:@"removeCoverViewAndMoveBackPopView" object:nil];

}

//读取用户信息
- (void)readAccountMessage{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *imageData = [defaults objectForKey:@"accountImage"];
    NSString *accountName = [defaults objectForKey:@"accountName"];
    NSString *accountAge = [defaults objectForKey:@"accountAge"];
    
    
    if (accountName != nil) {
        self.name = accountName;
    }
    
    if (accountAge != nil) {
        self.age = accountAge;
    }
    
    if (imageData != nil) {

        UIImage *accountImage = [UIImage imageWithData:imageData];

        UIImage *image2 = [self resizeUIImage:accountImage toWidth:230 toHeight:221];

        //将图片设置为圆形的
        //1.开启跟原始图片一样大小的上下文
        UIGraphicsBeginImageContextWithOptions(image2.size, NO, 0);
        //2.设置一个圆形裁剪区域

        //2.1绘制一个圆形
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 230, 221)];

        //2.2.把圆形的路径设置成裁剪区域
        [path addClip];//超过裁剪区域以外的内容都给裁剪掉

        //3.把图片绘制到上下文当中(超过裁剪区域以外的内容都给裁剪掉)
        [image2 drawAtPoint:CGPointZero];

        //4.从上下文当中取出图片
        UIImage *newImage =  UIGraphicsGetImageFromCurrentImageContext();

        //5.关闭上下文
        UIGraphicsEndImageContext();
        
        self.accountImage2 = newImage;
        
        [self.view bringSubviewToFront:self.accountImage];
        

    }else{
        
        NSLog(@"imageData == nil");
        
        
    }
        
    
    
    
//    if (accountName != nil) {
//        self.accountName.text = accountName;
//    }
//
//    if (accountAge != nil) {
//        self.accountLevel.text = accountAge;
//    }
    
}

//缩小图片并裁减成圆形
- (UIImage *)resizeUIImage:(UIImage *)image toWidth:(CGFloat)width toHeight:(CGFloat)height{
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0.0f, 0.0f, width, height)];
    
    UIImage *newImage = [[UIImage alloc] init];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //裁减成圆形
    
    
    
    return newImage;
}

- (UIImage *)roundPicture:(UIImage *)image{
    
    //将图片设置为圆形的
    //1.开启跟原始图片一样大小的上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //2.设置一个圆形裁剪区域
    //2.1绘制一个圆形
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, Width *0.09997, Width *0.09997)];
    //2.2.把圆形的路径设置成裁剪区域
    [path addClip];//超过裁剪区域以外的内容都给裁剪掉
    //3.把图片绘制到上下文当中(超过裁剪区域以外的内容都给裁剪掉)
    [image drawAtPoint:CGPointZero];
    //4.从上下文当中取出图片
    UIImage *newImage =  UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
    
    
}


- (void)setImage:(UIImage *)image{
    _image = image;
    self.backGroundImageV.image = image;
}

- (void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"viewWillAppear");
    
    //导航栏
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //画板
        CGFloat navigation_paintBoardX = self.view.bounds.size.width * 0.1174;
        CGFloat navigation_paintBoardY = self.view.bounds.size.height * 0.2380;
        CGFloat navigation_paintBoardW = self.view.bounds.size.width * 0.7324;
        CGFloat navigation_paintBoardH = self.view.bounds.size.height * 0.1365;
        
        UIButton *navigation_paintBoard = [[UIButton alloc] initWithFrame:CGRectMake(navigation_paintBoardX, navigation_paintBoardY, navigation_paintBoardW, navigation_paintBoardH)];
        navigation_paintBoard.tag = 0;
        [navigation_paintBoard setBackgroundImage:[UIImage imageNamed:@"navigation_paintBoard"] forState:UIControlStateNormal];
        [navigation_paintBoard addTarget:self action:@selector(moveBack:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //画册
        CGFloat navigation_albumY = self.view.bounds.size.height * 0.4077;
        UIButton *navigation_album = [[UIButton alloc] initWithFrame:CGRectMake(navigation_paintBoardX, navigation_albumY, navigation_paintBoardW, navigation_paintBoardH)];
        navigation_album.tag = 1;
        
        [navigation_album setBackgroundImage:[UIImage imageNamed:@"navigation_album"] forState:UIControlStateNormal];
        [navigation_album addTarget:self action:@selector(moveBack:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //故事
        CGFloat navigation_storyY = self.view.bounds.size.height * 0.5775;
        UIButton *navigation_story = [[UIButton alloc] initWithFrame:CGRectMake(navigation_paintBoardX, navigation_storyY, navigation_paintBoardW, navigation_paintBoardH)];
        navigation_story.tag = 2;
        [navigation_story setBackgroundImage:[UIImage imageNamed:@"navigation_story"] forState:UIControlStateNormal];
        [navigation_story addTarget:self action:@selector(moveBack:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //背包
        CGFloat navigation_packsackY = self.view.bounds.size.height * 0.7435;
        UIButton *navigation_packsack = [[UIButton alloc] initWithFrame:CGRectMake(navigation_paintBoardX, navigation_packsackY, navigation_paintBoardW, navigation_paintBoardH)];
        navigation_packsack.tag = 3;
        [navigation_packsack setBackgroundImage:[UIImage imageNamed:@"navigation_packsack"] forState:UIControlStateNormal];
        [navigation_packsack addTarget:self action:@selector(moveBack:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:navigation_paintBoard];
        [self.view addSubview:navigation_album];
        [self.view addSubview:navigation_story];
        [self.view addSubview:navigation_packsack];
        
        //用户头像框
        CGFloat accountFrameX = self.view.bounds.size.width * 0.0328;
        CGFloat accountFrameY = self.view.bounds.size.height * 0.0756;
        CGFloat accountFrameW = self.view.bounds.size.width * 0.8967;
        CGFloat accountFrameH = self.view.bounds.size.height * 0.0867;
        
        self.accountFrame.frame = CGRectMake(accountFrameX, accountFrameY, accountFrameW, accountFrameH);
        self.accountFrame.image = [UIImage imageNamed:@"navigation_accountFrame"];
        
        //用户头像
        CGFloat accountImageX = self.view.bounds.size.width * 0.69;
        CGFloat accountImageY = self.view.bounds.size.height * 0.0720;
        CGFloat accountImageW = self.view.bounds.size.width * 0.24;
        CGFloat accountImageH = self.view.bounds.size.width * 0.24;
        
        self.accountImage.frame = CGRectMake(accountImageX, accountImageY, accountImageW, accountImageH);
        //        self.accountImage.backgroundColor = [UIColor redColor];
        self.accountImage.tag = 5;
        //    self.accountImage.image = [UIImage imageNamed:@"navigation_accountImage"];
        
        [self.accountImage setBackgroundImage:[UIImage imageNamed:@"navigation_accountImage"] forState:UIControlStateNormal];
        [self.accountImage addTarget:self action:@selector(jumpToHomePageVC) forControlEvents:UIControlEventTouchUpInside];
        
        //等级label
        CGFloat accountLevelX = self.view.bounds.size.width * 0.2038;
        CGFloat accountLevelY = self.view.bounds.size.height * 0.1068;
        CGFloat accountLevelW = self.view.bounds.size.height * 0.1764;
        CGFloat accountLevelH = self.view.bounds.size.height * 0.0210;
        
        self.accountLevel.frame = CGRectMake(accountLevelX, accountLevelY, accountLevelW, accountLevelH);
        
        //可以设置字体和字体大小
        self.accountLevel.font = [UIFont systemFontOfSize:13];
        
        //字体颜色
        self.accountLevel.textColor = [UIColor colorWithRed:146/255.0 green:183/255.0 blue:165/255.0 alpha:1];
        
        self.accountLevel.text = @"8岁";
        
        self.accountLevel.textAlignment = NSTextAlignmentRight;
        
        [self.view addSubview:self.accountLevel];
        
        //名称
        CGFloat accountNameX = self.view.bounds.size.width * 0.2038;
        CGFloat accountNameY = self.view.bounds.size.height * 0.1322;
        CGFloat accountNameW = self.view.bounds.size.height * 0.1764;
        CGFloat accountNameH = self.view.bounds.size.height * 0.0210;
        
        
        
        self.accountName.frame = CGRectMake(accountNameX, accountNameY, accountNameW, accountNameH);
        self.accountName.font = [UIFont systemFontOfSize:16];
        
        self.accountName.textColor = [UIColor colorWithRed:115/255.0 green:156/255.0 blue:138/255.0 alpha:1];
        self.accountName.textAlignment = NSTextAlignmentRight;
        self.accountName.text = @"绘画小王子";
        
        
        
        
        self.accountName.adjustsFontSizeToFitWidth = YES;//字体大小和位置
        [self.view addSubview:self.accountName];
    });
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
    
//    });
    
    [self readAccountMessage];
    
}

- (void)moveBackWithNotification{
    CGFloat popVcW = self.view.frame.size.width;
    CGFloat popVcH = self.view.frame.size.height;
    CGFloat popVcX = self.view.frame.size.width * 4;
    CGFloat popVcY = 0;
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.view.frame = CGRectMake(popVcX, popVcY, popVcW, popVcH);
    }];
    
    self.view.tag = arc4random();
}

- (void)moveBack:(UIButton *)btn{
    
    [self moveBackWithNotification];
    
    if ([self.delegate respondsToSelector:@selector(switchChildViewController:btn:)]) {
        
        [self.delegate switchChildViewController:self btn:btn];
        
//        switch (btn.tag) {
//            case 0:
//                NSLog(@"画板");
//                //            [[NSNotificationCenter defaultCenter] postNotificationName:@"toDrawingBoard" object:@"0"];
//                [self.delegate switchChildViewController:self btn:btn];
//                break;
//            case 1:
//                NSLog(@"画板");
//                //            [self postNotification:@"toDrawingBoard" tag:@"0"];
//                break;
//
//            case 2:
//                NSLog(@"画板");
//                //            [self postNotification:@"toDrawingBoard" tag:@"0"];
//                break;
//            case 3:
//                NSLog(@"画板");
//                //            [self postNotification:@"toDrawingBoard" tag:@"0"];
//                break;
//
//            default:
//                break;
//        }
    }
    
    
}



//- (void)moveBack:(UIButton *)btn{
//    NSLog(@"moveBack");
//    CGFloat popVcW = self.view.frame.size.width;
//    CGFloat popVcH = self.view.frame.size.height;
//    CGFloat popVcX = self.view.frame.size.width * 4;
//    CGFloat popVcY = 0;
//
//    [UIView animateWithDuration:1.0 animations:^{
//
//        self.view.frame = CGRectMake(popVcX, popVcY, popVcW, popVcH);
//    }];
//
//    self.view.tag = arc4random();
//
//
//
//    switch (btn.tag) {
//        case 0:
//            //画板界面
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"toDrawingBoard" object:nil];
//            NSLog(@"画板界面");
//            break;
//        case 1:
//            //图册界面
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"toPhotoAlbum" object:@"1"];
//            NSLog(@"图册界面");
//            break;
//        case 2:
//            //故事界面
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"toStory" object:@"2"];
//            NSLog(@"故事界面");
//            break;
//        case 3:
//            //背包界面
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"toBackSack" object:@"3"];
//            NSLog(@"背包界面");
//            break;
//
//
//        default:
//            break;
//    }
//
//
//}

#pragma mark -----------------------------
#pragma mark 单例模式

static XZQPopViewController *_xzqPop;

+ (instancetype)shareXZQPopViewController{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _xzqPop = [super allocWithZone:zone];
    });
    
    return _xzqPop;
}

- (id)copyWithZone:(NSZone *)zone{
    return _xzqPop;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return _xzqPop;
}

- (void)jumpToHomePageVC{
    
    [self moveBack:self.accountImage];
}


@end
