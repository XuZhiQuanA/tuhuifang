//
//  SYAudioRecord.m
//  zhangshaoyu
//
//  Created by Herman on 2018/8/5.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//

#import "SYAudioRecord.h"
#import <UIKit/UIKit.h>

#import "lame.h"
#import "SYAudioFile.h"
#import "SYAudioTimer.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface SYAudioRecord () <AVAudioRecorderDelegate>

@property (nonatomic, strong) NSMutableDictionary *recorderDict; // 录音设置
@property (nonatomic, strong) AVAudioRecorder *recorder; // 录音
@property (nonatomic, strong) NSString *recorderFilePath;

@property (nonatomic, strong) NSTimer *voiceTimer; // 录音音量计时器

@property (nonatomic, strong) NSTimer *timecountTimer; // 录音倒计时计时器
@property (nonatomic, assign) NSTimeInterval timecountTime; // 录音倒计时时间

@end

@implementation SYAudioRecord

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.monitorVoice = NO;
    }
    
    return self;
}

// 内存释放
- (void)dealloc
{
    [self recorderStop];
    [self stopVoiceTimer];
    [self stopTimecountTimer];
    
    if (self.recorderDict) {
        self.recorderDict = nil;
    }
    
    if (self.recorder) {
        self.recorder.delegate = nil;
        self.recorder = nil;
    }
}

#pragma mark - getter

- (NSMutableDictionary *)recorderDict
{
    if (_recorderDict == nil) {
        // 参数设置 格式、采样率、录音通道、线性采样位数、录音质量
        _recorderDict = [NSMutableDictionary dictionary];
        // kAudioFormatMPEG4AAC ：xxx.acc；kAudioFormatLinearPCM ：xxx.caf
        [_recorderDict setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [_recorderDict setValue:[NSNumber numberWithInt:16000] forKey:AVSampleRateKey];
        [_recorderDict setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [_recorderDict setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [_recorderDict setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    }
    return _recorderDict;
}

#pragma mark - 录音

/// 开始录音
- (void)recorderStart:(NSString *)filePath complete:(void (^)(BOOL isFailed))complete
{
    if (!filePath || filePath.length <= 0) {
        if (complete) {
            complete(YES);
        }
        return;
    }
    
    // 强转音频格式为xx.caf
    BOOL isCaf = [filePath hasSuffix:@".caf"];
    if (isCaf) {
        self.recorderFilePath = filePath;
    } else {
        NSRange range = [filePath rangeOfString:@"." options:NSBackwardsSearch];
        NSString *filePathTmp = [filePath substringToIndex:(range.location + range.length)];
        self.recorderFilePath = [NSString stringWithFormat:@"%@caf", filePathTmp];
    }
    
    // 生成录音文件
    NSURL *urlAudioRecorder = [NSURL fileURLWithPath:filePath];
    self.recorder = [[AVAudioRecorder alloc] initWithURL:urlAudioRecorder settings:self.recorderDict error:nil];
    
    // 开启音量检测
    self.recorder.meteringEnabled = YES;
    self.recorder.delegate = self;
    
    if (self.recorder)
    {
        // 录音时设置audioSession属性，否则不兼容Ios7
        AVAudioSession *recordSession = [AVAudioSession sharedInstance];
        [recordSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [recordSession setActive:YES error:nil];
        
        if ([self.recorder prepareToRecord])
        {
            [self.recorder record];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(recordBegined)]) {
                [self.delegate recordBegined];
            }
            
            [self startVoiceTimer];
            [self startTimecountTimer];
        }
    }
}

/// 停止录音
- (void)recorderStop
{
    if (self.recorder)
    {
        if ([self.recorder isRecording])
        {
            [self.recorder stop];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(recordFinshed)]) {
                [self.delegate recordFinshed];
            }
            
            NSLog(@"1 file size = %lld", [SYAudioFile SYAudioGetFileSizeWithFilePath:self.recorderFilePath]);
            
            [self audioConvertMP3];
            
            // 停止录音后释放掉
            self.recorder.delegate = nil;
            self.recorder = nil;
        }
    }
    
    [self stopVoiceTimer];
    [self stopTimecountTimer];
}

/// 异常时停止
- (void)recorderStopWhileError
{
    if (self.recorder)
    {
        if ([self.recorder isRecording])
        {
            [self.recorder stop];
            
            [self.recorder deleteRecording];
            
            // 停止录音后释放掉
            self.recorder.delegate = nil;
            self.recorder = nil;
        }
    }
    
    [self stopVoiceTimer];
    [self stopTimecountTimer];
}

/// 录音时长
- (NSTimeInterval)recorderDurationWithFilePath:(NSString *)filePath
{
    NSURL *urlFile = [NSURL fileURLWithPath:filePath];
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:urlFile error:nil];
    NSTimeInterval time = audioPlayer.duration;
    audioPlayer = nil;
    return time;
}

#pragma mark - timer

#pragma mark 录音计时器

- (void)startVoiceTimer
{
    if (self.monitorVoice) {
        self.voiceTimer = SYAudioTimerInitialize(0.0, nil, YES, self, @selector(detectionVoice));
        SYAudioTimerStart(self.voiceTimer);
        NSLog(@"开始检测音量");
    }
}

- (void)stopVoiceTimer
{
    if (self.voiceTimer)
    {
        SYAudioTimerStop(self.voiceTimer);
        SYAudioTimerKill(self.voiceTimer);
        NSLog(@"停止检测音量");
    }
}

/// 录音音量显示
- (void)detectionVoice
{
    // 刷新音量数据
    [self.recorder updateMeters];
    
//    // 获取音量的平均值
//    [self.audioRecorder averagePowerForChannel:0];
//    // 音量的最大值
//    [self.audioRecorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordingUpdateVoice:)]) {
        [self.delegate recordingUpdateVoice:lowPassResults];
    }
    
    NSLog(@"voice: %f", lowPassResults);
}

#pragma mark 倒计时计时器

- (void)startTimecountTimer
{
    if (self.totalTime <= 0.0) {
        return;
    }
    
    self.timecountTime = -1.0;
    self.timecountTimer = SYAudioTimerInitialize(1.0, nil, YES, self, @selector(detectionTime));
    SYAudioTimerStart(self.timecountTimer);
    NSLog(@"开始录音倒计时");
}

- (void)stopTimecountTimer
{
    if (self.timecountTimer)
    {
        self.totalTime = 0.0;
        SYAudioTimerStop(self.timecountTimer);
        SYAudioTimerKill(self.timecountTimer);
        NSLog(@"停止录音倒计时");
    }
}

- (void)detectionTime
{
    self.timecountTime += 1.0;
    NSTimeInterval time = (self.totalTime - self.timecountTime);
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordingWithResidualTime:timer:)]) {
        [self.delegate recordingWithResidualTime:time timer:(self.totalTime > 0.0 ? YES : NO)];
    }
    
    if (time <= 0.0 && self.totalTime > 0.0) {
        [self recorderStop];
    }
}

#pragma mark - 文件压缩

- (void)audioConvertMP3
{
    NSString *cafFilePath = self.recorderFilePath;
    
    NSLog(@"audioConvertMP3 方法中的 cafFilePath = %@",cafFilePath);
    
    //根据cadFilePath 的大小进行取舍
    NSDictionary *fileInfoDict = [[NSFileManager defaultManager] attributesOfItemAtPath:cafFilePath error:nil];
    
    //fileInfoDict[@"NSFileSize"] 取出来的是一个对象 - integerValue 转换为integer数值
    NSInteger currentSize = [fileInfoDict[@"NSFileSize"] integerValue];
    
    if (currentSize <= 4096) {
        NSLog(@"caf文件为nil");
        BOOL flag = [[NSFileManager defaultManager] removeItemAtPath:cafFilePath error:nil];
        if (flag) {
            NSLog(@"caf文件移除成功");
        }else{
            NSLog(@"caf文件移除失败");
        }
        return;
        
    }
    
    NSLog(@"caf文件有数据");
    //传进去的是 nil
    //    NSString *mp3FilePath = [SYAudioFile SYAudioMP3FilePath:self.filePathMP3];
    
    //mp3FilePath == 虚拟机内存/tmp/xxxxxx.mp3
    
//    NSString *filePath = @"/Users/dmt312/Desktop/recordSound";
    NSString *filePath = self.recordSoundPath;
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
    
    NSInteger count = 0;
    for (NSString *temp in array) {
        if ([temp containsString:@"mp3"]) {
            count++;
        }
    }
    
    //mp3以sound_n.mp3命名
//    NSString *mp3FilePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"sound_%ld.mp3",count+1]];
    
    //这里以按钮name命名
    
    NSString *name = [cafFilePath lastPathComponent];

    //去掉.caf后缀
    name = [name stringByReplacingOccurrencesOfString:@".caf" withString:@""];
    
    NSLog(@"audioConvertMP3方法中 获取最后一组字符串%@",name);
    
//    NSString *mp3FilePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"sound_%ld.mp3",count+1]];
    
    //以按钮name命名的mp3 按钮name后面加上selfRecord 避免和系统的mp3冲突
    NSString *mp3FilePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_selfRecord.mp3",name]];
    
    NSLog(@"audioConvertMP3方法中 mp3FilePath = %@",mp3FilePath);
    
    NSLog(@"MP3转换开始");
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordBeginConvert)]) {
        [self.delegate recordBeginConvert];
    }
    
    @try {
        int read;
        int write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4 * 1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 16000); // 采样率不对，编出来的声音完全不对
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
            if (read == 0) {
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            } else {
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            }
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    } @catch (NSException *exception) {
        NSLog(@"%@", [exception description]);
        mp3FilePath = nil;
    } @finally {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
        NSLog(@"MP3转换结束");
        NSLog(@"2 file size = %lld", [SYAudioFile SYAudioGetFileSizeWithFilePath:mp3FilePath]);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(recordFinshConvert:)]) {
            [self.delegate recordFinshConvert:mp3FilePath];
        }
    }
    
    
    //转换结束 有两个地方 搞一个caf文件夹 再搞一个mp3文件夹  在变成mp3文件之前检查fileTime 为0不变成mp3 不为0变成mp3 重新命名 变成之后 删除caf中的文件 把字典也传过来 一个字典记录一个路径的资源信息 包括fileTime  转换结束 把资源的路径 名称 时长都通过代理传递出去 外面使用数组保存信息 然后再传递给弹框
    
    //这里删除caf文件中的数据
    BOOL flag = [[NSFileManager defaultManager] removeItemAtPath:cafFilePath error:nil];
    if (flag) {
        NSLog(@"caf文件移除成功");
    }else{
        NSLog(@"caf文件移除失败");
    }
    
}

#pragma mark - 代理

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    [self recorderStop];
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordFinshed)]) {
        [self.delegate recordFinshed];
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error
{
    [self recorderStopWhileError];
}

@end
