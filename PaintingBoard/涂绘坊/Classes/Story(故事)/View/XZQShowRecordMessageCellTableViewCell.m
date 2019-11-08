//
//  XZQShowRecordMessageCellTableViewCell.m
//  涂绘坊
//
//  Created by dmt312 on 2019/7/29.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "XZQShowRecordMessageCellTableViewCell.h"

@interface XZQShowRecordMessageCellTableViewCell()

/**保存录音原来的名称 */
@property(nonatomic,readwrite,strong) NSString *originName;



@end

@implementation XZQShowRecordMessageCellTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSLog(@"cell awakeFromNib");
    if (_dataDict != nil) {
        
        [self setDataDict:_dataDict];
        
    }
    
    
    
}

- (void)setDataDict:(NSMutableDictionary *)dataDict{

    
    NSLog(@"setDataDict : %@",dataDict);
    
    if (dataDict != nil) {
        _dataDict = dataDict;
        
//        [self.recordNameTextField addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
        
        [self.recordNameTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        
        //取消后缀.mp3
        NSString *fileName = [_dataDict objectForKey:@"fileName"];
        self.originName = fileName;
        fileName = [fileName stringByReplacingOccurrencesOfString:@".mp3" withString:@""];
        
        self.recordNameTextField.text = fileName;
        
        self.recordTimeConcreate.text = [_dataDict objectForKey:@"fileTimeConcreate"];
        self.recordImageView.image = [_dataDict objectForKey:@"recordImageView"];
        
        self.recordSoundPath = (NSString *)[_dataDict objectForKey:@"filePath"];
        
        
    }
    
}

//当key路径对应的属性值发生改变时，监听器就会回调自身的监听方法，如下
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void*)contex{
    
    //当用户改变录音文件的名称的时候
    NSString *originPath = [self.recordSoundPath stringByAppendingPathComponent:self.originName];
    
    NSString *newName = change[@"new"];
    newName = [newName stringByAppendingString:@".mp3"];
    NSString *newPath = [self.recordSoundPath stringByAppendingPathComponent:newName];
    
    NSLog(@"originPath = %@ ",originPath);
    NSLog(@"newPath = %@",newPath);
    NSLog(@"self.recordSoundPath = %@",self.recordSoundPath);
    
    if (self.recordSoundPath != nil) {
        [[NSFileManager defaultManager] moveItemAtPath:originPath toPath:newPath error:nil];
    }
    
    
    
    //立即刷新 不用 自动加载内存文件
    
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
