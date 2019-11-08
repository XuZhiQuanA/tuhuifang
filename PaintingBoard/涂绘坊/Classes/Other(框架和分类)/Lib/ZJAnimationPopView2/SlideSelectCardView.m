//
//  SlideSelectCardView.m
//  ZJAnimationPopViewDemo
//
//  Created by abner on 2017/8/16.
//  Copyright © 2017年 Abnerzj. All rights reserved.
//

#import "SlideSelectCardView.h"
#import "SYAudio.h"
#import "XZQStoryViewController.h"
#import "XZQShowRecordMessageCellTableViewCell.h"

/**
 #import "XZQDrawingBoard.h"
 #import "MyBezierPath.h"
 #import "XZQDrawingBoardViewController.h"
 */

//#define kPageCount 3

@interface SlideSelectCardView ()<UITableViewDelegate,UITableViewDataSource,SYAudioDelegate,XZQStoryViewControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *operationLabel;
@property (weak, nonatomic) IBOutlet UIButton *smallBtn;

@property (weak, nonatomic) IBOutlet UIButton *bigBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

/**<#备注#> */
@property(nonatomic,readwrite,strong) UIImageView *imageView;

/**保存当前的count */
@property(nonatomic,readwrite,assign) NSInteger count;
@property (weak, nonatomic) IBOutlet UIButton *currentBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**保存录音文件路径的数组 */
@property(nonatomic,readwrite,strong) NSMutableArray *array;


@property (weak, nonatomic) IBOutlet UILabel *storyName;

@property (weak, nonatomic) IBOutlet UIImageView *storyImageView;

@property (weak, nonatomic) IBOutlet UITextField *countNumber;

//改变画板颜色
@property (weak, nonatomic) IBOutlet UISwitch *boardColorSwitch;


@property (weak, nonatomic) IBOutlet UISlider *widthSlider;

@property (weak, nonatomic) IBOutlet UIImageView *widthImageView;

@property (weak, nonatomic) IBOutlet UILabel *widthLabel;

@property (weak, nonatomic) IBOutlet UILabel *widthCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *eraserImageView;

//@property (weak, nonatomic) IBOutlet UIView *superViewOfStoryVideoPlayer;


/**保存是否改变画板颜色*/
//@property(nonatomic,assign) BOOL isSwitchOn;


//xib20属性
@property (weak, nonatomic) IBOutlet UIImageView *systemPictureImageView;

@end

@implementation SlideSelectCardView

- (void)setSystemPicture:(UIImage *)systemPicture{
    _systemPicture = systemPicture;
    
    NSLog(@"setSystemPicture -  %@ systemPictureImageView = %@",systemPicture,self.systemPictureImageView);
    
    self.systemPictureImageView.image = _systemPicture;
}

- (void)setWidthImage:(UIImage *)widthImage{
    
    _widthImage = widthImage;
    self.widthImageView.image = _widthImage;

}

- (void)setEraserImage:(UIImage *)eraserImage{
    _eraserImage = eraserImage;
    
    self.eraserImageView.image = _eraserImage;
}


//判断输入的是数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (void)setRecordDownloadPersent:(UILabel *)recordDownloadPersent{
    _recordDownloadPersent = recordDownloadPersent;
    
    self.loadPersent.text = _recordDownloadPersent.text;
}


- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

//保存画笔的宽度
//保存颜色按钮的tag
static NSInteger i = 1;
static NSInteger j = 0;
static NSInteger widthCount = 10;

BOOL SlideSelectCardViewflag = NO;
BOOL isSwitchOn = NO;

- (void)awakeFromNib
{
    
    
    [super awakeFromNib];
    
    
    [self.tableView registerClass:[XZQShowRecordMessageCellTableViewCell class] forCellReuseIdentifier:@"recordCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XZQShowRecordMessageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"recordCell"];
    SlideSelectCardViewflag = YES;
    
    //self成为录音类的代理
    [SYAudio shareAudio].audioRecorder.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width, self.contentScrollView.contentSize.height);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.bounces = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    
    CGFloat contentScrollViewW = self.contentScrollView.frame.size.width;
    CGFloat contentScrollViewH = self.contentScrollView.frame.size.height;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentScrollViewW, contentScrollViewH)];
    self.imageView = imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFit;


    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentScrollView addSubview:imageView];
    
    //第二个view
    if (self.countLabel != nil) {
        
        self.count = i;
        self.countLabel.text = [NSString stringWithFormat:@"%ld",self.count];
    }
    
    if (self.countNumber != nil) {
        self.count = i;
        self.countNumber.text = [NSString stringWithFormat:@"%ld",self.count];
    }
    
    if (self.currentBtn != nil) {
        self.currentBtn.tag = j;
        [self.currentBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"colorBlock%ld",(self.currentBtn.tag+1)]]  forState:UIControlStateNormal];
    }
    
    
    //省得懒加载了
    if (!_recordDownloadPersent) {
        _recordDownloadPersent = [[UILabel alloc] init];
    }
    
    
    //监听音频下载进度
    [self.recordDownloadPersent addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    if (isSwitchOn) {
        
        self.boardColorSwitch.on = YES;
        
    }else{
        
        self.boardColorSwitch.on = NO;
    }
    
    //UISlider 逆时针 90度
    self.widthSlider.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.widthSlider.value = widthCount;
//    self.widthSlider.backgroundColor = [UIColor blueColor];
    
//    self.widthImageView.backgroundColor = [UIColor yellowColor];
    
    self.widthCountLabel.text = [NSString stringWithFormat:@"%ld",widthCount];
    
//    UILabel *widthLabel = ({
//
//        UILabel *widthLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.center.x, 100, 100, 50)];
//        widthLabel.center = CGPointMake(self.titleLabel.center.x,150);
//
//        widthLabel.text = @"当前大小 :";
//        widthLabel.backgroundColor = [UIColor redColor];
//        [self addSubview:widthLabel];
//
//
//        widthLabel;
//
//
//    });
    
//    _widthLabel = widthLabel;
    
//    UILabel *widthCountLabel = ({
//
//        UILabel *widthCountLabel = [[UILabel alloc] init];
//        widthCountLabel.center = CGPointMake(self.titleLabel.center.x, 230);
//        widthCountLabel.bounds = CGRectMake(0, 0, 100, 80);
//        widthCountLabel.text = [NSString stringWithFormat:@"%ld",widthCount];
//        widthCountLabel.textAlignment = NSTextAlignmentCenter;
//        [widthCountLabel setFont:[UIFont systemFontOfSize:40]];
//        widthCountLabel.backgroundColor = [UIColor grayColor];
//        [self addSubview:widthCountLabel];
//
//        widthCountLabel;
//
//    });
//
//    _widthCountLabel = widthCountLabel;

        
        

    
    
        
//    }
    
    //设置弹框圆角
    [self setSelfRadius];
    
    if (self.systemPicture != nil) {
        self.systemPictureImageView.image = self.systemPicture;
    }
}

#pragma mark -----------------------------
#pragma mark 改变笔触大小

- (IBAction)changeWidth:(UISlider *)sender {
    
    NSInteger width = [[NSString stringWithFormat:@"%.0f",sender.value] integerValue];
    self.widthCountLabel.text = [NSString stringWithFormat:@"%ld",width];
    widthCount = width;
    
}


#pragma mark -----------------------------
#pragma mark 确定和取消方法


- (IBAction)selectedAction:(UIButton *)sender {
    
    isSwitchOn = self.boardColorSwitch.on;
    
    NSLog(@"点击了确定 isSwitch = %d",isSwitchOn);
    
    //发出通知 移除弹框
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disappearSelfDefinePopView" object:nil];
    
    
    //在点击画板最上面的按钮时 不能调用后面的方法 所以return
    if (sender.tag == 60) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(getCountFromZJXibFoctory:count:)]) {
        
        //之前使用输入框的时候使用的代码
//        i = [self.countNumber.text integerValue];
//
//        if (i == 0) {
//            i++;
//            self.countNumber.text = [NSString stringWithFormat:@"%ld",i];
//        }
        
        [self.delegate getCountFromZJXibFoctory:self count:widthCount];
        
//        NSLog(@"画笔界面选择好了画笔的宽度 : %ld",[self.countNumber.text integerValue]);
    }
    
//
//    if ([self.title isEqualToString:@"橡皮擦"] || [self.title isEqualToString:@"铅笔"]) {
//        
//
//
//    }else{
//
//
//        //不让设置大小的按钮设置颜色
//
//        //让代理设置颜色
////        if ([self.delegate respondsToSelector:@selector(setColorOfPencil:colorBtn:)]) {
////            j = self.currentBtn.tag;
////            [self.delegate setColorOfPencil:self colorBtn:self.currentBtn];
////
////            NSLog(@"设置完成画笔颜色 tag:%ld",self.currentBtn.tag);//调用了 还是黑色
////        }
//
//        if ([self.delegate respondsToSelector:@selector(boardColorSwitchIsOn:on:)]) {
//
//            [self.delegate boardColorSwitchIsOn:self on:self.boardColorSwitch.on];
//
//        }
//    }
    
}

- (IBAction)cancel:(UIButton *)sender {
    
    isSwitchOn = NO;
    
    NSLog(@"cancel isSwitch = %d",isSwitchOn);
    if ([self.delegate respondsToSelector:@selector(dismissPopView:dismissBtn:)]) {
        [self.delegate dismissPopView:self dismissBtn:sender];
    }
    
}

#pragma KVO监听音频下载进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void*)contex{
    
    
    
    self.loadPersent.text = [(UILabel *)object text];
    
}


- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setShowOperaion:(NSString *)showOperaion{
    _showOperaion = showOperaion;
    self.operationLabel.text = showOperaion;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = _image;
    
}

- (void)setStoryOrPlotImage:(UIImage *)storyOrPlotImage{
    _storyOrPlotImage = storyOrPlotImage;
    
    self.storyImageView.image = storyOrPlotImage;
    self.storyImageView.layer.cornerRadius = 10;
    self.storyImageView.clipsToBounds = YES;
    self.storyImageView.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (IBAction)smaller:(id)sender{
    NSLog(@"smaller");
    self.count--;
    if (self.count == 0) {
        self.count = 1;
    }
    
    self.countNumber.text = [NSString stringWithFormat:@"%ld",self.count];
    
    if (self.countLabel != nil) {
        self.countLabel.text = [NSString stringWithFormat:@"%ld",self.count];
    }
    
    i = _count;
}

- (IBAction)bigger:(id)sender {
    NSLog(@"bigger");
    self.count++;
    
    self.countNumber.text = [NSString stringWithFormat:@"%ld",self.count];
    
    if (self.countLabel != nil) {
        self.countLabel.text = [NSString stringWithFormat:@"%ld",self.count];
    }
    
    i = _count;
}

- (IBAction)colorBtn:(UIButton *)sender {
    
    //改变那个用于显示点击了什么颜色的按钮的背景
    NSLog(@"colorBtn");
    
    //下面这句代码没有用 ！！！！！！
//    [self.currentBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"colorBlock%ld",sender.tag]] forState:UIControlStateNormal];
    
    self.currentBtn.tag = sender.tag;
    j = sender.tag;
    
    [self.currentBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"colorBlock%ld",(sender.tag+1)]]  forState:UIControlStateNormal];
    
    NSLog(@"tag:%ld",self.currentBtn.tag);
    
}



#pragma UITableView代理和数据源方法
#pragma mark - UITableViewDataSource, UITableViewDelegate

//会用到
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.array.count != 0) {
        return self.array.count;
    }
    return 0;
}

static NSInteger recordCount = 12;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString * identifier = @"recordCell";
//    XZQShowRecordMessageCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    XZQShowRecordMessageCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[XZQShowRecordMessageCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
//        cell = [XZQShowRecordMessageCellTableViewCell alloc]
        
        cell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        cell.layoutMargins = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
//        cell.textLabel.textColor = [UIColor blackColor];
//        cell.detailTextLabel.textColor = [UIColor orangeColor];
        
//        cell.textLabel.adjustsFontSizeToFitWidth = YES;
//        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        cell.recordNameTextField.adjustsFontSizeToFitWidth = YES;
        cell.recordTimeConcreate.adjustsFontSizeToFitWidth = YES;
        cell.recordName.adjustsFontSizeToFitWidth = YES;
        cell.recordTime.adjustsFontSizeToFitWidth = YES;
    }
    
    if (self.array.count != 0) {
        NSDictionary *dict = self.array[indexPath.row];
        NSString *fileName = dict[@"FileName"];
        //    NSNumber *fileSize = dict[@"FileSize"];
        NSNumber *fileTime = dict[@"FileTime"];
        NSString *filePath = dict[@"FilePath"];
        
        NSLog(@"self.array.count != 0 %@",dict);
        
        //    cell.textLabel.text = [NSString stringWithFormat:@"%@(size=%@Byte duration=%.2fs)", fileName, fileSize, fileTime.doubleValue];
        //    cell.detailTextLabel.text = filePath;
        
        if (recordCount >= 12 && recordCount <= 16) {
            recordCount++;
        }else{
            recordCount = 12;
        }
        
        
        //监听录音名称的改变
        //    [cell.recordNameTextField addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
        
        NSMutableDictionary *Datadict = [NSMutableDictionary dictionary];
        
        [Datadict setObject:fileName forKey:@"fileName"];
        [Datadict setObject:[NSString stringWithFormat:@"%.2fs",fileTime.doubleValue] forKey:@"fileTimeConcreate"];
        [Datadict setObject:filePath forKey:@"filePath"];
        [Datadict setObject:[UIImage imageNamed:[NSString stringWithFormat:@"sound_%ld",recordCount]] forKey:@"recordImageView"
         ];
        
        
        cell.dataDict = Datadict;
        
        //传递recordSoundPath
        cell.recordSoundPath = self.recordSoundFolderPath;
    }else{
        
        NSLog(@"array == 0LLL");
    }
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.array[indexPath.row];
    NSString *filePath = dict[@"FilePath"];
    //
    [SYAudio shareAudio].audioPlayer.delegate = self;
    [[SYAudio shareAudio].audioPlayer playerStart:filePath complete:^(BOOL isFailed) {
        
        NSLog(@"音频文件无效");

    }];
    
    //点击了录音列表中的cell 发出让情节Plot变大的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"biggerPlot" object:nil];
}

//设置cell高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

- (void)showRecordMessage:(XZQStoryViewController *)story messageArray:(NSMutableArray *)array{
    
    if (array == nil) {
        NSLog(@"传递的array 为nil");
    }
    
    NSLog(@"调用了showRecordMessage array = %@",array);
    
    self.array = array;

    [self.tableView reloadData];
}

- (void)postRecordSoundFolderPath:(NSString *)recordSoundFolderPath{
    self.recordSoundFolderPath = recordSoundFolderPath;
}



- (IBAction)onlinePlay:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onlinePlayFromXib" object:nil];
    
}

- (IBAction)downloadPlay:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadPlayFromXib" object:nil];
}

- (IBAction)studyClass:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"studyClassFromXib" object:nil];
}

- (IBAction)storyPlot:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"storyPlotFromXib" object:nil];
}


- (IBAction)suspendDownload:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"suspendDownloadFromXib" object:nil];
    
}

- (IBAction)goOnDownload:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goOnDownloadFromXib" object:nil];
}

- (IBAction)cancelDownload:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelDownloadFromXib" object:nil];
}

- (IBAction)onlinePlayRecordFromXib:(id)sender {
    NSLog(@"点击了点击了点击了onlinePlayRecordFromXib");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onlinePlayRecordFromXib" object:nil];
}

- (IBAction)listenSelfRecordFromXib:(id)sender {
    NSLog(@"点击了点击了点击了listenSelfRecordFromXib");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"listenSelfRecordFromXib" object:nil];
}

- (IBAction)downloadRecordFromXib:(id)sender {
    NSLog(@"点击了点击了点击了downloadRecordFromXib");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadRecordFromXib" object:nil];
}

- (IBAction)cancelRecordFromXib:(id)sender {
    NSLog(@"点击了点击了点击了cancelRecordFromXib");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelRecordFromXib" object:nil];
}

- (IBAction)suspendVideoDownload:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"suspendVideoDownload" object:nil];
}

- (IBAction)goOnVideoDownload:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goOnVideoDownload" object:nil];
}

- (IBAction)cancelVideoDownload:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelVideoDownload" object:nil];
}

- (IBAction)externalPicture:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"externalPicture" object:nil];
}

- (IBAction)externalVideo:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"externalVideo" object:nil];
}



- (IBAction)watchStoryVideo:(UIButton *)btn{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"watchStoryVideo" object:nil];
}

- (IBAction)listenToSelfAndWatchVideo:(UIButton *)btn{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"listenToSelfAndWatchVideo" object:nil];
}

- (IBAction)toStudyThis:(UIButton *)btn{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toStudyThis" object:nil];
}

#pragma 弹框圆角
- (void)setSelfRadius{
    self.layer.cornerRadius = 10;
}



@end

