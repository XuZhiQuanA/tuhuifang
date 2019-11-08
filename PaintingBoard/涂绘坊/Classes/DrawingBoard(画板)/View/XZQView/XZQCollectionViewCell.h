//
//  XZQCollectionViewCell.h
//  涂绘坊
//
//  Created by dmt312 on 2019/9/8.
//  Copyright © 2019 xzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class XZQCollectionViewCell;

@protocol XZQCollectionViewCellDelegate <NSObject>

- (void)throwSelectedCell:(XZQCollectionViewCell *)cell tag:(NSInteger)tag;

- (void)hideCellSelected;

- (void)cellClickChangeColor:(UIButton *)btn;

@end

@interface XZQCollectionViewCell : UICollectionViewCell

//给按钮设置图片
@property(nonatomic,readwrite,strong) UIImage *image;
//@property(nonatomic,readwrite,strong) UIButton *brushBtn;

/**tag of brush*/
@property(nonatomic,assign) NSInteger brushTag;
/**对号 */
@property(nonatomic,readwrite,strong) UIImageView *imageV;


@property(nonatomic,readwrite,weak) id<XZQCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
