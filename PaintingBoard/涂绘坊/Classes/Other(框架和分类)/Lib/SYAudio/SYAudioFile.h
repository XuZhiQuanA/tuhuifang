//
//  SYAudioFile.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/11/18.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//  音频文件处理

#import <Foundation/Foundation.h>

@interface SYAudioFile : NSObject

/// 录音文件保存路径（fileName 如：20180722.aac）
+ (NSString *)SYAudioDefaultFilePath:(NSString *)fileName;
/// MP3文件路径（fileName 如：2015875.mp3）
+ (NSString *)SYAudioMP3FilePath:(NSString *)fileName;

/// 获取文件名（包含后缀，如：xxx.acc；不包含文件类型，如xxx）
+ (NSString *)SYAudioGetFileNameWithFilePath:(NSString *)filePath type:(BOOL)hasFileType;

/// 获取文件大小
+ (long long)SYAudioGetFileSizeWithFilePath:(NSString *)filePath;

/// 删除文件
+ (void)SYAudioDeleteFileWithFilePath:(NSString *)filePath;

//recordSound路径
//+ (NSString *)SYAudioRecordSoundFilePath:(NSString *)recordSoundFilePath;

//新的保存录音文件地址的方法
+ (NSString *)SYAudioDefaultFilePath:(NSString *)fileName innerName:(NSString *)innterName;


@end
