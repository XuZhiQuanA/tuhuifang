//
//  XZQDrawingBoard.h
//  涂绘坊
//
//  Created by dmt312 on 2019/5/12.
//  Copyright © 2019 xzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQDrawingBoard : UIView<NSMutableCopying,NSSecureCoding>
/**<#备注#> */
@property(nonatomic,strong) UIImage *image;

/**从图形上下文中获取的图片 */
@property(nonatomic,readwrite,strong) UIImage *imageFromCGContext;

/**返回画板的索引*/
@property(nonatomic,assign) NSUInteger index;



//保存当前绘制的所有路径 包括图片
//@property (nonatomic, strong) NSMutableArray *allPathArray;

/**保存图片文件夹的路径 */
@property(nonatomic,readwrite,strong) NSString *picturePath;

/**外部导入的图片 */
@property(nonatomic,readwrite,strong) UIImage *externalPicture;

/**现在的颜色 */
@property(nonatomic,readwrite,strong) UIColor *currentColor;

//故事情节界面是否点击了plus按钮
@property(nonatomic, assign) BOOL isClickPlusBtn;
@end

NS_ASSUME_NONNULL_END
