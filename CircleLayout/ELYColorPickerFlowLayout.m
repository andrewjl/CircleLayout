//
//  ELYColorPickerFlowLayout.m
//  CircleLayout
//
//  Created by Andrew Lauer Barinov on 5/6/14.
//  Copyright (c) 2014 Elysian Fields. All rights reserved.
//

#import "ELYColorPickerFlowLayout.h"

CGFloat ELYPickerFlowLayoutItemSize = 65;
CGFloat ELYPickerFlowLayoutActiveDistance = 100;
CGFloat ELYPickerFlowLayoutZoomFactor = 0.3;


@implementation ELYColorPickerFlowLayout

+ (instancetype)colorPickerFlowLayout {
    return [[self alloc] init];
}

- (id)init {

    self = [super init];
    
    if (!self) {
        return nil;
    }

    self.itemSize = CGSizeMake(ELYPickerFlowLayoutItemSize, ELYPickerFlowLayoutItemSize);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(50.0, 0.0, 50.0, 0.0);
    self.minimumLineSpacing = 10.0;

    return self;
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes *attributes in layoutAttributes) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            CGFloat normalizedDistance = distance / ELYPickerFlowLayoutActiveDistance;
            
            if (ABS(distance) < ELYPickerFlowLayoutActiveDistance) {
                CGFloat zoom = 1 + ELYPickerFlowLayoutZoomFactor * (1 - ABS(normalizedDistance));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = round(zoom);
            }
        }
    }
    
    return layoutAttributes;
    
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity {

    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes *attributes in layoutAttributes) {
        CGFloat itemHorizontalCenter = attributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
    
}

@end