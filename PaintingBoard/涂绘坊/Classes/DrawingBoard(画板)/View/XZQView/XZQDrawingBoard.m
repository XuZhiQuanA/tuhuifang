//
//  XZQDrawingBoard.m
//  涂绘坊
//
//  Created by dmt312 on 2019/5/12.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQDrawingBoard.h"
#import "MyBezierPath.h"
#import "XZQDrawingBoardViewController.h"

@interface XZQDrawingBoard()<XZQDrawingBoardViewDelegate>
/**画板框 */
@property(nonatomic,strong) UIImageView *boardFrame;

/** 当前绘制的路径 */
@property (nonatomic, strong) UIBezierPath *path;

/**保存当前绘制的路径 除了颜色 为了进行存档 */
@property(nonatomic,readwrite,strong) UIBezierPath *currentPath;

//保存当前绘制的所有路径
@property (nonatomic, strong) NSMutableArray *allPathArray;

/**保存当前绘制的所有路径 元素没有颜色 */
@property(nonatomic,readwrite,strong) NSMutableArray *allPathArrayCopy;

/**保存当前绘制的所有路径的颜色 */
@property(nonatomic,readwrite,strong) NSMutableArray *allColor;

//当前路径的线宽
@property (nonatomic, assign) CGFloat width;

//当前路径的颜色
@property (nonatomic, strong) UIColor *color;

/**<#备注#>*/
@property(nonatomic,assign) BOOL paint;


/**文件管理者 */
@property(nonatomic,strong) NSFileManager *manager;

/**画板数组 */
@property(nonatomic,readwrite,strong) NSMutableArray *paintingBoardArray;

/**保存此对象全部数据的字典 */
@property(nonatomic,readwrite,strong) NSMutableDictionary *allDataDict;

/**保存当前画板对象所属图集 */
@property(nonatomic,readwrite,strong) NSString *currentAltasPath;

/**保存图片文件夹路径 */
@property(nonatomic,readwrite,strong) NSString *superPath;

/**保存的图片的英文名称 */
@property(nonatomic,readwrite,strong) NSString *englishName;

/**当前切换用的字典 */
@property(nonatomic,readwrite,strong) NSMutableDictionary *currentDict;

/**当前切换用的数组 装着所有的currentDict */
@property(nonatomic,readwrite,strong) NSMutableArray *allCurrentArray;

/**给切换计数用的*/
@property(nonatomic,assign) NSInteger countIndex;

/**将撤销所删除的path保存起来  */
@property(nonatomic,readwrite,strong) NSMutableArray *saveDeletePathArray;

@end

@implementation XZQDrawingBoard
#pragma mark -----------------------------
#pragma mark awakeFromNib

- (NSMutableArray *)saveDeletePathArray{
    if (_saveDeletePathArray == nil) {
        _saveDeletePathArray = [NSMutableArray array];
    }
    
    return _saveDeletePathArray;
}

- (void)setExternalPicture:(UIImage *)externalPicture{
    _externalPicture = externalPicture;
    
    if (externalPicture != nil) {
        [self.allPathArray addObject:externalPicture];
    }
    
    //重绘
    [self setNeedsDisplay];

}

- (NSMutableDictionary *)currentDict{
    if (!_currentDict) {
        
        self.countIndex = 0;
        
        if (self.allCurrentArray.count != 0) {
            _currentDict = self.allCurrentArray[self.countIndex];
            
            NSString *temp = @"";
            for (NSString *fileName in _currentDict) {
                temp = fileName;
                break;
            }
            self.englishName = [self matchingOfStringReturnEnglishName:temp];
            self.superPath = [self.picturePath stringByAppendingPathComponent:self.englishName];
            
            
            
            
        }else{
            _currentDict = [NSMutableDictionary dictionary];
        }
        
    }
    
    return _currentDict;
}

- (NSMutableArray *)allCurrentArray{
    
    _allCurrentArray = [NSMutableArray array];
    
    //array中保存的是卖火柴的小女孩、疯狂原始小猎人之类的父类的英文故事名称
    NSArray *array = [self.manager contentsOfDirectoryAtPath:self.picturePath error:nil];
    
    
    
    for (NSString *fileName in array) {
        
        
        
        //fileName 卖火柴的小女孩 self.superPath 是路径 一直到picture  filePath 路径 一直到 details_matchGirl
        
        NSString *filePath = [self.picturePath stringByAppendingPathComponent:fileName];
        
        
        
        
        
        
        //subArray 里面是自己画的图片的名称
        NSArray *subArray = [self.manager contentsOfDirectoryAtPath:filePath error:nil];
        
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        for (NSString *fileSubName in subArray) {

            //最终图片的路径
            NSString *fileSubPath = [filePath stringByAppendingPathComponent:fileSubName];
            
            [dict setObject:fileSubPath forKey:fileSubName];
            
            
            //每个字典存放的是图片的路径 key也是有.png的
            if ([_allCurrentArray containsObject:dict]) {
                
            }else{
                [_allCurrentArray addObject:dict];
            }
            
            
            
            
        }
    }
    
  
    
    return _allCurrentArray;
}

- (NSMutableArray *)allPathArrayCopy{
    if (!_allPathArrayCopy) {
        _allPathArrayCopy = [NSMutableArray array];
    }
    
    return _allPathArrayCopy;
}

- (NSMutableArray *)allColor{
    if (!_allColor) {
        _allColor = [NSMutableArray array];
    }
    
    return _allColor;
}

- (UIBezierPath *)currentPath{
    if (!_currentPath) {
        _currentPath = [[UIBezierPath alloc] init];
    }
    
    return _currentPath;
}

- (NSMutableDictionary *)allDataDict{
    if (!_allDataDict) {
        _allDataDict = [NSMutableDictionary dictionary];
        
        if (self.image != nil) {
            [_allDataDict setObject:self.image forKey:@"image"];
        }
        
        [_allDataDict setObject:self.imageFromCGContext forKey:@"imageFromCGContext"];
        [_allDataDict setObject:[NSString stringWithFormat:@"%ld",self.index] forKey:@"index"];
        
        //        [_allDataDict setObject:self.path forKey:@"path"];
        [_allDataDict setObject:self.currentPath forKey:@"currentPath"];
        
        [_allDataDict setObject:self.allPathArray forKey:@"allPathArray"];
        [_allDataDict setObject:[NSString stringWithFormat:@"%f",self.width] forKey:@"width"];
        [_allDataDict setObject:self.color forKey:@"color"];
        [_allDataDict setObject:[NSString stringWithFormat:@"%d",self.paint] forKey:@"paint"];
        [_allDataDict setObject:self.paintingBoardArray forKey:@"paintingBoardArray"];
        [_allDataDict setObject:self.allDataDict forKey:@"allDataDict"];
    }
    
    return _allDataDict;
}

- (NSMutableArray *)paintingBoardArray{
    if (!_paintingBoardArray) {
        _paintingBoardArray = [NSMutableArray array];
    }
    
    return _paintingBoardArray;
}


- (NSFileManager *)manager{
    if (!_manager) {
        _manager = [NSFileManager defaultManager];
    }
    
    return _manager;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    self.width = 10;
    self.color = [UIColor blackColor];
    
    return [super initWithFrame:frame];
    
}



#pragma mark -----------------------------
#pragma mark lazy load


- (UIImageView *)boardFrame{
    if (_boardFrame == nil) {
        _boardFrame = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_boardFrame];
        //        [self insertSubview:_boardFrame atIndex:0];
    }
    
    return _boardFrame;
}

- (NSMutableArray *)allPathArray {
    
    if (_allPathArray == nil) {
        _allPathArray = [NSMutableArray array];
    }
    return _allPathArray;
}


//拖动手势调用
- (void)pan:(UIPanGestureRecognizer *)pan {
    
    
    //获取的当前手指的点
    CGPoint curP = [pan locationInView:self];
    //判断手势的状态
    if(pan.state == UIGestureRecognizerStateBegan) {
        
        //创建路径
        MyBezierPath *path = [[MyBezierPath alloc] init];
        
        //设置线的顶角样式
        path.lineCapStyle = kCGLineCapRound;
        self.currentPath.lineCapStyle = path.lineCapStyle;
        
        //设置线的连接样式
        path.lineJoinStyle = kCGLineJoinRound;
        self.currentPath.lineJoinStyle = path.lineJoinStyle;
        
        self.path = path;
        
        //设置起点
        [path moveToPoint:curP];
        
        
        //设置线的宽度
        [path setLineWidth:self.width];
        [self.currentPath setLineWidth:self.width];
        //设置线的颜色
        //什么情况下自定义类:当发现系统原始的功能,没有办法瞒足自己需求时,这个时候,要自定义类.继承系统原来的东西.再去添加属性自己的东西.
        path.color = self.color;
        
        [self.allPathArray addObject:path];
        
    } else if(pan.state == UIGestureRecognizerStateChanged) {
        
        //绘制一根线到当前手指所在的点
        [self.path addLineToPoint:curP];
        //重绘
        [self setNeedsDisplay];
    }
    
}


//
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //绘制保存的所有路径
    for (MyBezierPath *path in self.allPathArray) {
        
        if ([path isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *)path;
            [image drawInRect:rect];
        }else{
            [path.color set];
            
            [path stroke];
        }
        
        
        
    }
    
}


- (void)setImage:(UIImage *)image{
    self.boardFrame.image = image;
}

#pragma mark -----------------------------
#pragma mark XZQDrawingBoardViewDelegate

//清屏
-(void)clearAllPath{
    //清空所有的路径
    [self.allPathArray removeAllObjects];
    
    //清空所有的路径
    [self.saveDeletePathArray removeAllObjects];
    
    //重绘
    [self setNeedsDisplay];
}

//保存到相册
- (void)saveBtn:(UIButton *)sender{
    // ---- 截图操作
    //开启图片上下文
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    //获取上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    //截屏
    [self.layer renderInContext:context];
    //获取图片
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    
    self.imageFromCGContext = image;
    //关闭图片上下文
    UIGraphicsEndImageContext();
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

//保存到相册中 存储在内存中
- (void)saveBtn:(UIButton *)sender ChineseName:(NSString *)chineseName EnglishName:(NSString *)englishName superPath:(NSString *)superPath{
    
    
    NSLog(@"EnglishName chineseName saveBtn");
    
    //保存到相册
    [self saveBtn:sender];
    
    //存在free图集中
    NSString *altasPath = [superPath stringByAppendingPathComponent:englishName];
    
    if ([self.manager fileExistsAtPath:altasPath]) {
        
    }else{
        
        //没有创建 现在创建
        [self.manager createDirectoryAtPath:altasPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    
    NSLog(@"自己画的东西的保存路径 %@",altasPath);
    
    //存在内存中
    
    //保存作品到内存中 - 得拿到画的画
    
    //该目录已经创建完毕 - 获取到该目录下有多少文件 - 保存文件
    NSArray *array = [self.manager contentsOfDirectoryAtPath:altasPath error:nil];
    NSUInteger count = array.count;
    
    NSString *altasPathSubpath = @"";
    
    if (self.isClickPlusBtn == true) {
       altasPathSubpath = [altasPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@SelfPlus_%ld.png",englishName,(count+1)]];
        NSLog(@"点击了plus按钮 的名称%@",altasPathSubpath);
    }else{
       altasPathSubpath = [altasPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%ld.png",englishName,(count+1)]];
        NSLog(@"没有点击plus按钮 的名称%@",altasPathSubpath);
    }
    
    
    
    
    BOOL result = [UIImagePNGRepresentation(self.imageFromCGContext) writeToFile:altasPathSubpath atomically:YES];
    BOOL result2 = [UIImagePNGRepresentation(self.imageFromCGContext) writeToFile:[NSString stringWithFormat:@"/Users/home/Desktop/%@",altasPathSubpath] atomically:YES];
    
    self.englishName = englishName;
    self.superPath = altasPath;
    
    if (result) {
        NSLog(@"保存成功");
    }
    
    if (result2) {
        NSLog(@"保存2成功");
    }
    
    self.currentDict = nil;
    
}

- (void)saveFreeFolderWithEnglishName:(NSString *)englishName superPath:(NSString *)superPath{
    
//    NSLog(@"saveFreeFolderWithEnglishName");
    
    //存在free图集中
    NSString *altasPath = [superPath stringByAppendingPathComponent:englishName];
    
    if ([self.manager fileExistsAtPath:altasPath]) {
        NSLog(@"已经有了free图集了");
    }else{
        
        //没有创建 现在创建
        BOOL flag = [self.manager createDirectoryAtPath:altasPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (flag) {
            NSLog(@"创建成功");
        }
        
        
        
    }
    
//    self.superPath = altasPath;
//    self.englishName = englishName;
    
}



//设置画板上的图片
//静态索引 //控制器中的count仅仅用来标记左还是右 然后在这个里面设置一个静态的变量 静态变量的值为1
static NSInteger currentIndex = 2;
BOOL flag = NO;
- (NSInteger)setBackImage:(NSInteger)count{
    
    NSLog(@"%@",self.allCurrentArray);
    
    if (count < 0) {
        
        //点击了左边
        currentIndex = currentIndex - 1;
        
        if (currentIndex <= 0) {
            //不只一个故事 切换
            if (self.allCurrentArray.count > 1) {
                
                currentIndex = 2;
                self.countIndex++;
                if (self.countIndex >= self.allCurrentArray.count) {
                    self.countIndex = 0;
                }
                self.currentDict = self.allCurrentArray[self.countIndex];
                
                NSString *temp = @"";
                for (NSString *fileName in self.currentDict) {
                    temp = fileName;
                    break;
                }
                self.englishName = [self matchingOfStringReturnEnglishName:temp];
                self.superPath = [self.picturePath stringByAppendingPathComponent:self.englishName];
                
                [self setBackImage:-1];
                
            }else{
                
                currentIndex = 2;
                return 0;
            }
        }
        
        //为了加载self.currentDict
        if (self.currentDict.count == 2) {
            flag = YES;
        }
        
        NSLog(@"图片路径%@",[self.superPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%ld.png",self.englishName,currentIndex]]);
        
        UIImage *image = [UIImage imageWithContentsOfFile:[self.superPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%ld.png",self.englishName,currentIndex]]];
        if (image != nil) {
            [self.allPathArray addObject:image];
        }
        
        [self setNeedsDisplay];
        
        count = 0;
        return count;
        
    }else{
        
        currentIndex = currentIndex + 1;
        
        if (self.currentDict.count == 1) {
            static NSInteger showTimes = 0;
            currentIndex = 2;
            
            if (showTimes == 1) {
                showTimes = 0;
                //切换到下一个
                if (self.allCurrentArray.count == 1) {
                    return 0;
                }else{
                    currentIndex = 2;
                    self.countIndex++;
                    if (self.countIndex >= self.allCurrentArray.count) {
                        self.countIndex = 0;
                    }
                    self.currentDict = self.allCurrentArray[self.countIndex];
                    
                    NSString *temp = @"";
                    for (NSString *fileName in self.currentDict) {
                        temp = fileName;
                        break;
                    }
                    self.englishName = [self matchingOfStringReturnEnglishName:temp];
                    self.superPath = [self.picturePath stringByAppendingPathComponent:self.englishName];
                    
                    [self setBackImage:1];
                }
                
            }else{
                UIImage *image = [UIImage imageWithContentsOfFile:[self.superPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%ld.png",self.englishName,showTimes]]];
                if (image != nil) {
                    [self.allPathArray addObject:image];
                    showTimes++;
                }
                
                [self setNeedsDisplay];
                
                count = 0;
                return count;
            }
            
            
            
            
        }else if (self.currentDict.count == 2){
            
            static NSInteger showTimes = 0;
            static NSInteger switchPicture = 0;
            if (flag) {
                showTimes++;
            }
            
            currentIndex = 2;
            
            if (showTimes >= 2 || switchPicture > 0) {
                NSLog(@"showTimes>=2");
                switchPicture = 0;
                showTimes = 0;
                //切换到下一个
                if (self.allCurrentArray.count == 1) {
                    return 0;
                }else{
                    currentIndex = 2;
                    self.countIndex++;
                    if (self.countIndex >= self.allCurrentArray.count) {
                        self.countIndex = 0;
                    }
                    
                    self.currentDict = self.allCurrentArray[self.countIndex];
                    
                    NSLog(@"当前图集中只有两张图片 切换图片现在 self.currentDict:%@",self.currentDict);
                    
                    NSString *temp = @"";
                    for (NSString *fileName in self.currentDict) {
                        temp = fileName;
                        break;
                    }
                    self.englishName = [self matchingOfStringReturnEnglishName:temp];
                    self.superPath = [self.picturePath stringByAppendingPathComponent:self.englishName];
                    
                    NSLog(@"切换成功 self.englishName:%@ self.superPath:%@",self.englishName,self.superPath);
                    
                    [self setBackImage:1];
                }
            }else{
                showTimes++;
                
                UIImage *image = [UIImage imageWithContentsOfFile:[self.superPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%ld.png",self.englishName,showTimes]]];
                if (image != nil) {
                    [self.allPathArray addObject:image];
                }
                [self setNeedsDisplay];
                
                if (showTimes == 2) {
                    showTimes = 0;
                    switchPicture++;
                }
                
                count = 0;
                return count;
            }
            
            
        }

        if (currentIndex > self.currentDict.count) {
            
            NSLog(@"currentIndex > self.currentDict.count");
            
            if (self.allCurrentArray.count > 1) {
                currentIndex = 2;
                self.countIndex++;
                if (self.countIndex >= self.allCurrentArray.count) {
                    self.countIndex = 0;
                }
                self.currentDict = self.allCurrentArray[self.countIndex];
                
                NSString *temp = @"";
                for (NSString *fileName in self.currentDict) {
                    temp = fileName;
                    break;
                }
                self.englishName = [self matchingOfStringReturnEnglishName:temp];
                self.superPath = [self.picturePath stringByAppendingPathComponent:self.englishName];
                
                [self setBackImage:1];
            }else{
                currentIndex = self.currentDict.count;
                return 0;
            }
        }
        
        
        NSLog(@"将要显示free图集中的东西 路径:%@",[self.superPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%ld.png",self.englishName,currentIndex]]);
        UIImage *image = [UIImage imageWithContentsOfFile:[self.superPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%ld.png",self.englishName,currentIndex]]];
        if (image != nil) {
            [self.allPathArray addObject:image];
        }
        
        NSLog(@" self.currentDict.count == %ld",self.currentDict.count);
        NSLog(@"currentIndex = %ld image = %@",currentIndex,image);
        
        [self setNeedsDisplay];
        
        count = 0;
        return count;
    }

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





// 图片保存方法，必需写这个方法体，不能会保存不了图片
//保存图片的回调
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *message = @"";
    if (!error) {
        message = @"成功保存到相册";
    }else{
        message = [error description];//如果拒绝的话
    }
    //    NSLog(@"message is %@",message);
}


//画笔宽度
- (void)setPaintWidth:(XZQDrawingBoardViewController *)drawingBoardView tagOfButton:(NSInteger)tag{
    NSLog(@"tagOfButton %ld",tag);
    self.width = tag;
}

//画笔颜色
- (void)setPaintColor:(XZQDrawingBoardViewController *)drawinBoardView tagOfButton:(NSInteger)tag{
    
    NSLog(@"setPaintColor %ld",tag);
    
    //点击画笔调颜色 点击铅笔只有黑色
    if (tag == 42 || tag == 41) {
//        self.paint = YES;
        
        if (tag == 42) {
            self.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        }else{
            self.color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
        }
        
        return;
    }
    
//    if (tag <= 40) {
//        self.paint = NO;
//    }
//
//    if (self.paint) {
//        return;
//    }
    
//    NSLog(@"到这里了吗");
    
    switch (tag) {
        case 0:
//            self.color = [UIColor colorWithRed:136/255.0 green:60/255.0 blue:115/255.0 alpha:1];
            self.color = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
            break;
        case 1:
//            self.color = [UIColor colorWithRed:234/255.0 green:63/255.0 blue:180/255.0 alpha:1];
            self.color = [UIColor colorWithRed:244/255.0 green:183/255.0 blue:232/255.0 alpha:1];
            break;
        case 2:
//            self.color = [UIColor colorWithRed:241/255.0 green:191/255.0 blue:229/255.0 alpha:1];
            self.color = [UIColor colorWithRed:233/255.0 green:208/255.0 blue:251/255.0 alpha:1];
            break;
        case 3:
//            self.color = [UIColor colorWithRed:136/255.0 green:59/255.0 blue:56/255.0 alpha:1];
            self.color = [UIColor colorWithRed:185/255.0 green:216/255.0 blue:250/255.0 alpha:1];
            break;
        case 4:
//            self.color = [UIColor colorWithRed:235/255.0 green:60/255.0 blue:46/255.0 alpha:1];
            self.color = [UIColor colorWithRed:194/255.0 green:252/255.0 blue:253/255.0 alpha:1];
            break;
        case 5:
//            self.color = [UIColor colorWithRed:242/255.0 green:192/255.0 blue:190/255.0 alpha:1];
            self.color = [UIColor colorWithRed:194/255.0 green:253/255.0 blue:229/255.0 alpha:1];
            break;
        case 6:
//            self.color = [UIColor colorWithRed:138/255.0 green:93/255.0 blue:59/255.0 alpha:1];
            self.color = [UIColor colorWithRed:224/255.0 green:253/255.0 blue:186/255.0 alpha:1];
            break;
        case 7:
//            self.color = [UIColor colorWithRed:238/255.0 green:125/255.0 blue:56/255.0 alpha:1];
            self.color = [UIColor colorWithRed:255/255.0 green:254/255.0 blue:188/255.0 alpha:1];
            break;
        case 8:
//            self.color = [UIColor colorWithRed:245/255.0 green:216/255.0 blue:192/255.0 alpha:1];
            self.color = [UIColor colorWithRed:249/255.0 green:218/255.0 blue:184/255.0 alpha:1];
            break;
        case 9:
//            self.color = [UIColor colorWithRed:144/255.0 green:121/255.0 blue:65/255.0 alpha:1];
            self.color = [UIColor colorWithRed:244/255.0 green:182/255.0 blue:181/255.0 alpha:1];
            break;
        case 10:
//            self.color = [UIColor colorWithRed:247/255.0 green:200/255.0 blue:74/255.0 alpha:1];
            self.color = [UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
            break;
        case 11:
//            self.color = [UIColor colorWithRed:249/255.0 green:237/255.0 blue:195/255.0 alpha:1];
            self.color = [UIColor colorWithRed:234/255.0 green:57/255.0 blue:186/255.0 alpha:1];
            break;
        case 12:
//            self.color = [UIColor colorWithRed:146/255.0 green:142/255.0 blue:67/255.0 alpha:1];
            self.color = [UIColor colorWithRed:154/255.0 green:48/255.0 blue:245/255.0 alpha:1];
            break;
        case 13:
//            self.color = [UIColor colorWithRed:254/255.0 green:252/255.0 blue:88/255.0 alpha:1];
            self.color = [UIColor colorWithRed:52/255.0 green:128/255.0 blue:246/255.0 alpha:1];
            break;
        case 14:
//            self.color = [UIColor colorWithRed:251/255.0 green:248/255.0 blue:194/255.0 alpha:1];
            self.color = [UIColor colorWithRed:115/255.0 green:249/255.0 blue:252/255.0 alpha:1];
            break;
        case 15:
            self.color = [UIColor colorWithRed:116/255.0 green:249/255.0 blue:175/255.0 alpha:1];
            break;
        case 16:
//            self.color = [UIColor colorWithRed:156/255.0 green:250/255.0 blue:82/255.0 alpha:1];
            self.color = [UIColor colorWithRed:160/255.0 green:249/255.0 blue:78/255.0 alpha:1];
            break;
        case 17:
//            self.color = [UIColor colorWithRed:221/255.0 green:250/255.0 blue:195/255.0 alpha:1];
            self.color = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:84/255.0 alpha:1];
            break;
        case 18:
//            self.color = [UIColor colorWithRed:80/255.0 green:145/255.0 blue:122/255.0 alpha:1];
            self.color = [UIColor colorWithRed:239/255.0 green:134/255.0 blue:51/255.0 alpha:1];
            break;
        case 19:
//            self.color = [UIColor colorWithRed:119/255.0 green:249/255.0 blue:195/255.0 alpha:1];
            self.color = [UIColor colorWithRed:234/255.0 green:50/255.0 blue:36/255.0 alpha:1];
            break;
        case 20:
//            self.color = [UIColor colorWithRed:202/255.0 green:250/255.0 blue:236/255.0 alpha:1];
            self.color = [UIColor colorWithRed:87/255.0 green:87/255.0 blue:87/255.0 alpha:1];
            break;
        case 21:
//            self.color = [UIColor colorWithRed:75/255.0 green:132/255.0 blue:144/255.0 alpha:1];
            self.color = [UIColor colorWithRed:152/255.0 green:34/255.0 blue:121/255.0 alpha:1];
            break;
        case 22:
//            self.color = [UIColor colorWithRed:106/255.0 green:225/255.0 blue:250/255.0 alpha:1];
            self.color = [UIColor colorWithRed:100/255.0 green:27/255.0 blue:160/255.0 alpha:1];
            break;
        case 23:
//            self.color = [UIColor colorWithRed:200/255.0 green:243/255.0 blue:250/255.0 alpha:1];
            self.color = [UIColor colorWithRed:32/255.0 green:84/255.0 blue:160/255.0 alpha:1];
            break;
        case 24:
//            self.color = [UIColor colorWithRed:61/255.0 green:93/255.0 blue:143/255.0 alpha:1];
            self.color = [UIColor colorWithRed:72/255.0 green:161/255.0 blue:164/255.0 alpha:1];
            break;
        case 25:
//            self.color = [UIColor colorWithRed:55/255.0 green:120/255.0 blue:246/255.0 alpha:1];
            self.color = [UIColor colorWithRed:73/255.0 green:162/255.0 blue:114/255.0 alpha:1];
            break;
        case 26:
//            self.color = [UIColor colorWithRed:194/255.0 green:214/255.0 blue:249/255.0 alpha:1];
            self.color = [UIColor colorWithRed:104/255.0 green:163/255.0 blue:48/255.0 alpha:1];
            break;
        case 27:
//            self.color = [UIColor colorWithRed:92/255.0 green:57/255.0 blue:141/255.0 alpha:1];
            self.color = [UIColor colorWithRed:165/255.0 green:165/255.0 blue:52/255.0 alpha:1];
            break;
        case 28:
//            self.color = [UIColor colorWithRed:132/255.0 green:53/255.0 blue:245/255.0 alpha:1];
            self.color = [UIColor colorWithRed:155/255.0 green:87/255.0 blue:30/255.0 alpha:1];
            break;
        case 29:
//            self.color = [UIColor colorWithRed:217/255.0 green:191/255.0 blue:246/255.0 alpha:1];
            self.color = [UIColor colorWithRed:152/255.0 green:30/255.0 blue:19/255.0 alpha:1];
            break;
        case 30:
            self.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
            break;
        case 31:
            self.color = [UIColor colorWithRed:217/255.0 green:65/255.0 blue:246/255.0 alpha:1];
            break;
        case 32:
            self.color = [UIColor colorWithRed:238/255.0 green:192/255.0 blue:246/255.0 alpha:1];
            break;
        case 33:
            self.color = [UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:1];
            break;
        case 34:
            self.color = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1];
            break;
        case 35:
            self.color = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
            break;
        case 41:
            self.color = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
            break;
            
            break;
        default:
            break;
    }
    
    self.currentColor = self.color;
}

- (XZQDrawingBoard *)mutableCopyWithZone:(NSZone *)drawingBoard{
    
    //
    XZQDrawingBoard *xzqDrawingBoard = [[XZQDrawingBoard alloc] init];
    
    [xzqDrawingBoard setValuesForKeysWithDictionary:self.allDataDict];
    
    return xzqDrawingBoard;
}



//返回上一步
/**
 
 */
- (void)returnLastStep:(XZQDrawingBoardViewController *)drawingBoardView{
    NSLog(@"//返回上一步");
    
    if (self.allPathArray.count != 0) {
        //将数组中最后一个path删除
        NSInteger count = self.allPathArray.count;
        
        [self.saveDeletePathArray addObject:self.allPathArray[count - 1]];
        
        [self.allPathArray removeObject:self.allPathArray[count - 1]];
        
        //重绘
        [self setNeedsDisplay];
    }
    
    
    NSLog(@"self.allPathArray %@",self.allPathArray);
    
}

//返回下一步
- (void)returnNextStep:(XZQDrawingBoardViewController *)drawingBoardView{
    NSLog(@"//返回下一步");
    
    //如果saveDeletePathArray里面有值的话
    if (self.saveDeletePathArray.count != 0) {
        
        [self.allPathArray addObject:self.saveDeletePathArray[self.saveDeletePathArray.count - 1]];
            
            //重绘
        [self setNeedsDisplay];
        
            //把saveDeletePathArray数组中的第0个元素删除掉
        [self.saveDeletePathArray removeObject:self.saveDeletePathArray[self.saveDeletePathArray.count - 1]];
    }
    
    NSLog(@"self.saveDelegatePathArray %@",self.saveDeletePathArray);
    
}















#pragma 归档解档

/**
 支持加密编码
 
 */
//暂时不用
+ (BOOL)supportsSecureCoding{
    return YES;
}

//解档
//暂时不用
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    NSLog(@"initWithCoder");
    
    if (self) {
        
        if ([aDecoder decodeObjectForKey:@"image"] != nil) {
            _image = [aDecoder decodeObjectOfClass:[UIImage class] forKey:@"image"];
        }
        
        _imageFromCGContext = [aDecoder decodeObjectOfClass:[UIImage class] forKey:@"imageFromCGContext"];
        _index = [aDecoder decodeIntegerForKey:@"index"];
        
        //        _path = [aDecoder decodeObjectOfClass:[MyBezierPath class] forKey:@"path"];
        _currentPath = [aDecoder decodeObjectOfClass:[UIBezierPath class] forKey:@"currentPath"];
        
        _allPathArray = [aDecoder decodeObjectOfClass:[NSMutableArray class] forKey:@"allPathArray"];
        _width = [aDecoder decodeFloatForKey:@"width"];
        _color = [aDecoder decodeObjectOfClass:[UIColor class] forKey:@"color"];
        _paint = [aDecoder decodeBoolForKey:@"paint"];
        _paintingBoardArray = [aDecoder decodeObjectOfClass:[NSMutableArray class] forKey:@"paintingBoardArray"];
        _allDataDict = [aDecoder decodeObjectOfClass:[NSMutableDictionary class] forKey:@"allDataDict"];
    }
    
    return self;
}

//归档
//暂时不用
- (void)encodeWithCoder:(NSCoder *)aCoder{
    NSLog(@"encodeWithCoder");
    if (self.image != nil) {
        [aCoder encodeObject:self.image forKey:@"image"];
    }
    
    [aCoder encodeObject:self.imageFromCGContext forKey:@"imageFromCGContext"];
    [aCoder encodeInteger:self.index forKey:@"index"];
    
    //    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:self.currentPath forKey:@"currentPath"];
    
    [aCoder encodeObject:self.allPathArray forKey:@"allPathArray"];
    [aCoder encodeFloat:self.width forKey:@"width"];
    [aCoder encodeObject:self.color forKey:@"color"];
    [aCoder encodeBool:self.paint forKey:@"paint"];
    [aCoder encodeObject:self.paintingBoardArray forKey:@"paintingBoardArray"];
    [aCoder encodeObject:self.allDataDict forKey:@"allDataDict"];
    
    NSLog(@"after encodeWithCoder");
}


//暂时不用
- (void)saveBtn:(UIButton *)sender ChineseName:(NSString *)chineseName EnglishName:(NSString *)englishName superPath:(NSString *)superPath superPaintingBoardPath:(NSString *)superPaintingBoardPath{
    
    //保存图片到画册和相册中
    [self saveBtn:sender ChineseName:chineseName EnglishName:englishName superPath:superPath];
    
    //保存此对象到内存中 用到的时候取出来
    
    //存在free图集中   superPaintingBoardPath    和video文件夹同级  altasPaintingBoardPath free图集
    NSString *altasPaintingBoardPath = [superPaintingBoardPath stringByAppendingPathComponent:englishName];
    
    self.currentAltasPath = altasPaintingBoardPath;
    
    //plist文件路径 下面的存储路径
    NSString *filePath = [altasPaintingBoardPath stringByAppendingPathComponent:@"paintingBoardArray_1.plist"];
    
    if ([self.manager fileExistsAtPath:filePath]) {
        
        NSLog(@"有 不用创建");
        
        //已经存在 需要检索有多少个plist文件 然后再建立plist文件
        
        //看看free图集下有多少plist文件了
        NSArray *array = [self.manager contentsOfDirectoryAtPath:altasPaintingBoardPath error:nil];
        NSUInteger count = array.count;
        
        NSString *altasPathSubpath = [altasPaintingBoardPath stringByAppendingPathComponent:[NSString stringWithFormat:@"paintingBoardArray_%ld.plist",(count+1)]];
        
        filePath = altasPathSubpath;
        
        self.index = count + 1;
        
        NSLog(@"filePath = %@ index = %ld",altasPathSubpath,self.index);
        
        
    }else{
        
        NSLog(@"没有创建 现在创建");
        
        //没有创建 现在创建
        [self.manager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        self.index = 1;
        
        //创建成功plist文件之后
        
        //使用NSKeyedArchiver进行归档 只能对遵守NSSecureCoding的类进行归档 UIImageView 默认没有遵守此协议 因为默认UIImageView不能进行归档
    }
    
    UIBezierPath *temp = [[UIBezierPath alloc] init];
    
    //画完结束 将当前的路径和颜色保存下来
    for (UIBezierPath *path in self.allPathArray) {
        
        temp.lineJoinStyle = path.lineJoinStyle;
        temp.lineCapStyle = path.lineCapStyle;
        temp.lineWidth = path.lineWidth;
        
        
        
    }
    
    
    
    NSError *error = nil;//?
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:YES error:&error];
    [data writeToFile:filePath atomically:YES];
    [data writeToFile:@"/Users/dmt312/Desktop/nn.plist" atomically:YES];
    
    if (data == nil || error) {
        NSLog(@"归档失败:%@",error);
    }else{
        NSLog(@"归档成功");
    }
    
    
    
    
    
}

//暂时不用
- (XZQDrawingBoard *)getPaintingBoard:(NSUInteger)row{
    
    NSArray *array = [self.manager contentsOfDirectoryAtPath:self.currentAltasPath error:nil];
    NSUInteger count = array.count;
    
    NSLog(@"array.count = %ld",count);
    
    if (row == 0 || row > count) {
        return nil;
    }else{
        
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/paintingBoardArray_%ld.plist",self.currentAltasPath,row]];
        
        NSLog(@"data = %@",data);
        
        XZQDrawingBoard *drawingBoard = [NSKeyedUnarchiver unarchivedObjectOfClass:[XZQDrawingBoard class] fromData:data error:&error];
        
        if (drawingBoard == nil) {
            NSLog(@"drawingBoard == nil error:%@",error);
        }
        
        if (drawingBoard.image != nil) {
            self.image = drawingBoard.image;
        }
        
        
        
        NSLog(@"drawingBoard = %@",drawingBoard);
        
        //        self.imageFromCGContext = drawingBoard.imageFromCGContext;
        //        self.index = drawingBoard.index;
        //        self.path = drawingBoard.path;
        //        self.allPathArray = drawingBoard.allPathArray;
        //        self.width = drawingBoard.width;
        //        self.color = drawingBoard.color;
        //        self.paint = drawingBoard.paint;
        //        self.paintingBoardArray = drawingBoard.paintingBoardArray;
        //        self.allDataDict = drawingBoard.allDataDict;
        
        NSLog(@"执行结束");
        
        return drawingBoard;
    }
    
    
    
    return nil;
}



@end

