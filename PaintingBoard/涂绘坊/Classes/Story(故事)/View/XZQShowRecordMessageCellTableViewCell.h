//
//  XZQShowRecordMessageCellTableViewCell.h
//  涂绘坊
//
//  Created by dmt312 on 2019/7/29.
//  Copyright © 2019 xzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQShowRecordMessageCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recordImageView;
@property (weak, nonatomic) IBOutlet UILabel *recordName;


@property (weak, nonatomic) IBOutlet UITextField *recordNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *recordTime;
@property (weak, nonatomic) IBOutlet UILabel *recordTimeConcreate;


/**数组字典 */
@property(nonatomic,readwrite,strong) NSMutableDictionary *dataDict;

/**保存recordSound的路径 */
@property(nonatomic,readwrite,strong) NSString *recordSoundPath;

@end



NS_ASSUME_NONNULL_END
