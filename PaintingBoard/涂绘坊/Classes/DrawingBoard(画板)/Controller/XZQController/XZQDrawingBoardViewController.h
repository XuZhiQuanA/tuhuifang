//
//  XZQDrawingBoardViewController.h
//  涂绘坊
//
//  Created by dmt312 on 2019/5/11.
//  Copyright © 2019 xzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZQPopViewBaseController.h"
@class XZQDrawingBoard;

NS_ASSUME_NONNULL_BEGIN

@class XZQDrawingBoardViewController;


@protocol XZQDrawingBoardViewDelegate <NSObject>


@optional
- (void)setPaintWidth:(XZQDrawingBoardViewController *)drawingBoardView tagOfButton:(NSInteger)tag;
- (void)setPaintColor:(XZQDrawingBoardViewController *)drawinBoardView tagOfButton:(NSInteger)tag;
- (void)clearAllPath;
- (void)saveBtn:(UIButton *)sender;

/**
 发送录音文件夹的路径

 @param drawingBoardView self
 @param recordSoundPath 路径
 */
- (void)postRecordSoundFolderPath:(XZQDrawingBoardViewController *)drawingBoardView recordSoundPath:(NSString *)recordSoundPath cafPath:(NSString *)cafPath;

/**
 保存的时候判断存储在哪个图集
 
 @param sender 按钮
 @param chineseName 中文名
 @param englishName 英文名
 */
- (void)saveBtn:(UIButton *)sender ChineseName:(NSString *)chineseName EnglishName:(NSString *)englishName;




/**
 保存的时候判断存储在哪个图集
 
 @param sender 按钮
 @param chineseName 中文名
 @param englishName 英文名
 @param superPath 要存储的父目录
 */
- (void)saveBtn:(UIButton *)sender ChineseName:(NSString *)chineseName EnglishName:(NSString *)englishName superPath:(NSString *)superPath;



/**
 单纯的建立一个free文件夹
 
 @param englishName 英文名
 @param superPath 要存储的父目录
 
 */
- (void)saveFreeFolderWithEnglishName:(NSString *)englishName superPath:(NSString *)superPath;


/**
 保存的时候判断存储在哪个图集
 
 @param sender 按钮
 @param chineseName 中文名
 @param englishName 英文名
 @param superPath 要存储图片的父目录
 @param superPaintingBoardPath 要存储画板的父目录
 */
- (void)saveBtn:(UIButton *)sender ChineseName:(NSString *)chineseName EnglishName:(NSString *)englishName superPath:(NSString *)superPath superPaintingBoardPath:(NSString *)superPaintingBoardPath;



/**
 向画册界面发送superPath
 
 @param superPath superPath的值
 */
- (void)postSuperpath:(NSString *)superPath;


/**
 @param row 加减数
 @return 返回一个画板
 */
- (XZQDrawingBoard *)getPaintingBoard:(NSUInteger)row;



/**
 切换画板的背景图片
 
 @param count 点击左右的计数器
 
 */
- (NSInteger)setBackImage:(NSInteger)count;


/**
 返回上一步

 @param drawingBoardView self
 */
- (void)returnLastStep:(XZQDrawingBoardViewController *)drawingBoardView;



/**
 返回下一步

 @param drawingBoardView    self
 */
- (void)returnNextStep:(XZQDrawingBoardViewController *)drawingBoardView;

- (void)postPicturePath:(XZQDrawingBoardViewController *)drawingBoardView picturePath:(NSString *)picturePath;

@end

@interface XZQDrawingBoardViewController : UIViewController
/**代理*/
@property(nonatomic,weak) id<XZQDrawingBoardViewDelegate> delegate;

/** 代理2*/
@property(nonatomic,readwrite,weak) id<XZQDrawingBoardViewDelegate> delegate2;

/** 代理3 */
@property(nonatomic,readwrite,weak) id<XZQDrawingBoardViewDelegate> delegate3;

/** 代理4*/
@property(nonatomic,readwrite,weak) id<XZQDrawingBoardViewDelegate> delegate4;

/**储存时的父目录 */
@property(nonatomic,readwrite,strong) NSString *superPath;

/**图集中文名 */
@property(nonatomic,readwrite,strong) NSString *ChineseName;

/**英文名 */
@property(nonatomic,readwrite,strong) NSString *EnglishName;

/**切换用的静态变量*/
@property(nonatomic,assign) NSInteger switchCount;

/**是否点击了保存按钮*/
@property(nonatomic,assign) BOOL saveClick;

//故事情节界面是否点击了plus按钮
@property(nonatomic, assign) BOOL isClickPlusBtn;

@end

NS_ASSUME_NONNULL_END
