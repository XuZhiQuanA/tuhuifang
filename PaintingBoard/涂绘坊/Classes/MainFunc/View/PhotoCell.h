//
//  PhotoCell.h
//  XZQCollectionView
//
//  Created by dmt312 on 2019/8/29.
//  Copyright © 2019 xzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoCell : UICollectionViewCell

@property(nonatomic,readwrite,strong) UIImage *image;

@property (weak, nonatomic) IBOutlet UIButton *backgroundBtn;
@end

NS_ASSUME_NONNULL_END
