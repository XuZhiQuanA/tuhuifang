//
//  SYAudioFile.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/11/18.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "SYAudioFile.h"

@implementation SYAudioFile


/// 录音文件保存路径（fileName 如：20180722.aac，或20180722.caf）
+ (NSString *)SYAudioDefaultFilePath:(NSString *)fileName
{
    NSString *fileNameTmp = fileName;
    
    //filfName就是录音文件夹的路径
    //先检索次文件夹下有多少个文件 然后名称+1
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *array = [manager contentsOfDirectoryAtPath:fileName error:nil];
    NSInteger count = array.count;
    
    NSString *filePath = [fileName stringByAppendingPathComponent:[NSString stringWithFormat:@"caf_%ld.caf",(count+1)]];
    NSLog(@"录音文件保存路径 filePath = %@",filePath);
    
    if (!fileNameTmp || fileNameTmp.length <= 0) {
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYYMMddHHmmss"];
        // 文件名称（aac, caf）
        fileNameTmp = [dateFormatter stringFromDate:currentDate];
        fileNameTmp = [NSString stringWithFormat:@"%@.caf", fileNameTmp];
    }

    return filePath;
}

//新录音文件保存路径 以按钮的名称为名 每一个情节只允许有一个录音
+ (NSString *)SYAudioDefaultFilePath:(NSString *)fileName innerName:(NSString *)innterName
{
    NSString *fileNameTmp = fileName;
    
    NSString *filePath = [fileName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",innterName]];
    NSLog(@"录音文件保存路径 filePath = %@",filePath);
    
    if (!fileNameTmp || fileNameTmp.length <= 0) {
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYYMMddHHmmss"];
        // 文件名称（aac, caf）
        fileNameTmp = [dateFormatter stringFromDate:currentDate];
        fileNameTmp = [NSString stringWithFormat:@"%@.caf", fileNameTmp];
    }

    return filePath;
}

/// MP3文件路径（fileName 如：2015875.mp3）
+ (NSString *)SYAudioMP3FilePath:(NSString *)fileName
{
    NSString *fileNameTmp = fileName;
    if (!fileNameTmp || fileNameTmp.length <= 0) {
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYYMMddHHmmss"];
        // 文件名称（mp3）
        fileNameTmp = [dateFormatter stringFromDate:currentDate];
        fileNameTmp = [NSString stringWithFormat:@"%@.mp3", fileNameTmp];
    }
    NSString *mp3FilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:mp3FilePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:mp3FilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //
    mp3FilePath = [mp3FilePath stringByAppendingPathComponent:fileNameTmp];
    //
    return mp3FilePath;
}

/// 获取文件名（包含后缀，如：xxx.acc；不包含文件类型，如xxx）
+ (NSString *)SYAudioGetFileNameWithFilePath:(NSString *)filePath type:(BOOL)hasFileType
{
    NSString *fileName = [filePath stringByDeletingLastPathComponent];
    if (hasFileType)
    {
        fileName = [filePath lastPathComponent];
    }
    return fileName;
}

/// 获取文件大小
+ (long long)SYAudioGetFileSizeWithFilePath:(NSString *)filePath
{
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (isExist)
    {
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        long long fileSize = fileDict.fileSize;
        return fileSize;
    }
    
    return 0.0;
}

/// 删除文件
+ (void)SYAudioDeleteFileWithFilePath:(NSString *)filePath
{
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (isExist)
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

@end
