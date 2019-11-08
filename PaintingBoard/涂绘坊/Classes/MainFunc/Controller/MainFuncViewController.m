//
//  MainFuncViewController.m
//  涂绘坊
//
//  Created by dmt312 on 2019/9/3.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "MainFuncViewController.h"
#import "PhotoCell.h"
#import "FlowLayout.h"
#import "XZQTabBarController.h"
#import "XZQPopViewController.h"

#import "UIImage+OriginalImage.h"

#import "XZQImageView.h"
#import "XZQButton.h"

/**
 效果1
 点击非位于中央的view滑动到中央 勉强完成
 
 效果2
 点击中央的按钮进入界面 (设置高亮状态下的图片 从而产生动画效果) 解决
 
 效果3
 设置头像、昵称在主功能界面上
 
 问题：
 怎么区分中央的 按钮 和 侧面的 按钮 没有解决这个问题
 
 效果1解决：
 1 - 给每一个cell 的 btn设置 tag 计算出设置完minimumLineSpacing 之后 每一个cell居中时的collectionView的偏移量 tag *偏移量 达到居中的目的
 
 效果2解决:
 首先 先居中 利用collection的偏移量除以 按钮的 483.5  == tag 才可以进行切换
 
 头像框 2.573
 
 */

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//最下面小按钮的正常宽高


//最下面小按钮的放大宽高

@interface MainFuncViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,readwrite,strong) FlowLayout *layout;


@property(nonatomic,readwrite,weak) UICollectionView *collectionView;

/**头像ImageView */
@property(nonatomic,readwrite,strong) UIImageView *headImageView;


//头像按钮 点击进入个人界面
@property(nonatomic, strong) UIButton *headImageViewButton;

//头像按钮后面的头像框
@property(nonatomic, weak) UIImageView *headFrameImageView;

/**姓名Label */
@property(nonatomic,readwrite,strong) UILabel *nameLabel;

/**年龄Label */
@property(nonatomic,readwrite,strong) UILabel *ageLabel;

/** 背景图*/
@property(nonatomic,readwrite,weak) UIImageView *bgImageV;

/** 滚动视图 点击进入界面*/
@property(nonatomic,readwrite,weak) UIScrollView *funcScrollView;

/** 滚动视图里的图片*/
@property(nonatomic,readwrite,weak) UIButton *pictureButton;

/** 想左切换*/
@property(nonatomic,readwrite,weak) UIButton *leftBtn;

/** 向右切换*/
@property(nonatomic,readwrite,weak) UIButton *rightBtn;

//下面的三个小按钮 放在一个数组中
@property(nonatomic, strong) NSMutableArray *threeSmallBtnArray;

//画板小图标
@property(nonatomic, weak) XZQImageView *paintBoardSmallImageView;

//画册小图标
@property(nonatomic, weak) XZQImageView *albumSmallImageView;

//故事小图标
@property(nonatomic, weak) XZQImageView *storySmallImageView;

//将小图标换成按钮

//画板小图标2
@property(nonatomic, weak) XZQButton *paintBoardSmallBtn;

//画册小图标
@property(nonatomic, weak) XZQButton *albumSmallBtn;

//故事小图标
@property(nonatomic, weak) XZQButton *storySmallBtn;

@property(nonatomic, strong) XZQButton *currentClickBtn;



@end

@implementation MainFuncViewController

#pragma ----------------------------
#pragma lazy initialize

//故事小图标2
- (XZQButton *)storySmallBtn{
    
    if (_storySmallBtn == nil) {
        XZQButton *btn = [[XZQButton alloc] init];
        btn.tag = 10;
        
        btn.bounds = CGRectMake(0, 0, ScreenWidth*0.0606, ScreenHeight*0.1098);
        btn.center = CGPointMake(ScreenWidth*0.7208, ScreenHeight*0.871);
        
        btn.smallCenterPoint = btn.center;
        btn.smallSize = CGSizeMake(ScreenWidth*0.0606, ScreenHeight*0.1098);
        
        btn.bigSize = CGSizeMake(ScreenWidth *0.1212, ScreenHeight *0.1618);
        
//        btn.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_storySmallBtnNormal"]];
        [btn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_storySmallBtnNormal"]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeImageAndOffset:) forControlEvents:UIControlEventTouchUpInside];
        _storySmallBtn = btn;
        [self.view addSubview:btn];
    }
    
    return _storySmallBtn;
}

- (XZQButton *)albumSmallBtn{
    if (_albumSmallBtn == nil) {
        XZQButton *btn = [[XZQButton alloc] init];
        btn.tag = 11;
        
        btn.bounds = CGRectMake(0, 0, ScreenWidth*0.0563, ScreenHeight*0.0983);
        btn.center = CGPointMake(ScreenWidth*0.4957, ScreenHeight*0.8728);
        
        btn.smallCenterPoint = btn.center;
        btn.smallSize = CGSizeMake(ScreenWidth*0.0563, ScreenHeight*0.0983);
        
        btn.bigSize = CGSizeMake(ScreenWidth *0.1212, ScreenHeight *0.1618);
        
        [btn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_albumSmallBtnNormal"]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeImageAndOffset:) forControlEvents:UIControlEventTouchUpInside];
        _albumSmallBtn = btn;
        [self.view addSubview:btn];
    }
    
    return _albumSmallBtn;
}



- (XZQButton *)paintBoardSmallBtn{
    if (_paintBoardSmallBtn == nil) {
        XZQButton *btn = [[XZQButton alloc] init];
        btn.tag = 12;
        //
        btn.bounds = CGRectMake(0, 0, ScreenWidth *0.1212, ScreenHeight *0.1618);
        btn.center = CGPointMake(ScreenWidth*0.2749, ScreenHeight*0.873);
        
        btn.smallCenterPoint = CGPointMake(ScreenWidth *0.0736, ScreenHeight *0.0925);
        btn.smallSize = CGSizeMake(ScreenWidth *0.0736, ScreenHeight *0.0925);
        
        btn.bigSize = CGSizeMake(ScreenWidth*0.1212, ScreenHeight *0.1618);
        
//        btn.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_paintBoardSmallBtnHighlight"]];
        [btn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_paintBoardSmallBtnHighlight"]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeImageAndOffset:) forControlEvents:UIControlEventTouchUpInside];
        _paintBoardSmallBtn = btn;
        [self.view addSubview:btn];
        
        //一开始默认点击的按钮是画板小按钮
        self.currentClickBtn = btn;
    }
    return _paintBoardSmallBtn;
}



- (NSMutableArray *)threeSmallBtnArray{
    
    if (_threeSmallBtnArray == nil) {
        _threeSmallBtnArray = [NSMutableArray array];
        
        //画板小按钮按钮
//        [_threeSmallBtnArray addObject:self.paintBoardSmallImageView];
//        [_threeSmallBtnArray addObject:self.albumSmallImageView];
//        [_threeSmallBtnArray addObject:self.storySmallImageView];
        
        [_threeSmallBtnArray addObject:self.paintBoardSmallBtn];
        [_threeSmallBtnArray addObject:self.albumSmallBtn];
        [_threeSmallBtnArray addObject:self.storySmallBtn];
        
    }
    
    return _threeSmallBtnArray;
}


//const CGFloat Width = [UIScreen mainScreen].bounds.size.width;
//const CGFloat Height = [UIScreen mainScreen].bounds.size.height;

- (UIScrollView *)funcScrollView{
    if (_funcScrollView == nil) {
        

        UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 90,ScreenWidth, 0.5714*ScreenHeight)];
        
        //设置滚动范围
        scrollV.contentSize = CGSizeMake(3*ScreenWidth, 0);
        //取消滚动条
        scrollV.showsHorizontalScrollIndicator = NO;
        
        //不让用户滚动
        scrollV.scrollEnabled = false;
        
        //设置代理 - 因为点击过快可能会出现偏移过度问题
        scrollV.delegate = self;
        
        [self.view addSubview:scrollV];

        _funcScrollView = scrollV;
        
    }
    
    return _funcScrollView;
}

static NSString * const ID = @"cell";

//记录按钮背景图片偏移
static CGFloat offsetX = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //创建UICollectionView
    
    /**
     
     FlowLayout *layout = ({
     
     FlowLayout *layout = [[FlowLayout alloc] init];
     layout.itemSize = CGSizeMake(ScrollWidth *0.55, ScrollHeight *0.57);
     layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
     CGFloat marginL = (ScrollWidth - ScrollWidth *0.55) * 0.5;
     layout.sectionInset = UIEdgeInsetsMake(0, marginL, 0, marginL);
     
     
     layout.minimumLineSpacing = - ScrollWidth *0.078;
     
     layout;
     
     });
     
     _layout = layout;
     
     UICollectionView *collectionView = ({
     
     UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
     collectionView.backgroundColor = [UIColor redColor];
     collectionView.center = self.view.center;
     collectionView.bounds = CGRectMake(0, 0, ScrollWidth, ScrollHeight *0.57);
     collectionView.showsHorizontalScrollIndicator = NO;
     
     [self.view addSubview:collectionView];
     
     //设置数据源
     collectionView.dataSource = self;
     //设置代理
     collectionView.delegate = self;
     
     //注册cell
     [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PhotoCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
     
     
     
     collectionView;
     
     });
     
     _collectionView = collectionView;
     */
    
    
    
    //设置背景图
    self.bgImageV.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"MainFunc_bg"]];
//    self.bgImageV.image = [UIImage imageNamed:@"MainFunc_bg"];
    
    
    //scrollView
//    self.funcScrollView.backgroundColor = [UIColor yellowColor];
//    self.funcScrollView.alpha = 0.5;
    
    //设置scrollView内部
    [self setFuncScrollViewInnter];
    
    //设置切换按钮
    [self setSwitchButton];
    
    
    //访问three数组
    NSLog(@"%ld",self.threeSmallBtnArray.count);
}
#pragma mark -----------------------------
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x > 2 * ScreenWidth) {
        offsetX = 2*ScreenWidth;
        [self switchView:_rightBtn];
    }else if (scrollView.contentOffset.x < 0){
        offsetX = 0;
        [self switchView:_leftBtn];
    }else{
        offsetX = scrollView.contentOffset.x;
    }
    
    NSLog(@"%s",__func__);
    NSLog(@"offsetX%f",offsetX);
    [self changeSizeAndPitctureOfSmallImageView];
}



#pragma mark -----------------------------
#pragma mark 设置切换按钮
- (void)setSwitchButton{
    
    UIButton *leftBtn = ({
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.tag = 0;
        leftBtn.center = CGPointMake(0.15 *ScreenWidth, 0.45*ScreenHeight);
        leftBtn.bounds = CGRectMake(0, 0, ScreenWidth*0.0681, ScreenHeight*0.1657);
        [leftBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"main_leftArrow"]] forState:UIControlStateNormal];
        
        [leftBtn addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:leftBtn];
        
        leftBtn;
        
    });
    
    _leftBtn = leftBtn;
    
    UIButton *rightBtn = ({
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.tag = 1;
        rightBtn.center = CGPointMake(0.85 *ScreenWidth, 0.45*ScreenHeight);
        rightBtn.bounds = CGRectMake(0, 0, ScreenWidth*0.0681, ScreenHeight*0.1657);
        [rightBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"main_rightArrow"]] forState:UIControlStateNormal];
        
        [rightBtn addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rightBtn];
        rightBtn;
        
    });
    
    _rightBtn = rightBtn;

}

#pragma mark -----------------------------
#pragma mark 切换view
- (void)switchView:(UIButton *)btn{
    
    
    
    
    if (btn.tag == 0) {//点击了向左的按钮

//        连续点击的话 这里会进行多次 应该将判断条件放在后面
        
        offsetX -= ScreenWidth;
        
        if (offsetX < 0) {
            offsetX = 0;
        }
    
        

    }else{//点击了向右的按钮 tag == 1
        
        //在之前的基础上加多少
        offsetX += ScreenWidth;
        
        if (offsetX > 2*ScreenWidth) {
            offsetX = 2*ScreenWidth;
        }
        
    }
    
    
    
    [self.funcScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    [self changeSizeAndPitctureOfSmallImageView];
}



#pragma mark -----------------------------
#pragma mark 设置scrollView内部
- (void)setFuncScrollViewInnter{
    
    for (NSInteger i = 0; i < 3; i++) {
        
        UIButton *pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pictureBtn.tag = i;
        pictureBtn.center = CGPointMake((i+0.5)*ScreenWidth, 260);
        pictureBtn.bounds = CGRectMake(0, 0, ScreenWidth*0.4085, ScreenHeight*0.4171);
        [self setFuncInnerButtonImage:i Button:pictureBtn];
        [self.funcScrollView addSubview:pictureBtn];
        
        if (i == 0) {
            _pictureButton = pictureBtn;
        }
        
        
        UIImageView *characterImageView = [[UIImageView alloc] init];
        characterImageView.center = CGPointMake((i+0.5)*ScreenWidth, 50);
        characterImageView.bounds = CGRectMake(0, 0, 200, 77);//画板 585 225 2.6
        
        [self.funcScrollView addSubview:characterImageView];
        [self setFuncInnerImage:(i+3) ImageView:characterImageView];
    }
    
}

//设置文字图片
- (void)setFuncInnerImage:(NSInteger)i ImageView:(UIImageView *)imageV{
    switch (i) {
        case 3:

            imageV.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_paintBoardName"]];
            break;
        case 4:

            imageV.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_albumName"]];
            break;
        case 5:
            imageV.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_storyName"]];
            break;
        default:
            break;
    }
}

//设置按钮背景图片
- (void)setFuncInnerButtonImage:(NSInteger)i Button:(UIButton *)btn{
    
    switch (i) {
        case 0:
            [btn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"main_paintBoard"]] forState:UIControlStateNormal];
            
            break;
        case 1:
            [btn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"main_paintAlbum"]] forState:UIControlStateNormal];
            break;
        case 2:
            [btn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"main_story"]] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    [btn addTarget:self action:@selector(goIntoInterFace:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -----------------------------
#pragma mark 按钮点击进入界面
- (void)goIntoInterFace:(UIButton *)btn{
    
    self.tabBarController.selectedIndex = btn.tag;
}


#pragma mark -----------------------------
#pragma mark initialize
- (UIImageView *)bgImageV{
    if (_bgImageV == nil) {
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:imageV];
        [self.view insertSubview:imageV atIndex:0];
        _bgImageV = imageV;
    }
    
    
    return _bgImageV;
    
}

- (UIImageView *)headImageView{
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
        [self.view addSubview:_headImageView];
    }
    
    return _headImageView;
}

- (UIButton *)headImageViewButton{
    if (_headImageViewButton == nil) {
        _headImageViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _headImageViewButton.frame = CGRectMake(27, 27, 85, 85);
        [self.view addSubview:_headImageViewButton];
        
        [_headImageViewButton addTarget:self action:@selector(jumpToPersonalIB) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _headImageViewButton;
}

- (UIImageView *)headFrameImageView{
    
    if (_headFrameImageView == nil) {
        UIImageView *headFrameIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 300, 117)];
        headFrameIV.contentMode = UIViewContentModeScaleAspectFit;
        headFrameIV.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"main_headFrame"]];
        [self.view addSubview:headFrameIV];
        _headFrameImageView = headFrameIV;
    }
    
    return _headFrameImageView;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
//        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 30, 100, 40)];
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(130, 85, 0, 0);
//        _nameLabel.tintColor = [UIColor colorWithRed:86.0/255.0 green:177.0/255.0 blue:218.0/255.0 alpha:1];
        [_nameLabel setTextColor:[UIColor colorWithRed:46.0/255.0 green:136.0/255.0 blue:177.0/255.0 alpha:1]];
        
        [self.view addSubview:_nameLabel];
    }
    
    return _nameLabel;
}

- (UILabel *)ageLabel{
    if (_ageLabel == nil) {
//        _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 80, 1000, 40)];
        _ageLabel = [[UILabel alloc] init];
        _ageLabel.frame = CGRectMake(130, 60, 0, 0 );
        
        [_ageLabel setTextColor:[UIColor colorWithRed:46.0/255.0 green:136.0/238.0 blue:177.0/255.0 alpha:1]];
        [self.view addSubview:_ageLabel];
    }
    
    return _ageLabel;
}

#pragma mark -----------------------------
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    NSString *imageName = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
    imageName = [@"MainFunc_" stringByAppendingString:imageName];
    
    cell.image = [UIImage imageNamed:imageName];
    
    
    
    cell.backgroundBtn.tag = indexPath.row;
    
//    [cell.backgroundBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    
    [cell.backgroundBtn addTarget:self action:@selector(touchupInside:) forControlEvents:UIControlEventTouchUpInside];
    
//    [cell.backgroundBtn addTarget:self action:@selector(touchDownDragOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
    [cell.backgroundBtn setTitle:@"" forState:UIControlStateNormal];
    
    
    
    return cell;
    
}






#pragma mark -----------------------------
#pragma mark 手指抬起
- (void)touchupInside:(UIButton *)btn{
    
    //居中
    [self centerCell:btn];
//    NSLog(@"tag = %ld %f",btn.tag,btn.frame.origin.x);//center.x都一样 ？？ 不知道为什么
    
    
    //切换子控制器
    if (btn.tag == (self.collectionView.contentOffset.x / 483.5)) {
        
        if (btn.tag == 3) {
            self.tabBarController.selectedIndex = btn.tag + 2;
        }else{
            self.tabBarController.selectedIndex = btn.tag;
        }
    }
    
    
//    NSLog(@"contentOffset x = %f",self.collectionView.contentOffset.x);
    
    
    
    //打印偏移量
//    NSLog(@"contentOffsetX = %f",self.collectionView.contentOffset.x);//483 966.5 1450   差为483.5
}

/**
 //切换子控制器
 //- (void)switchVc:(UIButton *)btn{
 //
 //    //居中
 //    [self centerCell:btn];
 //
 //
 //
 //
 //    UIView *view = btn.superview;
 //
 //    if (view == nil) {
 //        return;
 //    }
 //
 //    //复原
 //    view.transform = CGAffineTransformIdentity;
 //
 //    //调整位移
 //
 //
 //    //切换控制器
 //
 //
 //    if (btn.tag == 3) {
 //        self.tabBarController.selectedIndex = btn.tag + 2;
 //    }else{
 //        self.tabBarController.selectedIndex = btn.tag;
 //    }
 //
 //}
 
 //#pragma mark -----------------------------
 //#pragma mark 手指刚按下按钮没有抬起
 
 //- (void)touchDown:(UIButton *)btn{
 //
 //    //变小
 //
 //
 //}
 
 //- (void)touchDownDragOutside:(UIButton *)btn{
 //
 //    UIView *view = btn.superview;
 //
 //    if (view == nil) {
 //        return;
 //    }
 //
 //    //复原
 //    view.transform = CGAffineTransformIdentity;
 //}
 */

#pragma mark -----------------------------
#pragma mark 让cell居中
- (void)centerCell:(UIButton *)btn{
    
    UIView *view = btn.superview;
    
    if (view == nil) {
        return;
    }
    
    //居中
    
    CGPoint point = self.collectionView.contentOffset;
    
    point.x = btn.tag * 483.5;
    
    NSLog(@"point.x = %f",point.x);
    
    [self.collectionView setContentOffset:point animated:YES];
}

/**
 //#pragma mark -----------------------------
 //#pragma mark 切换子控制器
 //- (void)switchChildViewController:(UIButton *)btn{
 //
 //
 //}
 */


#pragma mark -----------------------------
#pragma mark 获取到头像图片
- (void)setRoundImage:(UIImage *)roundImage{
    _roundImage = roundImage;
    
//    self.headImageView.image = _roundImage;
    [self.headImageViewButton setBackgroundImage:[UIImage OriginalImageWithImage:_roundImage] forState:UIControlStateNormal];
    [self.view insertSubview:self.headFrameImageView belowSubview:self.headImageViewButton];
    
}

#pragma mark -----------------------------
#pragma mark 设置昵称
- (void)setName:(NSString *)name{
    _name = name;
//    _name = [@"姓名：" stringByAppendingString:_name];
    self.nameLabel.text = _name;
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    [_nameLabel sizeToFit];
}

#pragma mark -----------------------------
#pragma mark 设置年龄
- (void)setAge:(NSString *)age{
    _age = age;
    
//    _age = [@"年龄：" stringByAppendingString:_age];
    self.ageLabel.text = _age;
    [_ageLabel sizeToFit];
}


#pragma mark -----------------------------
#pragma mark 隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark -----------------------------
#pragma mark 滚动条范围超过了父视图
//解决
//- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
//
//    UIView *superView = self.view;
//    UIView * view = [superView hitTest:point withEvent:event];
//
//    if (view == nil) {
//        for (UIView * subView in self.view.subviews) {
//            // 将坐标系转化为自己的坐标系
//            CGPoint tp = [subView convertPoint:point fromView:superView];
//            if (CGRectContainsPoint(subView.bounds, tp)) {
//                view = subView;
//            }
//        }
//    }
//    return view;
//}

#pragma 跳转到个人主页
- (void)jumpToPersonalIB{
    self.tabBarController.selectedIndex = 5;
}

#pragma ----------------------------
#pragma 根据offsetX值改变小按钮图片和大小
- (void)changeSizeAndPitctureOfSmallImageView{

//    NSInteger i = offsetX / ScreenWidth;
    

    if (offsetX / ScreenWidth == 0) {
        
        //按钮
        //画板小按钮变大
        
        [self.paintBoardSmallBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_paintBoardSmallBtnHighlight"]] forState:UIControlStateNormal];
        
        self.paintBoardSmallBtn.bounds = CGRectMake(0, 0, self.paintBoardSmallBtn.bigSize.width, self.paintBoardSmallBtn.bigSize.height);
        
        //其他两个正常
        [self.albumSmallBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_albumSmallBtnNormal"]] forState:UIControlStateNormal];
        self.albumSmallBtn.bounds = CGRectMake(0, 0, self.albumSmallBtn.smallSize.width, self.albumSmallBtn.smallSize.height);
        
        [self.storySmallBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_storySmallBtnNormal"]] forState:UIControlStateNormal];
        self.storySmallBtn.bounds = CGRectMake(0, 0, self.storySmallBtn.smallSize.width, self.storySmallBtn.smallSize.height);
        
        //变大的是就是点前点击的按钮
        self.currentClickBtn = self.paintBoardSmallBtn;
        
        
    }else if (offsetX / ScreenWidth == 1){
        
        
        [self.paintBoardSmallBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_paintBoardSmallBtnNormal"]] forState:UIControlStateNormal];
        self.paintBoardSmallBtn.bounds = CGRectMake(0, 0, self.paintBoardSmallBtn.smallSize.width, self.paintBoardSmallBtn.smallSize.height);
        
        //画册小按钮变大
        [self.albumSmallBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_albumSmallBtnHighlight"]] forState:UIControlStateNormal];
        self.albumSmallBtn.bounds = CGRectMake(0, 0, self.albumSmallBtn.bigSize.width, self.albumSmallBtn.bigSize.height);
        
        [self.storySmallBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_storySmallBtnNormal"]] forState:UIControlStateNormal];
        self.storySmallBtn.bounds = CGRectMake(0, 0, self.storySmallBtn.smallSize.width, self.storySmallBtn.smallSize.height);
        
        //变大的是就是点前点击的按钮
        self.currentClickBtn = self.albumSmallBtn;
        
        
    }else if (offsetX / ScreenWidth == 2){
        

        [self.paintBoardSmallBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_paintBoardSmallBtnNormal"]] forState:UIControlStateNormal];
        self.paintBoardSmallBtn.bounds = CGRectMake(0, 0, self.paintBoardSmallBtn.smallSize.width, self.paintBoardSmallBtn.smallSize.height);
        
        //其他两个正常
        [self.albumSmallBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_albumSmallBtnNormal"]] forState:UIControlStateNormal];
        self.albumSmallBtn.bounds = CGRectMake(0, 0, self.albumSmallBtn.smallSize.width, self.albumSmallBtn.smallSize.height);
        
        //故事小按钮变大
        [self.storySmallBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_storySmallBtnHighlight"]] forState:UIControlStateNormal];
        self.storySmallBtn.bounds = CGRectMake(0, 0, self.storySmallBtn.bigSize.width, self.storySmallBtn.bigSize.height);
        
        //变大的是就是点前点击的按钮
        self.currentClickBtn = self.storySmallBtn;
        
    }

}

#pragma 小图标按钮调用方法
- (void)changeImageAndOffset:(XZQButton *)btn{
    NSLog(@"%s",__func__);
    
    //判断是不是当前点击的按钮并切换图片 改变位移
    [self isCurrentClickBtnAndChangeImageAndOffset:btn];
    
    
    self.currentClickBtn = btn;
}

#pragma 判断是不是当前点击的按钮并切换图片
- (void)isCurrentClickBtnAndChangeImageAndOffset:(XZQButton *)btn{
    
    NSLog(@"%s",__func__);
    
    //如果当前点击的按钮不是放大的按钮
    if (btn.tag != self.currentClickBtn.tag) {
        
        //之前点击按钮缩小
        switch (self.currentClickBtn.tag) {
            //故事
        case 10:
            NSLog(@"//故事");
                [self.currentClickBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_storySmallBtnNormal"]] forState:UIControlStateNormal];
                 self.currentClickBtn.bounds = CGRectMake(0, 0, self.currentClickBtn.smallSize.width, self.currentClickBtn.smallSize.height);
            break;
            
            //画册
        case 11:
            NSLog(@"//画册");
                
            [self.currentClickBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_albumSmallBtnNormal"]] forState:UIControlStateNormal];
            self.currentClickBtn.bounds = CGRectMake(0, 0, self.currentClickBtn.smallSize.width, self.currentClickBtn.smallSize.height);
        break;
            
            //画板
        case 12:
            NSLog(@"//画板");//changes_paintBoardSmallBtnNormal
            [self.currentClickBtn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_paintBoardSmallBtnNormal"]] forState:UIControlStateNormal];
            self.currentClickBtn.bounds = CGRectMake(0, 0, self.currentClickBtn.smallSize.width, self.currentClickBtn.smallSize.height);
        break;
            
        default:
                
            NSLog(@"666");
                
            break;
    }
        
        //现在点击按钮放大
        switch (btn.tag) {
                //故事
            case 10:
                NSLog(@"//故事");
                [btn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_storySmallBtnHighlight"]] forState:UIControlStateNormal];
                btn.bounds = CGRectMake(0, 0, btn.bigSize.width, btn.bigSize.height);
                
                //改变位移
                [self.funcScrollView setContentOffset:CGPointMake(2*ScreenWidth, 0) animated:YES];
                break;
                
                //画册
            case 11:
                NSLog(@"//画册");
                [btn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_albumSmallBtnHighlight"]] forState:UIControlStateNormal];
                btn.bounds = CGRectMake(0, 0, btn.bigSize.width, btn.bigSize.height);
                
                //改变位移
                [self.funcScrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
            break;
                
                //画板
            case 12:
                NSLog(@"//画板");
                [btn setBackgroundImage:[UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_paintBoardSmallBtnHighlight"]] forState:UIControlStateNormal];
                btn.bounds = CGRectMake(0, 0, btn.bigSize.width, btn.bigSize.height);
                //改变位移
                [self.funcScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
                
            default:
                break;
        }
        
        
    }
    
}
    
    

#pragma 失效小图标方法
//故事小图标
- (XZQImageView *)storySmallImageView{
    
    if (_storySmallImageView == nil) {
        
        XZQImageView *imageView = [[XZQImageView alloc] init];
        
        imageView.bounds = CGRectMake(0, 0, ScreenWidth*0.0606, ScreenHeight*0.1098);
        imageView.center = CGPointMake(ScreenWidth*0.7208, ScreenHeight*0.871);
        
        imageView.smallCenterPoint = imageView.center;
        imageView.smallSize = CGSizeMake(ScreenWidth*0.0606, ScreenHeight*0.1098);
        
        imageView.bigSize = CGSizeMake(ScreenWidth *0.1212, ScreenHeight *0.1618);
        
        imageView.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_storySmallBtnNormal"]];
        _storySmallImageView = imageView;
        [self.view addSubview:imageView];
        
    }
    
    return _storySmallImageView;
}

//画册小图标
- (XZQImageView *)albumSmallImageView{
    
    if (_albumSmallImageView == nil) {
        
        XZQImageView *imageView = [[XZQImageView alloc] init];
        
        imageView.bounds = CGRectMake(0, 0, ScreenWidth*0.0563, ScreenHeight*0.0983);
        imageView.center = CGPointMake(ScreenWidth*0.4957, ScreenHeight*0.8728);
        
        imageView.smallCenterPoint = imageView.center;
        imageView.smallSize = CGSizeMake(ScreenWidth*0.0563, ScreenHeight*0.0983);
        
        imageView.bigSize = CGSizeMake(ScreenWidth *0.1212, ScreenHeight *0.1618);
        
        imageView.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_albumSmallBtnNormal"]];
        _albumSmallImageView = imageView;
        [self.view addSubview:imageView];
        
    }
    
    return _albumSmallImageView;
}

//画板的小图标 - 一开始选中画板
- (XZQImageView *)paintBoardSmallImageView{
    
    if (_paintBoardSmallImageView == nil) {
        
        XZQImageView *imageView = [[XZQImageView alloc] init];
        
        //
        imageView.bounds = CGRectMake(0, 0, ScreenWidth *0.1212, ScreenHeight *0.1618);
        imageView.center = CGPointMake(ScreenWidth*0.2749, ScreenHeight*0.873);
        
        imageView.smallCenterPoint = CGPointMake(ScreenWidth *0.0736, ScreenHeight *0.0925);
        imageView.smallSize = CGSizeMake(ScreenWidth *0.0736, ScreenHeight *0.0925);
        
        imageView.bigSize = CGSizeMake(ScreenWidth*0.1212, ScreenHeight *0.1618);
        
        imageView.image = [UIImage OriginalImageWithImage:[UIImage imageNamed:@"changes_paintBoardSmallBtnHighlight"]];
        _paintBoardSmallImageView = imageView;
        [self.view addSubview:imageView];
        
    }
    
    return _paintBoardSmallImageView;
}

@end
