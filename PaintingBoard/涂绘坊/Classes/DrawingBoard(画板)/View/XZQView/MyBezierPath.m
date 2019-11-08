//
//  MyBezierPath.m
//  10-画板
//
//  Created by xiaomage on 16/1/23.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "MyBezierPath.h"

@implementation MyBezierPath

/**
 支持加密编码
 
 */
+ (BOOL)supportsSecureCoding{
    return YES;
}

//解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        _color = [aDecoder decodeObjectOfClass:[UIColor class] forKey:@"color"];
        
    }
    
    return self;
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.color forKey:@"color"];
}

@end
