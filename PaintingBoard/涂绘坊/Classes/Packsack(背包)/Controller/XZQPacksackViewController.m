//
//  XZQPacksackViewController.m
//  涂绘坊
//
//  Created by dmt312 on 2019/5/11.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQPacksackViewController.h"
#import "XZQPopViewController.h"
#import "XZQCoverView.h"
#import "XZQSnowCoverView.h"
#import "PacksackImageView.h"

#define ScreenWidth self.view.frame.size.width
#define ScreenHeight self.view.frame.size.height
#define ScaleW (2732/1048)
#define ScaleH (2048/768)

@interface XZQPacksackViewController ()
/**背景1 */
@property(nonatomic,readwrite,strong) UIImageView *imageV;

/**背景2 */
@property(nonatomic,readwrite,strong) UIImageView *imageV2;

/**画笔特效 */
@property(nonatomic,readwrite,strong) UIButton *pencilBtn;

/**花 */
@property(nonatomic,readwrite,strong) UIButton *flowerBtn;

/**衣服 */
@property(nonatomic,readwrite,strong) UIButton *clothBtn;

/**展示中间的效果数组 */
@property(nonatomic,readwrite,strong) NSMutableArray *showBtns;

/**被选中的按钮 */
@property(nonatomic,readwrite,strong) UIButton *selectedBtn;

/**按钮外面的框 */
@property(nonatomic,readwrite,strong) UIImageView *btnColorFrameView;

/**选中的左边的按钮 */
@property(nonatomic,readwrite,strong) UIButton *selectedLeftBtn;

/**对号 */
@property(nonatomic,readwrite,strong) UIButton *correctBtn;

/**主页 */
@property(nonatomic,readwrite,strong) UIButton *mainBtn;

//弹出的控制器
@property(nonatomic,strong) XZQPopViewController *popVc;

/**遮罩 */
@property(nonatomic,strong) XZQCoverView *coverView;

/**效果ImageView */
@property(nonatomic,readwrite,strong) PacksackImageView *effectImageView;


@end

@implementation XZQPacksackViewController


#pragma lazy initialization
- (UIImageView *)btnColorFrameView{
    if (!_btnColorFrameView) {
        _btnColorFrameView = [[UIImageView alloc] init];
    }
    return _btnColorFrameView;
}

- (UIButton *)selectedBtn{
    if (!_selectedBtn) {
        //一开始被选中的按钮是第一个
        _selectedBtn = self.showBtns[0];
    }
    
    return _selectedBtn;
}

- (UIButton *)selectedLeftBtn{
    if (!_selectedLeftBtn) {
        _selectedLeftBtn = _pencilBtn;
    }
    
    return _selectedLeftBtn;
}

- (UIView *)coverView{
    if (_coverView == nil) {
//        _coverView = [[XZQCoverView alloc] init];
        _coverView = [XZQSnowCoverView snowCoverView];
    }
    
    return _coverView;
}

- (UIImageView *)effectImageView{
    if (!_effectImageView) {
        _effectImageView = [[PacksackImageView alloc] init];
        _effectImageView.frame = CGRectMake(ScreenWidth *0.6667, ScreenHeight *0.2312, ScreenWidth *0.3030, ScreenHeight *0.4046);
        _effectImageView.origionFrame = _effectImageView.frame;
    
        [self.view addSubview:_effectImageView];
    }
    
    return _effectImageView;
}

#pragma viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建背景
    [self createBackGround];
    
    //创建左边的按钮
    [self createLeftBtn];
    
    
    //创建中间的按钮
    [self createMiddleBtns];
    
    //创建右上角的按钮
    [self createTopRightBtn];
    
    
    
}

#pragma 创建右上角的按钮
- (void)createTopRightBtn{
    
    if (_correctBtn) {
    
        return;
        
    }else{
        
        _correctBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth *0.6537, ScreenHeight *0.0520, ScreenHeight *0.0498, ScreenHeight *0.0498)];
        [_correctBtn setBackgroundImage:[UIImage imageNamed:@"yes"] forState:UIControlStateNormal];
        [_correctBtn addTarget:self action:@selector(correctBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_correctBtn];
        
        
        _mainBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth *0.9091, ScreenHeight *0.0520, ScreenHeight *0.0498, ScreenHeight *0.0498)];
        [_mainBtn setBackgroundImage:[UIImage imageNamed:@"main"] forState:UIControlStateNormal];
        [_mainBtn addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_mainBtn];
        
        //主页
        XZQPopViewController *popVc = [XZQPopViewController shareXZQPopViewController];
        
        self.popVc = popVc;
    }
}

#pragma 点击yes按钮调用
- (void)correctBtnClick{
    NSLog(@"correctBtnClick");
}

#pragma 点击主页按钮调用
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


#pragma 创建中间的按钮
- (void)createMiddleBtns{
    
    if (!_showBtns) {
        
        self.showBtns = [NSMutableArray array];
        
        [self setBtnFrame];
        
        [self setMiddleBtnBackground];
        
    }else{
        return;
    }
}

#pragma 处理按钮的位置大小
- (void)setBtnFrame{
    //列数
    NSInteger column = 3;
    
    //x/y/width/height/间距
    CGFloat btnX = ScreenWidth *0.0918;
    
    CGFloat btnY = ScreenHeight *0.0725;
    CGFloat btnW = ScreenWidth *0.1615;
    CGFloat btnH = ScreenHeight *0.1600;
    
    //xy方向的间距
    CGFloat spaceX = ScreenWidth *0.0120;
    CGFloat spaceY = ScreenHeight *0.0140;
    
    CGRect rect = CGRectMake(0, 0, btnW, btnH);
    
    for (NSInteger i = 0; i < 15; i++) {
        
        
        rect.origin.x = btnX + (i % column) * (btnW + spaceX);
        rect.origin.y = btnY + (i / column) * (btnH + spaceY);
        
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        
        
        btn.frame = rect;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.showBtns addObject:btn];
        [self.view addSubview:btn];
        
        
    }
}


#pragma 设置按钮点击外面的框
- (void)setBtnColorFrame:(UIButton *)btn{
    
    if (btn != self.selectedBtn) {
        self.selectedBtn.selected = NO;
        btn.selected = YES;
        self.selectedBtn = btn;
        
    }else{
        self.selectedBtn.selected = YES;
    }
    
    
    
    [self.view insertSubview:self.btnColorFrameView belowSubview:self.selectedBtn];
    self.btnColorFrameView.frame = CGRectMake(self.selectedBtn.frame.origin.x - 4, self.selectedBtn.frame.origin.y - 5, self.selectedBtn.frame.size.width + 9, self.selectedBtn.frame.size.height + 9);
    self.btnColorFrameView.image = [UIImage imageNamed:@"item_Selected"];
    
}

#pragma 给中间的按钮设置背景图片
- (void)setMiddleBtnBackground{

        
    UIImage *image = nil;
    UIImage *newImage = nil;
    
        for (UIButton  *btn in self.showBtns) {
            
            switch (btn.tag) {
                case 0:
                    image = [UIImage imageNamed:@"pencil_1"];
                    break;
                case 1:
                    image = [UIImage imageNamed:@"pencil_2"];
                    break;
                case 2:
                    image = [UIImage imageNamed:@"pencil_3"];
                    break;
                case 3:
                    image = [UIImage imageNamed:@"pencil_4"];
                    break;
                case 4:
                    image = [UIImage imageNamed:@"pencil_5"];
                    break;
                case 5:
                    image = [UIImage imageNamed:@"pencil_6"];
                    break;
                case 6:
                    image = [UIImage imageNamed:@"pencil_7"];
                    break;
                case 7:
                    image = [UIImage imageNamed:@"pencil_8"];
                    break;
                default:
                    return;
                    
            }
            
//            newImage = [self resoveBtnBackGroundProgrom:image];
//            newImage = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
            
            //top left bottom right - 通过这个来修改图片不被拉伸区域 - iOS提供了简单的方法来设置不被拉伸的区域，是以图片原本大小上对应区域来设置
            newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 35, 10, 35) resizingMode:UIImageResizingModeStretch];
    
            [btn setBackgroundImage:newImage forState:UIControlStateNormal];
            [btn setBackgroundImage:image forState:UIControlStateHighlighted];
            
            
            
        }
    
}

#pragma 点击中间的按钮调用的方法
- (void)btnClick:(UIButton *)btn{
    [self setBtnColorFrame:btn];
    
    if (btn.tag != 5) {
        
        [self loadEffectImageView:btn.currentBackgroundImage];
        
    }else{
        
        [self loadEffectImageView:[UIImage imageNamed:@"pencil_6_Selected"]];
        
    }
}

#pragma 给效果UIImageView设置图片
- (void)loadEffectImageView:(UIImage *)image{
    
    self.effectImageView.image = image;
}

#pragma 创建左边的按钮

//还有一个待解决的问题 - 默认选择的是笔这个按钮 - 直到点击花或者衣服的时候才变成normal !!!!

- (void)createLeftBtn{
    if (!_pencilBtn) {
        
        
        
        self.pencilBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth * 0.0346, ScreenHeight *0.1040, ScreenWidth *0.0346, ScreenHeight *0.0520)];
        self.pencilBtn.selected = YES;
        
        [self.view addSubview:self.pencilBtn];
        [self.pencilBtn setBackgroundImage:[UIImage imageNamed:@"PackSack_1"] forState:UIControlStateNormal];
        [self.pencilBtn setBackgroundImage:[UIImage imageNamed:@"pencil_1_HighLighted"] forState:UIControlStateSelected];
        [self.pencilBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        

        self.flowerBtn = [[UIButton alloc] initWithFrame:CGRectMake( ScreenWidth *0.0303, ScreenHeight *0.2081, ScreenWidth *0.0433, ScreenWidth *0.0520)];
        
        [self.view addSubview:self.flowerBtn];
        
        [self.flowerBtn setBackgroundImage:[UIImage imageNamed:@"PackSack_2"] forState:UIControlStateNormal];
//        [self.flowerBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        [self.flowerBtn setBackgroundImage:[UIImage imageNamed:@"pencil_2_HighLighted"] forState:UIControlStateSelected];
        [self.flowerBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        
        
        self.clothBtn = [[UIButton alloc] initWithFrame:CGRectMake( ScreenWidth *0.0303, ScreenHeight *0.3179, ScreenWidth *0.0433, ScreenHeight *0.0520)];
        [self.view addSubview:self.clothBtn];
        
        [self.clothBtn setBackgroundImage:[UIImage imageNamed:@"PackSack_3"] forState:UIControlStateNormal];
        [self.clothBtn setBackgroundImage:[UIImage imageNamed:@"pencil_3_HighLighted"] forState:UIControlStateSelected];
        [self.clothBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        

    }else{
        return;
    }
}

#pragma 左边按钮点击
- (void)leftBtnClick:(UIButton *)btn{
    
    if (btn != self.selectedLeftBtn) {
        
        self.selectedLeftBtn.selected = NO;
        btn.selected = YES;
        self.selectedLeftBtn = btn;
    }else{
        self.selectedLeftBtn.selected = YES;
    }
    
    

    
}

#pragma 创建背景图片
- (void)createBackGround{
    
    if (!_imageV) {
        self.imageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
        self.imageV.image = [UIImage imageNamed:@"backGround_paintBoard"];
        [self.view addSubview:self.imageV];
        
    }
    
    if (!_imageV2) {
        self.imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth *0.0173, ScreenHeight *0.0231, ScreenWidth *0.9697, ScreenHeight *0.9538)];
        self.imageV2.image = [UIImage imageNamed:@"PackSack"];
        [self.view addSubview:self.imageV2];
    }
    
}

#pragma 点击屏幕回到画板界面
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.tabBarController.selectedIndex = 0;
}

#pragma 隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}



@end
