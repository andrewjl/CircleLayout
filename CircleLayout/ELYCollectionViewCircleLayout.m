//
//  ELYCollectionViewCircleLayout.m
//  CircleLayout
//
//  Created by Andrew Lauer Barinov on 4/28/14.
//  Copyright (c) 2014 Elysian Fields. All rights reserved.
//

#import "ELYCollectionViewCircleLayout.h"

@interface ELYCollectionViewCircleLayout ()

@property (nonatomic, assign) NSUInteger cellCount;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;

// arrays to keep track of insert, delete index paths
@property (nonatomic, strong) NSMutableArray *deleteIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertIndexPaths;

@end

CGFloat ELYCircleLayoutItemSize = 50.0f;

@implementation ELYCollectionViewCircleLayout

+ (instancetype)collectionViewCircleLayout {
    ELYCollectionViewCircleLayout *layout = [[self alloc] init];
    return layout;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    CGSize size = [[self collectionView] frame].size;
    _cellCount = [[self collectionView] numberOfItemsInSection:0];
    _center = CGPointMake(size.width / 2.0, size.height / 2.0);
    _radius = MIN(size.width, size.height) / 2.5;
}

- (CGSize)collectionViewContentSize {
    return [[self collectionView] frame].size;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    [attributes setSize:CGSizeMake(ELYCircleLayoutItemSize, ELYCircleLayoutItemSize)];
    [attributes setCenter:CGPointMake(
                                      _center.x + _radius * cosf(2 * indexPath.item * M_PI / _cellCount),
                                      _center.y + _radius * sinf(2 * indexPath.item * M_PI / _cellCount)
                                      )];
    
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    
    for (NSInteger index = 0; index < [self cellCount]; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
    return attributes;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    
    [self setDeleteIndexPaths:[NSMutableArray array]];
    [self setInsertIndexPaths:[NSMutableArray array]];
    
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        if ([updateItem updateAction] == UICollectionUpdateActionDelete) {
            [[self deleteIndexPaths] addObject:[updateItem indexPathBeforeUpdate]];
        } else if ([updateItem updateAction] == UICollectionUpdateActionInsert) {
            [[self insertIndexPaths] addObject:[updateItem indexPathAfterUpdate]];
        }
    }
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    if ([[self insertIndexPaths] containsObject:itemIndexPath]) {
        if (!attributes) {
            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        }
        
        [attributes setAlpha:0.0f];
        [attributes setCenter:CGPointMake(_center.x, _center.y)];
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    if ([[self deleteIndexPaths] containsObject:itemIndexPath]) {
        if (!attributes) {
            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        }
        
        [attributes setAlpha:0.0f];
        [attributes setCenter:CGPointMake(_center.x, _center.y)];
        [attributes setTransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
    }
    
    return attributes;
}



@end
