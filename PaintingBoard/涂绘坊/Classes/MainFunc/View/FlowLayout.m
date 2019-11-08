//
//  FlowLayout.m
//  XZQCollectionView
//
//  Created by dmt312 on 2019/8/29.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "FlowLayout.h"

@interface FlowLayout()


@end

@implementation FlowLayout

- (void)setTargetPX:(CGFloat)targetPX{
    
    _targetPX = targetPX;
    
    NSLog(@"%f",targetPX);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{

    
    NSArray *attrs = [super layoutAttributesForElementsInRect:self.collectionView.bounds];
    
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        
        
        CGFloat delta = fabs((attr.center.x - self.collectionView.contentOffset.x) - self.collectionView.bounds.size.width * 0.5);
        
        CGFloat scale = 1 - delta / (self.collectionView.bounds.size.width * 0.5) * 0.5;
        
        attr.transform = CGAffineTransformMakeScale(scale, scale);
        
    }
    
    
    return attrs;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
//    NSLog(@"%s",__func__);
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    
    CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
    
    CGPoint targetP = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    
    
    CGRect targetRect = CGRectMake(targetP.x, 0, collectionViewWidth, MAXFLOAT);
    
    NSArray *attrs = [super layoutAttributesForElementsInRect:targetRect];
    
    CGFloat minDelta = MAXFLOAT;
    
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        CGFloat delta = (attr.center.x - targetP.x) - self.collectionView.bounds.size.width * 0.5;
        
        if (fabs(delta) < fabs(minDelta) ) {
            minDelta = delta;
        }

    }
    
    targetP.x += minDelta;
    
    self.targetPX = targetP.x;

    return targetP;
}


@end
