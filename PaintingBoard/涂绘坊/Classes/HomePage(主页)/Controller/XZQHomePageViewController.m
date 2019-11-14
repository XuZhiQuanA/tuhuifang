//
//  XZQHomePageViewController.m
//  涂绘坊
//
//  Created by dmt312 on 2019/5/11.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQHomePageViewController.h"
#import "XZQCoverView.h"
#import "XZQSnowCoverView.h"
#import "XZQPopViewController.h"
#import "XZQDrawingBoardViewController.h"

#import "MainFuncViewController.h"

#import "UIImage+OriginalImage.h"

#import "SlideSelectCardView.h"
#import "ZJAnimationPopView.h"

#define KeyWindow [UIApplication sharedApplication].keyWindow
#define Width self.view.frame.size.width
#define Height self.view.frame.size.height

@interface XZQHomePageViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,XZQDrawingBoardViewDelegate,UITextFieldDelegate>
/**背景图 */
@property(nonatomic,readwrite,strong) UIImageView *backGroundImage;

/**头像按钮 */
@property(nonatomic,readwrite,strong) UIButton *headBtn;

/**叶子按钮 */
@property(nonatomic,readwrite,strong) UIButton *levels;

/**主页按钮 */
@property(nonatomic,strong) UIButton *mainBtn;

/**遮罩 */
@property(nonatomic,strong) XZQCoverView *coverView;

//弹出的控制器
@property(nonatomic,strong) XZQPopViewController *popVc;

/**名称textField */
@property(nonatomic,readwrite,strong) UITextField *nameTextField;

/**年龄textField */
@property(nonatomic,readwrite,strong) UITextField *ageTextField;

/**保存绘画的图片文件夹路径 */
@property(nonatomic,readwrite,strong) NSString *pictureFolderPath;

/**文件管理者 */
@property(nonatomic,strong) NSFileManager *manager;

/**保存作品的个数*/
@property(nonatomic,assign)  NSInteger count;

/**作品个数 */
@property(nonatomic,readwrite,strong) UILabel *countLabel;

/**自定义弹框内容 */
@property(nonatomic,readwrite,strong) SlideSelectCardView *customView;

//为系统图片提供弹框

/**自定义弹框 */
@property(nonatomic,readwrite,strong) ZJAnimationPopView *ZJAPopView;


@end

@implementation XZQHomePageViewController

/**
 缺点
 主页界面没有返回按钮
 版本更新按钮太小
 画板界面没有视频框播放视频
 相册界面没有图片
 其实左边和上边可以让他们移动到可见范围外 点击按钮再出来
 */

#pragma lazy initialization

- (SlideSelectCardView *)customView{
    if (_customView == nil) {
        _customView = [SlideSelectCardView xib22];
        
    }
    
    return _customView;
}

- (NSFileManager *)manager{
    if (!_manager) {
        _manager = [NSFileManager defaultManager];
    }
    
    return _manager;
}

- (UIImageView *)backGroundImage{
    if (!_backGroundImage) {
        _backGroundImage = [[UIImageView alloc] init];
        
        _backGroundImage.frame = self.view.bounds;
        [self.view addSubview:_backGroundImage];
    }
    
    return _backGroundImage;
}

- (UIButton *)headBtn{
    if (!_headBtn) {
        _headBtn = [[UIButton alloc] init];
        [self.view addSubview:_headBtn];
    }
    
    return _headBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
//    self.backGroundImage.image = [UIImage imageNamed:@"background_1"];
    
    self.backGroundImage.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"PrincipalSheet_backgroundFrame"]]; 
    
    [self layoutLabel];
    
    [self layoutBtn];
    
    //创建主界面按钮
    [self createMainBtn];
    
    //从用户偏好设置中读取信息
    [self readAccountMessage];
    
    //给主功能界面设置头像和名称昵称
    [self postAccountMessage];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    //从用户偏好设置中读取信息
    [self readAccountMessage];
    
    
}

#pragma 创建主界面按钮
- (void)createMainBtn{
    
    if (!self.mainBtn) {
        
        CGFloat mainBtnX = Width * 0.8496;
        CGFloat mainBtnY = Height * 0.1783;
        CGFloat mainBtnW = Width *0.05194;
        CGFloat mainBtnH = Width *0.05194;
        
        self.mainBtn = [[UIButton alloc] initWithFrame:CGRectMake(mainBtnX, mainBtnY, mainBtnW, mainBtnH)];
        [self.view addSubview:self.mainBtn];
        
        self.mainBtn.tag = 4;
        [self.mainBtn addTarget:self action:@selector(jumpToMainFuncIB) forControlEvents:UIControlEventTouchUpInside];
        
        
//        [self.mainBtn setBackgroundImage:[UIImage imageNamed:@"main"] forState:UIControlStateNormal];
        
        [self.mainBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"PrincipalSheet_jumpToMainFuncIB"]]  forState:UIControlStateNormal];
        
        //主页
        XZQPopViewController *popVc = [XZQPopViewController shareXZQPopViewController];
        
        self.popVc = popVc;
        
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

- (UIView *)coverView{
    if (_coverView == nil) {
//        _coverView = [[XZQCoverView alloc] init];
        _coverView = [XZQSnowCoverView snowCoverView];
    }
    
    return _coverView;
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

- (UIButton *)levels{
    if (!_levels) {
        _levels = [[UIButton alloc] init];
//        [_levels setBackgroundImage:[UIImage imageNamed:@"btn_1"] forState:UIControlStateNormal];
        
        [_levels setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"PrincipalSheet_pen"]]  forState:UIControlStateNormal];
        [_levels addTarget:self action:@selector(writeFunc) forControlEvents:UIControlEventTouchUpInside];;
        
        [self.view addSubview:_levels];
    }
    
    return _levels;
}

#pragma 布局控件

//布局label 和 后面的textField
- (void)layoutLabel{
    
    //我的信息
//    CGFloat myLabelX = Width *0.18615;
//    CGFloat myLabelY = Height *0.13295;
//    CGFloat myLabelW = Width *0.13853;
//    CGFloat myLabelH = Height *0.04624;
//
//    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(myLabelX, myLabelY, myLabelW, myLabelH)];
//    myLabel.textColor = [UIColor colorWithRed:112.0/255.0 green:164.0/255.0 blue:141.0/255.0 alpha:1];
//
//    NSString *timeString = @"我的信息";
//    NSMutableAttributedString *timeAttrString = [[NSMutableAttributedString alloc] initWithString:timeString];
//
//    //NSMakeRange(0, 3)从0开始的3个字符
//    [timeAttrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:24.f]} range:NSMakeRange(0, 4)];//NSMakeRange(0, 3)
//
//    myLabel.attributedText = timeAttrString;
//
//    [self.view addSubview:myLabel];
    
    //label
    CGFloat textFieldX = Width *0.10390;
    CGFloat textFieldY = Height *0.26590;
    
    CGFloat textFieldSpace = Height *0.07300;
    
    
    
    for (NSInteger i = 0; i < 3; i++) {
    
        //6个
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithRed:0/255.0 green:139.0/255.0 blue:181.0/255.0 alpha:1];
        label.center = CGPointMake(textFieldX, textFieldY + i * textFieldSpace);
        
        //2个
        UITextField *textField = [[UITextField alloc] init];
        textField.textColor = [UIColor colorWithRed:0/255.0 green:139.0/255.0 blue:181.0/255.0 alpha:1];;
        textField.tag = 100 + i;
        
        //4个
        UILabel *label2 = [[UILabel alloc] init];
        label2.textColor = [UIColor colorWithRed:0/255.0 green:139.0/255.0 blue:181.0/255.0 alpha:1];
        label2.center = CGPointMake(textFieldX + 100, textFieldY + i * textFieldSpace);
        
        
        
        switch (i) {
            case 0:
                label.text = @"昵称:";
                [label sizeToFit];
                
//                textField.center = CGPointMake(label.center.x + 50, textFieldY + i * textFieldSpace);
                textField.frame = CGRectMake(label.center.x + 50, textFieldY + i * textFieldSpace, 400, 20);
                textField.text = @"绘画小王子";
//                textField.backgroundColor = [UIColor redColor];
//                [textField sizeToFit];
                
                [self.view addSubview:textField];
                
                self.nameTextField = textField;
                
                self.nameTextField.delegate = self;
                
                break;
            case 1:
                label.text = @"年龄:";
                [label sizeToFit];
                
//                textField.center = CGPointMake(label.center.x + 50, textFieldY + i * textFieldSpace);
                textField.frame = CGRectMake(label.center.x + 50, textFieldY + i * textFieldSpace, 400, 20);
                textField.text = @"8岁";
//                textField.backgroundColor = [UIColor redColor];
//                [textField sizeToFit];
                [self.view addSubview:textField];
                
                self.ageTextField = textField;
                
                self.ageTextField.delegate = self;
                
                break;
                

            case 2:
                label.text = @"作品总数:";
                [label sizeToFit];

//                label2.center = CGPointMake(label.center.x + 70, textFieldY + i * textFieldSpace);
                label2.frame = CGRectMake(label.center.x + 70, textFieldY + i * textFieldSpace, 400, 20);
                label2.text = @"0件";
//                label2.backgroundColor = [UIColor redColor];
//                [label2 sizeToFit];
                [self.view addSubview:label2];
                self.countLabel = label2;
                break;
            default:
                break;
        }
        
        [self.view addSubview:label];
    }
    
    
}

//布局按钮
- (void)layoutBtn{
    
    //头像
    CGFloat headX = Width *0.0636;
    CGFloat headY = Height *0.048;
    CGFloat headW = Width *0.103;
    CGFloat headH = Width *0.103;
    
    self.headBtn.frame = CGRectMake(headX, headY, headW, headH);
    [self.headBtn setBackgroundImage:[UIImage imageNamed:@"navigation_accountImage"] forState:UIControlStateNormal];
    [self.headBtn addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //树叶按钮
    CGFloat levelX = Width *0.50216;
    CGFloat levelY = Height *0.12139;
    CGFloat levelW = Width *0.05194;
    CGFloat levelH = Width *0.05194;
    
    self.levels.frame = CGRectMake(levelX, levelY, levelW, levelH);
    
    //菱形
    CGFloat rhombusX = Width *0.66667;
    CGFloat rhombusY = Height *0.2948;
    CGFloat rhombusW = Width *0.01299;
    CGFloat rhombusH = Height *0.02312;
    
    CGFloat rhombusSpace = Height *0.07300;
    
    //版本更新按钮
    CGFloat btnX = Width *0.68400;
    CGFloat btnY = Height *0.286;
    
    for (NSInteger i = 0; i < 5; i++) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.frame = CGRectMake(rhombusX, rhombusY + i *rhombusSpace, rhombusW, rhombusH);
        imageV.image = [UIImage imageNamed:@"PrincipalSheet_ rhombus"];
        [self.view addSubview:imageV];
        
        UIButton *btn = [[UIButton alloc] init];
//        [btn setBackgroundImage:[UIImage imageNamed:@"btn_back_1"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"btn_back_2"] forState:UIControlStateHighlighted];
        
//        [btn.titleLabel setTextColor:[UIColor colorWithRed:0/255.0 green:139.0/255.0 blue:181.0/255.0 alpha:1]];
        [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:139.0/255.0 blue:181.0/255.0 alpha:1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1] forState:UIControlStateHighlighted];
//        btn.backgroundColor = [UIColor blackColor];
//        btn.alpha = 0.5;
        
        btn.titleLabel.font = [UIFont systemFontOfSize:20.0];
        
        switch (i) {
            case 0:
                [btn setTitle:@"版本更新" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.frame = CGRectMake(btnX, btnY + i *rhombusSpace, 88, 30);
                break;
            case 1:
                [btn setTitle:@"帮助" forState:UIControlStateNormal];
                btn.frame = CGRectMake(btnX, btnY + i *rhombusSpace, 45, 30);
                break;
            case 2:
                [btn setTitle:@"反馈" forState:UIControlStateNormal];
                btn.frame = CGRectMake(btnX, btnY + i *rhombusSpace, 45, 30);
                break;
            case 3:
                [btn setTitle:@"联系我们" forState:UIControlStateNormal];
                btn.frame = CGRectMake(btnX, btnY + i *rhombusSpace, 88, 30);
                break;
            case 4:
                [btn setTitle:@"更多" forState:UIControlStateNormal];
                btn.frame = CGRectMake(btnX, btnY + i *rhombusSpace, 45, 30);
                break;
            default:
                break;
        }
        
        
        
        [self.view addSubview:btn];
        
    }
    
    //文本框
    
    
    
    
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

   
    
    NSInteger i = 0;
    
    
    //点击界面 退出键盘
    for (UIView *view in self.view.subviews) {

        if (view.tag == 100 || view.tag == 101) {
            i++;
            UITextField *field = (UITextField *)view;
            
            //保存用户的信息
            
            [field resignFirstResponder];
            
            
            [self saveAccountNameAndAge];

            if (i == 2) {
                
                
                
                if (self.nameTextField.userInteractionEnabled == false || self.ageTextField.userInteractionEnabled == false) {
                    
                    
                }else{
                    self.customView = nil;
                    self.customView = [SlideSelectCardView xib21];
                    
                    ZJAnimationPopStyle popStyle =  ZJAnimationPopStyleScale;
                    ZJAnimationDismissStyle dismissStyle = ZJAnimationDismissStyleScale;
                    
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
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                        [self.ZJAPopView dismiss];
                        
                    });
                }
                
                
                
                self.ageTextField.userInteractionEnabled = false;
                self.nameTextField.userInteractionEnabled = false;
                
                
                return;
            }

        }



    }
    
    
    
    
    
}


- (void)saveAccountNameAndAge{
    //将用户头像保存在用户偏好设置中
    //NSUserDefaults它保存也是一个plist.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.nameTextField.text forKey:@"accountName"];
    [defaults setObject:self.ageTextField.text forKey:@"accountAge"];
    
    //立马写入到文件当中
    [defaults synchronize];
    
    self.popVc.name = self.nameTextField.text;
    self.popVc.age = self.ageTextField.text;
    
    [self.popVc viewWillAppear:YES];
    
}

- (void)btnClick:(UIButton *)btn{
    NSLog(@"fff");
}

- (void)headBtnClick{
    
    
    //从相册选择图片作为头像 将从相册中选择的头像变成圆形的
    
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


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //点击了导入图片
    NSLog(@"%@",info);
    
    UIImage *image  = info[UIImagePickerControllerOriginalImage];
    
    //将图片进行缩小操作
    UIImage *image2 = [self resizeUIImage:image toWidth:102 toHeight:102];


    //将图片设置为圆形的
    //1.开启跟原始图片一样大小的上下文
    
    UIGraphicsBeginImageContextWithOptions(image2.size, NO, 0);
    
    //2.设置一个圆形裁剪区域
    //2.1绘制一个圆形
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, Width *0.09997, Width *0.09997)];
    //2.2.把圆形的路径设置成裁剪区域
    [path addClip];//超过裁剪区域以外的内容都给裁剪掉
    //3.把图片绘制到上下文当中(超过裁剪区域以外的内容都给裁剪掉)
    [image2 drawAtPoint:CGPointZero];
    //4.从上下文当中取出图片
    UIImage *newImage =  UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭上下文
    UIGraphicsEndImageContext();
    
    [self.headBtn setBackgroundImage:newImage forState:UIControlStateNormal];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
    //将用户头像保存在用户偏好设置中
    //NSUserDefaults它保存也是一个plist.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"accountImage"] != nil) {
        [defaults removeObjectForKey:@"accountImage"];
    }
    
//    NSData *imageData = UIImageJPEGRepresentation(image, 100);
    NSData *imageData = UIImagePNGRepresentation(image);
    
    [defaults setObject:imageData forKey:@"accountImage"];
    
    //立马写入到文件当中
    [defaults synchronize];
    
    [self.popVc viewWillAppear:YES];
    
    [self postAccountMessage];
    
}

//缩小图片
- (UIImage *)resizeUIImage:(UIImage *)image toWidth:(CGFloat)width toHeight:(CGFloat)height{
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0.0f, 0.0f, width, height)];
    
    UIImage *newImage = [[UIImage alloc] init];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

//读取用户信息
- (void)readAccountMessage{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *imageData = [defaults objectForKey:@"accountImage"];
    NSString *accountName = [defaults objectForKey:@"accountName"];
    NSString *accountAge = [defaults objectForKey:@"accountAge"];
    
//    NSLog(@"accountName = %@",accountName);
    
    if (imageData != nil) {
        
        UIImage *accountImage = [UIImage imageWithData:imageData];
        
        UIImage *image2 = [self resizeUIImage:accountImage toWidth:102 toHeight:102];
        
        
        //将图片设置为圆形的
        //1.开启跟原始图片一样大小的上下文
        UIGraphicsBeginImageContextWithOptions(image2.size, NO, 0);
        
        //2.设置一个圆形裁剪区域
        //2.1绘制一个圆形
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, Width *0.09997, Width *0.09997)];
        //2.2.把圆形的路径设置成裁剪区域
        [path addClip];//超过裁剪区域以外的内容都给裁剪掉
        //3.把图片绘制到上下文当中(超过裁剪区域以外的内容都给裁剪掉)
        [image2 drawAtPoint:CGPointZero];
        //4.从上下文当中取出图片
        UIImage *newImage =  UIGraphicsGetImageFromCurrentImageContext();
        //5.关闭上下文
        UIGraphicsEndImageContext();
        
        
        [self.headBtn setBackgroundImage:newImage forState:UIControlStateNormal];
        
        //给主功能界面设置头像
        [self postAccountMessage];
    }
    
    if (accountName != nil) {
        self.nameTextField.text = accountName;
    }
    
    if (accountAge != nil) {
        
        NSLog(@"accountAge = %@",accountAge);
        
        self.ageTextField.text = accountAge;
        
//        if (![self.ageTextField.text containsString:@"岁"]) {
//            self.ageTextField.text = [accountAge stringByAppendingString:@"岁"];
//        }else{
//            self.ageTextField.text = accountAge;
//        }
        
    }
    
    if ([self returnPictureCount] != 0) {
        
        self.countLabel.text = [NSString stringWithFormat:@"%ld件",[self returnPictureCount]];
    }

    
}

- (NSInteger)returnPictureCount{
    
    self.count = 0;
    
    //作品总数
    NSArray *array = [self.manager contentsOfDirectoryAtPath:self.pictureFolderPath error:nil];
    for (NSString *fileName in array) {
        
        
        //fileName 卖火柴的小女孩 self.superPath 是路径 一直到picture  filePath 路径 一直到 details_matchGirl
        NSString *filePath = [self.pictureFolderPath stringByAppendingPathComponent:fileName];
        
        //subArray 里面是自己画的图片的名称
        NSArray *subArray = [self.manager contentsOfDirectoryAtPath:filePath error:nil];
        
        for (NSString *fileSubName in subArray) {
            
            self.count += 1;
            
        }
    }
    
    return self.count;
}

- (void)postPicturePath:(XZQDrawingBoardViewController *)drawingBoardView picturePath:(NSString *)picturePath{
    
    self.pictureFolderPath = picturePath;
}

#pragma 跳转到主功能界面
- (void)jumpToMainFuncIB{
    
    
    self.tabBarController.selectedIndex = 6;
    
    //点击了详情按钮
    
}

#pragma 主功能界面设置用户信息 (左上角的)
- (void)postAccountMessage{
    
    MainFuncViewController *mainVc = (MainFuncViewController *)self.tabBarController.childViewControllers[6];
        
    if (self.headBtn.currentBackgroundImage != nil) {
        
        mainVc.roundImage = self.headBtn.currentBackgroundImage;
        
        if (self.nameTextField.text != nil) {
            mainVc.name = self.nameTextField.text;

        }
        
        if (self.ageTextField.text != nil) {
            mainVc.age = self.ageTextField.text;
        }
    }
}

#pragma UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    //键盘退出
    [self saveAccountNameAndAge];

    //给主功能界面配置信息
    [self postAccountMessage];
}


#pragma 写的方法
- (void)writeFunc{
    NSLog(@"%s",__func__);
    
    self.nameTextField.userInteractionEnabled = YES;
    self.ageTextField.userInteractionEnabled = YES;
    
    self.customView = nil;
    self.customView = [SlideSelectCardView xib22];
    
    ZJAnimationPopStyle popStyle =  ZJAnimationPopStyleScale;
    ZJAnimationDismissStyle dismissStyle = ZJAnimationDismissStyleScale;
    
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self.ZJAPopView dismiss];
        
    });
}

@end
