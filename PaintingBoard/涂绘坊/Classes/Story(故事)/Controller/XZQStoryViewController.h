//
//  XZQStoryViewController.h
//  涂绘坊
//
//  Created by dmt312 on 2019/5/11.
//  Copyright © 2019 xzq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZQStoryViewController;
NS_ASSUME_NONNULL_BEGIN

@protocol XZQStoryViewControllerDelegate <NSObject>

@optional
- (void)playVideo:(XZQStoryViewController *)story videoName:(NSString *)videoName;


/**
 只传递了在线播放教学视频的url

 @param story 控制器本身
 @param url 在线视频url
 */
- (void)playVideoOnline:(XZQStoryViewController *)story videoURL:(NSURL *)url;



/**
 传递在线播放视频的url还有视频的中文和英文名称

 @param story 控制器本身
 @param url 在线视频url
 @param chineseName 中文名
 @param englishName 英文名
 */
- (void)playVideoOnline:(XZQStoryViewController *)story videoURL:(NSURL *)url ChineseName:(NSString *)chineseName EnglishName:(NSString *)englishName;




/**
 传递在线播放视频的url还有视频的中文和英文名称
 
 @param story 控制器本身
 @param url 在线视频url
 @param chineseName 中文名
 @param englishName 英文名
 @param superPath 存储的父目录
 */
- (void)playVideoOnline:(XZQStoryViewController *)story videoURL:(NSURL *)url ChineseName:(NSString *)chineseName EnglishName:(NSString *)englishName superPath:(NSString *)superPath;



/**
 传递在线播放视频的url还有视频的中文和英文名称
 
 @param story 控制器本身
 @param url 在线视频url
 @param chineseName 中文名
 @param englishName 英文名
 @param superPath 存储图片的父目录
 @param superPaintingBoardPath 存储画板对象的父目录
 */
- (void)playVideoOnline:(XZQStoryViewController *)story videoURL:(NSURL *)url ChineseName:(NSString *)chineseName EnglishName:(NSString *)englishName superPath:(NSString *)superPath superPaintingBoardPath:(NSString *)superPaintingBoardPath;



/**
 传递录音文件信息数组

 @param story self
 @param array array
 */
- (void)showRecordMessage:(XZQStoryViewController *)story messageArray:(NSMutableArray *)array;


/**
 传递recordSoundFolderPath

 @param recordSoundFolderPath  路径
 */
- (void)postRecordSoundFolderPath:(NSString *)recordSoundFolderPath;

//传递故事动画的url
- (void)postStoryVideoURL:(XZQStoryViewController *)vc videoURL:(NSURL *)videoURL;



@end

@interface XZQStoryViewController : UIViewController
/**代理 */
@property(nonatomic,readwrite,weak) id <XZQStoryViewControllerDelegate>delegate;

/** 代理2 画板对象*/
@property(nonatomic,readwrite,weak) id <XZQStoryViewControllerDelegate>delegate2;

@property(nonatomic, weak) id<XZQStoryViewControllerDelegate> storyVideoPlayerDelegate;
@end

NS_ASSUME_NONNULL_END
